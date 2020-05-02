// *******************************************************************************************************************
// ************************************************** SETTINGS MENU **************************************************
// *******************************************************************************************************************
public void OpenMenuSettings(int client)
{
	Menu menu = new Menu(MenuHandlerSettings);

	menu.SetTitle("Soccer Mod - Admin - Settings");

	char DamageString[32], DissolveString[32];
	
	if(damageSounds == 0)				DamageString = "Damage Sound: OFF";
	else if(damageSounds == 1)			DamageString = "Damage Sound: ON";
		
	if(dissolveSet == 0)				DissolveString = "Remove Ragdoll: OFF";
	else if(dissolveSet == 1)			DissolveString = "Remove Ragdoll: YES";
	else if (dissolveSet == 2)			DissolveString = "Remove Ragdoll: Dissolve";
		
	Handle shoutplugin = FindPluginByFile("shout.smx");	

	menu.AddItem("allowed", "Allowed Maps");
	menu.AddItem("chatset", "Deadchat Settings");
	menu.AddItem("skinsmenu", "Skins");
	menu.AddItem("damagesound", DamageString);
	menu.AddItem("dissolve", DissolveString);
	if (shoutplugin != INVALID_HANDLE)
	{
		if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, true)) menu.AddItem("shoutplug", "Shout Plugin");
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerSettings(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "chatset"))				OpenMenuDeadChat(client);
		else if (StrEqual(menuItem, "skinsmenu"))		OpenSkinsMenu(client);
		else if (StrEqual(menuItem, "shoutplug"))		FakeClientCommandEx(client, "sm_shoutset");
		else if (StrEqual(menuItem, "allowed"))			OpenMenuMaps(client);
		else if(StrEqual(menuItem, "damagesound")) 
		{
			if(damageSounds == 0)
			{
				damageSounds = 1;
				UpdateConfigInt("Misc Settings", "soccer_damagesounds", damageSounds);
				OpenMenuSettings(client);
			}
			else if(damageSounds >0)
			{
				damageSounds = 0;
				UpdateConfigInt("Misc Settings", "soccer_damagesounds", damageSounds);
				OpenMenuSettings(client);
			}
		}
		else if(StrEqual(menuItem, "dissolve")) 
		{
			if(dissolveSet == 0)
			{
				dissolveSet = 1;
				UpdateConfigInt("Misc Settings", "soccer_dissolver", dissolveSet);
				OpenMenuSettings(client);
			}
			else if(dissolveSet == 1)
			{
				dissolveSet = 2;
				UpdateConfigInt("Misc Settings", "soccer_dissolver", dissolveSet);
				OpenMenuSettings(client);
			}
			else if(dissolveSet >= 2)
			{
				dissolveSet = 0;
				UpdateConfigInt("Misc Settings", "soccer_dissolver", dissolveSet);
				OpenMenuSettings(client);
			}
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}