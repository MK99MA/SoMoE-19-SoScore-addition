// **************************************************************************************************************
// ************************************************** DEFINES ***************************************************
// **************************************************************************************************************
#define PLUGIN_VERSION "1.1.0"
#define UPDATE_URL "https://raw.githubusercontent.com/MK99MA/SoMoE-19-SoScore-addition/master/addons/sourcemod/updatefile.txt"

// **************************************************************************************************************
// ************************************************** INCLUDES **************************************************
// **************************************************************************************************************
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdkhooks>
#include <cstrike>
#include <morecolors>
#include <clientprefs>
#undef REQUIRE_PLUGIN
#include <updater>

#pragma newdecls required

#include "soccer_modules\globals.sp"
#include "soccer_modules\commands.sp"
#include "soccer_modules\chat_listener.sp"
#include "soccer_modules\config.sp"
#include "soccer_modules\colormenu.sp"
#include "soccer_modules\menu.sp"
#include "soccer_modules\misc_functions.sp"
#include "soccer_modules\modules\adverts.sp"
#include "soccer_modules\modules\chat.sp"
#include "soccer_modules\modules\deadchat.sp"
#include "soccer_modules\modules\sprint.sp"
#include "soccer_modules\modules\skins.sp"
#include "soccer_modules\modules\allowedMaps.sp"

// *****************************************************************************************************************
// ************************************************** PLUGIN INFO **************************************************
// *****************************************************************************************************************
public Plugin myinfo =
{
	name		 = "Soccer Modules Standalone",
	author		 = "Arturo",
	description	 = "Standalone sprint & skins modules taken from 'SoMoE-19' ",
	version		 = PLUGIN_VERSION,
	url			 = "https://github.com/MK99MA/SoMoE-19-Standalones"
};

// ******************************************************************************************************************
// ************************************************** PLUGIN START **************************************************
// ******************************************************************************************************************
public void OnPluginStart()
{
	CreateConVar("soccer_module_version", PLUGIN_VERSION, "Soccer Module version", FCVAR_NOTIFY| FCVAR_DONTRECORD);
	
	if (!DirExists("cfg/sm_soccer"))			CreateDirectory("cfg/sm_soccer", 511, false);
	
	AddNormalSoundHook(sound_hook);
	
	AddCommandListener(SayCommandListener, "say");
	AddCommandListener(SayCommandListener, "say2");
	AddCommandListener(SayCommandListener, "say_team");
	
	HookEvent("player_death",		   	EventPlayerDeath);
	HookEvent("player_spawn",		   	EventPlayerSpawn);
	
	LoadAllowedMaps();
	ConfigFunc();
	RegisterClientCommands();

	AdvertsOnPluginStart();
	DeadChatOnPluginStart();
	RefereeOnPluginStart();
	SkinsOnPluginStart();
	RefereeOnPluginStart();
	SprintOnPluginStart();
	
	
	// Updater******************************************
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin(UPDATE_URL)
	}
	//**************************************************
	
}

// Updater******************************************
public void OnLibraryAdded(const char []name)
{
	if (StrEqual(name, "updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
}
//**************************************************

// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	bLATE_LOAD = late;
	
	return APLRes_Success;
}

public void OnMapStart()
{
	//Create missing ConfigFiles and/or read them
	if (!FileExists(configFileKV) || !FileExists(skinsKeygroup))
	{
		ConfigFunc();
		ReadFromConfig();
	}
	else	ReadFromConfig();
	
	LoadAllowedMaps();

	AdvertsOnMapStart(); // Parse adverts & Start Timer
	SkinsOnMapStart();
	PrecacheSound("player/suit_sprint.wav");
	if(bLATE_LOAD)
	{
		SetEveryClientDefaultSettings();
		//Clientprefs
		ReadEveryClientCookie();
	}
	bLATE_LOAD = false;
}

public void OnAllPluginsLoaded()
{
	AddDirToDownloads("sound/soccermod");
	AddDirToDownloads("materials/models/soccer_mod");
	AddDirToDownloads("models/soccer_mod");
	
	AddDirToDownloads("materials/models/player/soccer_mod/termi/2011");
	AddDirToDownloads("models/player/soccer_mod/termi/2011");
}

public void OnClientPutInServer(int client)
{
	changeSetting[client] = "";

	SkinsOnClientPutInServer(client);
}

public void OnClientDisconnect(int client)
{
	WriteClientCookie(client);
}

public Action EventPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	RefereeEventPlayerSpawn(event);
	SkinsEventPlayerSpawn(event);
	
	//Sprint
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	ResetSprint(client);
	PrintSprintCDMsgToClient(client);
	iCLIENT_STATUS[client] &= ~ CLIENT_SPRINTUNABLE;
}

public Action EventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	//Sprint
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	ResetSprint(client);
	
	if(dissolveSet == 2) CreateTimer(0.0, Dissolve, client);
	else if(dissolveSet == 1) CreateTimer(5.0, Dissolve, client);
}

// ***************************************************************************************************************
// ************************************************** DOWNLOADS **************************************************
// ***************************************************************************************************************
public void AddDirToDownloads(char path[PLATFORM_MAX_PATH])
{
	Handle dir = OpenDirectory(path);

	if (dir != INVALID_HANDLE)
	{
		char filename[PLATFORM_MAX_PATH];
		FileType type;
		char full[PLATFORM_MAX_PATH];

		while (ReadDirEntry(dir, filename, sizeof(filename), type))
		{
			if (!StrEqual(filename, ".") && !StrEqual(filename, ".."))
			{
				Format(full, sizeof(full), "%s/%s", path, filename);
				
				if (type == FileType_File) AddFileToDownloadsTable(full);
				else if (type == FileType_Directory) AddDirToDownloads(full);
			}
		}

		dir.Close();
	}
	else PrintToServer("[%s] Can't add folder %s to the downloads", prefix, path);
}