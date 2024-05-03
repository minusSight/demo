#define Accessory::%0(%1) 		Accessory_%0(%1)
#define MAX_ACCESSORIES         100
#define MAX_ACCESSORIES_DATA    1000

#define INVALID_ACCESSORY       -1
#define INVALID_ACCESSORY_DATA  -1

enum E_ACCESSORY_DATA
{
    ORM: E_ORM_ID,

    E_ID,
    E_FK_ID,
    E_MODEL,
    E_BONE,

    Float: E_OFFSET_X,
    Float: E_OFFSET_Y,
    Float: E_OFFSET_Z,

    Float: E_ROT_X,
    Float: E_ROT_Y,
    Float: E_ROT_Z,

    Float: E_SCALE_X,
    Float: E_SCALE_Y,
    Float: E_SCALE_Z,

    E_COLOR1,
    E_COLOR2
};
new AccessoryData[MAX_ACCESSORIES_DATA][E_ACCESSORY_DATA];

enum E_ACCESSORY
{
    ORM: E_ORM_ID,

    E_ID,
    E_NAME[64],
    E_DESC[256]
};
new Accessory[MAX_ACCESSORIES][E_ACCESSORY];
new g_AccessoryCount = 0;
new bool:g_AccessoryLoaded = false;

new g_AccessoryDataTotal = 0;

stock Accessory::Initialize()
{
    for(new i = 0; i < MAX_ACCESSORIES; i++)
    {
        static const empty_accessory[E_ACCESSORY];
        Accessory[i] = empty_accessory;

        // create orm instance and register all needed variables
        new ORM: ormid = Accessory[i][E_ORM_ID] = orm_create("acessories", g_SQL);

        Accessory[i][E_ID] = i;

        orm_addvar_int(ormid, Accessory[i][E_ID], "id");
        orm_addvar_string(ormid, Accessory[i][E_NAME], 64, "name");
        orm_addvar_string(ormid, Accessory[i][E_DESC], 256, "description");
        orm_setkey(ormid, "id");

        // tell the orm system to load all data, assign it to our variables and call our callback when ready
        orm_load(ormid, "OnAccessoryLoaded", "d", i);
    }
    LoadAccessoryData();
}

forward OnAccessoryLoaded(id);
public OnAccessoryLoaded(id)
{
	orm_setkey(Accessory[id][E_ORM_ID], "id");

	switch (orm_errno(Accessory[id][E_ORM_ID]))
	{
		case ERROR_OK:
		{
            g_AccessoryCount++;
		}

        case ERROR_NO_DATA:
        {
            if(!g_AccessoryLoaded) printf("[Accessory] Loaded %d accessories.", g_AccessoryCount);
            g_AccessoryLoaded = true;

            Accessory[id][E_ID] = INVALID_ACCESSORY;
        }
	}
	return 1;
}

forward OnAccessoryDataLoaded(id);
public OnAccessoryDataLoaded(id)
{
	orm_setkey(AccessoryData[id][E_ORM_ID], "id");

	switch (orm_errno(AccessoryData[id][E_ORM_ID]))
	{
		case ERROR_OK:
		{
            g_AccessoryDataTotal++;
		}
        case ERROR_NO_DATA:
        {
            AccessoryData[id][E_ID] = INVALID_ACCESSORY_DATA;
        }
	}
	return 1;
}

stock Accessory::PlayerSlotsCount(playerid)
{
    new count = 0;
    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(Player[playerid][E_INDEX] == INVALID_ACCESSORY_DATA) count++;
    }
    return count;
}
stock Accessory::SlotsCount(accessoryid)
{
    new count = 0;
    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(AccessoryData[accessoryid][E_FK_ID] == accessoryid) count++;
    }
    return count;
}

stock Accessory::Clear(accessoryid)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        for(new j = 0; j < MAX_PLAYER_ATTACHED_OBJECTS; j++)
        {
            if(Player[i][E_ACESSORY][j] == accessoryid)
            {
                for(new n = 0; n < MAX_ACCESSORIES_DATA; n++)
                {
                    if(AccessoryData[n][E_FK_ID] == accessoryid)
                    {
                        for(new h = 0; h < MAX_PLAYER_ATTACHED_OBJECTS; h++)
                        {
                            if(Player[i][E_INDEX][h] == AccessoryData[n][E_ID])
                            {
                                RemovePlayerAttachedObject(i, h);
                                break;
                            }
                        }
                    }
                }
                break;
            }
        }
    }

    Accessory[accessoryid][E_ID] = INVALID_ACCESSORY;
}

stock LoadAccessoryData()
{
    for(new i = 0; i < MAX_ACCESSORIES_DATA; i++)
    {
        static const empty_accessory[E_ACCESSORY_DATA];
        AccessoryData[i] = empty_accessory;

        // create orm instance and register all needed variables
        new ORM: ormid = AccessoryData[i][E_ORM_ID] = orm_create("acessories_data", g_SQL);

        AccessoryData[i][E_ID] = i;

        orm_addvar_int(ormid, AccessoryData[i][E_ID], "id");
        orm_addvar_int(ormid, AccessoryData[i][E_FK_ID], "fk_id");
        orm_addvar_int(ormid, AccessoryData[i][E_MODEL], "modelid");
        orm_addvar_int(ormid, AccessoryData[i][E_BONE], "bone");

        orm_addvar_float(ormid, AccessoryData[i][E_OFFSET_X], "offset_x");
        orm_addvar_float(ormid, AccessoryData[i][E_OFFSET_Y], "offset_y");
        orm_addvar_float(ormid, AccessoryData[i][E_OFFSET_Z], "offset_z");

        orm_addvar_float(ormid, AccessoryData[i][E_ROT_X], "rot_x");
        orm_addvar_float(ormid, AccessoryData[i][E_ROT_Y], "rot_y");
        orm_addvar_float(ormid, AccessoryData[i][E_ROT_Z], "rot_z");

        orm_addvar_float(ormid, AccessoryData[i][E_SCALE_X], "scale_x");
        orm_addvar_float(ormid, AccessoryData[i][E_SCALE_Y], "scale_y");
        orm_addvar_float(ormid, AccessoryData[i][E_SCALE_Z], "scale_z");

        orm_addvar_int(ormid, AccessoryData[i][E_COLOR1], "color1");
        orm_addvar_int(ormid, AccessoryData[i][E_COLOR2], "color2");
        orm_setkey(ormid, "id");

        // tell the orm system to load all data, assign it to our variables and call our callback when ready
        orm_load(ormid, "OnAccessoryDataLoaded", "d", i);
    }
}