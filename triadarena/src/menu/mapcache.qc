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

const string MAPCACHE_FILENAME = "mapcache.json";

var int num_mapcache = 0;
var map_t *mapcache = __NULL__;

bool mapcache_load(void)
{
	// open for reading
	filestream file = fopen(MAPCACHE_FILENAME, FILE_READNL);
	if (file < 0)
		return false;

	// parse as json
	jsonnode root = json_parse(fgets(file));
	if (!root)
		return false;

	// read in data
	for (int i = 0; i < root.length; i++)
	{
		// reallocate mapcache array
		mapcache = memrealloc(mapcache, num_mapcache * sizeof(map_t), (num_mapcache + 1) * sizeof(map_t));

		// read values
		mapcache[num_mapcache].name = root.a[i].name;
		mapcache[num_mapcache].package = (root.a[i])["package"].s;
		mapcache[num_mapcache].title = (root.a[i])["title"].s;

		// advance
		num_mapcache++;
	}

	// clean up
	json_free(root);
	fclose(file);
	return true;
}

bool mapcache_save(void)
{
	// open for writing
	filestream file = fopen(MAPCACHE_FILENAME, FILE_WRITE);
	if (file < 0)
		return false;

	// write opening
	fputs(file, "{");

	// write maps
	for (int i = 0; i < num_mapcache; i++)
	{
		fputs(file, sprintf("\"%s\":{\"package\":\"%s\",\"title\":\"%s\"}", mapcache[i].name, mapcache[i].package, mapcache[i].title));

		if (i < num_mapcache - 1)
			fputs(file, ",");
	}

	// clean up
	fputs(file, "}");
	fclose(file);
	return true;
}

bool mapcache_build(void)
{
	// check all packages
	for (int i = 0; i < 256; i++)
	{
		if (getpackagemanagerinfo(i, GPMI_NAME) == "")
			continue;

		string package_name = getpackagemanagerinfo(i, GPMI_NAME);
		string package_title = getpackagemanagerinfo(i, GPMI_TITLE);

		// remove the trailing version string which is there for no reason
		for (int j = strlen(package_name); j >= 0; j--)
		{
			if (package_name[j] == '=')
			{
				package_name[j] = 0;
				break;
			}
		}

		// concat ".zip" so the search subsystem knows what the hell we're talking about
		// TODO: what if they arent zip files??
		package_name = strcat(package_name, ".zip");

		// open search
		searchhandle sh = search_begin("*.rtc", SB_FORCESEARCH, FALSE, package_name);

		// go over all mapsets in this package
		for (int j = 0; j < search_getsize(sh); j++)
		{
			// open rtl to cache mapnames
			rtl_t *rtl = rtl_open(search_getfilename(sh, j));

			// cache maps
			for (int k = 0; k < RTL_NUM_MAPS; k++)
			{
				if (rtl.maps[k].used)
				{
					// reallocate mapcache array
					mapcache = memrealloc(mapcache, num_mapcache * sizeof(map_t), (num_mapcache + 1) * sizeof(map_t));

					// setup mapcache values
					mapcache[num_mapcache].package = package_title;
					mapcache[num_mapcache].name = sprintf("%s_%i.map", search_getfilename(sh, j), k);
					mapcache[num_mapcache].title = strdup(rtl.maps[k].name);

					// advance
					num_mapcache++;
				}
			}

			// clean up
			rtl_close(rtl);
		}

		search_end(sh);
	}

	return true;
}

void mapcache_clear(void)
{
	if (mapcache)
		memfree(mapcache);

	num_mapcache = 0;
	mapcache = __NULL__;
}

void mapcache_rebuild(void)
{
	mapcache_clear();
	mapcache_build();
	mapcache_save();
}
