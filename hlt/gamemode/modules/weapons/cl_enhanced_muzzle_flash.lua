local muzzleFlashColor = Color(41, 13, 0, 255)
local flashPos = Vector()
local flashAng = Angle()
local flash
local ply = LocalPlayer()
local dietime = UnPredictedCurTime()

local function drawEnhancedMuzzleFlash(pos, ang)
    if flash then flash:Remove() end
    
    flash = ProjectedTexture()

    dietime = UnPredictedCurTime() + 0.05 * math.Remap(ply:Ping(),0,200, 1, 3)

    flash:SetTexture( "effects/flashlight/soft" )
    flash:SetColor( muzzleFlashColor)
    flash:SetFarZ( 600 )
    flash:SetNearZ ( 60 )
    flash:SetFOV( math.random(100,135) )
    flash:SetBrightness( math.random(15,20) )
    flash:SetEnableShadows ( true )
    flash:SetPos( pos )
    flash:SetAngles( ang )
    flash:Update()
end

hook.Add("Think", "cl_enhanced_muzzle_flash Think", function()
    if dietime < UnPredictedCurTime() then
        if !IsValid(flash) then return end
        flash:Remove()
    end
end)

hook.Add("EntityFireBullets", "HLT Enhanced Muzzle Flash", function(ent, table)
    if !ent:IsPlayer() then return end
    if !IsValid(ent) then return end

    drawEnhancedMuzzleFlash(ent:GetPos(), ent:GetAngles())
end)
