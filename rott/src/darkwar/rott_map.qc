
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

int add_cube(entity ent, vector pos, vector brush_size, string texture)
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

	return brush_create(ent.modelindex, faces, 6, CONTENTBIT_SOLID);
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
		return texnames[0];
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
		/* 46 */ "WALL74"
	};

	static const string exits[] = {
		/* 47 */ "EXIT",
		/* 48 */ "ENTRANCE"
	};

	static const string elevators[] = {
		/* 72 */ "ELEV1",
		/* 73 */ "ELEV2",
		/* 74 */ "ELEV3",
		/* 75 */ "ELEV4",
		/* 76 */ "ELEV5",
		/* 77 */ "ELEV6",
		/* 78 */ "ELEV7",
		/* 79 */ "ELEV8"
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

// for player tiles only
static vector dir_to_angles_player(int dir)
{
	static const vector dirs[] = {
		[0, 90, 0], // north
		[0, 180, 0], // east
		[0, 270, 0], // south
		[0, 0, 0] // west
	};

	if (dir < 0 || dir >= 4)
		return [0, 0, 0];

	return dirs[dir];
}

// for everything else? maybe?
static vector dir_to_angles(int dir)
{
	static const vector dirs[] = {
		[0, 180, 0], // DIR_EAST
		[0, 135, 0], // DIR_NORTHEAST
		[0, 90, 0], // DIR_NORTH
		[0, 45, 0], // DIR_NORTHWEST
		[0, 0, 0], // DIR_WEST
		[0, 315, 0], // DIR_SOUTHWEST
		[0, 270, 0], // DIR_SOUTH
		[0, 225, 0] // DIR_SOUTHEAST
	};

	if (dir < 0 || dir >= DIR_NONE)
		return [0, 0, 0];

	return dirs[dir];
}

static float get_sprite_height(int in)
{
	if ((in >> 8) != 0xB0i)
		return 0;

	in = in & 0xFFi;

	printf("%i\n", in);

	return ((float)in / 255) * 64;
}

void make_rott_map(entity ent, int map)
{
	// open rtl and allocate walls buffer
	rtl_t *rtl = rtl_open("darkwar.rtl");
	void *walls = memalloc(RTL_MAP_PLANE_SIZE);
	void *sprites = memalloc(RTL_MAP_PLANE_SIZE);
	void *infos = memalloc(RTL_MAP_PLANE_SIZE);

	// read planes
	rtl_read_map_planes(rtl, map, walls, sprites, infos);

	// get level z height
	int level_height = 0;
	memcpy((void *)&level_height, sprites, 2);
	level_height = convert_level_height(level_height);

	// create brushes from walls
	for (int y = 0; y < RTL_MAP_HEIGHT; y++)
	{
		for (int x = 0; x < RTL_MAP_WIDTH; x++)
		{
			// read wall value
			int wall = 0;
			void *src = walls + ((y * RTL_MAP_WIDTH + x) * 2);
			memcpy((void *)&wall, src, 2);

			// is there a wall here? is it a valid texture?
			if (wall == 0)
				continue;
			if (get_wall_texture(wall) == "")
				continue;

			// add cube brush
			add_cube(ent, [y, x, 0], [64, 64, 64 * level_height], get_wall_texture(wall));
		}
	}

	// add floor
	int level_floor = 0;
	memcpy((void *)&level_floor, walls, 2);
	add_cube(ent, [0, 0, -1], [64 * 128, 64 * 128, 64], convert_updn_texture(level_floor));

	// add ceiling
	int level_ceiling = 0;
	memcpy((void *)&level_ceiling, walls + 2, 2);
	if (is_sky_index(level_ceiling))
	{
		add_cube(ent, [0, 0, level_height], [64 * 256, 64 * 256, 64], convert_sky_texture(level_ceiling));
	}
	else
	{
		add_cube(ent, [0, 0, level_height], [64 * 256, 64 * 256, 64], convert_updn_texture(level_ceiling));
	}

	// spawn some entities
	for (int y = 0; y < RTL_MAP_HEIGHT; y++)
	{
		for (int x = 0; x < RTL_MAP_WIDTH; x++)
		{
			// read tile value
			int tile = 0;
			void *src = sprites + ((y * RTL_MAP_WIDTH + x) * 2);
			memcpy((void *)&tile, src, 2);

			// is there anything here?
			if (tile == 0)
				continue;

			string cn = "";
			vector ang = [0, 0, 0];

			switch (tile)
			{
				// player 1
				case 19:
				case 20:
				case 21:
				case 22:
					cn = "info_player_start";
					ang = dir_to_angles_player(tile - 19);
					break;

				// player 2
				case 274:
				case 275:
				case 276:
				case 277:
					cn = "info_player_deathmatch";
					ang = dir_to_angles_player(tile - 274);
					break;

				// gad
				case 461:
					cn = "prop_disk";
					break;
			}

			if (cn != "")
			{
				entity e = spawn();
				e.classname = cn;
				e.angles = ang;

				// get sprite height
				int infotile = 0;
				src = infos + ((y * RTL_MAP_WIDTH + x) * 2);
				memcpy((void *)&infotile, src, 2);
				float sprite_height = get_sprite_height(infotile);

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
