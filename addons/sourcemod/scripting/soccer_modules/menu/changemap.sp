// *********************************************************************************************************************
// ************************************************** CHANGE MAP MENU **************************************************
// *********************************************************************************************************************
public void OpenMenuMapsChange(int client)
{
	File file = OpenFile(allowedMapsConfigFile, "r");

	if (file != null)
	{
		Menu menu = new Menu(MenuHandlerMapsChange);

		menu.SetTitle("Soccer - Admin - Change Map");

		char map[128];
		int length;

		while (!file.EndOfFile() && file.ReadLine(map, sizeof(map)))
		{
			length = strlen(map);
			if (map[length - 1] == '\n') map[--length] = '\0';

			if (map[0] != '/' && map[1] != '/' && map[0] && IsMapValid(map)) menu.AddItem(map, map);
		}

		file.Close();
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		PrintToChat(client, "[%s] Allowed maps list is empty", prefix);
		OpenMenuAdmin(client);
	}
}

public int MenuHandlerMapsChange(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char map[128];
		menu.GetItem(choice, map, sizeof(map));

		char command[128];
		Format(command, sizeof(command), "changelevel %s", map);

		Handle pack;
		CreateDataTimer(3.0, DelayedServerCommand, pack);
		WritePackString(pack, command);

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) PrintToChat(player, "[%s]%N has changed the map to %s", prefix, client, map);
			if(GetClientMenu(player) != MenuSource_None )	
			{
				CancelClientMenu(player,false);
				InternalShowMenu(player, "\10", 1); 
			}
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}