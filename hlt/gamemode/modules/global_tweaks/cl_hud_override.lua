local hide = {
	["CHudChat"] = false, -- Blocking this causes the user to not be able to open esc menu or console.
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudWeaponSelection"] = true, // also blocks the number weapon switching :P go figure
	["CHudCrosshair"] = true,
	["CHUDQuickInfo"] = true, -- Health and ammo near crosshair.
	["CHudCloseCaption"] = true,
	["CHudDamageIndicator"] = true,
}

local delay = CurTime()

hook.Add( "Think", "HLT cl_hud_override HUD Override", function()
	if delay > CurTime() then return end
	delay = CurTime() + .1

	local p = LocalPlayer()
	hide["CHudWeaponSelection"] = !p:isNoClipping() and true or false
end )

hook.Add( "HUDShouldDraw", "HLT cl_hud_override HUD Override", function( name )
	if ( hide[ name ] ) then
		return false
	end
	-- Don't return anything here, it may break other addons that rely on this hook.
end )

-- Disable seeing player's name and health when looking at them
hook.Add( "HUDDrawTargetID", "HLT cl_hud_override Hide Player Info When Looking At Them", function()
	return false
end )

hook.Add("DrawDeathNotice", "HLT cl_hud_override Disable Kill Feed", function()
		return 0,0
end)

hook.Add( "HUDWeaponPickedUp", "HLT cl_hud_override Weapon Picked Up HUD", function( itemName )
    return false
end )

hook.Add( "HUDItemPickedUp", "HLT cl_hud_override Item Picked Up HUD", function( itemName )
    return false
end )

-- Block suit zoom.
hook.Add("PlayerBindPress", "HLT cl_hud_override Block Suit Zoom", function(ply, bind, pressed, code)
    if(!IsValid(ply)) then return end

    if (bind == "+zoom") then 
        return true
    end
end)

-- Disable score board.
hook.Add( "ScoreboardShow", "HLT cl_hud_override Disable Score Board", function()
	return false
end )

-- Disable context menu.
hook.Add( "OnContextMenuOpen", "HLT cl_hud_override Disable Context Menu", function()
	if !LocalPlayer():IsAdmin() then 
        return false
    end
end )

-- Disable spawn menu.
hook.Add( "SpawnMenuOpen", "HLT cl_hud_override Disable Spawn Menu", function()
	if !LocalPlayer():IsAdmin() then 
        return false
    end
end )

