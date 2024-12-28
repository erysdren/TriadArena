
static bool parse_mapname(__out string mapset, __out int mapnum)
{
	int middle = -1;

	for (int i = strlen(mapname); i >= 0; i--)
	{
		if (mapname[i] == '_')
		{
			middle = i;
			break;
		}
	}

	if (middle == -1)
		return false;

	mapset = substring(mapname, 0, middle);
	mapnum = stoi(substring(mapname, middle + 1, strlen(mapname) - middle - 4));

	return true;
}

void worldspawn(void)
{
	string mapset = "darkwar.rtc";
	int mapnum = 0;

	if (!parse_mapname(mapset, mapnum))
		errorf("Server tried to load bogus mapname \"%s\"", mapname);

	make_rott_map(self, mapset, mapnum);
}
