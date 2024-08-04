----------------- Block low stamina jumping ----------------------
hook.Add("StartCommand", "HLT sh_stamina Handle Stamina Shared Movement", function(ply, ucmd)
    if ply:getStamina() < 30 then 
        ucmd:RemoveKey(IN_JUMP)
    end
end)   

----------------- Integrate Stamina To Affect Speed --------------
local speedAfterStamina 
local speedAfterLanding 

hook.Add("SetupMove", "HLT sh_stamina SetupMove", function(ply, mv, cmd)
    if !ply:Alive() or ply:isNoClipping() or ply:InVehicle() then return end
    
    -- Apply final speed based on all factors influencing stamina
    speedAfterStamina = math.Clamp( (HLT.playerRunSpeed * math.Remap(ply:getStamina(),35,0,1, 0.7)) , HLT.playerSlowRunSpeed, HLT.playerRunSpeed )
    speedAfterLanding = math.Remap(CurTime() - ply:getLastTimeLandedOnGround(), 0, 1, 100, speedAfterStamina)

    if cmd:GetButtons() == IN_SPEED + IN_FORWARD then 
        mv:SetForwardSpeed(ply:getJustLandedJump() and speedAfterLanding or speedAfterStamina)
    end
end)
