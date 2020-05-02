// **********************************************************************************************************************
// ************************************************** SPEC PLAYER MENU **************************************************
// **********************************************************************************************************************
public void OpenMenuSpecPlayer(int client)
{
	Menu menu = new Menu(MenuHandlerSpecPlayer);

	menu.SetTitle("Soccer - Admin - Spec player");

	int number = 0;
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player) && GetClientTeam(player) != 1)
		{
			number++;

			char playerid[8];
			IntToString(player, playerid, sizeof(playerid));

			char playerName[MAX_NAME_LENGTH];
			GetClientName(player, playerName, sizeof(playerName));

			menu.AddItem(playerid, playerName);
		}
	}

	if (number)
	{
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		PrintToChat(client, "[%s]All players already are in spectator", prefix);
		OpenMenuAdmin(client);
	}
}

public int MenuHandlerSpecPlayer(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[8];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		int target = StringToInt(menuItem);

		if (IsClientInGame(target) && IsClientConnected(target))
		{
			if (GetClientTeam(target) != 1)
			{
				ChangeClientTeam(target, 1);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) PrintToChat(player, "[%s]%N has put %N to spectator", prefix, client, target);
				}

				char clientSteamid[32];
				GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

				char targetSteamid[32];
				GetClientAuthId(target, AuthId_Engine, targetSteamid, sizeof(targetSteamid));

			}
			else PrintToChat(client, "[%s] Player is already in spectator", prefix);
		}
		else PrintToChat(client, "[%s] Player is no longer on the server", prefix);

		OpenMenuAdmin(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

