// ***************************************************************************************************************
// ************************************************* RULES MENU **************************************************
// ***************************************************************************************************************
public void OpenMenuRules(int client)
{
	Menu menu = new Menu(MenuHandlerRules);

	menu.SetTitle("Soccer - Rules");

	GetRules(menu);

	if(menuaccessed[client] == true) menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerRules(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		PrintToChat(client, "bla");
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMainMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void GetRules(Menu menu)
{
	char rulesString[128];
	kvRules = new KeyValues("Rules");
	kvRules.ImportFromFile(rulesKV);

	kvRules.GotoFirstSubKey();
	do
	{
		kvRules.GetString("rule", rulesString, sizeof(rulesString), "");
		menu.AddItem("rule", rulesString, ITEMDRAW_DISABLED);
	}
	while kvRules.GotoNextKey();

	kvRules.Rewind();
	kvRules.Close();
}