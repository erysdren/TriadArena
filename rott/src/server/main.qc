
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

	print("\n\nOPENING WAD!!\n");
	wad_t *wad = wad_open("data/darkwar.wad");
	if (wad == __NULL__)
		print("FAILED TO OPEN WAD!!\n");
	else
		wad_close(wad);
	print("CLOSED WAD!!\n\n\n");
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
	clientcommand(self, cmd);
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
	runstandardplayerphysics(self);
}
