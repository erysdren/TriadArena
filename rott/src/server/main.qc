
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

			sprint(self, 0, "YOU ARE ", player_character_names[self.type], "!\n");
		}

		default:
		{
			clientcommand(self, cmd);
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
