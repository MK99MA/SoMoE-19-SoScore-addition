// ***************************************************** PATHS **************************************************
char configFileKV[PLATFORM_MAX_PATH] 					= "cfg/sm_soccer/soccer.cfg";
char allowedMapsConfigFile[PLATFORM_MAX_PATH] 			= "cfg/sm_soccer/soccer_allowed_maps.cfg";
char skinsKeygroup[PLATFORM_MAX_PATH] 					= "cfg/sm_soccer/soccer_skins.cfg";
char pathRefCardsFile[PLATFORM_MAX_PATH] 				= "cfg/sm_soccer/soccer_referee_cards.txt";

// ************************************************** KEYVALUES *************************************************
KeyValues kvConfig;
KeyValues kvSkins;

// **************************************************** GENERAL **************************************************
// BOOLS
bool menuaccessed 				= false;
bool bLATE_LOAD					= false;

// FLOATS

// HANDLES
Handle allowedMaps	  			= INVALID_HANDLE;

// INTEGER
int damageSounds				= 0;
int dissolveSet					= 2;

// STRINGS
char changeSetting[MAXPLAYERS + 1][32];

// **************************************************** CHAT ****************************************************

// BOOL
bool g_msgIsChat;
bool g_msgIsTeammate;
bool g_msgTarget[MAXPLAYERS + 1];

// FLOATS

// HANDLES
Handle g_hCvarAllTalk = INVALID_HANDLE;

// INTEGER
int DeadChatMode		= 0;
int DeadChatVis			= 0;
int g_msgAuthor;

// STRINGS
char g_msgType[64];
char g_msgName[64];
char g_msgText[64];
char prefix[32]			= "Soccer"


// **************************************************** SKINS ***************************************************

// BOOL

// FLOATS

// HANDLES

// INTEGER
int skinsIsGoalkeeper[MAXPLAYERS + 1];

// STRINGS
char skinsModelCT[128]				  	= "models/player/soccer_mod/termi/2011/away/ct_urban.mdl";
char skinsModelCTNumber[4]			  	= "0";
char skinsModelT[128]				   	= "models/player/soccer_mod/termi/2011/home/ct_urban.mdl";
char skinsModelTNumber[4]			   	= "0";
char skinsModelCTGoalkeeper[128]		= "models/player/soccer_mod/termi/2011/gkaway/ct_urban.mdl";
char skinsModelCTGoalkeeperNumber[4]	= "0";
char skinsModelTGoalkeeper[128]			= "models/player/soccer_mod/termi/2011/gkhome/ct_urban.mdl";
char skinsModelTGoalkeeperNumber[4]		= "0";

// **************************************************** SPRINT ***************************************************

// BOOL
bool showHudPrev[MAXPLAYERS+1]	= {false, ...};

// FLOATS
float fSPRINT_COOLDOWN 			= 7.5;
float fSPRINT_SPEED 			= 1.25;
float fSPRINT_TIME				= 3.0;

float x_val[MAXPLAYERS+1]		= {0.8, ...};
float y_val[MAXPLAYERS+1]		= {0.8, ...};

// HANDLES
/*Handle h_BUTTON 				= INVALID_HANDLE;
Handle h_COOLDOWN 				= INVALID_HANDLE;
Handle h_SPRINT_ENABLED			= INVALID_HANDLE;
Handle h_SPEED 					= INVALID_HANDLE;
Handle h_TIME 					= INVALID_HANDLE;*/
Handle h_SPRINT_COOKIE 			= INVALID_HANDLE;
Handle h_TIMER_XY_COOKIE		= INVALID_HANDLE;
Handle h_TIMER_COL_COOKIE		= INVALID_HANDLE;
Handle h_SPRINT_TIMERS[MAXPLAYERS+1]; 
Handle h_SPRINT_DURATION[MAXPLAYERS+1];
Handle h_TIMER_SET[MAXPLAYERS+1];
Handle antiflood;

// INTEGER
int bSPRINT_BUTTON				= 1
int bSPRINT_ENABLED				= 1

int red_val[MAXPLAYERS+1]		= {255, ...};
int green_val[MAXPLAYERS+1]		= {140, ...};
int blue_val[MAXPLAYERS+1]		= {0, ...};

// STRINGS
char iCLIENT_STATUS[MAXPLAYERS+1];
char iP_SETTINGS[MAXPLAYERS+1];