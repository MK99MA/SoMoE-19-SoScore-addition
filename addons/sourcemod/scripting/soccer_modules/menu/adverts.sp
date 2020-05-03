// ***************************************************************************************************************
// **************************************** ADVERT SETTINGS MENU *************************************************
// ***************************************************************************************************************
public void OpenMenuAdverts(int client)
{
	Menu menu = new Menu(MenuHandlerAdverts);

	char adstate[32], adstate2[32];
	if(advertEnabled == 0) adstate = "Adverts: Off";
	else if(advertEnabled == 1) adstate = "Adverts: On";
	
	Format(adstate2, sizeof(adstate2), "Advert Interval: %.1f", advertInterval);

	menu.SetTitle("Soccer - Settings - Adverts");

	menu.AddItem("toggle", adstate);
	
	menu.AddItem("interval", adstate2);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdverts(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "toggle")) 					
		{
			if(advertEnabled == 0)
			{	
				advertEnabled = 1;
				UpdateConfigInt("Adverts Settings", "soccer_adverts_enabled", advertEnabled);
				OpenMenuAdverts(client);
				FakeClientCommandEx(client, "sm_reloadads");
			}
			else if(advertEnabled == 1)
			{	
				advertEnabled = 0;
				UpdateConfigInt("Adverts Settings", "soccer_adverts_enabled", advertEnabled);
				OpenMenuAdverts(client);
			}
		}
		else if (StrEqual(menuItem, "interval"))				
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired advert interval, 0 to stop.", prefixcolor, prefix, textcolor);
			changeSetting[client] = "AdvertInterval";
		}
	}

	else if (action == MenuAction_Cancel && choice == -6)		OpenMenuChat(client);
	else if (action == MenuAction_End)							menu.Close();
}