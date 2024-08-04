local damagePulseFraction = 0
local ply = LocalPlayer()

concommand.Add( "damagePulse", function()
    damagePulseFraction = damagePulseFraction + 1
    ply = LocalPlayer()
end )

local matGradient = Material( "vgui/gradient-u" )
hook.Add( "HUDPaint", "RUIN Damage Pulse HUDPaint", function()
    if !ply:Alive() then damagePulseFraction = 0 return end
    if ply.escMenuOpen then return end
    if (damagePulseFraction == 0) then return end

    local w, h = ScrW(), ScrH()
    damagePulseFraction = math.Clamp( damagePulseFraction - FrameTime() * 4, 0, 4 ) 
    local c = Color( 248, 115, 115, 50)
    local sca = h*.04 * damagePulseFraction
    surface.SetMaterial( matGradient ) 
    surface.SetDrawColor( c )
    surface.DrawTexturedRectRotated( sca/2, h/2, h, sca, 90 ) // l
    surface.DrawTexturedRectRotated( w-sca/2, h/2, h, sca, -90 ) // r
    surface.DrawTexturedRectRotated( w/2, sca/2, w, sca, 0 ) // u
    surface.DrawTexturedRectRotated( w/2, h-sca/2, w, sca, 180 ) // b
end )
