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

class fonts {
	static int initial;
	static int IFNT_15;
	static int NEWFNT1;
	static int NEWFNT2;
	static int OPTFNT1;
	static int OPTFNT2;
	static int OPTFNT3;
	static int SMALLFON;
	static int SMALLFON2;
	static int TINYFONT;
	static int TINYFONT2;
	static int TINYFONT3;
};

void font_init(void)
{
	fonts::initial = drawfont;
	fonts::IFNT_15 = loadfont("IFNT_15", "IFNT_15", "8 16 32", -1, FALSE, FALSE);
	fonts::NEWFNT1 = loadfont("NEWFNT1", "NEWFNT1", "8 16 32", -1, FALSE, FALSE);
	fonts::NEWFNT2 = loadfont("NEWFNT2", "NEWFNT2", "8 16 32", -1, FALSE, FALSE);
	fonts::OPTFNT1 = loadfont("OPTFNT1", "OPTFNT1", "8 16 32", -1, FALSE, FALSE);
	fonts::OPTFNT2 = loadfont("OPTFNT2", "OPTFNT2", "8 16 32", -1, FALSE, FALSE);
	fonts::OPTFNT3 = loadfont("OPTFNT3", "OPTFNT3", "8 16 32", -1, FALSE, FALSE);
	fonts::SMALLFON = loadfont("SMALLFON", "SMALLFON", "8 16 32", -1, FALSE, FALSE);
	fonts::SMALLFON2 = loadfont("SMALLFON2", "SMALLFON2", "8 16 32", -1, FALSE, FALSE);
	fonts::TINYFONT = loadfont("TINYFONT", "TINYFONT", "8 16 32", -1, FALSE, FALSE);
	fonts::TINYFONT2 = loadfont("TINYFONT2", "TINYFONT2", "8 16 32", -1, FALSE, FALSE);
	fonts::TINYFONT3 = loadfont("TINYFONT3", "TINYFONT3", "8 16 32", -1, FALSE, FALSE);
}

void font_set(int font)
{
	drawfont = font;
}

void font_quit(void)
{
	drawfont = fonts::initial;
}
