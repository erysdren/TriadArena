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

typedef struct map {
	string name;
	string package;
	string title;
} map_t;

const vector MENU_BG = [0.2, 0.3, 0.4];
const vector MENU_BG_DARK = [0.1, 0.15, 0.2];
const vector MENU_BORDER = [0.3, 0.4, 0.5];
const vector MENU_BUTTON = [0.3, 0.4, 0.5];
const vector MENU_BUTTON_BORDER = [0.35, 0.45, 0.55];
const vector MENU_TEXT_1 = [1, 1, 1];
const vector MENU_TEXT_2 = [0.7, 0.75, 0.75];
const vector MENU_HIGHLIGHT = [1, 1, 1];
const vector MENU_DARKEN = [1, 1, 1];

const vector MENU_TEXT_SMALL = [8, 8];
const vector MENU_TEXT_MEDIUM = [12, 12];
const vector MENU_TEXT_LARGE = [16, 16];
