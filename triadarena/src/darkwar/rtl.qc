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
const uint32_t RTL_VERSION = 0x0101u;
const uint32_t RTL_TAG_REGISTERED = 0x4344u;
const uint32_t RTL_TAG_SHAREWARE = 0x4d4bu;
const uint32_t RTL_MAP_WIDTH = 128u;
const uint32_t RTL_MAP_HEIGHT = 128u;
const uint32_t RTL_MAP_PLANE_SIZE = 32768u;
const uint32_t RTL_NUM_MAPS = 100u;
const uint32_t RTL_MAP_RESERVED_TILES = 5u;

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
	string name;
} rtl_map_t;

// rtl structure
typedef struct {
	rtl_map_t maps[RTL_NUM_MAPS];
	filestream file;
} rtl_t;

// open rtl from filename
rtl_t *rtl_open(string filename)
{
	uint32_t magic;
	uint32_t version;
	filestream file;
	rtl_t *rtl;
	int i;

	// open file
	if (!(file = fopen(filename, FILE_READ)))
	{
		print("RTL ERROR: Couldn't open ", filename, "!\n");
		return __NULL__;
	}

	// read magic
	if (fread(file, (void *)&magic, sizeof(uint32_t)) != sizeof(uint32_t))
	{
		print("RTL ERROR: Couldn't read bytes from file!\n");
		return __NULL__;
	}

	// test magic
	if (magic != RTL_MAGIC && magic != RTC_MAGIC)
	{
		print("WAD ERROR: ", filename, " does not have the RTL or RTC header!\n");
		return __NULL__;
	}

	// read version
	if (fread(file, (void *)&version, sizeof(uint32_t)) != sizeof(uint32_t))
	{
		print("RTL ERROR: Couldn't read bytes from file!\n");
		return __NULL__;
	}

	// test version
	if (version != RTL_VERSION)
	{
		print("RTL ERROR: ", filename, " is not the correct RTL version!\n");
		return __NULL__;
	}

	// allocate rtl structure
	if (!(rtl = memalloc(sizeof(rtl_t))))
	{
		print("RTL ERROR: Couldn't allocate RTL structure!\n");
		return __NULL__;
	}

	// read maps
	for (i = 0; i < RTL_NUM_MAPS; i++)
	{
		// read main map structuer
		fread(file, (void *)&rtl->maps[i], sizeof(rtl_map_t) - sizeof(string));

		// allocate and read name string
		rtl->maps[i].name = (string)memalloc(25);
		fread(file, (void *)rtl->maps[i].name, 24);
	}

	// add file handle to rtl structure
	rtl->file = file;

	return rtl;
}

// close rtl and free memory
void rtl_close(rtl_t *rtl)
{
	int i;

	// sanity check
	if (!rtl)
		return;

	// close file handle
	if (rtl->file)
		fclose(rtl->file);

	// free name strings
	for (i = 0; i < RTL_NUM_MAPS; i++)
	{
		if (!rtl->maps[i].used)
			continue;

		memfree((void *)rtl->maps[i].name);
	}

	// free rtl
	memfree(rtl);
}

// read plane from rtl file
static void rtl_read_plane(filestream file, uint32_t ofs, uint32_t len, uint32_t tag, void *buffer)
{
	// seek to plane offset
	fseek(file, ofs);

	// read plane data
	int pos = 0;
	int written = 0;
	while (pos < len && written < RTL_MAP_PLANE_SIZE)
	{
		// read test value
		uint32_t test;
		fread(file, (void *)&test, 2);

		if (test == tag)
		{
			// read compressed data
			uint32_t rle_len, rle_value;
			fread(file, (void *)&rle_len, 2);
			fread(file, (void *)&rle_value, 2);

			// write compressed data
			for (int r = 0; r < rle_len; r++)
			{
				memcpy(buffer, &rle_value, 2);
				buffer += 2;
			}

			written += rle_len * 2;
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
	if (!rtl->maps[map].used)
		return;

	// read walls
	if (walls)
		rtl_read_plane(rtl->file, rtl->maps[map].ofs_walls, rtl->maps[map].len_walls, rtl->maps[map].tag, walls);

	// read sprites
	if (sprites)
		rtl_read_plane(rtl->file, rtl->maps[map].ofs_sprites, rtl->maps[map].len_sprites, rtl->maps[map].tag, sprites);

	// read infos
	if (infos)
		rtl_read_plane(rtl->file, rtl->maps[map].ofs_infos, rtl->maps[map].len_infos, rtl->maps[map].tag, infos);
}
