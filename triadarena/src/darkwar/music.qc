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

enum {
	SONG_LOOP_NO,
	SONG_LOOP_YES
};

enum {
	SONG_TYPE_GASON,
	SONG_TYPE_BOSSSEE,
	SONG_TYPE_BOSSDIE,
	SONG_TYPE_ENDLEVEL,
	SONG_TYPE_DOGEND,
	SONG_TYPE_TITLE,
	SONG_TYPE_APOGEE,
	SONG_TYPE_YOUWIN,
	SONG_TYPE_LEVEL,
	SONG_TYPE_ELEVATOR,
	SONG_TYPE_SECRETMENU,
	SONG_TYPE_CINEMATIC1,
	SONG_TYPE_CINEMATIC2,
	SONG_TYPE_CINEMATIC3,
	SONG_TYPE_GAMEOVER,
	SONG_TYPE_CHRISTMAS,
	SONG_TYPE_SNAKECHASE,
	SONG_TYPE_MENU
};

typedef struct song {
	bool loop;
	int type;
	string name;
	string title;
	string author;
} song_t;

const song_t songs[] = {
	{ SONG_LOOP_NO,  SONG_TYPE_APOGEE,     "FANFARE2", "Apogee Fanfare",          "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_TITLE,      "RISE",     "Rise",                    "Bobby Prince" },
	{ SONG_LOOP_YES, SONG_TYPE_MENU,       "MMMENU",   "MMMenu",                  "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_CHRISTMAS,  "DEADLY",   "Deadly Gentlemen",        "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_ELEVATOR,   "GOINGUP",  "Going up?",               "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_SECRETMENU, "FISHPOLK", "Fish Polka",              "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_ENDLEVEL,   "HOWDIDO",  "How'd I do?",             "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_GAMEOVER,   "YOUSUCK",  "You Suck",                "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_CINEMATIC2, "WATZNEXT", "Watz Next?",              "Lee Jackson"  },
	{ SONG_LOOP_NO,  SONG_TYPE_GASON,      "GAZZ!",    "Gazz!",                   "Bobby Prince" },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "FASTWAY",  "Goin' Down The Fast Way", "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "MISTACHE", "Mist Ache",               "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "OWW",      "Oww!!!",                  "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "SMOKE",    "Smoke And Mirrors",       "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "SPRAY",    "Spray",                   "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "RUNLIKE",  "Run Like Smeg",           "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "SMOOTH",   "Havana Smooth",           "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "CHANT",    "Chant",                   "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "MEDIEV1A", "Funeral of Queen Mary",   "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "TASKFORC", "Task Force",              "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "KISSOFF",  "KISS Off",                "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "RADAGIO",  "Adagio For Strings",      "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "SHARDS",   "Shards",                  "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "STAIRS",   "I Choose the Stairs",     "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "SUCKTHIS", "Suck This",               "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "EXCALIBR", "Excalibur",               "Bobby Prince" },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "CCCOOL",   "CCCool",                  "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "WORK_DAY", "Work Day",                "Bobby Prince" },
	{ SONG_LOOP_YES, SONG_TYPE_LEVEL,      "WHERIZIT", "Where Iz It?",            "Lee Jackson"  },
	{ SONG_LOOP_NO,  SONG_TYPE_BOSSDIE,    "BOSSBLOW", "Boss Blow",               "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_BOSSSEE,    "HELLERO",  "Hellero",                 "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_CINEMATIC1, "EVINRUDE", "Evin Rude",               "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_YOUWIN,     "VICTORY",  "Victory!",                "Lee Jackson"  },
	{ SONG_LOOP_YES, SONG_TYPE_DOGEND,     "HERE_BOY", "Here Boy",                "Bobby Prince" }
};

int get_song_for_type(int songtype)
{
	for (int i = 0; i < songs.length; i++)
		if (songs[i].type == songtype)
			return i;

	return -1;
}

int get_song_for_name(string name)
{
	for (int i = 0; i < songs.length; i++)
		if (songs[i].name == name)
			return i;

	return -1;
}
