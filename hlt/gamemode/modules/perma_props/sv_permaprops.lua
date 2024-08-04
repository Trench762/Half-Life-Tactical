util.AddNetworkString("HLT Perma Props Notify Player Of Prop Save Status")

local currentMap = game.GetMap()
local currentProps = {}
local DEBUG = true

hook.Add("PlayerSpawnedProp", "HLT PermaProp Register Props As Player Spawned", function(ply, model, entity)
    entity.spawnedByPlayer = true
end)

local function saveProps(ply)
    -- Reject Calls from non Super Admins.
    if !ply:IsSuperAdmin() then 
        net.Start("HLT Perma Props Notify Player Of Prop Save Status")
        net.WriteInt(1, 3) 
        net.Send(ply)
        return 
    end

    -- Iterate through all props and add them to a prop table with relevant info such as model name, angle and position.
    local i = 1
    currentProps = {}

    for key, prop in pairs(ents.FindByClass("prop_physics")) do
        if !prop.spawnedByPlayer then continue end 
        
        local propData = {
            ["model"] = prop:GetModel(),
            ["pos"] = prop:GetPos(),
            ["ang"] = prop:GetAngles(),
            ["skin"] = prop:GetSkin(),
        }
        table.insert(currentProps, i, propData)
        
        i = i + 1
    end

    -- Save the props to a file relevant to the map we're on.
    if file.Exists( "HLT/permaprops/" .. currentMap .. ".txt", "DATA" ) then
        file.Write( "HLT/permaprops/" .. currentMap .. ".txt", util.TableToJSON( currentProps ) ) 
    else
        file.CreateDir( "HLT/permaprops" )
        file.Write( "HLT/permaprops/" .. currentMap .. ".txt", util.TableToJSON( currentProps ) ) 
    end

    -- Notify the player that the props have been saved
    net.Start("HLT Perma Props Notify Player Of Prop Save Status")
    net.WriteInt(3, 3) -- Code 3 == Props were successfully saved
    net.Send(ply)
    
    -- Print the props to server console
    if DEBUG then
        PrintTable(currentProps)
    end
end

local function loadProps()
    if !file.Exists( "HLT/permaprops/" .. currentMap .. ".txt", "DATA" ) then return end
    
    local props = util.JSONToTable( file.Read( "HLT/permaprops/" .. currentMap .. ".txt", "DATA" ) )

    for _, prop in pairs(props) do
        local spawnProp = ents.Create("prop_physics")
        spawnProp:SetModel(prop.model)
        spawnProp:SetPos(prop.pos)
        spawnProp:SetAngles(prop.ang)
        spawnProp:Spawn()
        spawnProp:SetSkin(prop.skin)
        spawnProp:GetPhysicsObject():EnableMotion( false )
        spawnProp.spawnedByPlayer = true
    end
end

-- Load props post cleanup.
hook.Add("PostCleanupMap", "HLT Load Props Post Cleanup Map", function()
    timer.Simple(0, function()
        loadProps()
    end)
end)

-- Load props on initial map spawn.
timer.Simple(0, function()
    -- Calling game.CleanUpMap() instead of spawning props because if working on code and saving, it will keep spawning duplicates.
    -- Might need to change this later if this causes issues.
    game.CleanUpMap() 
end)

concommand.Add( "hlt_save_props", saveProps)