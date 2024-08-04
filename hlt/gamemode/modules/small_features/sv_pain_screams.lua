local male_screams = {
    "vo/npc/male01/hitingut01.wav",
    "vo/npc/male01/hitingut02.wav",
    "vo/npc/male01/imhurt01.wav",
    "vo/npc/male01/imhurt02.wav",
    "vo/npc/male01/myarm02.wav",
    "vo/npc/male01/mygut02.wav",
    "vo/npc/male01/myleg01.wav",
    "vo/npc/male01/myleg02.wav",
    "vo/npc/male01/ow01.wav",
    "vo/npc/male01/ow02.wav",
    "vo/npc/male01/pain01.wav",
    "vo/npc/male01/pain02.wav",
    "vo/npc/male01/pain03.wav",
    "vo/npc/male01/pain04.wav",
    "vo/npc/male01/pain05.wav",
    "vo/npc/male01/pain06.wav",
    "vo/npc/male01/pain07.wav",
    "vo/npc/male01/pain08.wav",
    "vo/npc/male01/pain09.wav",
}

local female_screams = {
    "vo/npc/female01/myarm01.wav",
    "vo/npc/female01/myarm02.wav",
    "vo/npc/female01/mygut02.wav",
    "vo/npc/female01/myleg01.wav",
    "vo/npc/female01/myleg02.wav",
    "vo/npc/female01/ow01.wav",
    "vo/npc/female01/ow02.wav",
    "vo/npc/female01/pain01.wav",
    "vo/npc/female01/pain02.wav",
    "vo/npc/female01/pain03.wav",
    "vo/npc/female01/pain04.wav",
    "vo/npc/female01/pain05.wav",
    "vo/npc/female01/pain06.wav",
    "vo/npc/female01/pain07.wav",
    "vo/npc/female01/pain08.wav",
    "vo/npc/female01/pain09.wav",
}

hook.Add("EntityTakeDamage", "HLT Pain Screams", function(ent, dmginfo)
    if !IsValid(ent) or !ent:IsPlayer() then return end
    if ent:Health() - dmginfo:GetDamage() <= 0 then return end -- Don't scream if you are dying.

    if ent.screamAllow == nil then 
        ent.screamAllow = true 
    end

    if !ent.screamAllow then return end
    
    local gender = string.find(ent:GetModel(), "female" ) and "female" or "male"
    ent:EmitSound(table.Random(gender == "female" and female_screams or male_screams), 75, 100, 100, CHAN_VOICE)
    ent.screamAllow = false

    timer.Create(ent:EntIndex() .. " pain scream timer", 2, 1, function()
        if !IsValid(ent) then return end
        ent.screamAllow = true         
    end)
end)