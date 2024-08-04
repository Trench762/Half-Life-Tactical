----------------- Block Crouch Jumping ----------------------
hook.Add("StartCommand", "HLT sh_movement StartCommand", function(ply, ucmd)
    -- local onGround = ply:OnGround()
    -- local justJumped = (CurTime() - ply:getLastTimeJumped() < 0.25) and true or false

    -- if justJumped or not onGround then 
    --     if ply:isNoClipping() then return end
    --     ucmd:RemoveKey(IN_DUCK)
    -- end
end)   