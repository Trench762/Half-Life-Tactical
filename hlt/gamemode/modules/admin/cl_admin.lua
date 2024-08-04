local ply = LocalPlayer()
local delay = CurTime()

// globalize people
hook.Add( "Think", "globalize slaugh7er and trench", function()
    if delay > CurTime() then return end
    delay = CurTime() + 1

    slaugh7er = player.GetBySteamID("STEAM_0:0:29988093")  
    trench = player.GetBySteamID("STEAM_0:0:33414218")  
end )

local xrayColor = Color(0,255,0)
hook.Add("HUDPaint", "cl_admin HUDPaint player x-ray", function()
    if not (ply:IsSuperAdmin() and ply:isNoClipping()) then return end
    for _, ply in pairs(player.GetAll()) do
        local pos = (ply:GetPos() + Vector(0,0,90)):ToScreen()
        draw.SimpleTextOutlined(ply:Name(), "DermaDefault", pos.x, pos.y, xrayColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
    end
end)