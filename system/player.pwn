#define Player::%0(%1) 		Player_%0(%1)

enum E_PLAYER
{
	ORM: E_ORM_ID,

	E_ID,
	E_NAME[MAX_PLAYER_NAME],
	E_PASS[64],
    E_ACESSORY[10],
    E_ACCESSORIES[128],

	E_INDEX[MAX_PLAYER_ATTACHED_OBJECTS],

	bool: E_LOGGED
};

new Player[MAX_PLAYERS][E_PLAYER];