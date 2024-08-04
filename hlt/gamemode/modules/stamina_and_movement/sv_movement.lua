----------------- Hit Ground Penalties ----------------------
hook.Add("OnPlayerJump", "HLT sv_movement Stamina Handle Exhausted Jump", function(ply, speed)
    ply:setLastTimeJumped(CurTime())
end)

hook.Add("OnPlayerHitGround", "HLT sv_movement Stamina System Handle Player Hit Ground", function(ply, inWater, onFloat, speed)
    if !IsValid(ply) or ply:justSpawned() then return end
    
    ply:setJustLandedJump(true)
    ply:setLastTimeLandedOnGround(CurTime())

    -- Disable their sprint
    ply:ConCommand( "-speed")
    ply:ConCommand( "-duck")

    -- Speed penalties are applied in stamina_and_movement/sh_stamina.lua
    timer.Create("HLT Block Run After Landing Jump " .. ply:EntIndex(), 0.5, 1, function()
        if !IsValid(ply) then return end
        ply:setJustLandedJump(false)
    end)

    -- Viewpunch
    -- if ply:GetViewPunchAngles().p > 0 then return end -- This causes a weird bug when people spawn sometimes it makes their screen keep going up until they jump
    -- ply:ViewPunch( Angle(speed * 0.1,0,0) ) -- This must also be called clientside because of prediction in cl_movement
end) 