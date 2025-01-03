/*
Copyright (C) 1994-1995 Apogee Software, Ltd.
Copyright (C) 1996-1997 Id Software, Inc.
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

wad_t *darkwar_wad;
void *darkwar_palette;

void upload_sky_texture(string botname, string topname)
{
	void *texture8;
	void *texture32;
	int x, y;

	// read lump data
	texture8 = wad_read(darkwar_wad, wad_search(darkwar_wad, topname));

	// allocate rgba buffer
	texture32 = memalloc(256 * 400 * 4);

	// construct rgba buffer
	for (y = 0; y < 200; y++)
	{
		for (x = 0; x < 256; x++)
		{
			// max alpha
			uint32_t alpha = 0xFFFFFFFFu;

			// get palette offset
			int ofs = ((string)(texture8))[x * 200 + y];

			// get palette color
			void *src = darkwar_palette + (ofs * 3);

			// get pixel offset
			void *dest = texture32 + ((y * 256 + x) * 4);

			// copy color
			memcpy(dest, src, 3);

			// copy alpha
			memcpy(dest + 3, &alpha, 1);
		}
	}

	// free memory
	memfree(texture8);

	// read lump data
	texture8 = wad_read(darkwar_wad, wad_search(darkwar_wad, botname));

	// move ptr forward
	texture32 += 256 * 200 * 4;

	// construct rgba buffer
	for (y = 0; y < 200; y++)
	{
		for (x = 0; x < 256; x++)
		{
			// max alpha
			uint32_t alpha = 0xFFFFFFFFu;

			// get palette offset
			int ofs = ((string)(texture8))[x * 200 + y];

			// get palette color
			void *src = darkwar_palette + (ofs * 3);

			// get pixel offset
			void *dest = texture32 + ((y * 256 + x) * 4);

			// copy color
			memcpy(dest, src, 3);

			// copy alpha
			memcpy(dest + 3, &alpha, 1);
		}
	}

	// move ptr backwards
	texture32 -= 256 * 200 * 4;

	// create shader
	shaderforname(botname, sprintf("{\nprogram rottsky\n{\nmap $currentrender\n}\n{\nmap $rt:$nearest:%s\n}\n}\n", botname));
	// shaderforname(botname, sprintf("{\nprogram rottsky\ndiffusemap $rt:$nearest:%s\n}\n", botname));

	// upload to gpu
	r_uploadimage(botname, 256, 400, texture32, 256 * 400 * 4, IMGFMT_R8G8B8A8);

	// free memory
	memfree(texture8);
	memfree(texture32);
}

void upload_lpic_texture(string name)
{
	int lump;
	int width = 0, height = 0;
	int originx = 0, originy = 0;
	void *texture8;
	void *texture32;
	int x;
	int y;

	// read lump data
	lump = wad_search(darkwar_wad, name);
	texture8 = wad_read(darkwar_wad, lump);

	// read width, height, origin
	memcpy(&width, texture8, 2);
	memcpy(&height, texture8 + 2, 2);
	memcpy(&originx, texture8 + 4, 2);
	memcpy(&originy, texture8 + 6, 2);

	// allocate rgba buffer
	texture32 = memalloc(width * height * 4);

	// construct rgba buffer
	for (y = 0; y < height; y++)
	{
		for (x = 0; x < width; x++)
		{
			// max alpha
			uint32_t alpha = 0xFFFFFFFFu;

			// get palette offset
			int ofs = ((string)(texture8 + 8))[y * width + x];

			// get palette color
			void *src = darkwar_palette + (ofs * 3);

			// get pixel offset
			void *dest = texture32 + ((y * width + x) * 4);

			// copy color
			memcpy(dest, src, 3);

			// copy alpha
			memcpy(dest + 3, &alpha, 1);
		}
	}

	// create shader
	// shaderforname(name, sprintf("{\n{\nmap $rt:$nearest:%s\n}\n}\n", name));
	shaderforname(name, sprintf("{\nprogram defaultwall\ndiffusemap $rt:$nearest:%s\n}\n", name));

	// upload to gpu
	r_uploadimage(name, width, height, texture32, width * height * 4, IMGFMT_R8G8B8A8);

	// free memory
	memfree(texture8);
	memfree(texture32);
}

void upload_wall_texture(string name)
{
	int lump;
	void *texture8;
	void *texture32;
	int x;
	int y;

	// read lump data
	lump = wad_search(darkwar_wad, name);
	texture8 = wad_read(darkwar_wad, lump);

	// allocate rgba buffer
	texture32 = memalloc(64 * 64 * 4);

	// construct rgba buffer
	for (y = 0; y < 64; y++)
	{
		for (x = 0; x < 64; x++)
		{
			// max alpha
			uint32_t alpha = 0xFFFFFFFFu;

			// get palette offset
			int ofs = ((string)texture8)[y * 64 + x];

			// get palette color
			void *src = darkwar_palette + (ofs * 3);

			// get pixel offset
			void *dest = texture32 + ((x * 64 + y) * 4);

			// copy color
			memcpy(dest, src, 3);

			// copy alpha
			memcpy(dest + 3, &alpha, 1);
		}
	}

	// create shader
	// shaderforname(name, sprintf("{\n{\nmap $rt:$nearest:%s\n}\n}\n", name));
	shaderforname(name, sprintf("{\nprogram defaultwall\ndiffusemap $rt:$nearest:%s\n}\n", name));

	// upload to gpu
	r_uploadimage(name, 64, 64, texture32, 64 * 64 * 4, IMGFMT_R8G8B8A8);

	// free memory
	memfree(texture8);
	memfree(texture32);
}

void upload_animwall_texture(string name, int n, float rate)
{
	// upload frames
	for (int i = 1; i <= n; i++)
		upload_wall_texture(sprintf("%s%i", name, i));

	// create shader
	string shader = sprintf("{\nprogram defaultanimwall\n{\nanimclampmap %0.2f ", rate);
	for (int i = 1; i <= n; i++)
		shader = sprintf("%s%s ", shader, sprintf("%s%i", name, i));
	shader = sprintf("%s\n}\n{\nmap $lightmap\n}\n}\n", shader);
	shaderforname(name, shader);
}

void upload_wall_textures(void)
{
	static const string texnames[] = {
		/* 01 */ "WALL1",
		/* 02 */ "WALL2",
		/* 03 */ "WALL3",
		/* 04 */ "WALL4",
		/* 05 */ "WALL5",
		/* 06 */ "WALL6",
		/* 07 */ "WALL7",
		/* 08 */ "WALL8",
		/* 09 */ "WALL9",
		/* 10 */ "WALL10",
		/* 11 */ "WALL11",
		/* 12 */ "WALL12",
		/* 13 */ "WALL13",
		/* 14 */ "WALL14",
		/* 15 */ "WALL15",
		/* 16 */ "WALL16",
		/* 17 */ "WALL17",
		/* 18 */ "WALL18",
		/* 19 */ "WALL19",
		/* 20 */ "WALL20",
		/* 21 */ "WALL21",
		/* 22 */ "WALL22",
		/* 23 */ "WALL23",
		/* 24 */ "WALL24",
		/* 25 */ "WALL25",
		/* 26 */ "WALL26",
		/* 27 */ "WALL27",
		/* 28 */ "WALL28",
		/* 29 */ "WALL29",
		/* 30 */ "WALL30",
		/* 31 */ "WALL31",
		/* 32 */ "WALL32",
		/* 36 */ "WALL33",
		/* 37 */ "WALL34",
		/* 38 */ "WALL35",
		/* 39 */ "WALL36",
		/* 40 */ "WALL37",
		/* 41 */ "WALL38",
		/* 42 */ "WALL39",
		/* 43 */ "WALL40",
		/* 49 */ "WALL41",
		/* 50 */ "WALL42",
		/* 51 */ "WALL43",
		/* 52 */ "WALL44",
		/* 53 */ "WALL45",
		/* 54 */ "WALL46",
		/* 55 */ "WALL47",
		/* 56 */ "WALL48",
		/* 57 */ "WALL49",
		/* 58 */ "WALL50",
		/* 59 */ "WALL51",
		/* 60 */ "WALL52",
		/* 61 */ "WALL53",
		/* 62 */ "WALL54",
		/* 63 */ "WALL55",
		/* 64 */ "WALL56",
		/* 65 */ "WALL57",
		/* 66 */ "WALL58",
		/* 67 */ "WALL59",
		/* 68 */ "WALL60",
		/* 69 */ "WALL61",
		/* 70 */ "WALL62",
		/* 71 */ "WALL63",
		/* 80 */ "WALL64",
		/* 81 */ "WALL65",
		/* 82 */ "WALL66",
		/* 83 */ "WALL67",
		/* 84 */ "WALL68",
		/* 85 */ "WALL69",
		/* 86 */ "WALL70",
		/* 87 */ "WALL71",
		/* 88 */ "WALL72",
		/* 89 */ "WALL73",
		/* 46 */ "WALL74",
		/* 47 */ "EXIT",
		/* 48 */ "ENTRANCE",
		/* 72 */ "ELEV1",
		/* 73 */ "ELEV2",
		/* 74 */ "ELEV3",
		/* 75 */ "ELEV4",
		/* 76 */ "ELEV5",
		/* 77 */ "ELEV6",
		/* 78 */ "ELEV7",
		/* 79 */ "ELEV8"
	};

	for (int i = 0; i < texnames.length; i++)
		upload_wall_texture(texnames[i]);
}

void upload_animwall_textures(void)
{
#define VBLCOUNTER 30.0f
	upload_animwall_texture("FPLACE", 4, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMY", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMR", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMFAC", 4, VBLCOUNTER / 40.0f);
	upload_animwall_texture("ANIMONE", 4, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMTWO", 4, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMTHR", 4, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMFOR", 4, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMGW", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMYOU", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMBW", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMBP", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMCHN", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMFW", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMLAT", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMST", 6, VBLCOUNTER / 3.0f);
	upload_animwall_texture("ANIMRP", 6, VBLCOUNTER / 3.0f);
#undef VBLCOUNTER
}

void upload_floor_textures(void)
{
	upload_lpic_texture("FLRCL1");
	upload_lpic_texture("FLRCL2");
	upload_lpic_texture("FLRCL3");
	upload_lpic_texture("FLRCL4");
	upload_lpic_texture("FLRCL5");
	upload_lpic_texture("FLRCL6");
	upload_lpic_texture("FLRCL7");
	upload_lpic_texture("FLRCL8");
	upload_lpic_texture("FLRCL9");
	upload_lpic_texture("FLRCL10");
	upload_lpic_texture("FLRCL11");
	upload_lpic_texture("FLRCL12");
	upload_lpic_texture("FLRCL13");
	upload_lpic_texture("FLRCL14");
	upload_lpic_texture("FLRCL15");
	upload_lpic_texture("FLRCL16");
}

void upload_sky_textures(void)
{
	upload_sky_texture("SKYNT1", "SKYNT1A");
	upload_sky_texture("SKYDK1", "SKYDK1A");
	upload_sky_texture("SKYLG1", "SKYLG1A");
	upload_sky_texture("SKYLB1", "SKYLB1A");
	upload_sky_texture("SKYEN1", "SKYEN1A");
}
