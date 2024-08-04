if SERVER then
    hook.Add( "EntityTakeDamage", "RUIN Scale Damage", function( target, dmginfo )
        if !IsValid(dmginfo:GetAttacker()) then return end
        
        if (target:IsPlayer() and IsValid(target)) then
            if dmginfo:GetInflictor():IsNPC() then
                dmginfo:ScaleDamage(10) 
            elseif dmginfo:GetInflictor():IsPlayer() then
                dmginfo:ScaleDamage(1) 
            end
        elseif(target:IsNPC() and IsValid(target)) then
            dmginfo:ScaleDamage(6)
        end
    end )
end