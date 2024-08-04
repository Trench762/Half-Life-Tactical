hook.Add("EntityTakeDamage", "HLT sv_health_regen ealth Regen Take Damage Regen Delay", function(ent)
    if !IsValid(ent) or !ent:IsPlayer() then return end
    ent.justTookDamage = true 

    timer.Create(tostring(ent) .. " HLT hp regen delay", 3, 1, function()
        if !IsValid(ent) then return end
        ent.justTookDamage = false
    end)
end)

local delay1 = CurTime() 
local delay2 = CurTime() 

hook.Add("Think", "HLT sv_health_regen Health Regen", function()
    if delay1 > CurTime() then return end
    delay1 = CurTime() + 0.5

    for k, v in pairs(player.GetAll()) do
        if !IsValid(v) then continue end
        if !v:Alive() then continue end
        if v:Health() >= v:GetMaxHealth() then continue end
        local hp = v:Health()
        v:SetHealth(math.min(v:GetMaxHealth(), hp + 1))
    end
end)



