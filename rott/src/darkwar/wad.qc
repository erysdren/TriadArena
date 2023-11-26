
const uint32_t IWAD_MAGIC = 0x44415749u;
const uint32_t PWAD_MAGIC = 0x44415750u;

// wad lump structure
typedef struct {
	uint32_t ofs;
	uint32_t len;
	string name;
} wad_lump_t;

// wad structure
typedef struct {
	uint32_t num_lumps;
	wad_lump_t *lumps;
	filestream file;
} wad_t;

// allocate wad
wad_t *wad_allocate(uint32_t num_lumps)
{
	// sanity check
	if (!num_lumps)
		return __NULL__;

	// allocate wad
	wad_t *wad = memalloc(sizeof(wad_t));

	// assign value
	wad->num_lumps = num_lumps;

	// allocate lumps
	wad->lumps = memalloc(wad->num_lumps * sizeof(wad_lump_t));

	// return ptr
	return wad;
}

// open wad from file
wad_t *wad_open(string filename)
{
	uint32_t magic;
	uint32_t num_lumps;
	uint32_t ofs_lumps;
	filestream file;
	wad_t *wad;
	int i;

	// open file
	if (!(file = fopen(filename, FILE_READ)))
	{
		print("WAD ERROR: Couldn't open ", filename, "!\n");
		return __NULL__;
	}

	// read magic
	if (fread(file, (void *)&magic, sizeof(uint32_t)) != sizeof(uint32_t))
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
	if (fread(file, (void *)&num_lumps, sizeof(uint32_t)) != sizeof(uint32_t))
	{
		print("WAD ERROR: Couldn't read bytes from file!\n");
		return __NULL__;
	}

	// read ofs_lumps
	if (fread(file, (void *)&ofs_lumps, sizeof(uint32_t)) != sizeof(uint32_t))
	{
		print("WAD ERROR: Couldn't read bytes from file!\n");
		return __NULL__;
	}

	// allocate wad structure
	if (!(wad = wad_allocate(num_lumps)))
	{
		print("WAD ERROR: Couldn't allocate WAD structure!\n");
		return __NULL__;
	}

	// read lumps
	fseek(file, ofs_lumps);
	for (i = 0; i < num_lumps; i++)
	{
		// read ofs and len
		fread(file, (void *)&wad->lumps[i].ofs, sizeof(uint32_t));
		fread(file, (void *)&wad->lumps[i].len, sizeof(uint32_t));

		// allocate and read name string
		wad->lumps[i].name = (string)memalloc(9);
		fread(file, (void *)wad->lumps[i].name, 8);
	}

	// add file handle to wad structure
	wad->file = file;

	return wad;
}

// close wad
void wad_close(wad_t *wad)
{
	int i;

	// sanity check
	if (!wad)
		return;

	// close file handle
	if (wad->file)
		fclose(wad->file);

	// free lump names
	for (i = 0; i < wad->num_lumps; i++)
		memfree((void *)wad->lumps[i].name);

	// free lumps
	memfree(wad->lumps);

	// free wad structure
	memfree(wad);
}

// get lump index from name
int wad_search(wad_t *wad, string name)
{
	int i;

	// sanity check
	if (!wad)
		return -1;

	// slow linear search through lumps
	for (i = 0; i < wad->num_lumps; i++)
	{
		if (wad->lumps[i].name == name)
			return i;
	}

	// fail
	return -1;
}

// read lump from index into memory allocated buffer
void *wad_read(wad_t *wad, int lump)
{
	void *r;

	// sanity checks
	if (!wad)
		return __NULL__;
	if (!wad->file)
		return __NULL__;
	if (lump < 0 || lump >= wad->num_lumps)
		return __NULL__;

	// allocate buffer
	r = memalloc(wad->lumps[lump].len);
	if (!r)
		return __NULL__;

	// read lump into buffer
	fseek(wad->file, wad->lumps[lump].ofs);
	fread(wad->file, r, wad->lumps[lump].len);

	// return buffer
	return r;
}
