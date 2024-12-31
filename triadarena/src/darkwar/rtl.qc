/*
Copyright (C) 1994-1995 Apogee Software, Ltd.
Copyright (C) 2023-2025 erysdren (it/its)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

// rtl format constants
const uint32_t RTL_MAGIC = 0x4c5452u;
const uint32_t RTC_MAGIC = 0x435452u;
const uint32_t RTR_MAGIC = 0x525452;
const uint32_t RXL_MAGIC = 0x4C5852u;
const uint32_t RXC_MAGIC = 0x435852u;
const uint32_t RTL_VERSION = 0x0101u;
const uint32_t RXL_VERSION = 0x0200u;
const uint32_t RTL_TAG_REGISTERED = 0x4344u;
const uint32_t RTL_TAG_SHAREWARE = 0x4d4bu;
const uint32_t RTL_MAP_WIDTH = 128u;
const uint32_t RTL_MAP_HEIGHT = 128u;
const uint32_t RTL_MAP_PLANE_SIZE = 32768u;
const uint32_t RTL_NUM_MAPS = 100u;

// rtl map structure
typedef struct {
	uint32_t used;
	uint32_t crc;
	uint32_t tag;
	uint32_t flags;
	uint32_t ofs_walls;
	uint32_t ofs_sprites;
	uint32_t ofs_infos;
	uint32_t len_walls;
	uint32_t len_sprites;
	uint32_t len_infos;
	uint8_t name[24];
} rtl_map_t;

// rtl structure
typedef struct {
	filestream file;
	jsonnode info;
	bool ludicrous;
	bool commbat;
	bool shareware;
	bool randrott;
	rtl_map_t maps[RTL_NUM_MAPS];
} rtl_t;

static bool test_magic(filestream file)
{
	uint32_t magic;
	fseek(file, 0);
	fread(file, &magic, sizeof(uint32_t));
	return magic == RTL_MAGIC ||
		magic == RTC_MAGIC ||
		magic == RTR_MAGIC ||
		magic == RXL_MAGIC ||
		magic == RXC_MAGIC;
}

static bool test_version(filestream file)
{
	uint32_t version;
	fseek(file, 4);
	fread(file, &version, sizeof(uint32_t));
	return version == RTL_VERSION || version == RXL_VERSION;
}

static bool test_ludicrous(filestream file)
{
	uint32_t magic, version;
	fseek(file, 0);
	fread(file, &magic, sizeof(uint32_t));
	fread(file, &version, sizeof(uint32_t));
	return magic == RXL_MAGIC ||
		magic == RXC_MAGIC ||
		version == RXL_VERSION;
}

static bool test_commbat(filestream file)
{
	uint32_t magic;
	fseek(file, 0);
	fread(file, &magic, sizeof(uint32_t));
	return magic == RTC_MAGIC ||
		magic == RXC_MAGIC;
}

static bool test_shareware(filestream file)
{
	uint32_t mapofs = 8;

	for (int i = 0; i < RTL_NUM_MAPS; i++)
	{
		// seek right to crc for each map
		uint32_t crc;
		fseek(file, 4 + mapofs + (i * 64));
		fread(file, &crc, sizeof(uint32_t));
		if (crc == RTL_TAG_SHAREWARE)
			return true;
	}

	return false;
}

static bool test_randrott(filestream file)
{
	uint32_t magic;
	fseek(file, 0);
	fread(file, &magic, sizeof(uint32_t));
	return magic == RTR_MAGIC;
}

static uint32_t test_mapofs(filestream file)
{
	if (test_ludicrous(file))
	{
		int64_t ofs_info_headers, num_info_headers;
		fseek(file, 8);
		fread(file, &ofs_info_headers, sizeof(int64_t));
		fread(file, &num_info_headers, sizeof(int64_t));
		fseek(file, ofs_info_headers);

		for (int i = 0; i < num_info_headers; i++)
		{
			uint8_t name[16];
			int64_t ofs_info_data, len_info_data;
			fread(file, name, sizeof(name));
			fread(file, &ofs_info_data, sizeof(int64_t));
			fread(file, &len_info_data, sizeof(int64_t));

			if ((string)name == "MAPS" || (string)name == "MAPSET")
				return ofs_info_data;
		}

		return 24;
	}
	else
	{
		return 8;
	}
}

// open rtl from filename
rtl_t *rtl_open(string filename)
{
	// open file
	filestream file = fopen(filename, FILE_READ);
	if (file < 0)
		errorf("couldn't open \"%s\"", filename);

	// test magic
	if (!test_magic(file))
		errorf("\"%s\" is not a valid ROTT mapset (invalid signature)", filename);

	// test version
	if (!test_version(file))
		errorf("\"%s\" is not a valid ROTT mapset (invalid version)", filename);

	// allocate rtl structure
	rtl_t *rtl = memalloc(sizeof(rtl_t));

	// read maps
	fseek(file, test_mapofs(file));
	fread(file, rtl.maps, sizeof(rtl.maps));

	// setup details
	rtl.ludicrous = test_ludicrous(file);
	rtl.commbat = test_commbat(file);
	rtl.shareware = test_shareware(file);
	rtl.randrott = test_randrott(file);

	// save file handle
	rtl.file = file;

	return rtl;
}

// close rtl and free memory
void rtl_close(rtl_t *rtl)
{
	// sanity check
	if (!rtl)
		return;

	// close file handle
	if (rtl.file >= 0)
		fclose(rtl.file);

	// free rtl
	memfree(rtl);
}

// read plane from rtl file
static void rtl_read_plane(filestream file, uint32_t ofs, uint32_t len, uint32_t tag, void *buffer)
{
	// seek to plane offset
	fseek(file, ofs);

	// read plane data
	uint32_t pos = 0;
	uint32_t written = 0;
	while (pos < len && written < RTL_MAP_PLANE_SIZE)
	{
		// read test value
		uint32_t test = 0;
		fread(file, &test, 2);

		if (test == tag)
		{
			// read compressed data
			uint32_t rle_len = 0, rle_value = 0;
			fread(file, &rle_len, 2);
			fread(file, &rle_value, 2);

			// write compressed data
			for (int r = 0; r < rle_len; r++)
			{
				memcpy(buffer, &rle_value, 2);
				buffer += 2;
			}

			written += rle_len * 2u;
		}
		else
		{
			// write uncompressed data
			memcpy(buffer, &test, 2);
			buffer += 2;

			written += 2;
		}

		pos = ftell(file) - ofs;
	}
}

// read and uncompress map planes into user-provided buffers
// each user-provided buffer should be exactly RTL_MAP_PLANE_SIZE in size
void rtl_read_map_planes(rtl_t *rtl, int map, void *walls, void *sprites, void *infos)
{
	// sanity checks
	if (!rtl)
		return;
	if (map < 0 || map >= RTL_NUM_MAPS)
		return;
	if (!rtl.maps[map].used)
		return;

	// read walls
	if (walls)
		rtl_read_plane(rtl.file, rtl.maps[map].ofs_walls, rtl.maps[map].len_walls, rtl.maps[map].tag, walls);

	// read sprites
	if (sprites)
		rtl_read_plane(rtl.file, rtl.maps[map].ofs_sprites, rtl.maps[map].len_sprites, rtl.maps[map].tag, sprites);

	// read infos
	if (infos)
		rtl_read_plane(rtl.file, rtl.maps[map].ofs_infos, rtl.maps[map].len_infos, rtl.maps[map].tag, infos);
}
