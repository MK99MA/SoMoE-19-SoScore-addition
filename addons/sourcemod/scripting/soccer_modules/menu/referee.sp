// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public void RefereeOnPluginStart()
{
}

public void RefereeEventPlayerSpawn(Event event)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);

	char clientSteamid[32];
	GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

	if (PlayerHasCard(clientSteamid, "red"))
	{
		ChangeClientTeam(client, 1);
		CPrintToChat(client, "{%s}[%s] You have been put to spectator because you have a red card", prefixcolor, prefix);
	}
}

// ***********************************************************************************************************
// ************************************************** MENUS **************************************************
// ***********************************************************************************************************
public void OpenRefereeMenu(int client)
{
	Menu menu = new Menu(RefereeMenuHandler);

	menu.SetTitle("Soccer - Admin - Referee");

	menu.AddItem("yellow", "Yellow Card");

	menu.AddItem("red", "Red Card");
	
	menu.AddItem("remove_yellow", "Remove yellow card");

	menu.AddItem("remove_red", "Remove red card");

	menu.AddItem("remove_all", "Remove all cards");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int RefereeMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "yellow"))				   	OpenRefereeYellowCardMenu(client);
		else if (StrEqual(menuItem, "red"))				 	OpenRefereeRedCardMenu(client);
		else if (StrEqual(menuItem, "remove_yellow"))	 	OpenRemoveYellowCardMenu(client);
		else if (StrEqual(menuItem, "remove_red"))		  	OpenRemoveRedCardMenu(client);
		else if (StrEqual(menuItem, "remove_all"))		  	RemoveAllCards(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)	OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ***********************************************************************************************************************
// ************************************************** YELLOW CARD MENU  **************************************************
// ***********************************************************************************************************************

public void OpenRefereeYellowCardMenu(int client)
{
	Menu menu = new Menu(RefereeYellowCardMenuHandler);

	menu.SetTitle("Soccer - Yellow Card");

	int count = 0;
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			char playerSteamid[32];
			GetClientAuthId(player, AuthId_Engine, playerSteamid, sizeof(playerSteamid));

			if (!PlayerHasCard(playerSteamid, "red"))
			{
				count++;

				char playerid[8];
				IntToString(player, playerid, sizeof(playerid));

				char playerName[MAX_NAME_LENGTH];
				GetClientName(player, playerName, sizeof(playerName));

				if (PlayerHasCard(playerSteamid, "yellow")) Format(playerName, sizeof(playerName), "%s (%s)", playerName, "Yellow");

				menu.AddItem(playerid, playerName);
			}
		}
	}

	if (count)
	{
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] All players already have a red card", prefixcolor, prefix);
		OpenRefereeMenu(client);
	}
}

public int RefereeYellowCardMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[8];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		int target = StringToInt(menuItem);

		if (IsClientInGame(target) && IsClientConnected(target))
		{
			char clientSteamid[32];
			GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

			char targetSteamid[32];
			GetClientAuthId(target, AuthId_Engine, targetSteamid, sizeof(targetSteamid));

			KeyValues keygroup = new KeyValues("refereeCards");
			keygroup.ImportFromFile(pathRefCardsFile);
			keygroup.JumpToKey(targetSteamid, true);

			char targetName[MAX_NAME_LENGTH];
			GetClientName(target, targetName, sizeof(targetName));
			keygroup.SetString("name", targetName);

			if (keygroup.GetNum("yellow", 0))
			{
				keygroup.SetNum("yellow", 0);
				keygroup.SetNum("red", 1);

				ChangeClientTeam(target, 1);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has given a second yellow card to %N", prefixcolor, prefix, textcolor, client, target);
				}

			}
			else
			{
				keygroup.SetNum("yellow", 1);
				keygroup.SetNum("red", 0);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has given a yellow card to %N", prefixcolor, prefix, textcolor, client, target);
				}
			}

			keygroup.Rewind();
			keygroup.ExportToFile(pathRefCardsFile);
			keygroup.Close();
		}
		else CPrintToChat(client, "{%s}[%s] Player is no longer on the server", prefixcolor, prefix);

		OpenRefereeMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenRefereeMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}


// ***********************************************************************************************************************
// ************************************************** RED CARD MENU ******************************************************
// ***********************************************************************************************************************

public void OpenRefereeRedCardMenu(int client)
{
	Menu menu = new Menu(RefereeRedCardMenuHandler);

	menu.SetTitle("Soccer - Red Card");

	int count = 0;
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			char playerSteamid[32];
			GetClientAuthId(player, AuthId_Engine, playerSteamid, sizeof(playerSteamid));

			if (!PlayerHasCard(playerSteamid, "red"))
			{
				count++;

				char playerid[8];
				IntToString(player, playerid, sizeof(playerid));

				char playerName[MAX_NAME_LENGTH];
				GetClientName(player, playerName, sizeof(playerName));

				if (PlayerHasCard(playerSteamid, "yellow")) Format(playerName, sizeof(playerName), "%s (%s)", playerName, "Yellow");

				menu.AddItem(playerid, playerName);
			}
		}
	}

	if (count)
	{
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] All players already have a red card", prefixcolor, prefix);
		OpenRefereeMenu(client);
	}
}

public int RefereeRedCardMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[8];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		int target = StringToInt(menuItem);

		if (IsClientInGame(target) && IsClientConnected(target))
		{
			char targetSteamid[32];
			GetClientAuthId(target, AuthId_Engine, targetSteamid, sizeof(targetSteamid));

			KeyValues keygroup = new KeyValues("refereeCards");
			keygroup.ImportFromFile(pathRefCardsFile);
			keygroup.JumpToKey(targetSteamid, true);

			if (!keygroup.GetNum("red", 0))
			{
				char targetName[MAX_NAME_LENGTH];
				GetClientName(target, targetName, sizeof(targetName));
				keygroup.SetString("name", targetName);

				keygroup.SetNum("yellow", 0);
				keygroup.SetNum("red", 1);

				ChangeClientTeam(target, 1);

				char clientSteamid[32];
				GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has given a red card to %N", prefixcolor, prefix, textcolor, client, target);
				}
			}
			else CPrintToChat(client, "{%s}[%s] Player already has a red card", prefixcolor, prefix);

			keygroup.Rewind();
			keygroup.ExportToFile(pathRefCardsFile);
			keygroup.Close();

			OpenRefereeRedCardMenu(client);
		}
		else 
		{
			CPrintToChat(client, "{%s}[%s] Player is no longer on the server", prefixcolor, prefix);
			OpenRefereeMenu(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6) OpenRefereeMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ***********************************************************************************************************************
// ************************************************ REMOVE YELLOW MENU ***************************************************
// ***********************************************************************************************************************

public void OpenRemoveYellowCardMenu(int client)
{
	Menu menu = new Menu(RemoveYellowCardMenuHandler);

	menu.SetTitle("Soccer - Remove yellow card");

	int count = 0;
	char playerName[MAX_NAME_LENGTH];
	char playerSteamid[32];

	KeyValues keygroup = new KeyValues("refereeCards");
	keygroup.ImportFromFile(pathRefCardsFile);
	keygroup.GotoFirstSubKey();

	do
	{
		if (keygroup.GetNum("yellow", 0))
		{
			count++;

			keygroup.GetSectionName(playerSteamid, sizeof(playerSteamid));
			keygroup.GetString("name", playerName, sizeof(playerName));
			menu.AddItem(playerSteamid, playerName);
		}
	}
	while (keygroup.GotoNextKey());
	keygroup.Close();

	if (count)
	{
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] There are no players with a yellow card", prefixcolor, prefix);
		OpenRefereeMenu(client);
	}
}

public int RemoveYellowCardMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char targetSteamid[32];
		menu.GetItem(choice, targetSteamid, sizeof(targetSteamid));

		KeyValues keygroup = new KeyValues("refereeCards");
		keygroup.ImportFromFile(pathRefCardsFile);
		keygroup.JumpToKey(targetSteamid, true);

		if (keygroup.GetNum("yellow", 0))
		{
			char clientSteamid[32];
			GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

			char playerName[MAX_NAME_LENGTH];
			keygroup.GetString("name", playerName, sizeof(playerName));

			char playerSteamid[32];
			keygroup.GetSectionName(playerSteamid, sizeof(playerSteamid));

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has removed the yellow card from %s", prefixcolor, prefix, textcolor, client, playerName);
			}

			keygroup.SetNum("yellow", 0);

			keygroup.Rewind();
			keygroup.ExportToFile(pathRefCardsFile);
			keygroup.Close();
			
			OpenRemoveYellowCardMenu(client);
		}
		else CPrintToChat(client, "{%s}[%s] Yellow card already removed", prefixcolor, prefix);

		keygroup.Close();

		OpenRefereeMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6) OpenRefereeMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ***********************************************************************************************************************
// ************************************************** REMOVE RED MENU ****************************************************
// ***********************************************************************************************************************

public void OpenRemoveRedCardMenu(int client)
{
	Menu menu = new Menu(RemoveRedCardMenuHandler);

	menu.SetTitle("Soccer - Remove red card");

	int count = 0;
	char playerName[MAX_NAME_LENGTH];
	char playerSteamid[32];

	KeyValues keygroup = new KeyValues("refereeCards");
	keygroup.ImportFromFile(pathRefCardsFile);
	keygroup.GotoFirstSubKey();

	do
	{
		if (keygroup.GetNum("red", 0))
		{
			count++;

			keygroup.GetSectionName(playerSteamid, sizeof(playerSteamid));
			keygroup.GetString("name", playerName, sizeof(playerName));
			menu.AddItem(playerSteamid, playerName);
		}
	}
	while (keygroup.GotoNextKey());
	keygroup.Close();

	if (count)
	{
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] There are no players with a red card", prefixcolor, prefix);
		OpenRefereeMenu(client);
	}
}

public int RemoveRedCardMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char targetSteamid[32];
		menu.GetItem(choice, targetSteamid, sizeof(targetSteamid));

		KeyValues keygroup = new KeyValues("refereeCards");
		keygroup.ImportFromFile(pathRefCardsFile);
		keygroup.JumpToKey(targetSteamid, true);

		if (keygroup.GetNum("red", 0))
		{
			char clientSteamid[32];
			GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

			char playerName[MAX_NAME_LENGTH];
			keygroup.GetString("name", playerName, sizeof(playerName));

			char playerSteamid[32];
			keygroup.GetSectionName(playerSteamid, sizeof(playerSteamid));

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has removed the red card from %s", prefixcolor, prefix, textcolor, client, playerName);
			}

			keygroup.SetNum("yellow", 0);
			keygroup.SetNum("red", 0);

			keygroup.Rewind();
			keygroup.ExportToFile(pathRefCardsFile);
			keygroup.Close();
			
			OpenRemoveRedCardMenu(client);
		}
		else CPrintToChat(client, "{%s}[%s] Red card already removed", prefixcolor, prefix);

		keygroup.Close();

		OpenRefereeMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6) OpenRefereeMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}


// ***************************************************************************************************************
// ************************************************** FUNCTIONS **************************************************
// ***************************************************************************************************************
public bool PlayerHasCard(char[] steamid, char[] card)
{
	KeyValues keygroup = new KeyValues("refereeCards");
	keygroup.ImportFromFile(pathRefCardsFile);

	keygroup.JumpToKey(steamid, true);

	if (keygroup.GetNum(card, 0)) return true;
	return false;
}

public void RemoveAllCards(int client)
{
	DeleteFile(pathRefCardsFile);

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has removed all cards", prefixcolor, prefix, textcolor, client);
	}

	char clientSteamid[32];
	GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

	OpenRefereeMenu(client);
}
