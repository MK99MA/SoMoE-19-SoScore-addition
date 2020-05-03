#include "soccer_modules\menu\adverts.sp"
#include "soccer_modules\menu\help.sp"
#include "soccer_modules\menu\changemap.sp"
#include "soccer_modules\menu\referee.sp"
#include "soccer_modules\menu\spec_player.sp"
#include "soccer_modules\menu\adminlists.sp"
#include "soccer_modules\menu\settings.sp"
#include "soccer_modules\menu\rules.sp"

public void OpenMainMenu(int client)
{
	Menu menu = new Menu(MenuHandlerMain);
	menu.SetTitle("Soccer Menu");
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	SetMenuExitButton(menu, true);

	Handle shoutplugin = FindPluginByFile("shout.smx");	

	if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC))
	{
		menu.AddItem("admin", "Admin");
	}

	menu.AddItem("sprintinfo", "Sprintsettings");
	
	if (shoutplugin != INVALID_HANDLE)
	{
		menu.AddItem("shout", "Shouts");
	}
	
	menu.AddItem("rules", "Rules");
	
	menu.AddItem("admins", "Online admins");
	
	menu.AddItem("help", "Help");

	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMain(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "admin"))
		{
			if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC))	OpenMenuAdmin(client);
		}
		else if (StrEqual(menuItem, "help"))		OpenMenuHelp(client);
		else if (StrEqual(menuItem, "sprintinfo"))  OpenInfoPanel(client);
		else if (StrEqual(menuItem, "admins"))		
		{
			menuaccessed[client] = true;
			OpenMenuOnlineAdmin(client);
		}
		else if (StrEqual(menuItem, "rules"))		
		{
			menuaccessed[client] = true;
			OpenMenuRules(client);
		}
		else if (StrEqual(menuItem, "shout"))		FakeClientCommandEx(client, "sm_shout");
	}
	else if (action == MenuAction_End) menu.Close();
}

// ****************************************************************************************************************
// ************************************************** ADMIN MENU **************************************************
// ****************************************************************************************************************
public void OpenMenuAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerAdmin);

	menu.SetTitle("Soccer Mod - Admin");

	menu.AddItem("referee", "Referee");

	menu.AddItem("spec", "Spec Player");

	menu.AddItem("change", "Change Map");	
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("settings", "Misc settings");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdmin(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "spec"))				OpenMenuSpecPlayer(client);
		else if (StrEqual(menuItem, "change")) 		OpenMenuMapsChange(client);
		else if (StrEqual(menuItem, "referee"))		OpenRefereeMenu(client);
		else if (StrEqual(menuItem, "skins"))		OpenSkinsMenu(client);
		else if (StrEqual(menuItem, "settings"))	OpenMenuSettings(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMainMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

