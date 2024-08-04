hook.Add( "EntityTakeDamage", "sv_disable_prop_damage disable prop damage", function(e,t)
    local c = e:GetClass()
    if c == "prop_physics" then t:SetDamage(0) end
end ) 
