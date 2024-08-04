local ply = LocalPlayer()
ply.flashlightEnabled = true
local flashLightColor = Color(255,242,210)
local flashlight = nil

local activeFlashlightPlayers = {}

local function killFlashlight(ply)
    if !IsValid(ply) then return end
    if !flashlight or !IsValid(flashlight) then return end
    flashlight:Remove()
    ply.flashlightEnabled = true
    
    -- We need to update that the client has disabled their flashlight for other players now so we can turn of the rendering of their flashlight sprite on other clients.
    net.Start("HLT Notify Server Player Flashlight Toggled")
    net.WriteBool(flashlightEnabled)
    net.SendToServer()
end

net.Receive("HLT Disable Flashlight On Death", function()
    killFlashlight(ply)
end)

local function toggleFlashlight(ply, flashlightEnabled)
    if !IsValid(ply) then return end
    if !IsValid(ply:GetActiveWeapon()) then return end
    
    if IsValid(flashlight) then flashlight:Remove() end
    surface.PlaySound("items/flashlight1.wav")
    
    net.Start("HLT Notify Server Player Flashlight Toggled")
    net.WriteBool(flashlightEnabled)
    net.SendToServer()
    
    if !flashlightEnabled then return end

    -- Create flashlight
    flashlightPos = ply:GetActiveWeapon():GetPos() + Vector(0,0,12) 
    flashlight = ProjectedTexture()
    flashlight:SetTexture( "effects/flashlight001" )
    flashlight:SetColor(flashLightColor)
    flashlight:SetFarZ( 1200 )
    flashlight:SetNearZ ( 12 )
    flashlight:SetFOV( 30 )
    flashlight:SetBrightness( 1 )
    flashlight:SetEnableShadows ( true )
    flashlight:SetPos(flashlightPos)
    flashlight:SetAngles( ply:EyeAngles() )
end

local flashlightSpriteBeamColor = Color(255,250,234,238)
local flashlightSpriteMaterial = Material("particle/particle_glow_05_addnofog")
local flashlightBeamMaterial = CreateMaterial( "HLTflashlightbeam", "UnlitGeneric", {
    ["$basetexture"] = "sprites/glow_test01",
    ["$additive"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1
} )
local activeWeapon
local flashlightPos
local renderFlashlightPostSprintDelay = CurTime()

hook.Add("PostDrawTranslucentRenderables", "HLT Render Flashlight Beams", function()
    for k, v in pairs(player.GetAll()) do
        if v:hasFlashLightEnabled() and v != ply then -- Don't draw for ourselves             
            
            -- Don't draw if invalid.
            activeWeapon = v:GetActiveWeapon()
            if !IsValid(activeWeapon) or HLT.isHLTWeapon(activeWeapon) then continue end
            
            -- Don't draw if reloading.
            if v:isReloading() then continue end

            -- Don't draw if sprinting or holstered. (Looks akward when enabling it right after the player finishes sprinting or unholstering because the gun isn't fully up)
            -- TODO: re-integrate isHolstered()
            local sprinting =  ply:IsSprinting() and (ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_BACK))
            if sprinting then 
                renderFlashlightPostSprintDelay = CurTime() + .25 
                return 
            end
            if renderFlashlightPostSprintDelay > CurTime() then continue end
            
            -- Don't draw if too far.
            if v:GetPos():Distance(ply:GetPos()) > 1024 then continue end

            if !IsValid(activeWeapon) then continue end
            flashlightPos = activeWeapon:GetAttachment(activeWeapon:LookupAttachment( "muzzle" )).Pos
            render.SetMaterial( flashlightSpriteMaterial )
            render.DrawSprite( flashlightPos, 128, 128, flashlightSpriteBeamColor )
            render.SetMaterial( flashlightBeamMaterial )
            render.DrawBeam( flashlightPos, flashlightPos + v:GetAimVector() * 100, 50, 0, .99, flashlightSpriteBeamColor )
        end
    end
end)

local flashlightBrightness 
local flashlightPos
local flashlightAng
hook.Add("PostDrawTranslucentRenderables", "HLT cl_flashlight Update Flashlights", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
    activeWeapon = ply:GetActiveWeapon()
    if !IsValid(flashlight) or !IsValid(activeWeapon) or !flashlight then return end

    if (ply:GetViewModel():LookupAttachment("muzzle")) == 0 then return end
    viewModel = ply:GetViewModel():GetAttachment(ply:GetViewModel():LookupAttachment("muzzle"))
    flashlightPos = viewModel.Pos
    flashlightAng = viewModel.Ang

    flashlight:SetPos(flashlightPos)
    flashlight:SetAngles(flashlightAng) 
    -- local sprinting =  ply:IsSprinting() and (ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_BACK))
    flashlightBrightness = math.random(0.97,1) 
    flashlight:SetBrightness( flashlightBrightness )
    flashlight:Update()
end)

hook.Add("PlayerSwitchWeapon", "HLT Disable Flashlight On Switch Weapon", function(ply, oldWeapon, newWeapon)
    killFlashlight(ply)
end)

local delay3 = CurTime() + 0.1
hook.Add("PlayerButtonDown", "HLT cl_flashlight detect keypress", function(ply, button)
    if input.LookupKeyBinding( button ) != "impulse 100" then return end
    if HLT.isHLTWeapon(ply:GetActiveWeapon()) then return end 
    if delay3 > CurTime() then return end
    delay3 = CurTime() + 0.1
    
    if ply.flashlightEnabled then 
        ply.flashlightEnabled = false 
    else 
        ply.flashlightEnabled = true 
    end

    toggleFlashlight(ply, !ply.flashlightEnabled)
end)