local DEBUG = true

player_manager.AddValidHands( "models/player/combine_soldier.mdl", "models/weapons/c_arms_combine.mdl", 0, "10000000" )
player_manager.AddValidHands( "models/player/combine_soldier_prisonguard.mdl", "models/weapons/c_arms_combine.mdl", 0, "10000000" )
player_manager.AddValidHands( "models/player/combine_super_soldier.mdl", "models/weapons/c_arms_combine.mdl", 0, "10000000" )
player_manager.AddValidHands( "models/player/police.mdl", "models/weapons/c_arms_combine.mdl", 0, "10000000" )
player_manager.AddValidHands( "models/player/police_fem.mdl", "models/weapons/c_arms_combine.mdl", 0, "10000000" )
player_manager.AddValidHands( "models/player/group03/female_01.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/female_02.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/female_03.mdl", "models/weapons/c_arms_refugee.mdl", 1, "11")
player_manager.AddValidHands( "models/player/group03/female_04.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/female_05.mdl", "models/weapons/c_arms_refugee.mdl", 1, "11")
player_manager.AddValidHands( "models/player/group03/female_06.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/male_01.mdl", "models/weapons/c_arms_refugee.mdl", 1, "11")
player_manager.AddValidHands( "models/player/group03/male_02.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/male_03.mdl", "models/weapons/c_arms_refugee.mdl", 1, "11")
player_manager.AddValidHands( "models/player/group03/male_04.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/male_05.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/male_06.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/male_07.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/male_08.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")
player_manager.AddValidHands( "models/player/group03/male_09.mdl", "models/weapons/c_arms_refugee.mdl", 0, "11")

local playerModels = {
	-- "models/player/group03/female_01.mdl",
	-- "models/player/group03/female_02.mdl",
	-- "models/player/group03/female_03.mdl",
	-- "models/player/group03/female_04.mdl",
	-- "models/player/group03/female_05.mdl",
	-- "models/player/group03/female_06.mdl",
	
	"models/player/group03/male_01.mdl",
	"models/player/group03/male_02.mdl", 
	"models/player/group03/male_03.mdl",
	"models/player/group03/male_04.mdl", 
	"models/player/group03/male_05.mdl", 
	"models/player/group03/male_06.mdl",
	"models/player/group03/male_07.mdl",
	"models/player/group03/male_08.mdl",
	"models/player/group03/male_09.mdl",
	
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier.mdl",
	"models/player/combine_super_soldier.mdl",
	"models/player/police.mdl",
	"models/player/police.mdl",
	"models/player/police.mdl",
	"models/player/police.mdl",
} 

local HLT_Data_Table = {
	["money"] = 0,
	["primaryWeapon"] = nil,
	["secondaryWeapon"] = nil,
	["armor"] = nil,
	["grenades"] = {},
}

hook.Add("PlayerLoadout", "HLT Loadout", function(ply)
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES) -- Makes it so player isn't pushed back by damage
	ply:SetViewOffsetDucked(HLT.playerViewOffsetDuckedValue) -- Changes the first person camera position to be a bit higher when players duck to match the world model animations (current 48 is for csgo anims, this should be changed if using other animations)
	ply:SetDuckSpeed( 0.75)
	ply:SetUnDuckSpeed( 0.75 )
	ply:SetSlowWalkSpeed(HLT.playerSlowWalkSpeed)
	ply:SetWalkSpeed(HLT.playerWalkSpeed)
	ply:SetRunSpeed(HLT.playerRunSpeed)
	ply:SetCrouchedWalkSpeed(0.75)
	ply:SetJumpPower( 120 )
	ply:SetMaxHealth(100)
	ply:SetHealth(100)
	ply:RemoveAllAmmo()

	-------TESTING ONLY-------------
	ply:SetAmmo( 10000, "ar2" )
	ply:SetAmmo( 10000, "357")
	ply:SetAmmo( 10000, "buckshot")
	ply:SetAmmo( 10000, "pistol")
	ply:SetAmmo( 10000, "smg1")
	ply:SetAmmo( 10000, "grenade")
	ply:SetAmmo( 10000, "xbowbolt")
	ply:SetAmmo( 10000, "ar2altfire")
	ply:SetAmmo( 10000, "smg1altfire")
	-------TESTING ONLY-------------

    return true
end)

player_manager.AddValidHands( "hostage01", "models/weapons/c_arms_combine.mdl", 0, "00000000" )

hook.Add("PlayerSpawn", "HLT Set Up Player On Spawn", function(ply, transition)
	timer.Simple(0, function() 
		ply:SetModel(table.Random(playerModels))
		-- Set up cHands.
        ply:GetHands():SetModel(player_manager.TranslatePlayerHands(ply:GetModel()).model) 
		ply:GetHands():SetSkin(player_manager.TranslatePlayerHands(ply:GetModel()).skin) 
		ply:GetHands():SetBodyGroups(player_manager.TranslatePlayerHands(ply:GetModel()).body) 
		ply:ShouldDropWeapon( true )
	end)

	ply:setJustSpawned(true)
	timer.Simple(1, function()
		ply:setJustSpawned(false)
	end)
end)

hook.Add( "PlayerNoClip", "HLT Set Ply Is No Clipping", function( ply, desiredNoClipState )
    ply:setIsNoClipping(desiredNoClipState)
end )

function HLT.savePlayerData(ply)
	-- TODO
end

function HLT.loadPlayerData(ply)

end

hook.Add("PlayerDisconnected", "HLT Save Player Data On Disconnect", function(ply)
	HLT.savePlayerData(ply)
end)

hook.Add("PlayerInitialSpawn", "HLT Initialize Player Data On Initial Spawn", function(ply, transition)
	if file.Exists( "HLT/players/" .. ply:SteamID64() .. ".txt", "DATA" ) then
        ply.HLT_Data_Table = util.JSONToTable( file.Read( "HLT/players/" .. ply:SteamID64() .. ".txt", "DATA" ) )
		if DEBUG then print("Data found for " .. ply:Name() .. "[Steam ID: " .. ply:SteamID64() .. "]" .. ":")  PrintTable(ply.HLT_Data_Table) end
    else
        if DEBUG then print("No data for " .. ply:Name() .. "[Steam ID: " .. ply:SteamID64() .. "]" .. " creating...") end
		file.CreateDir( "HLT/players" )
		file.Write( "HLT/players/" .. ply:SteamID64() .. ".txt", util.TableToJSON( HLT_Data_Table ) ) 
    end
end)
