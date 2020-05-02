// ******************************************************************************************************************
// ************************************************** ALLOWED MAPS **************************************************
// ******************************************************************************************************************
public void LoadAllowedMaps()
{
	File file = OpenFile(allowedMapsConfigFile, "r");
	allowedMaps = CreateArray(128);

	if (file != null)
	{
		char map[128];
		int length;

		while (!file.EndOfFile() && file.ReadLine(map, sizeof(map)))
		{
			length = strlen(map);
			if (map[length - 1] == '\n') map[--length] = '\0';

			if (map[0] != '/' && map[1] != '/' && map[0]) PushArrayString(allowedMaps, map);
		}

		file.Close();
	}
	else CreateAllowedMapsFile();
}

public void CreateAllowedMapsFile()
{
	File file = OpenFile(allowedMapsConfigFile, "w");
	
	PushArrayString(allowedMaps, "ka_soccer_xsl_stadium_b1");
	if (FileExists("maps/ka_soccer_stadium_2019_b1.bsp")) PushArrayString(allowedMaps, "ka_soccer_stadium_2019_b1");
	file.WriteLine("ka_soccer_xsl_stadium_b1");
	if (FileExists("maps/ka_soccer_stadium_2019_b1.bsp")) file.WriteLine("ka_soccer_stadium_2019_b1");

	file.Close();
}

public bool IsCurrentMapAllowed()
{
	char map[128];
	GetCurrentMap(map, sizeof(map));
	if (FindStringInArray(allowedMaps, map) > -1) return true;
	return false;
}

public void SaveAllowedMaps()
{
	int i;
	File file = OpenFile(allowedMapsConfigFile, "w");

	if (file != null)
	{
		while (i < GetArraySize(allowedMaps))
		{
			char map[128];
			GetArrayString(allowedMaps, i, map, sizeof(map));
			file.WriteLine(map);
			i++;
		}

		file.Close();
	}
}

public void OpenMapsDirectory(char path[PLATFORM_MAX_PATH], Menu menu)
{
	Handle dir = OpenDirectory(path);
	if (dir != INVALID_HANDLE)
	{	
		FileType type;
		char filename[PLATFORM_MAX_PATH];

		while (ReadDirEntry(dir, filename, sizeof(filename), type))
		{
			if (!StrEqual(filename, ".") && !StrEqual(filename, ".."))
			{
				char full[PLATFORM_MAX_PATH];
				Format(full, sizeof(full), "%s/%s", path, filename);

				if (type == FileType_File)
				{
					int replaced = ReplaceString(filename, sizeof(filename), ".bsp", "");
					Format(full, sizeof(full), "%s/%s", path, filename);
					ReplaceString(full, sizeof(full), "maps/", "");
					if (FindStringInArray(allowedMaps, full) < 0 && replaced && IsMapValid(full)) menu.AddItem(full, full);
				}
				else if (type == FileType_Directory) OpenMapsDirectory(full, menu);
			}
		}

		dir.Close();
	}
}

// ***************************************************************************************************************
// ************************************************** MAPS MENU **************************************************
// ***************************************************************************************************************
public void OpenMenuMaps(int client)
{
	Menu menu = new Menu(MenuHandlerMaps);

	menu.SetTitle("Soccer - Admin -  Allowed Maps");

	menu.AddItem("add", "Add Map");

	menu.AddItem("remove", "Remove Map");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMaps(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "add"))					  OpenMenuMapsAdd(client);
		else if (StrEqual(menuItem, "remove"))			  OpenMenuMapsRemove(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ******************************************************************************************************************
// ************************************************** ADD MAP MENU **************************************************
// ******************************************************************************************************************
public void OpenMenuMapsAdd(int client)
{
	Menu menu = new Menu(MenuHandlerMapsAdd);

	menu.SetTitle("Soccer - Admin - Allowed Maps - Add");

	OpenMapsDirectory("maps", menu);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMapsAdd(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char map[128];
		menu.GetItem(choice, map, sizeof(map));

		if (FindStringInArray(allowedMaps, map) > -1) PrintToChat(client, "[%s] %s is already added to the allowed maps list.", prefix, map);
		else
		{
			PushArrayString(allowedMaps, map);
			SaveAllowedMaps();

			PrintToChat(client, "[%s] %s added to the allowed maps list.", prefix, map);
		}

		OpenMenuMaps(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMaps(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *********************************************************************************************************************
// ************************************************** REMOVE MAP MENU **************************************************
// *********************************************************************************************************************
public void OpenMenuMapsRemove(int client)
{
	File file = OpenFile(allowedMapsConfigFile, "r");

	if (file != null)
	{
		Menu menu = new Menu(MenuHandlerMapsRemove);

		menu.SetTitle("Soccer - Admin - Allowed Maps - Remove");

		char map[128];
		int length;

		while (!file.EndOfFile() && file.ReadLine(map, sizeof(map)))
		{
			length = strlen(map);
			if (map[length - 1] == '\n') map[--length] = '\0';

			if (map[0] != '/' && map[1] != '/' && map[0]) menu.AddItem(map, map);
		}

		file.Close();
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		PrintToChat(client, "[%s] Allowed maps list is empty.", prefix);
		OpenMenuMaps(client);
	}
}

public int MenuHandlerMapsRemove(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char map[128];
		menu.GetItem(choice, map, sizeof(map));

		if (FindStringInArray(allowedMaps, map) > -1)
		{
			int index = FindStringInArray(allowedMaps, map);
			RemoveFromArray(allowedMaps, index);
			SaveAllowedMaps();
			LoadAllowedMaps();

			PrintToChat(client, "[%s] %s removed from the allowed maps list.", prefix, map);
		}
		else PrintToChat(client, "[%s] %s is already removed from the allowed maps list.", prefix, map);

		OpenMenuMaps(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMaps(client);
	else if (action == MenuAction_End)					  menu.Close();
}