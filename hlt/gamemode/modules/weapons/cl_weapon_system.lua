local ply = LocalPlayer()
local justPlayedSwitchWeaponSound =  false

local function switchToPrimary(ply)
    if ply:isNoClipping() then return end
    local activeWeapon = ply:GetActiveWeapon()
    local primaryWeapon, secondaryWeapon = HLT.getPrimaryAndSecondaryWeapons(ply)

    if !primaryWeapon then return end
    if activeWeapon == primaryWeapon then return end

    -- Set the activeWeapon to the primary weapon.
    input.SelectWeapon(primaryWeapon)

    -- Play a sound when they switched their weapon.
    if justPlayedSwitchWeaponSound then return end -- This is needed because of the holstering system addon (It switches to the holster before switching to the weapon)
    justPlayedSwitchWeaponSound = true
    timer.Simple(.25, function() justPlayedSwitchWeaponSound = false end)
    surface.PlaySound("weapons/pistol/pistol_empty.wav")
end

local function switchToSecondary(ply)
    if ply:isNoClipping() then return end
    currentWeapons = ply:GetWeapons()
    local activeWeapon = ply:GetActiveWeapon()
    local primaryWeapon, secondaryWeapon = HLT.getPrimaryAndSecondaryWeapons(ply)

    if !secondaryWeapon then return end
    if activeWeapon == secondaryWeapon then return end
    
    -- Set the activeWeapon to the primary weapon.
    input.SelectWeapon(secondaryWeapon)

    -- Play a sound when they switched their weapon.
    if justPlayedSwitchWeaponSound then return end -- This is needed because of the holstering system addon (It switches to the holster before switching to the weapon)
    justPlayedSwitchWeaponSound = true
    timer.Simple(.25, function() justPlayedSwitchWeaponSound = false end)
    ply:EmitSound("weapons/pistol/pistol_empty.wav", 40, math.random(90,110), 10, CHAN_WEAPON) 
end

local function switchToActiveUtility(ply)
-- TODO
end

hook.Add("PlayerButtonDown", "HLT Weapon System Detect Button Down", function(ply, button)
    if !ply:Alive() then return end
    local bind = input.LookupKeyBinding( button )
    
    if bind == "slot1" then
        print("working")
        switchToPrimary(ply)  
    elseif bind == "slot2" then
        print("working 2")
        switchToSecondary(ply)
    elseif bind == "die_right_grenade" then
        print("throw grenade")
    end
end)

------------------------WEAPON SWAY---------------------
local start = SysTime()

local delay = CurTime() + 0.01
hook.Add("InputMouseApply", "HLT Weapon Sway", function(cmd, x, y, ang)
    if not ply:KeyDown(IN_ATTACK2) then return end
    if not ply:Alive() then return end
    if ply:isNoClipping() then return end 
    if ply:InVehicle() then return end
    if HLT.isHLTWeapon(ply:GetActiveWeapon()) then return end

    local swayStrength = ply:isHoldingBreath() and 800 or (400 * math.Remap(ply:getStamina(), 0, ply:getMaxStamina(), 0.2, 1))
    ang.p = ang.p + math.cos(CurTime() * 2) / swayStrength
    ang.y = ang.y + math.sin(CurTime() * 1) / swayStrength

    if SysTime() - start > 2 then
        start = SysTime()
    end

    cmd:SetViewAngles( ang )
    return false
end)

-------------------------------------------HANDLE WEAPON AIM--------------------------------------------
local delay = CurTime() + 0.1
hook.Add("Think", "HLT Weapon Set Speed On Aiming", function()
    if delay > CurTime() then return end
    delay = CurTime() + 0.1

    if !ply:Alive() or HLT.isHLTWeapon(ply:GetActiveWeapon()) then return end
    if !ply:KeyDown(IN_ATTACK2) then return end
    if ply:getStamina() >= 3 then return end
    ply:ConCommand("-attack2")
end)