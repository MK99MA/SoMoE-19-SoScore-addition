#include "adverts/topcolors.sp"

// ********************************************************************************************************************
// ************************************************** ADVERTS MODULE **************************************************
// ********************************************************************************************************************
public void AdvertsOnPluginStart()
{	
	AddTopColors();
}

public void AdvertsOnMapStart()
{
	// Parse adverts
	GetAdverts();
	
	// Start Timer
	advertTimer = CreateTimer(advertInterval, DisplayAdvert, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

void GetAdverts()
{
	delete kvAdverts;
	kvAdverts = new KeyValues("Advertisements")
	
	kvAdverts.ImportFromFile(advertsKV);
	kvAdverts.GotoFirstSubKey();
}

bool showadvert(int client, bool bFlags, bool bAdmins, int iFlags)
{
	if(IsClientInGame(client) && !IsFakeClient(client) && ((!bAdmins && !(bFlags && (GetUserFlagBits(client) & (iFlags|ADMFLAG_ROOT)))) || (bAdmins && (GetUserFlagBits(client) & (ADMFLAG_GENERIC|ADMFLAG_ROOT))))) return true;
	
	return false;
}

void ProcessVariables(char sText[1024])
{
    char sBuffer[64];
    if (StrContains(sText, "{currentmap}", false) != -1) {
        GetCurrentMap(sBuffer, sizeof(sBuffer));
        ReplaceString(sText, sizeof(sText), "{currentmap}", sBuffer, false);
    }

    if (StrContains(sText, "{date}", false) != -1) {
        FormatTime(sBuffer, sizeof(sBuffer), "%m/%d/%Y");
        ReplaceString(sText, sizeof(sText), "{date}", sBuffer, false);
    }

    if (StrContains(sText, "{time}", false) != -1) {
        FormatTime(sBuffer, sizeof(sBuffer), "%I:%M:%S%p");
        ReplaceString(sText, sizeof(sText), "{time}", sBuffer, false);
    }

    if (StrContains(sText, "{time24}", false) != -1) {
        FormatTime(sBuffer, sizeof(sBuffer), "%H:%M:%S");
        ReplaceString(sText, sizeof(sText), "{time24}", sBuffer, false);
    }

    if (StrContains(sText, "{timeleft}", false) != -1) {
        int iMins, iSecs, iTimeLeft;
        if (GetMapTimeLeft(iTimeLeft) && iTimeLeft > 0) {
            iMins = iTimeLeft / 60;
            iSecs = iTimeLeft % 60;
        }

        Format(sBuffer, sizeof(sBuffer), "%d:%02d", iMins, iSecs);
        ReplaceString(sText, sizeof(sText), "{timeleft}", sBuffer, false);
    }

    ConVar hConVar;
    char sConVar[64], sSearch[64], sReplace[64];
    int iEnd = -1, iStart = StrContains(sText, "{"), iStart2;
    while (iStart != -1) {
        iEnd = StrContains(sText[iStart + 1], "}");
        if (iEnd == -1) {
            break;
        }

        strcopy(sConVar, iEnd + 1, sText[iStart + 1]);
        Format(sSearch, sizeof(sSearch), "{%s}", sConVar);

        if ((hConVar = FindConVar(sConVar))) {
            hConVar.GetString(sReplace, sizeof(sReplace));
            ReplaceString(sText, sizeof(sText), sSearch, sReplace, false);
        }

        iStart2 = StrContains(sText[iStart + 1], "{");
        if (iStart2 == -1) {
            break;
        }

        iStart += iStart2 + 1;
    }
}

public int Handler_DoNothing(Menu menu, MenuAction action, int param1, int param2) 
{
}

// ****************************************************** TIMER *****************************************************

public Action DisplayAdvert(Handle timer)
{
	if (advertEnabled == 0) return;

	char sCenter[1024], sChat[1024], sHint[1024], sMenu[1024], sTop[1024], sFlags[16];
	kvAdverts.GetString("center",	sCenter,	sizeof(sCenter));
	kvAdverts.GetString("chat",		sChat,		sizeof(sChat));
	kvAdverts.GetString("hint",		sHint,		sizeof(sHint));
	kvAdverts.GetString("menu",		sMenu,		sizeof(sMenu));
	kvAdverts.GetString("top",		sTop,		sizeof(sTop));
	kvAdverts.GetString("flags",	sFlags,		sizeof(sFlags), "none");
	int iFlags   = ReadFlagString(sFlags);
	bool bAdmins = StrEqual(sFlags, "");
	bool bFlags  = !StrEqual(sFlags, "none");

	if (sCenter[0]) 
	{
		ProcessVariables(sCenter);
		CRemoveTags(sCenter, sizeof(sCenter));

		for (int i = 1; i <= MaxClients; i++) 
		{
			if (showadvert(i, bFlags, bAdmins, iFlags)) 
			{
				PrintCenterText(i, sCenter);

				DataPack DataCenterAd;
				CreateDataTimer(1.0, Timer_CenterAd, DataCenterAd, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
				DataCenterAd.WriteCell(i);
				DataCenterAd.WriteString(sCenter);
			}
		}
	}
	if (sHint[0]) 
	{
		ProcessVariables(sHint);
		CRemoveTags(sHint, sizeof(sHint));

		for (int i = 1; i <= MaxClients; i++) 
		{
			if (showadvert(i, bFlags, bAdmins, iFlags)) 
			{
				PrintHintText(i, sHint);
			}
		}
	}
	if (sMenu[0]) 
	{
		ProcessVariables(sMenu);
		CRemoveTags(sMenu, sizeof(sMenu));

		Panel adPanel = new Panel();
		adPanel.DrawText(sMenu);
		adPanel.CurrentKey = 10;

		for (int i = 1; i <= MaxClients; i++) 
		{
			if (showadvert(i, bFlags, bAdmins, iFlags)) 
			{
				adPanel.Send(i, Handler_DoNothing, 10);
			}
		}

		delete adPanel;
	}
	if (sChat[0]) 
	{
		Format(sChat, sizeof(sChat), "{%s}[%s] {%s}%c%s",prefixcolor, prefix, textcolor, 1, sChat);
		ProcessVariables(sChat);

		for (int i = 1; i <= MaxClients; i++) 
		{
			if (showadvert(i, bFlags, bAdmins, iFlags)) 
			{
				CPrintToChat(i, sChat);
			}
		}
	}
	if (sTop[0]) 
	{
		int iStart	= 0;
		int aColor[4] = {255, 255, 255, 255};

		ParseTopColor(sTop, iStart, aColor);
		ProcessVariables(sTop[iStart]);

		KeyValues hKv = new KeyValues("Stuff", "title", sTop[iStart]);
		hKv.SetColor4("color", aColor);
		hKv.SetNum("level",	1);
		hKv.SetNum("time",	 10);

		for (int i = 1; i <= MaxClients; i++) 
		{
			if (showadvert(i, bFlags, bAdmins, iFlags))  
			{
				CreateDialog(i, hKv, DialogType_Msg);
			}
		}

		delete hKv;
	}

	if (!kvAdverts.GotoNextKey()) 
	{
		kvAdverts.Rewind();
		kvAdverts.GotoFirstSubKey();
	}
}

public Action Timer_CenterAd(Handle timer, DataPack pack)
{
    char sCenter[1024];
    static int iCount = 0;

    pack.Reset();
    int iClient = pack.ReadCell();
    pack.ReadString(sCenter, sizeof(sCenter));

    if (!IsClientInGame(iClient) || ++iCount >= 5) 
	{
        iCount = 0;
        return Plugin_Stop;
    }

    PrintCenterText(iClient, sCenter);
	
    return Plugin_Continue;
}