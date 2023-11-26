
void player_preframe(void)
{

}

void player_postframe(void)
{

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

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.health = PLAYER_DEFAULT_HEALTH;
	self.fixangle = TRUE;
	setsize(self, PLAYER_MIN_SIZE, PLAYER_MAX_SIZE);
	self.view_ofs = PLAYER_DEFAULT_VIEW_OFFSET;
	self.flags |= FL_CLIENT;
	self.classname = "player";
}
