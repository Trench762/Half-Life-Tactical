-- DEFINE WEAPONS -------------------------------------------
HLT.primaryWeapons = {
    -- ARS
    ["tfa_mmod_crossbow"] = true,
    ["tfa_mmod_ar3"] = true,
    ["tfa_mmod_ar2"] = true,
    ["tfa_mmod_rpg"] = true,
    ["tfa_mmod_shotgun"] = true,
    ["tfa_mmod_smg"] = true,
}

HLT.secondaryWeapons = {
    -- Pistols
    ["tfa_mmod_357"] = true,
    ["tfa_mmod_pistol"] = true,
    ["tfa_mmod_crowbar"] = true,
    ["tfa_mmod_stunstick"] = true,
    ["tfa_mmod_grenade"] = true,
}

function HLT.isHLTWeapon(classname)
    return HLT.primaryWeapons[classname] or HLT.secondaryWeapons[classname] and true or false
end

function HLT.isPrimaryWeapon(classname)
    return HLT.primaryWeapons[classname] and true or false
end

function HLT.isSecondaryWeapon(classname)
    return HLT.secondaryWeapons[classname] and true or false
end
--------------------------------------------------------------

function HLT.getPrimaryAndSecondaryWeapons(ply)
    local currentWeapons = ply:GetWeapons() 
    local primaryWeapon = false
    local secondaryWeapon = false
    local primaryWeaponEnt = nil 
    local secondaryWeaponEnt = nil

    -- Filter through all the player's weapons and find the one's that's flagged as a primary weapon, if we don't find one, just exit.
    for _, weapon in pairs(currentWeapons) do
        if HLT.isPrimaryWeapon(weapon:GetClass()) then
            primaryWeapon = weapon
            break
        else
            continue
        end
    end

    -- Filter through all the player's weapons and find the one's that's flagged as a secondary weapon, if we don't find one, just exit.
    for _, weapon in pairs(currentWeapons) do
        if HLT.isSecondaryWeapon(weapon:GetClass()) then
            secondaryWeapon = weapon
            break
        else
            continue
        end
    end
    
    return primaryWeapon, secondaryWeapon
end
