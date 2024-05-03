#include <a_samp>
#include <crashdetect>
#include <a_mysql>
#include <sscanf2>

enum
{
	DIALOG_UNUSED,
	DIALOG_LOGIN,
	DIALOG_REGISTER
};

#include "../system/player.pwn"
#include "../system/mysql_utils.pwn"
#include "../system/accessories.pwn"

#define DIALOG_ACCS_LIST    3
#define DIALOG_ACCS_MENU    4

main(){}

new accsList[10];

public OnGameModeInit()
{
    mysql_log(ALL);
	MySQLUtils::Connect();
	mysql_tquery(g_SQL,"SET NAMES cp1251");
	MySQLUtils::SetPlayerDataLoad("OnPlayerFetch");
	Accessory::Initialize();
	return 1;
}

public OnGameModeExit()
{
	MySQLUtils::Exit();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	MySQLUtils::OnPlayerConnect(playerid);
	
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
	    Player[playerid][E_INDEX][i] = -1;
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    MySQLUtils::OnPlayerDisconnect(playerid, reason);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
	}
	
	SetCameraBehindPlayer(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/accs", cmdtext, true, 5) == 0)
	{
		new list[64*12] = "{00FF00}Создать новый\n";
	    new string[64];
	    new idx = 0;
		for(new i = 0; i < MAX_ACCESSORIES; i++)
		{
		    if(Accessory[i][E_ID] == INVALID_ACCESSORY) continue;
		    format(string, sizeof(string), "> %s <", Accessory[i][E_NAME]);
		    strcat(list, string, sizeof(list));
		    
		    accsList[idx] = Accessory[i][E_ID];
		    idx++;
		}
		ShowPlayerDialog(playerid, DIALOG_ACCS_LIST, DIALOG_STYLE_LIST, "Список аксессуаров", list, "Выбрать", "Отмена");
		return 1;
	}
	return 0;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new accid = GetPVarInt(playerid, "hueta");
    if(response)
    {
        SendClientMessage(playerid, -1, "Attached object edition saved.");

        AccessoryData[accid][E_OFFSET_X] = fOffsetX;
        AccessoryData[accid][E_OFFSET_Y] = fOffsetY;
        AccessoryData[accid][E_OFFSET_Z] = fOffsetZ;
        AccessoryData[accid][E_ROT_X] = fRotX;
        AccessoryData[accid][E_ROT_Y] = fRotY;
        AccessoryData[accid][E_ROT_Z] = fRotZ;
        AccessoryData[accid][E_SCALE_X] = fScaleX;
        AccessoryData[accid][E_SCALE_Y] = fScaleY;
        AccessoryData[accid][E_SCALE_Z] = fScaleZ;
        
        orm_update(AccessoryData[accid][E_ORM_ID]);
    }
    else
    {
		SetPlayerAttachedObject(playerid, index, AccessoryData[accid][E_MODEL], AccessoryData[accid][E_BONE], AccessoryData[accid][E_OFFSET_X],
 		AccessoryData[accid][E_OFFSET_Y], AccessoryData[accid][E_OFFSET_Z], AccessoryData[accid][E_ROT_X], AccessoryData[accid][E_ROT_Y], AccessoryData[accid][E_ROT_Z],
 		AccessoryData[accid][E_SCALE_X], AccessoryData[accid][E_SCALE_Y], AccessoryData[accid][E_SCALE_Z], AccessoryData[accid][E_COLOR1], AccessoryData[accid][E_COLOR2]);
    }
    return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DIALOG_UNUSED: return 1;

		case DIALOG_LOGIN:
		{
			if (!response) return Kick(playerid);

			if (strcmp(inputtext, Player[playerid][E_PASS]) == 0)
			{
				Player[playerid][E_LOGGED] = true;

                SetSpawnInfo(playerid, NO_TEAM, 0, 1958.33, 1343.12, 15.36, 0.0, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				SetCameraBehindPlayer(playerid);
			}
			else ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Wrong password!\nPlease enter your password in the field below:", "Login", "Abort");
		}
		case DIALOG_REGISTER:
		{
			if (!response) return Kick(playerid);

			if (strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration", "Your password must be longer than 5 characters!\nPlease enter your password in the field below:", "Register", "Abort");

			format(Player[playerid][E_PASS], 64, inputtext);
			orm_save(Player[playerid][E_ORM_ID], "OnPlayerRegister", "d", playerid);
		}
		case DIALOG_ACCS_LIST:
		{
		    if(!response) return 1;
		    switch(listitem)
		    {
		        case 0:
		        {
		            //create
		        }
		        default:
		        {
		            new accessory = listitem-1;
		            
		            new caption[100], info[256];
		            
		            format(caption, sizeof(caption), "{FFFFFF}Аксессуар: %s", Accessory[accessory][E_NAME]);
					format(info, sizeof(info), "{FFFFFF}1. Изменить название\n2. Изменить описание\n3. Список предметов\n{FF0000}4. Удалить аксессуар\n{00FF00}Одеть аксессуар");
		            
		            SetPVarInt(playerid, "accessory", accessory);
					ShowPlayerDialog(playerid, DIALOG_ACCS_MENU, DIALOG_STYLE_LIST, caption, info, "Выбрать", "Отмена");
		        }
		    }
		}
		case DIALOG_ACCS_MENU:
		{
		    if(!response) return 1;
		    
		    new idx = GetPVarInt(playerid, "accessory");
		    
		    switch(listitem)
		    {
		        case 3:
		        {
		            orm_delete(Accessory[idx][E_ORM_ID]);
		            SendClientMessage(playerid, -1, "Аксессуар удален!");
		            
		            Accessory::Clear(idx);
		            DeletePVar(playerid, "accessory");
		        }
		        case 4:
		        {
		            if(Accessory::PlayerSlotsCount(playerid) < Accessory::SlotsCount(idx)) return SendClientMessage(playerid, -1, "На вас надето слишком много аксессуаров! Снимите один из них.");
		            for(new j = 0; j < MAX_ACCESSORIES_DATA; j++)
				    {
				        print("eblo");
				    	if(AccessoryData[j][E_ID] == INVALID_ACCESSORY_DATA) continue;
				        if(AccessoryData[j][E_FK_ID] != accsList[idx]) continue;
 						print("eblo1");
						for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
						{
						    if(Player[playerid][E_INDEX][i] == -1)
						    {
						         print("eblo2");
						        Player[playerid][E_INDEX][i] = AccessoryData[accsList[idx]][E_ID];
						    
				    			SetPlayerAttachedObject(playerid, i, AccessoryData[accsList[idx]][E_MODEL], AccessoryData[accsList[idx]][E_BONE], AccessoryData[accsList[idx]][E_OFFSET_X],
				    			AccessoryData[accsList[idx]][E_OFFSET_Y], AccessoryData[accsList[idx]][E_OFFSET_Z], AccessoryData[accsList[idx]][E_ROT_X], AccessoryData[accsList[idx]][E_ROT_Y], AccessoryData[accsList[idx]][E_ROT_Z],
				    			AccessoryData[accsList[idx]][E_SCALE_X], AccessoryData[accsList[idx]][E_SCALE_Y], AccessoryData[accsList[idx]][E_SCALE_Z], AccessoryData[accsList[idx]][E_COLOR1], AccessoryData[accsList[idx]][E_COLOR2]);
								break;
							}
						}
						 print("eblo3");

				    	//EditAttachedObject(playerid, AccessoryData[accsList[idx]][E_SLOT]);
				    	break;
				    }
		        }
		    }
		}

		default: return 0;
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	Player[playerid][E_LOGGED] = true;

	SetSpawnInfo(playerid, NO_TEAM, 0, 1958.33, 1343.12, 15.36, 0.0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	SetCameraBehindPlayer(playerid);
	return 1;
}


forward OnPlayerFetch(playerid, result);
public OnPlayerFetch(playerid, result)
{
	new string[115];
	switch (result)
	{
		case 1:
		{
			format(string, sizeof string, "{FFFFFF}Аккаунт (%s) зарегистрирован. \n\nВведи пароль в окошко ниже:", Player[playerid][E_NAME]);
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FFFFFF}Авторизация", string, "Войти", "Отмена");

		}
		case 0:
		{
			format(string, sizeof string, "{FFFFFF}Привет %s, ты можешь зарегистрироваться.\n\nДля этого введи пароль в окошко ниже:", Player[playerid][E_NAME]);
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{FFFFFF}Регистрация", string, "Готово", "Отмена");
		}
	}
	return 1;
}

