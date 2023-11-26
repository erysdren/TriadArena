
const int IWAD_MAGIC = 0x44415749i;
const int PWAD_MAGIC = 0x44415750i;

typedef struct
{
	int ofs;
	int len;
	string name;
} lump_t;

typedef struct
{
	int num_lumps;
	lump_t *lumps;
	filestream file;
} wad_t;

// allocate wad
wad_t *wad_allocate(int num_lumps)
{
	if (num_lumps <= 0)
		return __NULL__;
	wad_t *wad = memalloc(sizeof(wad_t));
	wad->num_lumps = num_lumps;
	wad->lumps = memalloc(wad->num_lumps * sizeof(lump_t));
	return wad;
}

// open wad from file
wad_t *wad_open(string filename)
{
	int magic;
	int num_lumps;
	int ofs_lumps;
	filestream file;
	wad_t *wad;

	// open file
	if (!(file = fopen(filename, FILE_READ)))
	{
		print("WAD ERROR: Couldn't open ", filename, "!\n");
		return __NULL__;
	}

	// read magic
	if (fread(file, (void *)&magic, sizeof(int)) != sizeof(int))
	{
		print("WAD ERROR: Couldn't read bytes from file!\n");
		return __NULL__;
	}

	// test magic
	if (magic != IWAD_MAGIC && magic != PWAD_MAGIC)
	{
		print("WAD ERROR: ", filename, " does not have the IWAD or PWAD header!\n");
		return __NULL__;
	}

	// read num_lumps
	if (fread(file, (void *)&num_lumps, sizeof(int)) != sizeof(int))
	{
		print("WAD ERROR: Couldn't read bytes from file!\n");
		return __NULL__;
	}

	// read ofs_lumps
	if (fread(file, (void *)&ofs_lumps, sizeof(int)) != sizeof(int))
	{
		print("WAD ERROR: Couldn't read bytes from file!\n");
		return __NULL__;
	}

	// allocate wad
	if (!(wad = wad_allocate(num_lumps)))
	{
		print("WAD ERROR: Couldn't allocate WAD structure!\n");
		return __NULL__;
	}

	// read lumps
	fseek(file, ofs_lumps);
	for (int i = 0; i < num_lumps; i++)
	{
		// read ofs and len
		fread(file, (void *)&wad->lumps[i].ofs, sizeof(int));
		fread(file, (void *)&wad->lumps[i].len, sizeof(int));

		// how to read the name string??
		fseek(file, ftell(file) + 8);
	}

	// add file handle to wad structure
	wad->file = file;

	return wad;
}

// close wad
void wad_close(wad_t *wad)
{
	fclose(wad->file);
	memfree(wad->lumps);
	memfree(wad);
}
