----------------- Hit Ground Penalties ----------------------
local ply = LocalPlayer()

hook.Add("OnPlayerHitGround", "HLT Stamina System Handle Player Hit Ground", function(ply, inWater, onFloat, speed)
    if !IsValid(ply) or ply:justSpawned() then return end

    -- Disable their sprint
    ply:ConCommand( "-speed")
    ply:ConCommand( "-duck")
    util.ScreenShake( ply:GetPos(), 1, 1, .25, 32, false, ply )
    -- if ply:GetViewPunchAngles().p > 0 then return end -- This causes a weird bug when people spawn sometimes it makes their screen keep going up until they jump
    -- ply:ViewPunch( Angle(speed * 0.1,0,0) ) - this must also be called in sv_movement for prediction
end)