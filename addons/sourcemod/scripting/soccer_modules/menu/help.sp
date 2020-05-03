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
			CPrintToChat(client, "{%s}[%s] {%s}http://steamcommunity.com/sharedfiles/filedetails/?id=267151106", prefixcolor, prefix, textcolor);
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
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("maprr", "!maprr");
	menu.AddItem("commands", "!commands");
	menu.AddItem("adminlist", "!admins");
	menu.AddItem("help", "!help");
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("reloadads", "!reloadads");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerCommands(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "menu"))				CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer main menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "help"))		CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer help menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "gk"))		  	CPrintToChat(client, "{%s}[%s] {%s}Enables or disables the goalkeeper skin", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "maprr"))		CPrintToChat(client, "{%s}[%s] {%s}Reload the current map; Requires admin", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "commands"))	CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer commands menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "adminlist"))	CPrintToChat(client, "{%s}[%s] {%s}Shows the current online admins", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "adminlist"))	CPrintToChat(client, "{%s}[%s] {%s}Reloads the advertisements.", prefixcolor, prefix, textcolor);
		
		OpenMenuCommands(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuHelp(client);
	else if (action == MenuAction_End)					  menu.Close();
}