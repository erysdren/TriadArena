
static const vector cardinal_planes[6] = {
	[1, 0, 0], [0, 1, 0], [0, 0, 1],
	[-1, 0, 0], [0, -1, 0], [0, 0, -1],
};

static void generate_texcoords(brushface_t *face, vector brush_min, vector brush_max)
{
	vector scorner = [0, 0, 0], tcorner = [0, 0, 0];

	// reset everything
	face->sdir = [0, 0, 0];
	face->sbias = 0;
	face->tdir = [0, 0, 0];
	face->tbias = 0;

	// get absolute normals
	float a = fabs(face->planenormal.x);
	float b = fabs(face->planenormal.y);
	float c = fabs(face->planenormal.z);

	// sdir
	if (a >= b && a >= c)
		face->sdir.y = 1;
	else
		face->sdir.x = 1;

	// tdir
	if (c > a && c > b)
		face->tdir.y = -1;
	else
		face->tdir.z = -1;

	// biases
	for (int i = 0; i < 3; i++)
	{
		scorner[i] = (face->sdir[i] > 0) ? brush_min[i] : brush_max[i];
		tcorner[i] = (face->tdir[i] > 0) ? brush_min[i] : brush_max[i];
	}

	face->sbias = scorner * face->sdir;
	face->tbias = tcorner * face->tdir;
}

static int add_cube(entity ent, vector pos, vector brush_size, string texture, int contents)
{
	static brushface_t faces[6];
	vector brush_min = [brush_size.x * pos.x, brush_size.y * pos.y, brush_size.z * pos.z];
	vector brush_max = brush_min + brush_size;

	// assign texture
	faces[0].shadername = texture;
	faces[1].shadername = texture;
	faces[2].shadername = texture;
	faces[3].shadername = texture;
	faces[4].shadername = texture;
	faces[5].shadername = texture;

	// assign planes
	faces[0].planenormal = cardinal_planes[0];
	faces[0].planedist = brush_max.x;
	faces[1].planenormal = cardinal_planes[1];
	faces[1].planedist = brush_max.y;
	faces[2].planenormal = cardinal_planes[2];
	faces[2].planedist = brush_max.z;
	faces[3].planenormal = cardinal_planes[3];
	faces[3].planedist = -brush_min.x;
	faces[4].planenormal = cardinal_planes[4];
	faces[4].planedist = -brush_min.y;
	faces[5].planenormal = cardinal_planes[5];
	faces[5].planedist = -brush_min.z;

	// generate texcoords
	for (int i = 0; i < 6; i++)
		generate_texcoords(&faces[i], brush_min, brush_max);

	return brush_create(ent.modelindex, faces, 6, contents);
}

// convert level height from tilemap index (sprites plane)
static int convert_level_height(int in)
{
	if (in >= 90 && in <= 97)
		return in - 89;
	else if (in >= 450 && in <= 457)
		return in - 449;
	else
		return 1;
}

// convert floor and ceiling textures from tile index to string
static string convert_updn_texture(int in)
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

	if (in >= 180 && in <= 195)
		return texnames[in - 180];
	else if (in >= 198 && in <= 213)
		return texnames[in - 198];
	else
		return "";
}

static bool is_sky_index(int in)
{
	if (in >= 234 && in <= 238)
		return true;
	else
		return false;
}

static string get_wall_texture(int in)
{
	static const string walls[] = {
		"WALL1",
		"WALL2",
		"WALL3",
		"WALL4",
		"WALL5",
		"WALL6",
		"WALL7",
		"WALL8",
		"WALL9",
		"WALL10",
		"WALL11",
		"WALL12",
		"WALL13",
		"WALL14",
		"WALL15",
		"WALL16",
		"WALL17",
		"WALL18",
		"WALL19",
		"WALL20",
		"WALL21",
		"WALL22",
		"WALL23",
		"WALL24",
		"WALL25",
		"WALL26",
		"WALL27",
		"WALL28",
		"WALL29",
		"WALL30",
		"WALL31",
		"WALL32",
		"WALL33",
		"WALL34",
		"WALL35",
		"WALL36",
		"WALL37",
		"WALL38",
		"WALL39",
		"WALL40",
		"WALL41",
		"WALL42",
		"WALL43",
		"WALL44",
		"WALL45",
		"WALL46",
		"WALL47",
		"WALL48",
		"WALL49",
		"WALL50",
		"WALL51",
		"WALL52",
		"WALL53",
		"WALL54",
		"WALL55",
		"WALL56",
		"WALL57",
		"WALL58",
		"WALL59",
		"WALL60",
		"WALL61",
		"WALL62",
		"WALL63",
		"WALL64",
		"WALL65",
		"WALL66",
		"WALL67",
		"WALL68",
		"WALL69",
		"WALL70",
		"WALL71",
		"WALL72",
		"WALL73",
		"WALL74"
	};

	static const string exits[] = {
		"EXIT",
		"ENTRANCE"
	};

	static const string elevators[] = {
		"ELEV1",
		"ELEV2",
		"ELEV3",
		"ELEV4",
		"ELEV5",
		"ELEV6",
		"ELEV7",
		"ELEV8"
	};

	if ((in >= 1) && (in <= 32))
		return walls[in - 1];
	else if ((in >= 36) && (in <= 45))
		return walls[in - 3 - 1];
	else if (in == 46)
		return walls[73];
	else if ((in >= 47) && (in <= 48))
		return exits[in - 47];
	else if ((in >= 49) && (in <= 71))
		return walls[in - 8 - 1];
	else if ((in >= 72) && (in <= 79))
		return elevators[in - 72];
	else if ((in >= 80) && (in <= 89))
		return walls[in - 16 - 1];
	else
		return "";
}

static string get_maskwall_texture(int in)
{
	return "";
}

static string convert_sky_texture(int in)
{
	static const string texnames[] = {
		"SKYNT1",
		"SKYDK1",
		"SKYLG1",
		"SKYLB1",
		"SKYEN1"
	};

	if (!is_sky_index(in))
		return "";

	return texnames[in - 234];
}

static int convert_level_brightness(int in)
{
	if (in >= 216 && in <= 223)
		return in - 216;
	return 7;
}

static string light_levels[] = {
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
	"p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
};

static string remap_level_brightness(int in)
{
	return light_levels[rint(remap(in, [0, 7], [6, light_levels.length - 13]))];
}

static vector dir_to_angles(int dir)
{
	static const vector dirs[] = {
		[0, 90, 0], // north
		[0, 180, 0], // east
		[0, 270, 0], // south
		[0, 0, 0] // west
	};

	if (dir < 0 || dir >= 4)
		return [0, 0, 0];

	// hack because maps are rotated
	return dirs[dir] - [0, 90, 0];
}

static float get_sprite_height(int in, int level_height)
{
	if ((in >> 8) != 0xB0i)
		return 0;

	in &= 0xFFi;

	int z = in >> 4;
	int zf = in & 0xFi;

	int nominalheight = (level_height << 6) - 64;

	if (z == 0xFi)
		return nominalheight + 64 - (zf << 2);
	else
		return nominalheight - (z << 6) - (zf << 2);
}

static int planespot(void *plane, int x, int y)
{
	int r = 0;
	memcpy(&r, plane + ((y * RTL_MAP_WIDTH + x) * 2), 2);
	return r;
}

static bool is_window_index(int in)
{
	return in == 13;
}

static bool is_platform_index(int in)
{
	if (in == 1 || (in >= 4 && in <= 9))
		return true;
	else
		return false;
}

void make_rott_map(entity ent, string mapset, int map)
{
	// open rtl and allocate walls buffer
	rtl_t *rtl = rtl_open(mapset);
	if (!rtl) return;
	void *walls = memalloc(RTL_MAP_PLANE_SIZE);
	void *sprites = memalloc(RTL_MAP_PLANE_SIZE);
	void *infos = memalloc(RTL_MAP_PLANE_SIZE);

	// read planes
	rtl_read_map_planes(rtl, map, walls, sprites, infos);

	// get level z height
	int level_height = convert_level_height(planespot(sprites, 0, 0));

#ifdef SERVER
	// get level song
	int level_song = 0;
	for (int x = 0; x < RTL_MAP_WIDTH; x++)
	{
		int infotile = planespot(infos, x, 0);

		if (infotile >> 8 == 0xBA)
		{
			level_song = infotile & 0xFF;
			break;
		}
	}
	ent.sounds = -1;
	ent.noise = songs[get_song_for_type(SONG_TYPE_LEVEL) + level_song].name;

	// get level name
	ent.message = sprintf("%s", rtl.maps[map].name);

	// get level lighting
	int level_brightness = convert_level_brightness(planespot(walls, 2, 0));
	lightstyle(0, remap_level_brightness(level_brightness));
#endif

	// add floor
	int level_floor = planespot(walls, 0, 0);
	add_cube(ent, [0, 0, -1], [64 * RTL_MAP_WIDTH, 64 * RTL_MAP_HEIGHT, 64], convert_updn_texture(level_floor), CONTENTBIT_SOLID);

	// add ceiling
	int level_ceiling = planespot(walls, 1, 0);
	if (is_sky_index(level_ceiling))
	{
		add_cube(ent, [0, 0, level_height], [64 * RTL_MAP_WIDTH, 64 * RTL_MAP_HEIGHT, 64], convert_sky_texture(level_ceiling), CONTENTBIT_SKY);
	}
	else
	{
		add_cube(ent, [0, 0, level_height], [64 * RTL_MAP_WIDTH, 64 * RTL_MAP_HEIGHT, 64], convert_updn_texture(level_ceiling), CONTENTBIT_SOLID);
	}

	// add walls
	for (int y = 0; y < RTL_MAP_HEIGHT; y++)
	{
		for (int x = 0; x < RTL_MAP_WIDTH; x++)
		{
			// get wall tile value
			int walltile = planespot(walls, x, y);

			// get info tile value
			int infotile = planespot(infos, x, y);

			if (is_window_index(infotile))
			{
				// is it a window to the sky?
				add_cube(ent, [y, x, 0], [64, 64, 64 * level_height], convert_sky_texture(level_ceiling), CONTENTBIT_SKY);
			}
			else if (get_wall_texture(walltile) != "")
			{
				if (is_platform_index(infotile))
				{
					// is it a platform wall?
				}
				else
				{
					// is it a standard wall?
					add_cube(ent, [y, x, 0], [64, 64, 64 * level_height], get_wall_texture(walltile), CONTENTBIT_SOLID);
				}
			}
			else if (get_maskwall_texture(walltile) != "")
			{
				// is it a masked wall?
			}
		}
	}

	// spawn some entities
	for (int y = 0; y < RTL_MAP_HEIGHT; y++)
	{
		for (int x = 0; x < RTL_MAP_WIDTH; x++)
		{
			// read tile value
			int spritetile = planespot(sprites, x, y);

			// is there anything here?
			if (spritetile == 0)
				continue;

			string cn = "";
			vector ang = [0, 0, 0];

			switch (spritetile)
			{
				// player 1
				case 19:
				case 20:
				case 21:
				case 22:
					cn = "info_player_start";
					ang = dir_to_angles(spritetile - 19);
					break;

				// player 2
				case 274:
				case 275:
				case 276:
				case 277:
					cn = "info_player_deathmatch";
					ang = dir_to_angles(spritetile - 274);
					break;

				// gad
				case 461:
				case 462:
				case 463:
				case 464:
				case 465:
				case 466:
					cn = "prop_disk";
					break;
			}

			if (cn != "")
			{
				entity e = spawn();
				e.classname = cn;
				e.angles = ang;

				// get sprite height
				int infotile = planespot(infos, x, y);
				float sprite_height = get_sprite_height(infotile, level_height);

				// set origin
				setorigin(e, [(y * 64) + 32, (x * 64) + 32, sprite_height]);

				void() spawnfunc = externvalue(-1, cn);
				if (spawnfunc)
				{
					entity oself = self;
					self = e;
					spawnfunc();
					self = oself;
				}
			}
		}
	}

	// close rtl and free walls buffer
	rtl_close(rtl);
	memfree(walls);
	memfree(sprites);
	memfree(infos);
}
