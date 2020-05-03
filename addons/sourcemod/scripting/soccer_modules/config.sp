public void ConfigFunc()
{
	if (!FileExists(configFileKV)) CreateSoccerConfig();
	if (!FileExists("cfg/sm_soccer/soccer_downloads.cfg"))
	{
		CreateDownloadFile();
		AutoExecConfig(false, "soccer_downloads", "sm_soccer");
	}
	else AutoExecConfig(false, "soccer_downloads", "sm_soccer");
	if (!FileExists(skinsKeygroup)) CreateSkinsConfig();
	if (!FileExists(rulesKV))		CreateRules();
	if (!FileExists(advertsKV))		CreateAdverts();
	
	if (FileExists(configFileKV)) 	ReadFromConfig();
}

public void CreateSoccerConfig()
{
	File hFile = OpenFile(configFileKV, "w");
	hFile.Close();
	kvConfig = new KeyValues("Soccer Config");
	kvConfig.ImportFromFile(configFileKV);

	kvConfig.JumpToKey("Chat Settings", true);
	kvConfig.SetString("soccer_prefix", 					prefix);
	kvConfig.SetString("soccer_textcolor", 					textcolor);
	kvConfig.SetString("soccer_prefixcolor", 				prefixcolor);
	kvConfig.SetNum("soccer_deadchat_mode",					DeadChatMode);
	kvConfig.SetNum("soccer_deadchat_visibility",			DeadChatVis);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Adverts Settings", true);
	kvConfig.SetNum("soccer_adverts_enabled",				advertEnabled);
	kvConfig.SetFloat("soccer_adverts_interval",			advertInterval);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	kvConfig.SetNum("soccer_damagesounds",					damageSounds);
	kvConfig.SetNum("soccer_dissolver",						dissolveSet);
	kvConfig.SetString("soccer_command",					commandString);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Sprint Settings", true);
	kvConfig.SetNum("soccer_sprint_enable",					bSPRINT_ENABLED);
	kvConfig.SetFloat("soccer_sprint_speed",				fSPRINT_SPEED);
	kvConfig.SetFloat("soccer_sprint_time",					fSPRINT_TIME);
	kvConfig.SetFloat("soccer_sprint_cooldown",				fSPRINT_COOLDOWN);
	kvConfig.SetNum("soccer_sprint_button",					bSPRINT_BUTTON);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Current Skins", true);
	kvConfig.SetString("soccer_skins_model_ct",				skinsModelCT);
	kvConfig.SetString("soccer_skins_model_t",				skinsModelT);
	kvConfig.SetString("soccer_skins_model_ct_gk",			skinsModelCTGoalkeeper);
	kvConfig.SetString("soccer_skins_model_t_gk",			skinsModelTGoalkeeper);
	kvConfig.GoBack();
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void CreateRules()
{
	File hFile = OpenFile(rulesKV, "w");
	hFile.Close();
	kvRules = new KeyValues("Rules");
	kvRules.ImportFromFile(rulesKV);
	kvRules.JumpToKey("rule1", true);
	kvRules.SetString("rule",			"Follow this example to add rules.");
	kvRules.GoBack();
	
	kvRules.JumpToKey("rule2", true);
	kvRules.SetString("rule",			"Try to keep it short, 128 chars is the limit per rule/line. But they can take alot of space using it. This is an example of it!");
	kvRules.GoBack();
	
	kvRules.JumpToKey("rule3", true);
	kvRules.SetString("rule",			"Each rule needs 1 section with a 'rule' key.");
	kvRules.GoBack();
	
	kvRules.JumpToKey("lelele", true);
	kvRules.SetString("rule",			"Section names don't have to be different");
	kvRules.GoBack();
	
	kvRules.JumpToKey("Gr8B8M8", true);
	kvRules.SetString("rule",			"And you can use any name you want.");
	kvRules.GoBack();
	
	kvRules.Rewind();
	kvRules.ExportToFile(rulesKV);
	kvRules.Close();
}

public void CreateAdverts()
{
	File hFile = OpenFile(advertsKV, "w");
	hFile.Close();
	kvAdverts = new KeyValues("Advertisements");
	kvAdverts.ImportFromFile(advertsKV);
	kvAdverts.JumpToKey("Chat Ad", true);
	kvAdverts.SetString("chat",			"Example of a chat advert.");
	kvAdverts.GoBack();
	
	kvAdverts.JumpToKey("Top Ad", true);
	kvAdverts.SetString("top",			"Example of a top advert");
	kvAdverts.GoBack();
	
	kvAdverts.JumpToKey("Center Ad", true);
	kvAdverts.SetString("center",			"Example of a center advert that won't show for generic admins");
	kvAdverts.SetString("flags",			"b");
	kvAdverts.GoBack();
	
	kvAdverts.JumpToKey("Menu Ad", true);
	kvAdverts.SetString("menu",			"Example of a menu advert\n across multiple lines");
	kvAdverts.GoBack();
	
	kvAdverts.JumpToKey("Hint Ad", true);
	kvAdverts.SetString("hint",			"Example of a hint advert");
	kvAdverts.GoBack();
	
	kvAdverts.JumpToKey("Multi Ad", true);
	kvAdverts.SetString("top",			"This will be shown at {crimson}top");
	kvAdverts.SetString("chat",			"{crimson} This will be shown in chat with other {yellow} colors.");
	kvAdverts.GoBack();
	
	kvAdverts.Rewind();
	kvAdverts.ExportToFile(advertsKV);
	kvAdverts.Close();
}

public void UpdateConfig(char section[32], char type[32], char value[32])
{
	if(!FileExists(configFileKV)) CreateSoccerConfig();
	kvConfig = new KeyValues("Soccer Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetString(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfigInt(char section[32], char type[50], int value)
{
	if(!FileExists(configFileKV)) CreateSoccerConfig();
	kvConfig = new KeyValues("Soccer Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetNum(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfigFloat(char section[32], char type[32], float value)
{
	if(!FileExists(configFileKV)) CreateSoccerConfig();
	kvConfig = new KeyValues("Soccer Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetFloat(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfigModels(char section[32], char type[32], char value[128])
{
	if(!FileExists(configFileKV)) CreateSoccerConfig();
	kvConfig = new KeyValues("Soccer Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetString(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void CreateDownloadFile()
{
	File hFile = OpenFile("cfg/sm_soccer/soccer_downloads.cfg", "at");
	hFile.WriteLine("//Adds a directory and all the subdirectories to the downloads - values: path/to/dir");
	hFile.WriteLine("//Example (without //):");
	hFile.WriteLine("//soccer_mod_downloads_add_dir materials\\models\\player\\soccer_mod");
	hFile.Close();
	
	if (FileExists("cfg/sm_soccer/soccer_downloads.cfg", false)) AutoExecConfig(false, "soccer_downloads", "sm_soccer");
}

public void CreateSkinsConfig()
{
	File hFile = OpenFile(skinsKeygroup, "w");
	hFile.Close();
	kvSkins = new KeyValues("Skins");
	kvSkins.ImportFromFile(skinsKeygroup);
	kvSkins.JumpToKey("Termi", true);
	kvSkins.SetString("CT",			skinsModelCT);
	kvSkins.SetString("T",			skinsModelT);
	kvSkins.SetString("CTGK",		skinsModelCTGoalkeeper);
	kvSkins.SetString("TGK",		skinsModelTGoalkeeper);
	
	kvSkins.Rewind();
	kvSkins.ExportToFile(skinsKeygroup);
	kvSkins.Close();
}

public void ReadFromConfig()
{
	kvConfig = new KeyValues("Soccer Config");
	kvConfig.ImportFromFile(configFileKV);

	kvConfig.JumpToKey("Chat Settings", false);
	kvConfig.GetString("soccer_prefix", prefix, sizeof(prefix), "Soccer Mod");
	kvConfig.GetString("soccer_textcolor", textcolor, sizeof(textcolor), "lightgreen");
	kvConfig.GetString("soccer_prefixcolor", prefixcolor, sizeof(prefixcolor), "green");
	DeadChatMode			= kvConfig.GetNum("soccer_deadchat_mode", 0);
	DeadChatVis				= kvConfig.GetNum("soccer_deadchat_visibility", 0);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Adverts Settings", false);
	advertEnabled			= kvConfig.GetNum("soccer_adverts_enabled",	0);
	advertInterval			= kvConfig.GetFloat("soccer_adverts_interval",	30.0);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	damageSounds			= kvConfig.GetNum("soccer_damagesounds", 0);
	dissolveSet				= kvConfig.GetNum("soccer_dissolver", 2);
	kvConfig.GetString("soccer_command", commandString, sizeof(commandString), "menu");			
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Sprint Settings", true);
	bSPRINT_ENABLED			= kvConfig.GetNum("soccer_sprint_enable", 1);
	fSPRINT_SPEED			= kvConfig.GetFloat("soccer_sprint_speed", 1.25);
	fSPRINT_TIME			= kvConfig.GetFloat("soccer_sprint_time", 3.0);
	fSPRINT_COOLDOWN		= kvConfig.GetFloat("soccer_sprint_cooldown", 7.5);
	bSPRINT_BUTTON			= kvConfig.GetNum("soccer_sprint_button", 1);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Current Skins", true);
	kvConfig.GetString("soccer_skins_model_ct", skinsModelCT, sizeof(skinsModelCT), "models/player/soccer_mod/termi/2011/away/ct_urban.mdl");
	kvConfig.GetString("soccer_skins_model_t", skinsModelT, sizeof(skinsModelT), "models/player/soccer_mod/termi/2011/home/ct_urban.mdl");
	kvConfig.GetString("soccer_skins_model_ct_gk", skinsModelCTGoalkeeper, sizeof(skinsModelCTGoalkeeper), "models/player/soccer_mod/termi/2011/gkaway/ct_urban.mdl");
	kvConfig.GetString("soccer_skins_model_t_gk", skinsModelTGoalkeeper, sizeof(skinsModelTGoalkeeper), "models/player/soccer_mod/termi/2011/gkhome/ct_urban.mdl");
	PrecacheModel(skinsModelCT);
	PrecacheModel(skinsModelT);
	PrecacheModel(skinsModelCTGoalkeeper);
	PrecacheModel(skinsModelTGoalkeeper);
	kvConfig.GoBack();

	kvConfig.Rewind();
	kvConfig.Close();
}