-------------------------------------- HANDLE WEAPON PICKUP ------------------------------------------
hook.Add("WeaponEquip", "HLT Weapon System Handle Weapon Pickup", function(weapon, ply)
    local primaryWeapon, secondaryWeapon = HLT.getPrimaryAndSecondaryWeapons(ply)

    -- Hacky fix to avoid consuming a weapon for it's ammo if the player already has the same weapon.
    -- Tried integrated with VMANIP but couldn't get it to work. Maybe something to look into later.
    
    if primaryWeapon == weapon or secondaryWeapon == weapon then
        local duplicateWeapon = primaryWeapon == weapon and primaryWeapon or secondaryWeapon
        ply:DropWeapon( duplicateWeapon )
        ply:Give(weapon:GetClass())
        ply:SetAmmo( ply:GetAmmoCount( weapon:GetPrimaryAmmoType() ) - weapon:GetMaxClip1(), weapon:GetPrimaryAmmoType() )
    end

    -- If the player has a primary, and the weapon they are picking up is a primary, drop their previous primary.
    if primaryWeapon and HLT.isPrimaryWeapon(weapon:GetClass()) then
        ply:DropWeapon( primaryWeapon )
    end

    -- If the player has a secondary, and the weapon they are picking up is a secondary, drop their previous secondary.
    if secondaryWeapon and HLT.isSecondaryWeapon(weapon:GetClass()) then
        ply:DropWeapon( secondaryWeapon )
    end
    
    -- Force equip the newly picked up weapon.
    timer.Simple(.1, function()
        if !IsValid(ply) or !IsValid(weapon) then return end
        ply:SelectWeapon(tostring(weapon:GetClass()))
    end)
end)

-- Disables weapons from being able to be picked up by walking over them
hook.Add("PlayerCanPickupWeapon", "HLT Weapon System Handle Weapon Default Pickup", function(ply, wep)    
    if wep.playerUsed == ply or wep.justSpawned then return true end
    return false
end)

hook.Add("OnEntityCreated", "HLT sv_weapon_system OnEntityCreated", function(ent)
    if !ent:IsWeapon() then return end
    ent.justSpawned = true 
    timer.Simple(0, function()
        ent.justSpawned = false
    end)
end)

hook.Add("PlayerUse", "HLT sv_weapon_system PlayerUse", function(ply, ent)
    if !ent:IsWeapon() then return end
    ent.playerUsed = ply
    timer.Simple(0, function()
        ent.playerUsed = nil
    end)
end)

-------------------------------------------HANDLE WEAPON AIM--------------------------------------------

local delay = CurTime() + 0.1
hook.Add("Think", "HLT Weapon System Stamina On Aiming", function()
    if delay > CurTime() then return end
    delay = CurTime() + 0.1

    for _, ply in pairs(player.GetAll()) do 
        if !ply:Alive() or HLT.isHLTWeapon(ply:GetActiveWeapon()) then continue end
        if ply:KeyDown(IN_ATTACK2) then
            if ply:getStamina() <= 3 then
                ply:ConCommand("-attack2")
            end
            ply:setStamina(ply:getStamina() - 2)
        else
            ply:SetWalkSpeed(HLT.playerWalkSpeed)
        end
    end
end)

-------------------------------------------AIM BREATH--------------------------------------------

hook.Add("Think", "HLT Weapon Sway Handle Breath", function()
    for _, ply in pairs(player.GetAll()) do
        if not IsValid(ply) then continue end
        
        ply.HLTWeaponSwayThinkDelay = ply.HLTWeaponSwayThinkDelay or CurTime()
        if ply.HLTWeaponSwayThinkDelay > CurTime() then continue end
        ply.HLTWeaponSwayThinkDelay = CurTime() + .05
        
        if not ply:Alive() then continue end
        if ply:isNoClipping() then continue end
        if ply:InVehicle() then return end

        if(ply:KeyDown(IN_ATTACK2) and ply:KeyDown(IN_SPEED)) then
            ply:setIsHoldingBreath(true)
            ply:setStamina(ply:getStamina() - 0.2)
        else
            ply:setIsHoldingBreath(false)
        end
    end
end)
