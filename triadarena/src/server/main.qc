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

void main(void)
{

}

void StartFrame(void)
{

}

void EndFrame(void)
{

}

void PlayerPreThink(void)
{
	player_preframe();
}

void PlayerPostThink(void)
{
	player_postframe();
}

void ClientKill(void)
{

}

void ClientConnect(void)
{

}

void PutClientInServer(void)
{
	player_spawn();
}

void ClientDisconnect(void)
{

}

void SetNewParms(void)
{

}

void SetChangeParms(void)
{

}

void SpectatorConnect(void)
{

}

void SpectatorDisconnect(void)
{

}

void SpectatorThink(void)
{

}

void SV_ParseClientCommand(string cmd)
{
	int argc = tokenize_console(cmd);

	switch (argv(0))
	{
		case "setcharacter":
		{
			if (argc >= 2)
			{
				int character = stoi(argv(1));
				if (character >= 0 && character <= 4)
					player_set_character(self, character);
			}

			sprint(self, 5, "YOU ARE ", player_character_names[self.type], "!\n");
			break;
		}

		default:
		{
			clientcommand(self, cmd);
			break;
		}
	}
}

void SV_PausedTic(float paused_time)
{

}

float SV_ShouldPause(float new_status)
{
	return TRUE;
}

void SV_RunClientCommand(void)
{
	// suppress jumps
	input_buttons &= ~2;

	// run standard player physics with prediction
	runstandardplayerphysics(self);
}
