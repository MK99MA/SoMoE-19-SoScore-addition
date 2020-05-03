// ***************************************************************************************************************
// ****************************************** CHAT SETTINGS MENU *************************************************
// ***************************************************************************************************************
public void OpenMenuChat(int client)
{
	Menu menu = new Menu(MenuHandlerChat);

	char dcstate[32], command[32];
	if(DeadChatMode == 1) dcstate = "DeadChat: On";
	else if(DeadChatMode == 0) dcstate = "DeadChat: Off";
	else if(DeadChatMode == 2) dcstate = "DeadChat: Alltalk";
	
	Format(command, sizeof(command), "Menu Command: %s", commandString);

	menu.SetTitle("Soccer - Settings - Chat");

	menu.AddItem("chatstyle", "Chat Style");
	
	menu.AddItem("deadchatset", dcstate);
	
	menu.AddItem("advertset", "Adverts");
	
	menu.AddItem("command", command);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerChat(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "chatstyle")) 					OpenMenuChatStyle(client);
		else if (StrEqual(menuItem, "deadchatset"))				OpenMenuDeadChat(client);
		else if (StrEqual(menuItem, "advertset"))				OpenMenuAdverts(client);
		else if (StrEqual(menuItem, "command"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired chatcommand, !cancel to stop. Changing the command requires a {%s}SERVER RESTART.", prefixcolor, prefix, textcolor, prefixcolor);
			changeSetting[client] = "CustomCommand";
		}
	}

	else if (action == MenuAction_Cancel && choice == -6)		OpenMenuSettings(client);
	else if (action == MenuAction_End)							menu.Close();
}

public void OpenMenuChatStyle(int client)
{
	Menu menu = new Menu(MenuHandlerChatStyle);

	char currentPrefix[64], currentColor1[64], currentColor2[64];
	Format(currentPrefix, sizeof(currentPrefix), "Prefix: %s", prefix);
	Format(currentColor1, sizeof(currentColor1), "Prefix color: %s ", prefixcolor);
	Format(currentColor2, sizeof(currentColor2), "Text color: %s", textcolor);

	menu.SetTitle("Soccer - Settings - Chat Style");

	menu.AddItem("ch_prefix", currentPrefix);

	menu.AddItem("prefix_col", currentColor1);

	menu.AddItem("text_col", currentColor2);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerChatStyle(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "ch_prefix"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in your prefix without [] and \" around them, !cancel to stop. Current prefix is: {%s}[%s].", prefixcolor, prefix, textcolor, prefixcolor, prefix);
			changeSetting[client] = "CustomPrefix";
		}
		else if (StrEqual(menuItem, "prefix_col"))
		{
			OpenMenuColorlist(client);
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired prefixcolor, !cancel to stop. Current prefixcolor is: {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, prefixcolor);
			changeSetting[client] = "CustomPrefixCol";
		}
		else if (StrEqual(menuItem, "text_col"))
		{
			OpenMenuColorlist(client);
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired textcolor, !cancel to stop. Current textcolor is: {%s}%s", prefixcolor, prefix, textcolor, textcolor, textcolor);
			changeSetting[client] = "TextCol";
		}
	}

	else if (action == MenuAction_Cancel && choice == -6)	   OpenMenuChat(client);
	else if (action == MenuAction_End)						  menu.Close();
}