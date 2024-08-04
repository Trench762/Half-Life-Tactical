----------------- Set The Players Stamina ----------------------
local stamina
local speedAfterLanding 
local speedAfterStamina 

local delay = CurTime() + .05
hook.Add("Think", "HLT sv_stamina Stamina Think", function()
    if delay > CurTime() then return end
    delay = CurTime() + .05

    for _, ply in pairs(player.GetAll()) do
        if !IsValid(ply) or !ply:Alive() or ply:isNoClipping() or ply:InVehicle() then continue end
        stamina = ply:getStamina()
        stamina = (ply:KeyDown(IN_SPEED) and ply:GetVelocity():LengthSqr() > 0 and !ply:Crouching()) and (stamina - 0.5) or (stamina + 0.75)
        ply:setStamina(math.Clamp( stamina, 0, ply:getMaxStamina()))
    end
end)

hook.Add("OnPlayerJump", "sv_stamina OnPlayerJump", function(ply, speed)
    ply:setStamina(math.max(0,ply:getStamina() - 40))
end)

----------------- Reset Stamina After Death ----------------------
hook.Add("PlayerDeath", "HLT Stamina System Reset Stamina On Player Death", function(victim, inflictor, attack)
    if !IsValid(victim) then return end
    victim:setStamina(victim:getMaxStamina())
end)