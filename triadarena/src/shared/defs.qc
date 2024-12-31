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

const vector PLAYER_MIN_SIZE = [-8, -8, 0];
const vector PLAYER_MAX_SIZE = [8, 8, 48];

enum {
	PLAYER_CHARACTER_TARADINO,
	PLAYER_CHARACTER_THI,
	PLAYER_CHARACTER_DOUG,
	PLAYER_CHARACTER_LORELEI,
	PLAYER_CHARACTER_IANPAUL
};

const string player_character_names[] = {
	"TARADINO CASSATT",
	"THI BARRETT",
	"DOUG WENDT",
	"LORELEI NI",
	"IAN PAUL FREELEY"
};

typedef enum {false, true} bool;

#define printf(...) print(sprintf(__VA_ARGS__))
#define errorf(...) error(sprintf(__VA_ARGS__))
#define localcmdf(...) localcmd(sprintf(__VA_ARGS__))

typedef __uint8 uint8_t;
typedef __int8 int8_t;

typedef __uint16 uint16_t;
typedef __int16 int16_t;

typedef __uint32 uint32_t;
typedef __int32 int32_t;

typedef __uint64 uint64_t;
typedef __int64 int64_t;

// player fields
.int type;
.float accuracy;
.vector previous_velocity;
