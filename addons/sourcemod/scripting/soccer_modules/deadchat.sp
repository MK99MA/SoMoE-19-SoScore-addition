public void OpenMenuDeadChat(int client)
{
	char currentDeadChatSet[64], currentDeadChatSet2[64], dcstate[32], dcvisstate[32];
	if(DeadChatMode == 1) dcstate = "On";
	else if(DeadChatMode == 0) dcstate = "Off";
	else if(DeadChatMode == 2) dcstate = "Alltalk";
	if(DeadChatVis == 1) dcvisstate = "Teammates";
	else if(DeadChatVis == 0) dcvisstate = "Default";
	else if(DeadChatVis == 2) dcvisstate = "Everyone";
	
	Format(currentDeadChatSet, sizeof(currentDeadChatSet), "DeadChat: %s ", dcstate);
	Format(currentDeadChatSet2, sizeof(currentDeadChatSet2), "Visibility: %s", dcvisstate);
	Menu menu = new Menu(MenuHandlerDeadChat);
	menu.SetTitle("Soccer - Admin - Deadchat Settings");

	menu.AddItem("enable", "Enable");

	menu.AddItem("alltalk", "Enable if Alltalk On");

	menu.AddItem("disable", "Disable");
	
	menu.AddItem("visibility", "Visibility");
	
	menu.AddItem("locknumber", currentDeadChatSet, ITEMDRAW_DISABLED);
	menu.AddItem("locknumber", currentDeadChatSet2, ITEMDRAW_DISABLED);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerDeadChat(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "enable"))
		{
			DeadChatMode = 1;
			UpdateConfigInt("Chat Settings", "soccer_deadchat_mode", DeadChatMode);
			PrintToChat(client, "[%s] Deadchat enabled.", prefix);
			OpenMenuDeadChat(client);
		}
		else if (StrEqual(menuItem, "disable"))
		{
			DeadChatMode = 0;
			UpdateConfigInt("Chat Settings", "soccer_deadchat_mode", DeadChatMode);
			PrintToChat(client, "[%s] Deadchat disabled.", prefix);
			OpenMenuDeadChat(client);
		}
		else if (StrEqual(menuItem, "alltalk"))
		{
			DeadChatMode = 2;
			UpdateConfigInt("Chat Settings", "soccer_deadchat_mode", DeadChatMode);
			PrintToChatAll("[%s] Deadchat enabled if sv_alltalk = 1.", prefix);
			OpenMenuDeadChat(client);
		}
		else if (StrEqual(menuItem, "visibility"))
		{
			OpenMenuDeadChatVis(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuDeadChatVis(int client)
{

	Menu menu = new Menu(MenuHandlerDeadChatSetVis);
	menu.SetTitle("Soccer - Admin - Deadchat Settings");

	menu.AddItem("default", "Default");

	menu.AddItem("teammates", "All Teammates");

	menu.AddItem("everyone", "Everyone");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerDeadChatSetVis(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "default"))
		{
			DeadChatVis = 0;
			UpdateConfigInt("Chat Settings", "soccer_deadchat_visibility", DeadChatVis);
			PrintToChat(client, "[%s] Deadchat visibility set to default.", prefix);
			OpenMenuDeadChatVis(client);
		}
		else if (StrEqual(menuItem, "teammates"))
		{
			DeadChatVis = 1;
			UpdateConfigInt("Chat Settings", "soccer_deadchat_visibility", DeadChatVis);
			PrintToChat(client, "[%s] Deadchat visibility set to teammates.", prefix);
			OpenMenuDeadChatVis(client);
		}
		else if (StrEqual(menuItem, "everyone"))
		{
			DeadChatVis = 2;
			UpdateConfigInt("Chat Settings", "soccer_deadchat_visibility", DeadChatVis);
			PrintToChat(client, "[%s] Deadchat visibility set to everyone.", prefix);
			OpenMenuDeadChatVis(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuDeadChat(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ********************************************************************************************************************
// ************************************************** DEADCHAT MODULE *************************************************
// ********************************************************************************************************************
public void DeadChatOnPluginStart()
{
	UserMsg SayText2 = GetUserMessageId("SayText2");
	
	if (SayText2 == INVALID_MESSAGE_ID)
	{
		SetFailState("This game doesn't support SayText2 user messages.");
	}
	
	HookUserMessage(SayText2, Hook_UserMessage);
	HookEvent("player_say", Event_PlayerSay);
	
	// Convars.
	g_hCvarAllTalk = FindConVar("sv_alltalk");		
	
	// Commands.
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say_team");
	
}

public Action Hook_UserMessage(UserMsg msg_id, Handle bf, const char[] players, int playersNum, bool reliable, bool init)
{
	g_msgAuthor = BfReadByte(bf);
	g_msgIsChat = view_as<bool>(BfReadByte(bf));
	BfReadString(bf, g_msgType, sizeof(g_msgType), false);
	BfReadString(bf, g_msgName, sizeof(g_msgName), false);
	BfReadString(bf, g_msgText, sizeof(g_msgText), false);
	
	for (int i = 0; i < playersNum; i++)
	{
		g_msgTarget[players[i]] = false;
	}
}

public Action Event_PlayerSay(Handle event, const char[] name, bool dontBroadcast)
{
	int mode = DeadChatMode;
	
	if (mode < 1)
	{
		return;
	}
	
	if (mode > 1 && g_hCvarAllTalk != INVALID_HANDLE && !GetConVarBool(g_hCvarAllTalk))
	{
		return;
	}
	
	if (GetClientOfUserId(GetEventInt(event, "userid")) != g_msgAuthor)
	{
		return;
	}
	
	mode = DeadChatVis;
	
	if (g_msgIsTeammate && mode < 1)
	{
		return;
	}
	
	int[] players = new int[MaxClients];
	int playersNum = 0;
	
	if (g_msgIsTeammate && mode == 1 && g_msgAuthor > 0)
	{
		int team = GetClientTeam(g_msgAuthor);
		
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && g_msgTarget[client] && GetClientTeam(client) == team)
			{
				players[playersNum++] = client;
			}
			
			g_msgTarget[client] = false;
		}
	}
	else
	{
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && g_msgTarget[client])
			{
				players[playersNum++] = client;
			}
			
			g_msgTarget[client] = false;
		}
	}
	
	if (playersNum == 0)
	{
		return;
	}
	
	Handle SayText2 = StartMessage("SayText2", players, playersNum, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS);
	
	if (SayText2 != INVALID_HANDLE)
	{
		BfWriteByte(SayText2, g_msgAuthor);
		BfWriteByte(SayText2, g_msgIsChat);
		BfWriteString(SayText2, g_msgType);
		BfWriteString(SayText2, g_msgName);
		BfWriteString(SayText2, g_msgText);
		EndMessage();
	}
}

public Action Command_Say(int client, const char[] command, int argc)
{
	for (int target = 1; target <= MaxClients; target++)
	{
		g_msgTarget[target] = true;
	}
	
	if (StrEqual(command, "say_team", false))
	{
		g_msgIsTeammate = true;
	}
	else
	{
		g_msgIsTeammate = false;
	}
	
	return Plugin_Continue;
}