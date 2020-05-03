public void RegisterClientCommands()
{
	char menuCMD[64];
	Format(menuCMD, sizeof(menuCMD), "sm_%s", commandString);
	RegConsoleCmd(menuCMD, ClientCommands, "Opens the main menu");
	
	RegConsoleCmd("sm_admins", AdminListCommand, "Shows a list of Online Admins");
	RegConsoleCmd("sm_commands", CommandsCommand, "Opens the Soccer Mod commands list");
	RegConsoleCmd("sm_gk", GkCommand, "Toggle the GK skin");	
	RegConsoleCmd("sm_help", HelpCommand, "Opens the Soccer Mod help menu");
	RegConsoleCmd("sm_maprr", MaprrCommand, "Quickly rr the map");
	RegConsoleCmd("sm_rules", RulesCommand, "Display defined rules");	
	RegConsoleCmd("sm_reloadads", ReloadAdsCommand, "Reload the advertisements");
}

public void RegisterServerCommandsSkins()
{
	RegServerCmd
	(
		"soccer_skins_model_ct",
		ServerCommandsSkins,
		"Sets the model of the counter-terrorists - values: [path/to/dir/file.mdl] [skin number]"
	);
	RegServerCmd
	(
		"soccer_skins_model_t",
		ServerCommandsSkins,
		"Sets the model of the terrorists - values: [path/to/dir/file.mdl] [skin number]"
	);
	RegServerCmd
	(
		"soccer_skins_model_ct_gk",
		ServerCommandsSkins,
		"Sets the model of the counter-terrorist goalkeeper - values: [path/to/dir/file.mdl] [skin number]"
	);
	RegServerCmd
	(
		"soccer_skins_model_t_gk",
		ServerCommandsSkins,
		"Sets the model of the terrorist goalkeeper - values: [path/to/dir/file.mdl] [skin number]"
	);
}

// *******************************************************************************************************************
// ************************************************ CLIENT COMMANDS **************************************************
// *******************************************************************************************************************

public Action ClientCommands(int client, int args)
{
	OpenMainMenu(client);

	return Plugin_Handled;
}

public Action GkCommand(int client, int args)
{
	ClientCommandSetGoalkeeperSkin(client);
	
	return Plugin_Handled;
}

public Action ReloadAdsCommand(int client, int args)
{
	GetAdverts();
	
	return Plugin_Handled;
}

public Action MaprrCommand(int client, int args)
{
	char command[128], map[128];
	GetCurrentMap(map, sizeof(map));
	Format(command, sizeof(command), "changelevel %s", map);
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC))
	{
		Handle pack;
		CreateDataTimer(2.0, DelayedServerCommand, pack);
		WritePackString(pack, command);
	
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has reloaded the map", prefixcolor, prefix, textcolor, client, map);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
	
	for (int player = 1; player <= MaxClients; player++)
	{
		if(GetClientMenu(player) != MenuSource_None )	
		{
			CancelClientMenu(player,false);
			InternalShowMenu(player, "\10", 1);
		}
	}
	
	return Plugin_Handled;
}

public Action AdminListCommand(int client, int args)
{
	menuaccessed[client] = false;
	OpenMenuOnlineAdmin(client);
	
	return Plugin_Handled;
}

public Action HelpCommand(int client, int args)
{
	OpenMenuHelp(client);
	return Plugin_Handled;
}

public Action CommandsCommand(int client, int args)
{
	OpenMenuCommands(client);
	return Plugin_Handled;
}

public Action RulesCommand(int client, int args)
{
	menuaccessed[client] = false;
	OpenMenuRules(client);
	return Plugin_Handled;
}

public Action ServerCommandsSkins(int args)
{
	char serverCommand[64], cmdArg1[128], cmdArg2[4];
	GetCmdArg(0, serverCommand, sizeof(serverCommand));
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));
	GetCmdArg(2, cmdArg2, sizeof(cmdArg2));

	if (StrEqual(serverCommand, "soccer_skins_model_ct"))		   SkinsServerCommandModelCT(cmdArg1, cmdArg2);
	else if (StrEqual(serverCommand, "soccer_skins_model_t"))	   SkinsServerCommandModelT(cmdArg1, cmdArg2);
	else if (StrEqual(serverCommand, "soccer_skins_model_ct_gk"))   SkinsServerCommandModelCTGoalkeeper(cmdArg1, cmdArg2);
	else if (StrEqual(serverCommand, "soccer_skins_model_t_gk"))	SkinsServerCommandModelTGoalkeeper(cmdArg1, cmdArg2);

	return Plugin_Handled;
}

public void SkinsServerCommandModelCT(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelCT = model;
		if (!number[0]) number = "0";
		skinsModelCTNumber = number;
		UpdateConfigModels("Current Skins", "soccer_skins_model_ct", skinsModelCT);
		
		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (!skinsIsGoalkeeper[client] && team == 3)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Counter-terrorist model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Counter-terrorist model set to {%s}%s {%s}and skin number {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model, textcolor, prefixcolor, number);
	}
	else
	{
		PrintToServer("[%s] Can't set counter-terrorist model to %s", prefix, model);
		CPrintToChatAll("{%s}[%s] {%s}Can't set counter-terrorist model to {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model);
	}
}

public void SkinsServerCommandModelT(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelT = model;
		if (!number[0]) number = "0";
		skinsModelTNumber = number;
		UpdateConfigModels("Current Skins", "soccer_skins_model_t", skinsModelT);

		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (!skinsIsGoalkeeper[client] && team == 2)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Terrorist model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Terrorist model set to {%s}%s {%s}and skin number {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model, textcolor, prefixcolor, number);
	}
	else
	{
		PrintToServer("[%s] Can't set terrorist model to %s", prefix, model);
		CPrintToChatAll("{%s}[%s] {%s}Can't set terrorist model to {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model);
	}
}

public void SkinsServerCommandModelCTGoalkeeper(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelCTGoalkeeper = model;
		if (!number[0]) number = "0";
		skinsModelCTGoalkeeperNumber = number;
		UpdateConfigModels("Current Skins", "soccer_skins_model_ct_gk", skinsModelCTGoalkeeper);

		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (skinsIsGoalkeeper[client] && team == 3)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Counter-terrorist goalkeeper model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Counter-terrorist goalkeeper model set to {%s}%s {%s}and skin number {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model, textcolor, prefixcolor, number);
	}
	else
	{
		PrintToServer("[%s] Can't set counter-terrorist goalkeeper model to %s", prefix, model);
		CPrintToChatAll("{%s}[%s] {%s}Can't set counter-terrorist goalkeeper model to {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model);
	}
}

public void SkinsServerCommandModelTGoalkeeper(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelTGoalkeeper = model;
		if (!number[0]) number = "0";
		skinsModelTGoalkeeperNumber = number;
		UpdateConfigModels("Current Skins", "soccer_skins_model_t_gk", skinsModelTGoalkeeper);

		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (skinsIsGoalkeeper[client] && team == 2)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Terrorist goalkeeper model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Terrorist goalkeeper model set to {%s}%s {%s}and skin number {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model, textcolor, prefixcolor, number);
	}
	else
	{
		PrintToServer("[%s] Can't set terrorist goalkeeper model to %s", prefix, model);
		CPrintToChatAll( "{%s}[%s] {%s}Can't set terrorist goalkeeper model to {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, model);
	}
}