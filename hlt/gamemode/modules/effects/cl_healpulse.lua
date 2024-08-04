local healPulseFraction = 0
local ply = LocalPlayer()

concommand.Add( "healPulse", function()
    healPulseFraction = healPulseFraction + 200
    ply = LocalPlayer()
end )

local matGradient = Material( "vgui/gradient-u" )
hook.Add( "HUDPaint", "RUIN HealPulse HUDPaint", function()
    if !ply:Alive() then healPulseFraction = 0 return end
    if ply.escMenuOpen then return end
    if (healPulseFraction == 0) then return end
    
    local w, h = ScrW(), ScrH()
    healPulseFraction = math.Clamp( healPulseFraction - FrameTime() * 8, 0, 4 ) 
    local c = Color( 87, 255, 64, 50)
    local sca = h*.01 * healPulseFraction
    surface.SetMaterial( matGradient ) 
    surface.SetDrawColor( c )
    surface.DrawTexturedRectRotated( sca/2, h/2, h, sca, 90 ) // l
    surface.DrawTexturedRectRotated( w-sca/2, h/2, h, sca, -90 ) // r
    surface.DrawTexturedRectRotated( w/2, sca/2, w, sca, 0 ) // u
    surface.DrawTexturedRectRotated( w/2, h-sca/2, w, sca, 180 ) // b
end )
