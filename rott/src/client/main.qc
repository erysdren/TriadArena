
wad_t *darkwar_wad;
rtl_t *darkwar_rtl;
void *darkwar_map_planes[3];
void *darkwar_palette;

#define MAPWALLS 1

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
			unsigned int alpha = 0xFFu;

			// get palette offset
			int ofs = ((string)texture8)[y * 64 + x];

			// get palette color
			void *src = darkwar_palette + (ofs * 3);

			// get pixel offset
			void *dest = texture32 + ((y * 64 + x) * 4);

			// copy color
			memcpy(dest, src, 3);

			// copy alpha
			memcpy(dest + 3, &alpha, 1);
		}
	}

	// create shader
	shaderforname(name, sprintf("{\n{\nmap $rt:$nearest:%s\n}\n}\n", name));

	// upload to gpu
	r_uploadimage(name, 64, 64, texture32, 64 * 64 * 4, IMGFMT_R8G8B8A8);

	// free memory
	memfree(texture8);
	memfree(texture32);
}

void upload_wall_textures(void)
{
	int i;

	for (i = 0; i < darkwar_wall_tiles.length; i++)
	{
		if (darkwar_wall_tiles[i] != "")
		{
			upload_wall_texture(darkwar_wall_tiles[i]);
		}
	}
}

void CSQC_RendererRestarted(string rendererdescription)
{
	// upload wall textures
	upload_wall_textures();
}

void CSQC_Init(float apilevel, string enginename, float engineversion)
{
	int lump;

	// open DARKWAR.WAD
	darkwar_wad = wad_open("DARKWAR.WAD");
	if (!darkwar_wad)
		darkwar_wad = wad_open("darkwar.wad");
	if (!darkwar_wad)
		error("Couldn't open DARKWAR.WAD!\n");

	// read palette
	lump = wad_search(darkwar_wad, "PAL");
	darkwar_palette = wad_read(darkwar_wad, lump);

	// open DARKWAR.RTL
	darkwar_rtl = rtl_open("DARKWAR.RTL");
	if (!darkwar_rtl)
		darkwar_rtl = rtl_open("darkwar.rtl");
	if (!darkwar_rtl)
		error("Couldn't open DARKWAR.RTL!\n");

	// read planes of the first map
	darkwar_map_planes[0] = memalloc(RTL_MAP_PLANE_SIZE);
	darkwar_map_planes[1] = memalloc(RTL_MAP_PLANE_SIZE);
	darkwar_map_planes[2] = memalloc(RTL_MAP_PLANE_SIZE);
	rtl_read_map_planes(darkwar_rtl, 0, darkwar_map_planes[0], darkwar_map_planes[1], darkwar_map_planes[2]);

	// construct an image from it
#if MAPWALLS
	void *map_image = memalloc(128 * 128 * 4);
	for (int y = 0; y < RTL_MAP_HEIGHT; y++)
	{
		for (int x = 0; x < RTL_MAP_WIDTH; x++)
		{
			uint32_t alpha = 0xFFu;
			void *src = darkwar_map_planes[0] + ((y * 128 + x) * 2);
			void *dest = map_image + ((y * 128 + x) * 4);
			memcpy(dest, src, 2);
			memcpy(dest + 3, (void *)&alpha, 1);
		}
	}
	shaderforname("MAPWALLS", "{\n{\nmap $rt:$nearest:MAPWALLS\n}\n}\n");
	r_uploadimage("MAPWALLS", 128, 128, map_image, 128 * 128 * 4, IMGFMT_R8G8B8A8);
	memfree(map_image);
#endif
}

void CSQC_Shutdown()
{
	// free palette data
	memfree(darkwar_palette);

	// close DARKWAR.wad
	wad_close(darkwar_wad);

	// close DARKWAR.RTL
	rtl_close(darkwar_rtl);

	// free map planes
	memfree(darkwar_map_planes[0]);
	memfree(darkwar_map_planes[1]);
	memfree(darkwar_map_planes[2]);
}

void CSQC_UpdateView(float vwidth, float vheight, float notmenu)
{
	clearscene();

	setproperty(VF_DRAWENGINESBAR, TRUE);
	setproperty(VF_DRAWCROSSHAIR, TRUE);
	setproperty(VF_DRAWWORLD, TRUE);
	addentities(MASK_ENGINE | MASK_VIEWMODEL);

	renderscene();

#if MAPWALLS
	drawpic([0, 0], "MAPWALLS", [128, 128], [1, 1, 1], 1);
#endif
}
