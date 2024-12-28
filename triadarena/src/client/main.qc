
void CSQC_RendererRestarted(string rendererdescription)
{
	upload_wall_textures();
	upload_floor_textures();
	upload_sky_textures();
}

void CSQC_Init(float apilevel, string enginename, float engineversion)
{
	// open darkwar.wad
	darkwar_wad = wad_open("darkwar.wad");
	if (!darkwar_wad)
		error("Couldn't open darkwar.wad!");

	// read palette
	darkwar_palette = wad_read(darkwar_wad, wad_search(darkwar_wad, "PAL"));
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
	static vec4 glsl_userdata[16];

	// clear screen
	clearscene();

	// setup userdata
	glsl_userdata[0][0] = getproperty(VF_ANGLES_X);
	glsl_userdata[0][1] = getproperty(VF_ANGLES_Y);
	glsl_userdata[0][2] = getproperty(VF_ANGLES_Z);
	glsl_userdata[1][0] = getproperty(VF_MIN_X);
	glsl_userdata[1][1] = getproperty(VF_MIN_Y);
	glsl_userdata[1][2] = getproperty(VF_SIZE_X);
	glsl_userdata[1][3] = getproperty(VF_SIZE_Y);
	setproperty(VF_USERDATA, &glsl_userdata, sizeof(glsl_userdata));

#if (VIEWSKEW == 1)
	// setup viewport
	setproperty(VF_VIEWPORT, [0, -(vheight / 2) - (getproperty(VF_ANGLES_X) * 2)], [vwidth, vheight * 2]);
	setproperty(VF_ANGLES_X, 0);
	setproperty(VF_AFOV, 110);
#endif

	// setup other properties
	setproperty(VF_DRAWENGINESBAR, FALSE);
	setproperty(VF_DRAWCROSSHAIR, FALSE);
	setproperty(VF_DRAWWORLD, TRUE);

	// add entities
	addentities(MASK_ENGINE | MASK_VIEWMODEL);

	// do render
	renderscene();
}

void CSQC_Input_Frame(void)
{
	// suppress jumps
	input_buttons &= ~2;
}

float CSQC_ConsoleCommand(string cmd)
{
	int argc = tokenize(cmd);

	switch (argv(0))
	{
		default:
		{
			return FALSE;
		}
	}
}

void CSQC_Parse_Event(void)
{
	int event = readbyte();

	switch (event)
	{
		default:
		{
			break;
		}
	}
}
