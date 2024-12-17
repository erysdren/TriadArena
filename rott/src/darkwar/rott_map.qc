
static const vector cardinal_planes[6] = {
	[1, 0, 0], [0, 1, 0], [0, 0, 1],
	[-1, 0, 0], [0, -1, 0], [0, 0, -1],
};

int add_cube(entity ent, vector pos, vector brush_size, string texture)
{
	brushface_t faces[6];
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

	// assign u
	faces[0].sdir = [0, 1, 0];
	faces[0].sbias = 0;
	faces[1].sdir = [1, 0, 0];
	faces[1].sbias = 0;
	faces[2].sdir = [1, 0, 0];
	faces[2].sbias = 0;
	faces[3].sdir = [0, 1, 0];
	faces[3].sbias = 0;
	faces[4].sdir = [1, 0, 0];
	faces[4].sbias = 0;
	faces[5].sdir = [1, 0, 0];
	faces[5].sbias = 0;

	// assign v
	faces[0].tdir = [0, 0, -1];
	faces[0].tbias = 0;
	faces[1].tdir = [0, 0, -1];
	faces[1].tbias = 0;
	faces[2].tdir = [0, -1, 0];
	faces[2].tbias = 0;
	faces[3].tdir = [0, 0, -1];
	faces[3].tbias = 0;
	faces[4].tdir = [0, 0, -1];
	faces[4].tbias = 0;
	faces[5].tdir = [0, -1, 0];
	faces[5].tbias = 0;

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

void make_rott_map(entity ent, int map)
{
	// open rtl and allocate walls buffer
	rtl_t *rtl = rtl_open("darkwar.rtl");
	void *walls = memalloc(RTL_MAP_PLANE_SIZE);
	void *sprites = memalloc(RTL_MAP_PLANE_SIZE);

	// read walls and sprites
	rtl_read_map_planes(rtl, map, walls, sprites, NULL);

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
			int wall;
			void *src = walls + ((y * RTL_MAP_WIDTH + x) * 2);
			memcpy((void *)&wall, src, 2);

			// is there a wall here? is it a valid texture?
			if (!wall || wall >= darkwar_wall_tiles.length)
				continue;
			if (darkwar_wall_tiles[wall] == "")
				continue;

			// add cube brush
			add_cube(ent, [x, y, 0], [64, 64, 64 * level_height], darkwar_wall_tiles[wall]);
		}
	}

	// add floor
	int level_floor = 0;
	memcpy((void *)&level_floor, walls, 2);
	add_cube(ent, [0, 0, -1], [64 * 256, 64 * 256, 64], convert_updn_texture(level_floor));

	// add ceiling
	int level_ceiling = 0;
	memcpy((void *)&level_ceiling, walls + 2, 2);
	if (is_sky_index(level_ceiling))
	{
		// TODO: set sky here
	}
	else
	{
		add_cube(ent, [0, 0, level_height + 1], [64 * 256, 64 * 256, 64], convert_updn_texture(level_ceiling));
	}

	// close rtl and free walls buffer
	rtl_close(rtl);
	memfree(walls);
	memfree(sprites);
}
