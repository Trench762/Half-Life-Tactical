local ply = LocalPlayer()
local black = Color(0,0,0)
local scrW, scrH = ScrW(), ScrH()

net.Receive("HLT Fade Death Screen In", function()
    local instantDeath = net.ReadBool()
    local deathScreenColor = Color(0,0,0)
    local timeDied = UnPredictedCurTime()
    
    ply.deathPanel = vgui.Create( "DPanel" )
    ply.deathPanel:SetSize(scrW, scrH)
    
    if instantDeath then
        ply:ConCommand("soundfade 100 999999 0 0")
    else
        ply:ConCommand("soundfade 100 999999 0 3")
    end

    function ply.deathPanel:Paint(w, h)
        deathScreenColor.a = math.Remap(CurTime() - timeDied, 0, 3, 0, 255) 
        draw.RoundedBox(0, 0, 0, scrW, scrH, instantDeath and black or deathScreenColor)
    end
end)

net.Receive("HLT Fade Death Screen Out", function()
    if ply.deathPanel then 
        ply:ConCommand("soundfade 0 1 1 0")
        ply.deathPanel:Remove()
    end
end)

hook.Add( "CalcView", "cl_instant_death CalcView", function( ply, pos, angles, fov) 
    if ply:Health() > 0 then return end
    local ragdoll = ply:GetRagdollEntity()
    if !IsValid(ragdoll) then return end

    local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ))
    if !eyes  then return end

    local view = {
        origin = eyes.Pos,
        angles = eyes.Ang,
    }

    return view
end)

