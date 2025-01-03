/*
Copyright (C) 1994-1995 Apogee Software, Ltd.
Copyright (C) 1996-1997 Id Software, Inc.
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
