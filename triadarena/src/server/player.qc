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

void player_preframe(void)
{

}

void player_postframe(void)
{
	// play running-into-wall sound
	if ((self.velocity.x == 0 && fabs(self.previous_velocity.x) >= 150) ||
		(self.velocity.y == 0 && fabs(self.previous_velocity.y) >= 150))
		sound(self, CHAN_AUTO, "wavs/c_hitwal.wav", 1, ATTN_NORM);

	// play landing-on-ground sound
	if ((self.flags & FL_ONGROUND) && (self.previous_velocity.z <= -300))
		sound(self, CHAN_AUTO, "wavs/p_land.wav", 1, ATTN_NORM);

	// save velocity for next frame
	self.previous_velocity = self.velocity;
}

void player_set_character(entity e, int character)
{
	switch (character)
	{
		case PLAYER_CHARACTER_TARADINO:
		{
			e.health = 100;
			e.accuracy = 2;
			e.view_ofs = [0, 0, 39];
			break;
		}

		case PLAYER_CHARACTER_THI:
		{
			e.health = 85;
			e.accuracy = 3;
			e.view_ofs = [0, 0, 32];
			break;
		}

		case PLAYER_CHARACTER_DOUG:
		{
			e.health = 150;
			e.accuracy = 3;
			e.view_ofs = [0, 0, 44];
			break;
		}

		case PLAYER_CHARACTER_LORELEI:
		{
			e.health = 70;
			e.accuracy = 2;
			e.view_ofs = [0, 0, 31];
			break;
		}

		case PLAYER_CHARACTER_IANPAUL:
		{
			e.health = 120;
			e.accuracy = 3;
			e.view_ofs = [0, 0, 39];
			break;
		}

		default:
		{
			errorf("invalid character num %i\n", character);
			return;
		}
	}

	e.type = character;
}

void player_spawn(void)
{
	entity spot = find(world, classname, "info_player_start");

	if (spot)
	{
		setorigin(self, spot.origin);
		self.angles = spot.angles;
	}
	else
	{
		setorigin(self, [0, 0, 0]);
		self.angles = [0, 0, 0];
	}

	precache_sound("wavs/c_hitwal.wav");
	precache_sound("wavs/p_land.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.fixangle = TRUE;
	setsize(self, PLAYER_MIN_SIZE, PLAYER_MAX_SIZE);
	self.flags |= FL_CLIENT;
	self.classname = "player";

	player_set_character(self, PLAYER_CHARACTER_TARADINO);
}
