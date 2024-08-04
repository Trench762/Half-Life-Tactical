GM.Name = "Half Life: Tactical"
GM.Author = "Trench"
GM.Email = "N/A" --Dont wanna give out my personal email, contact me on steam for any questions
GM.Website = "https://steamcommunity.com/id/12312415121235/" --steam link
HLT = HLT or {}
HLT.gameVersion = "0.0.39"
-- RunConsoleCommand("sv_loadingurl", "")

// GLOBAL META TABLES
pMeta = FindMetaTable( "Player" ) 
pmeta = pMeta
eMeta = FindMetaTable( "Entity" ) 
emeta = eMeta
// GLOBAL META TABLES

DeriveGamemode( "sandbox" ) --for testing
--DeriveGamemode( "base" )

local function LoadFolderStart( k )
	print( "[ " .. k .. " ]" )
end
local function LoadFolderEnd( k )
	print( "[ " .. k .. " ]" )
end
	
local function LoadFileStart( k )
	timer.Create( k, 1, 1, function() print( " -- <" .. k .. "> <FAILED TO LOAD>" ) end )
	-- print( "++ <" .. k .. ">" )
end
local function LoadFileEnd( k )
	timer.Remove( k )
	print( " ++ <" .. k .. ">" )
end

local ClientsideFiles
local function LoadModules() -- credits to darkrp developers
	ClientsideFiles = 0
    local root = GAMEMODE.FolderName .. "/gamemode/modules/"
    local _, folders = file.Find(root .. "*", "LUA")
	
	local StartTime = math.Round(RealTime())
	
	print( [[
================================================
	MODULE LOADER STARTED <]] .. StartTime .. [[>
================================================
	]] )
	
    for _, folder in SortedPairs(folders) do 
		LoadFolderStart( folder )
		// MOUNT SERVER FILES
		if SERVER then
			for _, File in SortedPairs(file.Find(root .. folder .. "/sv_*.lua", "LUA")) do
				LoadFileStart( folder .. " >> " .. File )
				timer.Simple(0,function()
					include(root .. folder .. "/" .. File)
				end)
				LoadFileEnd( folder .. " >> " .. File )
			end
		end
		// MOUNT SHARED FILES
        for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA")) do
			LoadFileStart( folder .. " >> " .. File )
			timer.Simple(0,function()
				AddCSLuaFile( root .. folder .. "/" .. File )
				include(root .. folder .. "/" .. File) 
			end)
			LoadFileEnd( folder .. " >> " .. File )
			ClientsideFiles = ClientsideFiles + 1
        end
		// MOUNT CLIENT FILES
		for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA")) do
			LoadFileStart( folder .. " >> " .. File )
			timer.Simple(0,function()
				AddCSLuaFile( root .. folder .. "/" .. File )
				if CLIENT then include(root .. folder .. "/" .. File) end
			end)
			LoadFileEnd( folder .. " >> " .. File )
			ClientsideFiles = ClientsideFiles + 1
		end
		LoadFolderEnd( folder )
		print( " " ) -- print splitter
    end
	
	local TimeElapsed = math.abs( math.Round( (RealTime() - StartTime), 2 ) )
	print( [[
================================================
	MODULE LOADER FINISHED <]] .. TimeElapsed .. [[>
================================================
	]] )
	if CLIENT then RunConsoleCommand( "CheckClientsideFiles", ClientsideFiles ) end
end

local function TellClientTheyAreMissingFilesAndWillAutoRejoin()
	hook.Add( "HUDPaint", "TellClientTheyAreMissingFilesAndWillAutoRejoin", function() 
		local w, h = ScrW(), ScrH()
		draw.RoundedBox( h*.09, w*.25, h*.5, w*.5, h*.2, Color(0,0,0,200) )
		draw.RoundedBoxEx( h*.09, w*.3, h*.7, w*.4, h*.1, Color(0,0,0,200), false, false, true, true )
		draw.SimpleTextOutlined( "[ MISSING FILES ]", "ui.100", w/2, h*.6, Color(255,255,255,255), 1, 1, 3, Color(0,0,0,100) )
		draw.SimpleTextOutlined( "clientside files are missing", "DermaLarge", w/2, h*.7, Color(255,255,255,255), 1, 1, 3, Color(0,0,0,100) )
		draw.SimpleTextOutlined( "you will be reconected", "DermaLarge", w/2, h*.725, Color(255,255,255,255), 1, 1, 3, Color(0,0,0,100) )
		draw.SimpleTextOutlined( "to rectify this issue/s", "DermaLarge", w/2, h*.75, Color(255,255,255,255), 1, 1, 3, Color(0,0,0,100) )
		draw.SimpleTextOutlined( "[ The GAMEMODE ]", "DermaLarge", w/2, h*.775, Color(255,255,255,255), 1, 1, 3, Color(0,0,0,100) )
	end )
	timer.Simple( 1, function() 
		local messages = {
			"[ MISSING FILES ]",
			"clientside files are missing",
			"you will be reconected",
			"to rectify this issue/s",
			"[ The GAMEMODE ]",
		}
		for _, v in SortedPairs( messages, true ) do 
			notification.Add( v, 9 ) 
		end
	end )
end

if SERVER then 
	concommand.Add( "CheckClientsideFiles", function(p,_,t)
		local v = t[1] or 0
		local vv = math.abs(v-ClientsideFiles)
		print( "[CheckClientsideFiles] <"..tostring(p).."> "..math.abs(v-ClientsideFiles).." missing files" )
		if vv == 0 then return end
		-- TellClientTheyAreMissingFilesAndWillAutoRejoin()
		-- chat.AddText( p, Color(255,0,0), "[MISSING FILES] ", Color(255,255,255), "you are missing ("..vv..") ", Color(255,150,0), "Clientside ", Color(255,255,255), "files" )
		-- timer.Simple( 10, function() p:ConCommand( "retry" ) end )
	end )
end


// GLOBAL META TABLES
pMeta = FindMetaTable( "Player" ) 
pmeta = pMeta
eMeta = FindMetaTable( "Entity" ) 
emeta = eMeta
// GLOBAL META TABLES

function NilFunc() return nil end 	
function nilfunc() return nil end 	
function NullFunc() return NULL end 
function nullfunc() return NULL end 

GAMEMODE_RELOADING_ALPHA = GAMEMODE_RELOADING_ALPHA or 0
timer.Create( "GAMEMODE_RELOADING_ALPHA IN", .05, 20, function() 
	GAMEMODE_RELOADING_ALPHA = math.Clamp( GAMEMODE_RELOADING_ALPHA+.05, 0, 1 ) 
end )
timer.Create( "GAMEMODE_RELOADING_ALPHA OUT", 2, 1, function() 
	timer.Create( "GAMEMODE_RELOADING_ALPHA OUT", .05, 20, function() 
		GAMEMODE_RELOADING_ALPHA = math.Clamp( GAMEMODE_RELOADING_ALPHA-.05, 0, 1 ) 
	end )
end )
hook.Add( "HUDPaint", "cl.gamemode.reload.HUDPaint", function() 
	local w, h = ScrW(), ScrH()
	if GAMEMODE_RELOADING_ALPHA <= 0 then return end 
	local a = GAMEMODE_RELOADING_ALPHA
	draw.RoundedBox( 32, w*.4, (h*.1)*a, w*.2, h*.1, Color(0,0,0,100*a) )
	draw.SimpleTextOutlined( "[GAMEMODE RELOADING]", "DermaLarge", w/2, (h*.05)+(h*.1)*a, Color(255,255,255,255*a), 1, 1, 3, Color(0,0,0,100*a) )
end )

hook.Add( "Think", "sh.LoadModules.Think", function() -- supports lua refresh and hotloading
	LoadModules() 
	hook.Remove( "Think", "sh.LoadModules.Think" )
end )	


if SERVER then
	concommand.Add( "_remount_all_gamemode_lua_server", function() 
		LoadModules() 
	end )
	concommand.Add( "_remount_all_gamemode_lua_shared", function() 
		LoadModules() 
		for _, p in pairs( player.GetAll() ) do p:ConCommand("remount_all_gamemode_lua_client") end
	end )
end
if CLIENT then
	concommand.Add( "remount_all_gamemode_lua_client", function() 
		LoadModules() 
	end )
	concommand.Add( "remount_all_gamemode_lua_server", function() 
		RunConsoleCommand( "_remount_all_gamemode_lua_server" )
	end )
	concommand.Add( "remount_all_gamemode_lua_shared", function()
		RunConsoleCommand( "_remount_all_gamemode_lua_shared" )
	end )
end 