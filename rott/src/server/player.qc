
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

void player_preframe(void)
{

}

void player_postframe(void)
{

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

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.fixangle = TRUE;
	setsize(self, PLAYER_MIN_SIZE, PLAYER_MAX_SIZE);
	self.flags |= FL_CLIENT;
	self.classname = "player";

	player_set_character(self, PLAYER_CHARACTER_TARADINO);
}
