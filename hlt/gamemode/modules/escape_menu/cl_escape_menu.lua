HLT.EscMenu = HLT.EscMenu or nil
HLT.EscMenuOpen = HLT.EscMenuOpen or false
HLT.ScoreBoard = HLT.ScoreBoard or nil
HLT.ScoreBoardOpen = HLT.ScoreBoardOpen or false
local ply = LocalPlayer()
local scrW, scrH = ScrW(), ScrH()
local escMenuColor = Color(0,0,0,100)
local color_button_hover = Color(255,255,255)
local color_button_no_hover = Color(172,172,172)
local colorEscGradient = Color(20,141,255,120)

surface.CreateFont("Trebuchet MS 9" , { font = "Trebuchet MS", size = ScreenScale(9), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })
surface.CreateFont("Trebuchet MS 15" , { font = "Trebuchet MS", size = ScreenScale(15), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })
surface.CreateFont("Gruppo 10" , { font = "Gruppo", size = ScreenScale(10), weight = 1000, blursize = 0; scanlines = 0, shadow = false, additive = false, })

hook.Add( "OnScreenSizeChanged", "HLT HUD Rebuild Fonts", function( oldWidth, oldHeight )
    scrW, scrH = ScrW(), ScrH()
    surface.CreateFont("Trebuchet MS 9" , { font = "Trebuchet MS", size = ScreenScale(9), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })
    surface.CreateFont("Trebuchet MS 15" , { font = "Trebuchet MS", size = ScreenScale(15), weight = 500, blursize = 0; scanlines = 0, shadow = false, additive = false, })
    surface.CreateFont("Gruppo 10" , { font = "Gruppo", size = ScreenScale(10), weight = 1000, blursize = 0; scanlines = 0, shadow = false, additive = false, })
end )

local function playEscMenuButtonEnteredSound()
    EmitSound( "buttons/lightswitch2.wav", Vector(0,0,0), -2, CHAN_AUTO, 1, 75, 0, 200, 0 )
end

local function playEscMenuButtonPressedSound()
    EmitSound( "buttons/button9.wav", Vector(0,0,0), -2, CHAN_AUTO, 1, 75, 0, 250, 0 )
end

local function createScoreboard(parentPanel)
    local panel = vgui.Create( "DFrame", parentPanel )
    panel:SetSize( scrW * 0.25, scrH )
    panel:SetPos(scrW * 0.5, scrH * 0)
    panel:Center()
    panel:SetTitle( "" ) 
    panel:MakePopup()
    panel:SetDraggable(false)
    panel:ShowCloseButton(false)
    HLT.ScoreBoard = panel
    panel.Paint = function(s,w,h)
        --draw.RoundedBox(0,0,0,w,h,Color(0,255,0))
    end

    local scrollPanel = vgui.Create( "DScrollPanel", panel )
    scrollPanel:Dock( FILL )
    scrollPanel.Paint = function(s,w,h)
        --draw.RoundedBox(0,0,0,w,h,Color(255,0,0))
    end

    for k, v in pairs(player.GetAll()) do
        local button = scrollPanel:Add( "DButton" )
        button.Paint = function(s,w,h)
        end
        button:SetText( v:GetName() )
        button:SetFont("Trebuchet MS 15")
        button:SetSize(scrW, scrH * 0.05)
        button:Dock( TOP )
        button:DockMargin( 0, 0, 0, 5 )
    end
end

local function createResumeButton(parentPanel)
    local resumeButton = vgui.Create("DButton", parentPanel)
    resumeButton:SetText("")
    resumeButton:SetPos(0, 0)
    resumeButton:SetSize( scrW * 0.25, scrH * 0.1) 
    resumeButton:Dock(TOP)
    resumeButton:DockMargin(0, 0, 0, 0) 
    resumeButton:DockPadding( 0, 0, 0, 0 )
    resumeButton.Paint = function(s,w,h)
        if s:IsHovered() then
            draw.SimpleTextOutlined("RESUME", "Gruppo 10", w * 0.5, h * 0.1, color_button_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        else
            draw.SimpleTextOutlined("RESUME", "Gruppo 10", w * 0.5, h * 0.1, color_button_no_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        end
    end
    resumeButton.OnCursorEntered = function(s)
        playEscMenuButtonEnteredSound() 
    end
    resumeButton.DoClick = function(s)
        playEscMenuButtonPressedSound()
        HLT.EscMenu:Remove()
        HLT.EscMenuOpen = false
    end
end

local function createSettingsButton(parentPanel)
    -- local HLTsettings = vgui.Create("DButton", parentPanel)
    -- HLTsettings:SetText("")
    -- HLTsettings:SetPos(0, 0)
    -- HLTsettings:SetSize( scrW * 0.25, scrH * 0.1) 
    -- HLTsettings:Dock(TOP)
    -- HLTsettings:DockMargin(0, 0, 0, 0) 
    -- HLTsettings:DockPadding( 0, 0, 0, 0 )
    -- HLTsettings.Paint = function(s,w,h)
    --     if s:IsHovered() then
    --         draw.SimpleTextOutlined("SETTINGS", "Gruppo 10", w * 0.5, h * 0.1, color_button_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
    --     else
    --         draw.SimpleTextOutlined("SETTINGS", "Gruppo 10", w * 0.5, h * 0.1, color_button_no_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
    --     end
    -- end
    -- HLTsettings.OnCursorEntered = function(s)
    --     playEscMenuButtonEnteredSound() 
    -- end
    -- HLTsettings.DoClick = function(s)
    --     playEscMenuButtonPressedSound()
    -- end
end

local function createScoreboardButton(parentPanel)
    local scoreBoard = vgui.Create("DButton", parentPanel)
    scoreBoard:SetText("")
    scoreBoard:SetPos(0, 0)
    scoreBoard:SetSize( scrW * 0.25, scrH * 0.1) 
    scoreBoard:Dock(TOP)
    scoreBoard:DockMargin(0, 0, 0, 0) 
    scoreBoard:DockPadding( 0, 0, 0, 0 )
    scoreBoard.Paint = function(s,w,h)
        if s:IsHovered() then
            draw.SimpleTextOutlined("PLAYERS", "Gruppo 10", w * 0.5, h * 0.1, color_button_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        else
            draw.SimpleTextOutlined("PLAYERS", "Gruppo 10", w * 0.5, h * 0.1, color_button_no_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        end
    end
    scoreBoard.OnCursorEntered = function(s)
        playEscMenuButtonEnteredSound() 
    end
    scoreBoard.DoClick = function(s)
        playEscMenuButtonPressedSound()
        if HLT.ScoreBoard then HLT.ScoreBoard:Remove() HLT.ScoreBoard = nil return end
        createScoreboard(HLT.EscMenu)
    end
end

local function createCreditsButton(parentPanel)
    local creditsButton = vgui.Create("DButton", parentPanel)
    creditsButton:SetText("")
    creditsButton:SetPos(0, 0)
    creditsButton:SetSize( scrW * 0.25, scrH * 0.1) 
    creditsButton:Dock(TOP)
    creditsButton:DockMargin(0, 0, 0, 0) 
    creditsButton:DockPadding( 0, 0, 0, 0 )
    creditsButton.Paint = function(s,w,h)
        if s:IsHovered() then
            draw.SimpleTextOutlined("DISCORD", "Gruppo 10", w * 0.5, h * 0.1, color_button_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        else
            draw.SimpleTextOutlined("DISCORD", "Gruppo 10", w * 0.5, h * 0.1, color_button_no_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        end
    end
    creditsButton.OnCursorEntered = function(s)
        playEscMenuButtonEnteredSound() 
    end
    creditsButton.DoClick = function(s)
        playEscMenuButtonPressedSound()
        gui.OpenURL( "https://discord.gg/pRH5MhtKzm" )
    end
end

local function createMainMenuButton(parentPanel)
    local gmodMenuButton = vgui.Create("DButton", parentPanel)
    gmodMenuButton:SetText("")
    gmodMenuButton:SetPos(0, 0)
    gmodMenuButton:SetSize( scrW * 0.25, scrH * 0.1) 
    gmodMenuButton:Dock(TOP)
    gmodMenuButton:DockMargin(0, 0, 0, 0) 
    gmodMenuButton:DockPadding( 0, 0, 0, 0 )
    gmodMenuButton.Paint = function(s,w,h)
        if s:IsHovered() then
            draw.SimpleTextOutlined("MAIN MENU", "Gruppo 10", w * 0.5, h * 0.1, color_button_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        else
            draw.SimpleTextOutlined("MAIN MENU", "Gruppo 10", w * 0.5, h * 0.1, color_button_no_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        end
    end
    gmodMenuButton.OnCursorEntered = function(s)
        playEscMenuButtonEnteredSound() 
    end
    gmodMenuButton.DoClick = function(s)
        playEscMenuButtonPressedSound()
        HLT.EscMenu:Remove()
        HLT.EscMenuOpen = false
        gui.ActivateGameUI() 
    end
end

local function createDisconnectButton(parentPanel)
    local disconnectButton = vgui.Create("DButton", parentPanel)
    disconnectButton:SetText("")
    disconnectButton:SetPos(0, 0)
    disconnectButton:SetSize( scrW * 0.25, scrH * 0.1) 
    disconnectButton:Dock(TOP)
    disconnectButton:DockMargin(0, 0, 0, 0) 
    disconnectButton:DockPadding( 0, 0, 0, 0 )
    disconnectButton.Paint = function(s,w,h)
        if s:IsHovered() then
            draw.SimpleTextOutlined("DISCONNECT", "Gruppo 10", w * 0.5, h * 0.1, color_button_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        else
            draw.SimpleTextOutlined("DISCONNECT", "Gruppo 10", w * 0.5, h * 0.1, color_button_no_hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, w * .002, Color(0,0,0))
        end
    end
    disconnectButton.OnCursorEntered = function(s)
        playEscMenuButtonEnteredSound() 
    end
    disconnectButton.DoClick = function(s)
        playEscMenuButtonPressedSound()
        ply:ConCommand("disconnect")
    end
end

local function HLTescapeMenuToggle()
    ----------------Toggle Menu -----------------
    if HLT.EscMenu and HLT.EscMenuOpen then 
        HLT.EscMenu:Remove()
        HLT.EscMenuOpen = false
        return 
    end

    HLT.EscMenuOpen = true
    input.SetCursorPos(scrW * 0.3, scrH * 0.5 )

    -------------- Main Panel ---------------------
    local EscMenuParentFrame = vgui.Create( "DFrame" )
    HLT.EscMenu = EscMenuParentFrame
    EscMenuParentFrame:SetPos( 0, 0 ) 
    EscMenuParentFrame:SetSize( scrW, scrH ) 
    EscMenuParentFrame:SetTitle( "" ) 
    EscMenuParentFrame:SetVisible( true ) 
    EscMenuParentFrame:SetDraggable( false ) 
    EscMenuParentFrame:ShowCloseButton( false ) 
    EscMenuParentFrame:MakePopup()
    EscMenuParentFrame.startTime = SysTime() 
    EscMenuParentFrame.Paint = function(s, w, h)
        Derma_DrawBackgroundBlur(s, s.startTime)
        draw.RoundedBox(0,0,0,w,h,escMenuColor)
    end
    EscMenuParentFrame.OnClose = function(s)
        HLT.EscMenuOpen = false
        HLT.ScoreBoard = nil
    end

    -------------- Button Panel ---------------------
    local buttonPanel = vgui.Create("DPanel",EscMenuParentFrame)
    buttonPanel:SetPos( scrW * 0.0, scrH * 0.0 ) 
    buttonPanel:SetSize( scrW * 0.25, scrH) 
    buttonPanel:DockPadding(0,scrH * 0.25,0,0)
    buttonPanel.Paint = function(s,w,h)
        draw.RoundedBox(0,w *0.1,0,w*0.005,h,Color(196,158,77,10))
        draw.RoundedBox(0,w * .9,0,w*0.005,h,Color(196,158,77,10))
        surface.SetTexture(surface.GetTextureID("hlt/ui/square_dots_grid_01_1024px"))
        surface.SetDrawColor(Color(255,255,255,2))
        surface.DrawTexturedRectUV( w *0.1, 0, w * 0.8, h, 0, 0, w / 64, h / 64 )
    end

    -------------- Buttons ---------------------
    createResumeButton(buttonPanel)
    createSettingsButton(buttonPanel)
    createScoreboardButton(buttonPanel)
    createCreditsButton(buttonPanel)
    createMainMenuButton(buttonPanel)
    createDisconnectButton(buttonPanel)
end

local colorLookup = {
    [ "$pp_colour_addr" ] = 0,
    [ "$pp_colour_addg" ] = 0,
    [ "$pp_colour_addb" ] = 0,
    [ "$pp_colour_brightness" ] = 0,
    [ "$pp_colour_contrast" ] = 1,
    [ "$pp_colour_colour" ] = 1, -- This controls saturation.
    [ "$pp_colour_mulr" ] = 0,
    [ "$pp_colour_mulg" ] = 0,
    [ "$pp_colour_mulb" ] = 0
}

hook.Add( "RenderScreenspaceEffects", "HLT cl_escape_menu HP Related Effects", function() --Desaturation, Toytown blur, and motion blur
    if !HLT.EscMenuOpen then return end
    
    colorLookup["$pp_colour_colour"] = math.Clamp(CurTime() - HLT.EscMenu.startTime, 0, 1)
    DrawColorModify( colorLookup )  
end )


concommand.Add("HLT_escapeMenuToggle", HLTescapeMenuToggle) -- Rebinding functionality. (Doubt anyone will use it, I'm not going to bother integrating it)

-- Hide the default game UI
local frontBuffer = Material("effects/frontbuffer")
hook.Add( "PreRender", "HLT cl_escape_menu Custom Escape Menu", function()
    if (input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible()) then
        gui.HideGameUI()
        ply:ConCommand("HLT_escapeMenuToggle")
        -- Render a texture of the screen over the screen for a frame to mask the gmod menu popping up for a frame before its closed by gui.HideGameUI()
        -- For some reason effects/frontbuffer is a missing texture when it shouldn't be so we need to do some extra work to make it function properly using 
        -- render.GetScreenEffectTexture()
        cam.Start2D()
            surface.SetDrawColor(255, 255, 255, 255)
            render.UpdateScreenEffectTexture()
            frontBuffer:SetTexture( "$basetexture", render.GetScreenEffectTexture() )
            surface.SetMaterial(frontBuffer)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        cam.End2D()
        
        return true 
    end
end )