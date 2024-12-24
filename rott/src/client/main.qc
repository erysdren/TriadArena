
void CSQC_RendererRestarted(string rendererdescription)
{
	upload_wall_textures();
	upload_floor_textures();
	upload_sky_textures();
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

void CSQC_Shutdown(void)
{
	// free palette data
	memfree(darkwar_palette);

	// close DARKWAR.wad
	wad_close(darkwar_wad);
}

void CSQC_UpdateView(float vwidth, float vheight, float notmenu)
{
	clearscene();

	setproperty(VF_DRAWENGINESBAR, FALSE);
	setproperty(VF_DRAWCROSSHAIR, FALSE);
	setproperty(VF_DRAWWORLD, TRUE);
	addentities(MASK_ENGINE | MASK_VIEWMODEL);

	renderscene();
}

void CSQC_Input_Frame(void)
{
	// suppress jumps
	input_buttons &= ~2;
}
