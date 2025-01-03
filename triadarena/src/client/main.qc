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

#if 0
static bool is_floor_texture(string shadername)
{
	static const string texnames[] = {
		"FLRCL1",
		"FLRCL2",
		"FLRCL3",
		"FLRCL4",
		"FLRCL5",
		"FLRCL6",
		"FLRCL7",
		"FLRCL8",
		"FLRCL9",
		"FLRCL10",
		"FLRCL11",
		"FLRCL12",
		"FLRCL13",
		"FLRCL14",
		"FLRCL15",
		"FLRCL16"
	};

	for (int i = 0; i < texnames.length; i++)
		if (shadername == texnames[i])
			return true;

	return false;
}

static bool is_animwall_texture(string shadername)
{
	static const string texnames[] = {
		"FPLACE",
		"ANIMY",
		"ANIMR",
		"ANIMFAC",
		"ANIMONE",
		"ANIMTWO",
		"ANIMTHR",
		"ANIMFOR",
		"ANIMGW",
		"ANIMYOU",
		"ANIMBW",
		"ANIMBP",
		"ANIMCHN",
		"ANIMFW",
		"ANIMLAT",
		"ANIMST",
		"ANIMRP"
	};

	for (int i = 0; i < texnames.length; i++)
		if (shadername == texnames[i])
			return true;

	return false;
}

string CSQC_GenerateMaterial(string shadername)
{
	if (is_floor_texture(shadername))
	{
		upload_lpic_texture(shadername);
		return sprintf("program defaultwall\ndiffusemap $rt:$nearest:%s", shadername);
	}
	else if (is_animwall_texture(shadername))
	{
		// upload frames
		for (int i = 1; i <= 6; i++)
			upload_wall_texture(sprintf("%s%i", shadername, i));

		// create shader
		string shader = sprintf("{\nanimmap %0.2f ", 0.25);
		for (int i = 1; i <= 6; i++)
			shader = sprintf("%s%s ", shader, sprintf("$rt:$nearest:%s%i", shadername, i));
		shader = sprintf("%s\n}", shader);
		return shader;
	}

	return 0;
}
#endif

void CSQC_RendererRestarted(string rendererdescription)
{
	upload_wall_textures();
	upload_animwall_textures();
	upload_floor_textures();
	upload_sky_textures();
}

void CSQC_Init(float apilevel, string enginename, float engineversion)
{
	// set window title
	setwindowcaption(_("m_game_title"));

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
	setproperty(VF_USERDATA, &glsl_userdata, (int)sizeof(glsl_userdata));

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

	// draw chat
	chat_draw([vwidth, vheight]);
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

void CSQC_Parse_Print(string printmsg, float printlvl)
{
	float lvl = cvar("msg");

	if (printlvl == PRINT_CHAT)
	{
		chat_add(printmsg);
		print(printmsg);
	}
	else if (printlvl >= lvl)
	{
		print(printmsg);
	}
}
