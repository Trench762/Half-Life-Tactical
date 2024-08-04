hook.Add("EntityTakeDamage", "RUIN Damage Pulse Trigger", function(ent, dmg)
    if !IsValid(ent) or !ent:IsPlayer() then return end
    ent:ConCommand( "damagePulse" )
end)

