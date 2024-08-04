util.AddNetworkString("HLT Fade Death Screen In")
util.AddNetworkString("HLT Fade Death Screen Out")

hook.Add("PlayerDeath", "HLT Instant Death Screen Fade", function(victim, inflictor, attacker)
    timer.Simple(0.1, function()
        net.Start("HLT Fade Death Screen In")
        local instantDeath = (victim:LastHitGroup() == HITGROUP_HEAD or victim:LastHitGroup() == HITGROUP_GENERIC) and true or false
        net.WriteBool(instantDeath)
        net.Send(victim)
    end)
end)

hook.Add("PlayerSpawn", "HLT Instant Death Screen Fadeout", function(ply, transition)
    net.Start("HLT Fade Death Screen Out")
    net.Send(ply)
end)