// *******************************************************************************************************************
// ************************************************** ONLINE LIST ****************************************************
// *******************************************************************************************************************

public void OpenMenuOnlineAdmin(int client)
{
	int onlinecount = 0;
	
	Menu menu = new Menu(MenuHandlerOnlineAdmin);
	menu.SetTitle("Online Admins");

	for (int clientindex = 1; clientindex <= MaxClients; clientindex++)
	{
		if (IsClientInGame(clientindex))
		{
			if(GetUserAdmin(clientindex) != INVALID_ADMIN_ID)
			{
				char AdminName[64];
				GetClientName(clientindex, AdminName, sizeof(AdminName));
				menu.AddItem(AdminName, AdminName, ITEMDRAW_DISABLED);
				onlinecount++;
			}
		}
	}
	if(onlinecount == 0) menu.AddItem("", "No Admins on the server", ITEMDRAW_DISABLED);
	
	if(menuaccessed == true) menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerOnlineAdmin(Menu menu, MenuAction action, int client, int choice)
{
	char clientName[64];
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)		PrintToChatAll("bla");
	
	else if (action == MenuAction_Cancel && choice == -6)   OpenMainMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}
