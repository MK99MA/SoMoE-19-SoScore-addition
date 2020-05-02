// ***************************************************************************************************************
// ************************************************** HELP MENU **************************************************
// ***************************************************************************************************************
public void OpenMenuHelp(int client)
{
	Menu menu = new Menu(MenuHandlerHelp);

	menu.SetTitle("Soccer - Help");

	menu.AddItem("commands", "Chat Commands");

	menu.AddItem("sprint","bind <key> say !sprint or +use key (default E) to sprint", ITEMDRAW_DISABLED);

	menu.AddItem("guide", "Guide");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerHelp(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "commands"))				 OpenMenuCommands(client);
		else if (StrEqual(menuItem, "sprint"))			  OpenMenuHelp(client);
		else if (StrEqual(menuItem, "guide"))
		{
			PrintToChat(client, "{%s}[%s] {%s}http://steamcommunity.com/sharedfiles/filedetails/?id=267151106", prefix);
			OpenMenuHelp(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMainMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuCommands(int client)
{
	Menu menu = new Menu(MenuHandlerCommands);

	menu.SetTitle("Soccer - Help - Chat Commands");

	menu.AddItem("menu", "!soccer");
	menu.AddItem("gk", "!gk");
	menu.AddItem("maprr", "!maprr");
	menu.AddItem("commands", "!commands");
	menu.AddItem("adminlist", "!admins");
	menu.AddItem("help", "!help");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerCommands(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "menu"))				PrintToChat(client, "[%s] Opens the Soccer main menu", prefix);
		else if (StrEqual(menuItem, "help"))		PrintToChat(client, "[%s] Opens the Soccer help menu", prefix);
		else if (StrEqual(menuItem, "gk"))		  	PrintToChat(client, "[%s] Enables or disables the goalkeeper skin", prefix);
		else if (StrEqual(menuItem, "maprr"))		PrintToChat(client, "[%s] Reload the current map; Requires admin", prefix);
		else if (StrEqual(menuItem, "commands"))	PrintToChat(client, "[%s] Opens the Soccer commands menu", prefix);
		else if (StrEqual(menuItem, "adminlist"))	PrintToChat(client, "[%s] Shows the current online admins", prefix);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuHelp(client);
	else if (action == MenuAction_End)					  menu.Close();
}