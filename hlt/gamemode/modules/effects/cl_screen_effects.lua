if CLIENT then
	local scrH = ScrH()
    local ply = LocalPlayer()
    local hp = 100

	local colorLookup = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 1, -- This controls saturation.
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}

	hook.Add( "RenderScreenspaceEffects", "HLT cl_screen_effects HP Related Effects", function() --Desaturation, Toytown blur, and motion blur
		hp = ply:Health()
		if hp == ply:GetMaxHealth() then return end
        
        colorLookup["$pp_colour_colour"] = math.max(0, 1 - (1 - hp/ply:GetMaxHealth())) 
        DrawColorModify( colorLookup )  
	end )
end