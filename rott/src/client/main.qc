
wad_t *darkwar_wad;
void *darkwar_palette;

void upload_patch_texture(string name)
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
	shaderforname(name, sprintf("{\n{\nmap $rt:$nearest:%s\n}\n}\n", name));

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

void upload_floor_textures(void)
{
	upload_patch_texture("FLRCL1");
	upload_patch_texture("FLRCL2");
	upload_patch_texture("FLRCL3");
	upload_patch_texture("FLRCL4");
	upload_patch_texture("FLRCL5");
	upload_patch_texture("FLRCL6");
	upload_patch_texture("FLRCL7");
	upload_patch_texture("FLRCL8");
	upload_patch_texture("FLRCL9");
	upload_patch_texture("FLRCL10");
	upload_patch_texture("FLRCL11");
	upload_patch_texture("FLRCL12");
	upload_patch_texture("FLRCL13");
	upload_patch_texture("FLRCL14");
	upload_patch_texture("FLRCL15");
	upload_patch_texture("FLRCL16");
}

void CSQC_RendererRestarted(string rendererdescription)
{
	upload_wall_textures();
	upload_floor_textures();
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
}

void CSQC_Shutdown()
{
	// free palette data
	memfree(darkwar_palette);

	// close DARKWAR.wad
	wad_close(darkwar_wad);
}

void CSQC_UpdateView(float vwidth, float vheight, float notmenu)
{
	clearscene();

	setproperty(VF_DRAWENGINESBAR, TRUE);
	setproperty(VF_DRAWCROSSHAIR, TRUE);
	setproperty(VF_DRAWWORLD, TRUE);
	addentities(MASK_ENGINE | MASK_VIEWMODEL);

	renderscene();
}
