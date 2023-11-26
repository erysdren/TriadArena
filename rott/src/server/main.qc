
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
