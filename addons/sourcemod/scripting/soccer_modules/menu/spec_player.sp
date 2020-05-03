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
		CPrintToChat(client, "{%s}[%s] {%s}All players already are in spectator", prefixcolor, prefix, textcolor);
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
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] [%s]%N has put %N to spectator", prefixcolor, prefix, textcolor, client, target);
				}

				char clientSteamid[32];
				GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

				char targetSteamid[32];
				GetClientAuthId(target, AuthId_Engine, targetSteamid, sizeof(targetSteamid));

			}
			else CPrintToChat(client, "{%s}[%s] {%s}Player is already in spectator", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Player is no longer on the server", prefixcolor, prefix, textcolor);

		OpenMenuAdmin(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

