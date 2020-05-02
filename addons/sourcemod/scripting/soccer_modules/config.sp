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
	
	if (FileExists(configFileKV)) ReadFromConfig();
}

public void CreateSoccerConfig()
{
	File hFile = OpenFile(configFileKV, "w");
	hFile.Close();
	kvConfig = new KeyValues("Soccer Config");
	kvConfig.ImportFromFile(configFileKV);

	kvConfig.JumpToKey("Chat Settings", true);
	kvConfig.SetNum("soccer_deadchat_mode",					DeadChatMode);
	kvConfig.SetNum("soccer_deadchat_visibility",			DeadChatVis);
	kvConfig.SetString("soccer_chat_prefix",				prefix);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	kvConfig.SetNum("soccer_damagesounds",					damageSounds);
	kvConfig.SetNum("soccer_dissolver",						dissolveSet);
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
	DeadChatMode			= kvConfig.GetNum("soccer_deadchat_mode", 0);
	DeadChatVis				= kvConfig.GetNum("soccer_deadchat_visibility", 0);
	kvConfig.GetString("soccer_chat_prefix", prefix, sizeof(prefix));
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	damageSounds			= kvConfig.GetNum("soccer_damagesounds", 0);
	dissolveSet				= kvConfig.GetNum("soccer_dissolver", 2);
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