// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************
public Action SayCommandListener(int client, char[] command, int argc)
{
	char cmdArg1[32];
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));

	float customInterval	= StringToFloat(cmdArg1);
	char custom_tag[32], custom_cmd[32];
	custom_cmd = cmdArg1;
	custom_tag = cmdArg1;

	if (StrEqual(changeSetting[client], "CustomPrefix"))
	{
		ChatSet(client, "CustomPrefix", custom_tag);
		return Plugin_Handled;			
	}
	else if (StrEqual(changeSetting[client], "CustomPrefixCol"))
	{
		ChatSet(client, "CustomPrefixCol", custom_tag);
		return Plugin_Handled;			
	}
	else if (StrEqual(changeSetting[client], "TextCol"))
	{
		ChatSet(client, "TextCol", custom_tag);
		return Plugin_Handled;			
	}	
	else if (StrEqual(changeSetting[client], "CustomCommand"))
	{
		CommandSet(client, "Command", custom_cmd);
		return Plugin_Handled;	
	}
	else if (StrEqual(changeSetting[client], "AdvertInterval"))
	{
		IntervalSet(client, "Interval", customInterval, 10.0, 300.0);
		return Plugin_Handled;	
	}

	return Plugin_Continue;
}

// *******************************************************************************************************************
// ************************************************* CHAT LISTENER ***************************************************
// *******************************************************************************************************************
public void IntervalSet(int client, char type[32], float interval, float min, float max)
{
	if (interval >= min && interval <= max || interval == 0)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		
		if (StrEqual(type, "Interval"))
		{
			if(interval != 0)
			{
				advertInterval = interval;
				UpdateConfigFloat("Adverts Settings", "soccer_adverts_interval", interval);
				if (advertTimer != INVALID_HANDLE)	delete advertTimer; // KILL TIMER

				advertTimer = CreateTimer(advertInterval, DisplayAdvert, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

				CPrintToChat(client, "{%s}[%s] {%s}Set the advert interval to {%s}%.1f.", prefixcolor, prefix, textcolor, prefixcolor, interval);
			}
			else
			{
				OpenMenuChat(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		
		changeSetting[client] = "";
		OpenMenuAdverts(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Please use an interval between %.1f and %.1f seconds.", prefixcolor, prefix, textcolor, min, max);
}

public void CommandSet(int client, char type[32], char custom_cmd[32])
{
	int min = 0;
	int max = 32;

	if (strlen(custom_cmd) >= min && strlen(custom_cmd) <= max)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		
		if (StrEqual(type, "Command"))
		{
			if(!StrEqual(custom_cmd, "!cancel"))
			{
				commandString = custom_cmd;
				UpdateConfig("Misc Settings", "soccer_command", commandString);
				
				CPrintToChat(client, "{%s}[%s] {%s}Set the menu command to {%s}%s.", prefixcolor, prefix, textcolor, prefixcolor, custom_cmd);
			}
			else 
			{
				OpenMenuChat(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		
		changeSetting[client] = "";
		OpenMenuChat(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Prefix is too long. Please use a prefix with %i to %i characters.", prefixcolor, prefix, textcolor, min, max);
}

public void ChatSet(int client, char type[32], char custom_tag[32])
{
	int min = 0;
	int max = 32;
	if (strlen(custom_tag) >= min && strlen(custom_tag) <= max)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		
		if (StrEqual(type, "CustomPrefix"))
		{
			if(!StrEqual(custom_tag, "!cancel"))
			{
				prefix = custom_tag;
				UpdateConfig("Chat Settings", "soccer_prefix", prefix);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the prefix to {%s}[%s].", prefixcolor, prefix, textcolor, client, prefixcolor, custom_tag);
				}
			}
			else 
			{
				OpenMenuChatStyle(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "CustomPrefixCol"))
		{
			if(!StrEqual(custom_tag, "!cancel"))
			{
				prefixcolor = custom_tag;
				UpdateConfig("Chat Settings", "soccer_prefixcolor", prefixcolor);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the prefixcolor to {%s}%s.", prefixcolor, prefix, textcolor, client, custom_tag, custom_tag);
				}
			}
			else 
			{
				OpenMenuChatStyle(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "TextCol"))
		{
			if(!StrEqual(custom_tag, "!cancel"))
			{
				textcolor = custom_tag;
				UpdateConfig("Chat Settings", "soccer_textcolor", textcolor);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the textcolor to {%s}%s.", prefixcolor, prefix, textcolor, client, custom_tag, custom_tag);
				}
			}
			else
			{
				OpenMenuChatStyle(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		
		changeSetting[client] = "";
		OpenMenuChatStyle(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Prefix is too long. Please use a prefix with %i to %i characters.", prefixcolor, prefix, textcolor, min, max);
}