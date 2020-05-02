# SoMoE-19 SoScore Complementary
A "light" Version of my SoMoE-19 plugin based on Marco Boogers SourceMod plugin to be used together with Forlix SoScore & SoStats.  
Just like the "full" version it is aimed at Counter-Strike:Source soccer servers, so no CS:GO support for now.  
The idea behind it was to function as a complimentary plugin to the above mentioned plugins, which are great for public soccer servers but are lacking some features on its own.  
I'm still new to the whole Sourcemod stuff, so just expect heavily improvable code...   

### Features 
  ● Configurable Sprint  
  ● Skins management (Add them to the downloadlists, GK skins)   
  ● Minor admin functionality (Change Map, "Referee")  
  ● DeadChat options  
  ● Misc stuff  

## [>>DOWNLOAD<< Please still read all the information below]()  
  
## Credits:
I incorporated parts of the following plugins and only modified them partially to my needs or in a way so they would fit all into one plugin file. Therefore almost all credit should go to:  
  ● Original version by Marco Boogers - https://github.com/marcoboogers/soccermod  
  ● Allchat (aka DeadChat) by Frenzzy - https://forums.alliedmods.net/showthread.php?t=171734  
  ● ShortSprint by walmar - https://forums.alliedmods.net/showthread.php?p=2294299  
  Not included in soccer_mod.smx but relied on:  
  ● Updater by GoD-Tony - https://forums.alliedmods.net/showthread.php?t=169095  
  
## Installation
### 1. Download the required plugins  
Click the links and select the correct download for your server (Linux or Windows). Save the zip files in the same location, for example on your desktop.  

To run Soccer Mod on your server you need the following plugins:  
 ● Metamod:Source 1.10 or higher  
http://www.sourcemm.net/downloads.php?branch=stable  
  
 ● SourceMod 1.10 or higher  
https://www.sourcemod.net/downloads.php?branch=stable  
  
 ● (OPTIONAL BUT RECOMMENDED) Updater.smx  
Adding this to your server will allow you to automatically update the plugin whenever a new version is uploaded. For more information check the [alliedmodders thread](https://forums.alliedmods.net/showthread.php?p=1570806).  
[Steamworks](http://users.alliedmods.net/~kyles/builds/SteamWorks/)  
[Updater](https://bitbucket.org/GoD_Tony/updater/downloads/updater.smx)  
   
 ● SoScore & Sostats  
 [SoScore](http://forlix.org/gameaddons/soscore.shtml)  
 [SoStats](http://forlix.org/gameaddons/sostats.shtml)  
   
 ● This plugin 
[>>Download<<](https://github.com/MK99MA/SoMoE-19-SoScore-addition/blob/master/addons/sourcemod/plugins/soccer_modules.smx)  
[>>Previous Versions<< In case of any major issues](https://github.com/MK99MA/SoMoE-19-SoScore-addition/blob/master/addons/sourcemod/plugins/old/)  
  
 ● (OPTIONAL) Download soccer skins  
 [>>Default skins download<< if you need them](https://github.com/MK99MA/soccermod-2019edit/raw/master/skins/termi/termi_models.zip)  
 [>Alternate skins download<](https://github.com/MK99MA/soccermod-2019edit/tree/master/skins#alternative-skins-screenshots-below)  
### If you are using alternate skins make sure to edit /sm_soccer/soccer__skins.cfg AND /sm_soccer/soccer_downloads.cfg!! Follow [this](https://github.com/MK99MA/soccermod-2019edit/tree/master/skins/EXAMPLE_soccer_mod_skins.cfg) and [this](https://github.com/MK99MA/soccermod-2019edit/blob/master/skins/EXAMPLE_soccer_mod_downloads.cfg) for example files.  

● (OPTIONAL) AFK-Kicker  
A customizable AFK-Kicker plugin can be found [here](https://forums.alliedmods.net/showthread.php?p=708265)  
  
### 2. Extract the zip files
Right click on each zip file and select "Extract Here". After extracting the zip files you should have 4 folders on your desktop:  
 ● addons  
 ● cfg  
 ● materials  
 ● models  
  
### 3. Copy or upload the folders
Copy or upload the folders to your server's "cstrike" folder, for example:  
 ● D:\Servers\Counter-Strike Source\cstrike (local server)  
 ● /home/cstrike (hosted server)  
  
A suitable setup for a public Soccer Server is now installed and will be loaded automatically when the server is restarted.
