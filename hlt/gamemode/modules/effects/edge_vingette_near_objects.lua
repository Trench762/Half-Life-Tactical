GRADIENT_TOP = 1
GRADIENT_BOTTOM = 2
GRADIENT_VERTICAL = 3
GRADIENT_VERTICLE = 3
GRADIENT_HORIZONTAL = 4
GRADIENT_LEFT = 5
GRADIENT_RIGHT = 6
local matGradient = Material( "vgui/gradient-u" )
function draw.Gradient( x, y, w, h, color, type ) 
    surface.SetMaterial( matGradient or "" )
    surface.SetDrawColor( color or color_white )
    if type == GRADIENT_TOP then 
        surface.DrawTexturedRectRotated( x, y, w, h, 0 )
    end
    if type == GRADIENT_BOTTOM then
        surface.DrawTexturedRectRotated( x, y, w, h, 180 )
    end
    if type == GRADIENT_VERTICAL then
        surface.DrawTexturedRectRotated( x, y+h*.245, w, h*.5, 0 )
        surface.DrawTexturedRectRotated( x, y-h*.245, w, h*.5, 180 )
    end
    if type == GRADIENT_HORIZONTAL then
        surface.DrawTexturedRectRotated( x+w*.245, y, h, w*.5, 90 )
        surface.DrawTexturedRectRotated( x-w*.245, y, h, w*.5, -90 )
    end
    if type == GRADIENT_LEFT then
        surface.DrawTexturedRectRotated( x, y, h, w, 90 )
    end
    if type == GRADIENT_RIGHT then
        surface.DrawTexturedRectRotated( x, y, h, w, -90 )
    end	
end 

local LeftTrace, RightTrace
hook.Add( "Think", "screen.edge.vignette.Think", function()
    local v = LocalPlayer():EyePos()
    local a = LocalPlayer():EyeAngles()
    LeftTrace = util.QuickTrace( v, a:Right()*-64, player.GetAll() )
    RightTrace = util.QuickTrace( v, a:Right()*64, player.GetAll() )
end )
local LeftAlpha, RightAlpha = 0, 0 
hook.Add( "HUDPaint", "screen.edge.vignette.HUDPaint", function()
    if LeftTrace and LeftTrace.Hit and LeftTrace.Fraction < 1 then
        LeftAlpha = Lerp( FrameTime(), LeftAlpha, 1-LeftTrace.Fraction )
    else
        LeftAlpha = math.Clamp( LeftAlpha-FrameTime(), 0, 1 )
    end
    if RightTrace and RightTrace.Hit and RightTrace.Fraction < 1 then
        RightAlpha = Lerp( FrameTime(), RightAlpha, 1-RightTrace.Fraction )
    else
        RightAlpha = math.Clamp( RightAlpha-FrameTime(), 0, 1 )
    end
    local w, h = ScrW(), ScrH()
    for i=1, 6 do
        draw.Gradient( 0, h*.5, h*(i)/5, h, Color( 0, 0, 0, 255*LeftAlpha ), GRADIENT_LEFT ) // left
        draw.Gradient( w, h*.5, h*(i)/5, h, Color( 0, 0, 0, 255*RightAlpha ), GRADIENT_RIGHT ) // right
    end
end )