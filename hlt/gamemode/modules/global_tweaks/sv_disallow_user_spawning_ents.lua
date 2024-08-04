-- blocks: npc's
hook.Add("PlayerSpawnNPC", "HLT Block User Spawn NPC", function(ply)
    if !ply:IsAdmin() then
        return false
    end
end)

-- blocks: props, effects, ragdolls
hook.Add("PlayerSpawnObject", "HLT Block User Spawn Object", function(ply)
    if !ply:IsAdmin() then
        return false
    end
end)

-- blocks: SENTS
hook.Add("PlayerSpawnSENT", "HLT Block User Spawn SENT", function(ply)
    if !ply:IsAdmin() then
        return false
    end
end)

-- blocks: SWEP spawning on floor (middle clicking on weapon in Q menu)
hook.Add("PlayerSpawnSWEP", "HLT Block User Spawn SWEP", function(ply)
    if !ply:IsAdmin() then
        return false
    end
end)

-- blocks: SWEP spawning in player's hands (left clicking on weapon in Q menu)
hook.Add("PlayerGiveSWEP", "HLT Block User Give SWEP", function(ply)
    if !ply:IsAdmin() then
        return false
    end
end)

-- blocks: Vehicles
hook.Add("PlayerSpawnVehicle", "HLT Block User Spawn Vehicle", function(ply)
    if !ply:IsAdmin() then
        return false
    end
end)




