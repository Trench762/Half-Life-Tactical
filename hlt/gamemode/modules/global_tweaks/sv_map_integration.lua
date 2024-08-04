local Blacklist = {
    ["item_healthkit"] = true,
    ["item_battery"] = true,
    ["item_ammo_357"] = true,
    ["item_ammo_357_large"] = true,
    ["item_ammo_ar2"] = true,
    ["item_ammo_ar2_large"] = true,
    ["item_ammo_ar2_altfire"] = true,
    ["combine_mine"] = true,
    ["item_ammo_crossbow"] = true,
    ["item_healthcharger"] = true,
    ["item_healthkit"] = true,
    ["item_healthvial"] = true,
    ["grenade_helicopter"] = true,
    ["item_suit"] = true,
    ["item_ammo_pistol"] = true,
    ["item_ammo_pistol_large"] = true, 
    ["item_rpg_round"] = true,
    ["item_box_buckshot"] = true,
    ["item_ammo_smg1"] = true,
    ["item_ammo_smg1_large"] = true,
    ["item_ammo_smg1_grenade"] = true,
    ["item_suitcharger"] = true,
    ["npc_grenade_frag"] = true,
    ["item_ammo_smg1_large"] = true,

    ["weapon_357"] = true,
    ["weapon_pistol"] = true,
    ["weapon_bugbait"] = true,
    ["weapon_crossbow"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_frag"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_ar2"] = true,
    ["weapon_rpg"] = true,
    ["weapon_slam"] = true,
    ["weapon_shotgun"] = true,
    ["weapon_smg1"] = true,
    ["weapon_stunstick"] = true,
}


hook.Add("OnEntityCreated", "HLT sv_map_integration remove illegal entities OnEntityCreated", function( ent )
    timer.Simple(0.2,function()
        if IsValid(ent) and not IsValid(ent:GetOwner()) then 
            if Blacklist[ent:GetClass()] then 
                ent:Remove()
            end
        end
    end)
end)

