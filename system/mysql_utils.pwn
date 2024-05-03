#define MySQLUtils::%0(%1) 		MySQLUtils_%0(%1)

#define		MYSQL_HOST 			"127.0.0.1"
#define		MYSQL_USER 			"root"
#define 	MYSQL_PASSWORD 		""
#define		MYSQL_DATABASE 		"demo"

new MySQL: g_SQL;
new g_MysqlRaceCheck[MAX_PLAYERS];

new g_DataLoadCallback[128] = EOS;

stock MySQLUtils::Connect()
{
    new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true); // it automatically reconnects when loosing connection to mysql server

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id); // AUTO_RECONNECT is enabled for this connection handle only
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("[MySQLUtils] Connection failed. Server is shutting down.");
		SendRconCommand("exit"); // close the server if there is no connection
		return 1;
	}

	print("[MySQLUtils] Connection is successful.");
	return 1;
}

stock MySQLUtils::Exit()
{
    // save all player data before closing connection
	for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) // GetPlayerPoolSize function was added in 0.3.7 version and gets the highest playerid currently in use on the server
	{
		if (IsPlayerConnected(i))
		{
			CallLocalFunction("OnPlayerDisconnect", "i", 1);
		}
	}

	mysql_close(g_SQL);
	return 1;
}

stock MySQLUtils::OnPlayerConnect(playerid)
{
    g_MysqlRaceCheck[playerid]++;

	// reset player data
	static const empty_player[E_PLAYER];
	Player[playerid] = empty_player;

	GetPlayerName(playerid, Player[playerid][E_NAME], MAX_PLAYER_NAME);

	// create orm instance and register all needed variables
	new ORM: ormid = Player[playerid][E_ORM_ID] = orm_create("players", g_SQL);

	orm_addvar_int(ormid, Player[playerid][E_ID], "id");
	orm_addvar_string(ormid, Player[playerid][E_NAME], MAX_PLAYER_NAME, "username");
	orm_addvar_string(ormid, Player[playerid][E_PASS], 64, "password");
    orm_addvar_string(ormid, Player[playerid][E_ACCESSORIES], 128, "accessories");
	orm_setkey(ormid, "username");

	// tell the orm system to load all data, assign it to our variables and call our callback when ready
	orm_load(ormid, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);
	return 1;
}

stock MySQLUtils::OnPlayerDisconnect(playerid, reason)
{
    g_MysqlRaceCheck[playerid]++;

	MySQLUtils::UpdatePlayerData(playerid, reason);
	Player[playerid][E_LOGGED] = false;
	return 1;
}

stock MySQLUtils::UpdatePlayerData(playerid, reason)
{
	if (!Player[playerid][E_LOGGED]) return 0;

	new string[128];
	for(new i = 0; i < 9; i++)
    {
		format(string, sizeof(string), "%s%d,", string, Player[playerid][E_ACESSORY][i]);
    }
	format(string, sizeof(string), "%s%d", string, Player[playerid][E_ACESSORY][9]);

	Player[playerid][E_ACCESSORIES] = string;

	orm_save(Player[playerid][E_ORM_ID]);
	orm_destroy(Player[playerid][E_ORM_ID]);
	return 1;
}

stock MySQLUtils::SetPlayerDataLoad(callback[])
{
    format(g_DataLoadCallback, 128, callback);
}

forward OnPlayerDataLoaded(playerid, race_check);
public OnPlayerDataLoaded(playerid, race_check)
{
	if (race_check != g_MysqlRaceCheck[playerid]) return Kick(playerid);

	orm_setkey(Player[playerid][E_ORM_ID], "id");

	switch (orm_errno(Player[playerid][E_ORM_ID]))
	{
		case ERROR_OK:
		{
            sscanf(Player[playerid][E_ACCESSORIES], "p<,>a<i>[10]", Player[playerid][E_ACESSORY]); 
            CallLocalFunction(g_DataLoadCallback, "dd", playerid, 1);

		}
		case ERROR_NO_DATA:
		{
            CallLocalFunction(g_DataLoadCallback, "dd", playerid, 0);
		}
	}
	return 1;
}