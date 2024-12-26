
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

enum {
	EVENT_MUSIC_START
};

#define NULL __NULL__

#define printf(...) print(sprintf(__VA_ARGS__))
#define errorf(...) error(sprintf(__VA_ARGS__))
#define localcmdf(...) localcmd(sprintf(__VA_ARGS__))

typedef __uint uint32_t;
typedef __int int32_t;

typedef __uint64 uint64_t;
typedef __int64 int64_t;

// player fields
.int type;
.float accuracy;
.vector previous_velocity;
