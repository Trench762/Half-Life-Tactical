hook.Add("PlayerFootstep", "HLT Play Sprinting Foot Step Noise", function(ply, pos, foot, sound, volume, filter)
    if ply:IsSprinting() then
        ply:EmitSound("npc/combine_soldier/gear" .. tostring(math.random(1,6)) .. ".wav", 75, math.random(95,105), 0.05, CHAN_AUTO)
    end
    return false
end)