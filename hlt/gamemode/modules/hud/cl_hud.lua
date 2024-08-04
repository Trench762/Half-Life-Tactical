local ply = LocalPlayer()
local scrW, scrH = ScrW(), ScrH()
local showHealthAndStaminaHUD = false
local showWeaponHUD = false
local showAmmoHUD = false
local healthAndStaminaAlphaMult = 0
local weaponsAlphaMult = 0
local ammoAlphaMult = 0
local magAmmoTextWidth, magAmmoTextHeight = 0, 0
local crosshairColor = Color(138,255,84)
local crosshairColor2 = Color(138,255,84,70)
local crosshairAccuracyDisplayColor = Color(112,209,67)
local yellow = Color(196,158,77)
local yellowFaded = Color(88,72,36)
local ammoColor = Color(196,158,77)
local ammoColorFaded = Color(88,72,36)
local black = Color(22,22,22,178)
local compassLetterBGColor = Color(0,0,0,100)
local green = Color(84,182,59,255)
local red = Color(179,0,0)
local compassColor = Color(196,158,77) 
local compassColorFaded = Color(88,72,36)
local curStamina = 0
local targetStamina 
local curHealth = 0
local targetHealth 
local fastUpdateActiveWeapon
local activeWeapon 
local backupWeapon
local justSwitchedWeapon = false
local weaponSwitchHudFadeDelay = 2.5
local checkAmmo = false
local ammoHudFadeDelay = 2.5
local movingSpreadCrosshairOffset = 0
local shootingSpreadCrosshairOffset = 0
local crosshairGap = scrH * 0.01

surface.CreateFont("HUD Weapon Font Default" , { font = "2nd Amendment", size = ScreenScale(9), weight = 0, blursize = 0; scanlines = 1, shadow = false, additive = false, })
surface.CreateFont("HUD Ammo Font" , { font = "Trebuchet MS", size = ScreenScale(9), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })
surface.CreateFont("HUD Ammo Font Small" , { font = "Trebuchet MS", size = ScreenScale(7), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })

hook.Add( "OnScreenSizeChanged", "HLT HUD Rebuild Fonts", function( oldWidth, oldHeight )
    scrW, scrH = ScrW(), ScrH()
    crosshairGap = scrH * 0.01
    surface.CreateFont("HUD Weapon Font Default" , { font = "2nd Amendment", size = ScreenScale(9), weight = 0, blursize = 0; scanlines = 1, shadow = false, additive = false, })
    surface.CreateFont("HUD Ammo Font" , { font = "Trebuchet MS", size = ScreenScale(9), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })
    surface.CreateFont("HUD Ammo Font Small" , { font = "Trebuchet MS", size = ScreenScale(7), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })
end )

local weaponHudTranslations = {
    ["tfa_fas2_g3"] = {["character"] = "%", ["font"] = "HUD Weapon Font Default"},
    ["tfa_fas2_ks23"] = {["character"] = "%", ["font"] = "HUD Weapon Font Default"},
    ["tfa_fas2_mp5"] = {["character"] = "K", ["font"] = "HUD Weapon Font Default"},
    ["tfa_fas2_p226"] = {["character"] = "A", ["font"] = "HUD Weapon Font Default"},
    ["tfa_fas2_sg55x"] = {["character"] = "7", ["font"] = "HUD Weapon Font Default"},
    ["tfa_fas2_sks"] = {["character"] = "%", ["font"] = "HUD Weapon Font Default"},
    ["tfa_fas2_svd"] = {["character"] = "%", ["font"] = "HUD Weapon Font Default"},
}

local viewModelPos
local viewModelPosX, viewModelPosY
hook.Add("HUDPaint", "HLT HUD Paint", function()
    if !IsValid(ply) or ply:Health() <= 0 or !ply:Alive() or ply:isNoClipping() then return end

    -- Gamemode Notice -------------------------------------------------------------------------------------
    draw.SimpleText("HLT [" .. HLT.gameVersion .. "]", "HUD Ammo Font", scrW * 0.01, scrH * 0.027, Color(0,0,0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Compass ---------------------------------------------------------------------------------------------
    local compassWidth = scrH * 0.66
    local compassDirectionColor = Color(196,158,77)
    local compassPlyAng = ply:GetAngles()

    local lookAngleNorth = math.Remap(compassPlyAng.y,-180,180,0,2) 
    compassPlyAng:RotateAroundAxis( Vector(0,0,1), 90 )
    local lookAngleEast = math.Remap(compassPlyAng.y,-180,180,0,2) 
    compassPlyAng:RotateAroundAxis( Vector(0,0,1), 90 )
    local lookAngleSouth = math.Remap(compassPlyAng.y,-180,180,0,2) 
    compassPlyAng:RotateAroundAxis( Vector(0,0,1), 90 )
    local lookAngleWest = math.Remap(compassPlyAng.y,-180,180,0,2) 

    for i = 1, 19 do
        local offset = i * compassWidth * (1/30)
        local pos = Vector(((scrW * 0.5)  * lookAngleNorth) + offset, 0)
        local screenCenter = Vector(scrW * 0.5, 0)

        compassColor.a = math.Remap(pos:Distance2D(screenCenter),0,500,255,0)
        draw.RoundedBox(0, pos.x, scrH * 0.02, scrH * 0.002, scrH * 0.002, compassColor) 
    end

    for i = 1, 19 do
        local offset = i * compassWidth * (1/30)
        local pos = Vector(((scrW * 0.5)  * lookAngleEast) + offset, 0)
        local screenCenter = Vector(scrW * 0.5, 0)

        compassColor.a = math.Remap(pos:Distance2D(screenCenter),0,500,255,0)
        draw.RoundedBox(0, pos.x, scrH * 0.02, scrH * 0.002, scrH * 0.002, compassColor) 
    end

    for i = 1, 19 do
        local offset = i * compassWidth * (1/30)
        local pos = Vector(((scrW * 0.5)  * lookAngleSouth) + offset, 0)
        local screenCenter = Vector(scrW * 0.5, 0)

        compassColor.a = math.Remap(pos:Distance2D(screenCenter),0,500,255,0)
        draw.RoundedBox(0, pos.x, scrH * 0.02, scrH * 0.002, scrH * 0.002, compassColor) 
    end

    for i = 1, 19 do
        local offset = i * compassWidth * (1/30)
        local pos = Vector(((scrW * 0.5)  * lookAngleWest) + offset, 0)
        local screenCenter = Vector(scrW * 0.5, 0)

        compassColor.a = math.Remap(pos:Distance2D(screenCenter),0,500,255,0)
        draw.RoundedBox(0, pos.x, scrH * 0.02, scrH * 0.002, scrH * 0.002, compassColor) 
    end
    
    local alignmentNumber = math.Round(math.Remap(lookAngleSouth,0,2,0,360),0)
    compassLetterBGColor.a = (alignmentNumber == 0 or alignmentNumber == 90 or alignmentNumber == 180 or alignmentNumber == 270 or alignmentNumber == 360) and 0 or 255
    compassDirectionColor.a = (alignmentNumber == 0 or alignmentNumber == 90 or alignmentNumber == 180 or alignmentNumber == 270 or alignmentNumber == 360) and 0 or 255
    draw.SimpleTextOutlined(alignmentNumber, "HUD Ammo Font Small", scrW * 0.5, scrH * 0.04, compassDirectionColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, compassLetterBGColor)

    local northPos = (scrW * 0.5) * lookAngleNorth
    compassDirectionColor.a = 255 * math.Remap(math.abs((scrW * 0.5) - (scrW - northPos)),0,450,1,0)
    compassLetterBGColor.a = compassDirectionColor.a 
    draw.SimpleTextOutlined("N", "HUD Ammo Font Small", (scrW * 0.5) * lookAngleNorth, scrH * 0.02, compassDirectionColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, compassLetterBGColor)
    
    local eastPos = (scrW * 0.5) * lookAngleEast
    compassDirectionColor.a = 255 * math.Remap(math.abs((scrW * 0.5) - (scrW - eastPos)),0,450,1,0)
    compassLetterBGColor.a = compassDirectionColor.a 
    draw.SimpleTextOutlined("E", "HUD Ammo Font Small", (scrW * 0.5) * lookAngleEast, scrH * 0.02, compassDirectionColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, compassLetterBGColor)
    
    local southPos = (scrW * 0.5) * lookAngleSouth
    compassDirectionColor.a = 255 * math.Remap(math.abs((scrW * 0.5) - (scrW - southPos)),0,450,1,0)
    compassLetterBGColor.a = compassDirectionColor.a 
    draw.SimpleTextOutlined("S", "HUD Ammo Font Small", (scrW * 0.5) * lookAngleSouth, scrH * 0.02, compassDirectionColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, compassLetterBGColor)
    
    local westPos = (scrW * 0.5) * lookAngleWest
    compassDirectionColor.a = 255 * math.Remap(math.abs((scrW * 0.5) - (scrW - westPos)),0,450,1,0)
    compassLetterBGColor.a = compassDirectionColor.a 
    draw.SimpleTextOutlined("W", "HUD Ammo Font Small", (scrW * 0.5) * lookAngleWest, scrH * 0.02, compassDirectionColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, compassLetterBGColor)
    
    -- We are using fastUpdateActiveWeapon for crosshair and ammo HUD and activeWeapon for weapon HUD because the weapon HUD needs to synchronize active anc backup weapon using PlayerSwitchWeapon.
    fastUpdateActiveWeapon = ply:GetActiveWeapon()

    -- Make sure stuff doesn't draw if player just spawned so we don't see values lerp into position.
    crosshairColor.a = ply:justSpawned() and 0 or 210
    crosshairAccuracyDisplayColor.a = ply:justSpawned() and 0 or 255
    yellow.a = ply:justSpawned() and 0 or 255
    yellowFaded.a = ply:justSpawned() and 0 or 255
    black.a = ply:justSpawned() and 0 or 255
    green.a = ply:justSpawned() and 0 or 255

    -- Crosshair ----------------------------------------------------------------------------------------
    if IsValid(fastUpdateActiveWeapon) and !ply:KeyDown(IN_ATTACK2) and !ply:KeyDown(IN_SPEED) then 
        --draw.RoundedBox(0, scrW * 0.5, scrH * 0.5, scrH * 0.003, scrH * 0.004, crosshairColor2)
        draw.RoundedBox(0, scrW * 0.5 + crosshairGap, scrH * 0.5, scrH * 0.003, scrH * 0.003, crosshairColor)
        draw.RoundedBox(0, scrW * 0.5 - crosshairGap, scrH * 0.5, scrH * 0.003, scrH * 0.003, crosshairColor)
        draw.RoundedBox(0, scrW * 0.5, scrH * 0.5 + crosshairGap, scrH * 0.003, scrH * 0.003, crosshairColor)
        draw.RoundedBox(0, scrW * 0.5, scrH * 0.5 - crosshairGap, scrH * 0.003, scrH * 0.003, crosshairColor)
    end


    -- Health bar and stamina bar shown together if either one needs to be shown
    showHealthAndStaminaHUD = (ply:getStamina() < ply:getMaxStamina() or ply:Health() < ply:GetMaxHealth()) and true or false
    healthAndStaminaAlphaMult = showHealthAndStaminaHUD and 1 or math.max(0, healthAndStaminaAlphaMult - FrameTime() * 1)
    surface.SetAlphaMultiplier(healthAndStaminaAlphaMult)

    -- Health bar ----------------------------------------------------------------------------------------
    targetHealth = math.Remap(ply:Health(), 0, ply:GetMaxHealth(), 0, 1)
    curHealth = Lerp(FrameTime() * 5, curHealth, targetHealth)
    draw.RoundedBox(0,scrW * 0.025, scrH * 0.96, scrW * 0.2, scrH * 0.002, black)
    red.a = 255 * math.abs(math.sin(CurTime() * 10))
    draw.RoundedBox(0,scrW * 0.025, scrH * 0.96, scrW * (0.2 * curHealth), scrH * 0.002, ply:Health() > 25 and green or red)

    -- Stamina bar ---------------------------------------------------------------------------------------
    targetStamina = math.Remap(ply:getStamina(), 0, ply:getMaxStamina(), 0, 1)
    curStamina = Lerp(FrameTime() * 5, curStamina, targetStamina)
    draw.RoundedBox(0,scrW * 0.025, scrH * 0.965, scrW * 0.2, scrH * 0.002, black)
    draw.RoundedBox(0,scrW * 0.025, scrH * 0.965, scrW * (0.2 * curStamina), scrH * 0.002, yellow)
    -------------------------------------------------------------------------------------------------------

    -- Ammo --------------------------------------------------------------------------------------------0     
    showAmmoHUD = checkAmmo and true or false
    ammoAlphaMult = showAmmoHUD and 1 or math.max(0, ammoAlphaMult - FrameTime() * 1)
    surface.SetAlphaMultiplier(ammoAlphaMult)

    if IsValid(fastUpdateActiveWeapon) and IsValid(ply:GetViewModel(0)) then 
        if (ply:GetViewModel():LookupAttachment("muzzle")) == 0 then return end
        viewModelPos = ply:GetViewModel():GetAttachment(ply:GetViewModel():LookupAttachment("muzzle")).Pos
        viewModelPos = viewModelPos:ToScreen()
        
        -- Mag ammo
        draw.SimpleTextOutlined( fastUpdateActiveWeapon:Clip1(), "HUD Ammo Font", viewModelPos.x - scrW * 0.095, viewModelPos.y , ammoColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, black )

        -- Reserve ammo
        surface.SetFont("HUD Ammo Font")
        magAmmoTextWidth, magAmmoTextHeight = surface.GetTextSize(fastUpdateActiveWeapon:Clip1())
        draw.SimpleTextOutlined( " + " .. ply:GetAmmoCount( fastUpdateActiveWeapon:GetPrimaryAmmoType() ), "HUD Ammo Font", viewModelPos.x - scrW * 0.095 + magAmmoTextWidth, viewModelPos.y, ammoColorFaded, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, black )
    end
    
    -- Weapons -------------------------------------------------------------------------------------------- 
    --if !IsValid(activeWeapon) or !IsValid(backupWeapon) or !weaponHudTranslations[activeWeapon:GetClass()] or !weaponHudTranslations[backupWeapon:GetClass()] then return end

    --showWeaponHUD = justSwitchedWeapon and true or false
    --weaponsAlphaMult = showWeaponHUD and 1 or math.max(0, weaponsAlphaMult - FrameTime() * 1)
    --surface.SetAlphaMultiplier(weaponsAlphaMult)

    --draw.SimpleText(weaponHudTranslations[activeWeapon:GetClass()]["character"], weaponHudTranslations[activeWeapon:GetClass()]["font"], scrW * 0.95, scrH * 0.935, compassColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    --draw.SimpleText(weaponHudTranslations[backupWeapon:GetClass()]["character"], weaponHudTranslations[backupWeapon:GetClass()]["font"], scrW * 0.95, scrH * 0.96, compassColorFaded, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    -----------------------------------------------------------------------------------------------------
end)

hook.Add("PlayerSwitchWeapon", "HLT HUD Detect Switch Weapon", function(ply, oldWeapon, newWeapon) 
    activeWeapon = nil
    backupWeapon = nil

    -- Set the active weapon to the weapon we're switching to. If we don't have a valid weapon, just return. (This makes sure to exclude things like holster SWEP)
    if !weaponHudTranslations[ply:GetActiveWeapon():GetClass()] then return end
    activeWeapon = newWeapon
    
    -- Now we want to know what the backup weapon is, if there even is one. So we call this function, if either one is missing then we know we don't have a backup weapon.
    local primaryWeapon, secondaryWeapon = HLT.getPrimaryAndSecondaryWeapons(ply)
    if !primaryWeapon or !secondaryWeapon then return end

    -- If the active weapon is our primary then we know our backup weapon is the secondary weapon, if not, then the secondary weapon is our backup weapon.
    backupWeapon = activeWeapon == primaryWeapon and secondaryWeapon or primaryWeapon

    justSwitchedWeapon = true 
    timer.Create("HLT Update justSwitchedWeapon", weaponSwitchHudFadeDelay, 1, function()
        justSwitchedWeapon = false
    end)

    -- Disable reload HUD when switching weapon.
    checkAmmo = false 
    ammoAlphaMult = 0 -- We need to immediately stop showing the ammo when switching weapons.
    if timer.Exists("HLT Delay HUD Fade After Reload Pressed") then
        timer.Remove("HLT Delay HUD Fade After Reload Pressed")
    end
end)

hook.Add("PlayerBindPress", "HLT Block Default Reload", function(ply, bind, pressed, code)
    if(!IsValid(ply)) then return end

    -- if(bind == "+reload") then 
    --     return true 
    -- end
end)

local reloadHeld = 0
local timeWhenPressedReload = CurTime()
hook.Add("PlayerButtonDown", "HLT HUD Reload Pressed Detect", function(ply, key)
    if key != KEY_R then return end
    -- Player gets to see their ammo count regardless of if they are just checking it or if they are reloading.
    checkAmmo = true
    timer.Create("HLT Delay Ammo HUD Fade After Check Ammo", ammoHudFadeDelay, 1, function() checkAmmo = false end)
    timeWhenPressedReload = CurTime()
end)

local buttonReleaseDetectDelay = CurTime()
hook.Add("PlayerButtonUp", "HLT HUD Reload Released Detect", function(ply, key)
    --if buttonReleaseDetectDelay > CurTime() then return end -- Seems to get called multiple times for some reason, so adding this delay.
    --buttonReleaseDetectDelay = CurTime() + 0.1
    -- print(key)
    -- print(reloadHeld)
    -- if key != KEY_R then return end
    -- reloadHeld = CurTime() - timeWhenPressedReload

    -- -- If they tap the reload button, then they simple reload. If they don't want to reload and just check ammo, they just hold the button a bit longer
    -- if reloadHeld < 0.5 then
    --     ply:ConCommand("+reload") 
    --     timer.Simple(0.1, function() ply:ConCommand("-reload") end)
    -- end
end)

