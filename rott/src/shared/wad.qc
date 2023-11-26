
const string IWAD_MAGIC = "IWAD";
const string PWAD_MAGIC = "PWAD";

typedef struct
{
	__uint ofs;
	__uint len;
	string name;
} lump_t;

typedef struct
{
	__uint magic;
	__uint num_lumps;
	__uint ofs_lumps;
	lump_t *lumps;
} wad_t;
