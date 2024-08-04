if SERVER then
    local primaryWeapons = {
        ["tfa_mmod_crossbow"] = "tfa_mmod_crossbow",
        ["tfa_mmod_ar3"] = "tfa_mmod_ar3",
        ["tfa_mmod_ar2"] = "tfa_mmod_ar2",
        ["tfa_mmod_rpg"] = "tfa_mmod_rpg",
        ["tfa_mmod_shotgun"] = "tfa_mmod_shotgun",
        ["tfa_mmod_smg"] = "tfa_mmod_smg",
    }

    local secondaryWeapons = {
        ["tfa_mmod_357"] = "tfa_mmod_357",
        ["tfa_mmod_pistol"] = "tfa_mmod_pistol",
    }

    hook.Add("PlayerSpawn", "sh_test DM Give Weapons", function(ply)  
        timer.Simple(0,function()
            ply:Give(table.Random(secondaryWeapons))
            ply:Give(table.Random(primaryWeapons))
            for k, v in pairs(ply:GetWeapons()) do
                v:SetClip1(v:GetMaxClip1())
            end
        end)
    end)
end

