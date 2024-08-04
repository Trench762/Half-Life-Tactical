if CLIENT then
    hook.Add( "HUDPaint", "cl_dev_hud HUDPaint", function()
        local p, w, h = LocalPlayer(), ScrW(), ScrH()
        local sca = 6
        if !tobool(p:isNoClipping()) then return end
        draw.RoundedBox( 0, (w/2-sca/2), (h/2-sca/2), sca, sca, Color(0,0,0,200) )
        sca = sca - 2
        draw.RoundedBox( 0, (w/2-sca/2), h/2-sca/2, sca, sca, Color(255,255,255,200) )
        surface.DrawCircle( w/2, h/2, 16, 255, 255, 255, 50 )
    end )
end