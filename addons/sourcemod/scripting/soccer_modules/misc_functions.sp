// ************************************************************************************************************
// ************************************************ DISSOLVER *************************************************
// ************************************************************************************************************
public Action Dissolve(Handle timer, any client)
{
	if (!IsValidEntity(client))		return;
	
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (ragdoll<0)
	{
		PrintToServer("Could not get ragdoll for player!");	
		return;
	}
	
	char dname[32];
	Format(dname, sizeof(dname), "dis_%d", client);
	
	int dis_ent = CreateEntityByName("env_entity_dissolver");
	if (dis_ent>0)
	{
		if(dissolveSet == 2)
		{
			DispatchKeyValue(ragdoll, "targetname", dname);
			DispatchKeyValue(dis_ent, "dissolvetype", "0");
			DispatchKeyValue(dis_ent, "target", dname);
			AcceptEntityInput(dis_ent, "Dissolve");
			AcceptEntityInput(dis_ent, "kill");
		}
		else if(dissolveSet == 1) AcceptEntityInput(ragdoll, "kill");
	}
}

// ************************************************************************************************************
// ************************************************ DAMAGESOUND *************************************************
// ************************************************************************************************************

public Action sound_hook(int clients[64], int& numClients, char sample[PLATFORM_MAX_PATH], int& entity, int& channel, float& volume, int& level, int& pitch, int& flags)
{
	if(damageSounds == 0)
	{
		if(StrContains(sample, "player/damage", false) >= 0) 	return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action DelayedServerCommand(Handle timer, DataPack pack)
{
	pack.Reset();
	char command[64];
	pack.ReadString(command, sizeof(command));
	ServerCommand(command);
}