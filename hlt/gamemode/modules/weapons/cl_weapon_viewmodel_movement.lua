--NOTE: This was done by Trench, using Kait's viewbob instead for viewmodel manip, keeping for now until Kait's is fully integrated

local xmouse, ymouse = 0,0
hook.Add( "CreateMove", "HLT cl_weapon_viewmodel_movement CreateMove", function(cmd)
    xmouse = Lerp(RealFrameTime() * 3, xmouse , cmd:GetMouseX())
    ymouse = Lerp(RealFrameTime() * 3, ymouse , cmd:GetMouseY())
end )

hook.Add( "CalcViewModelView", "HLT cl_weapon_viewmodel_movement CalcViewModelView", function(  wep,  vm,  oldPos,  oldAng,  pos,  ang )
    ang:Add(Angle(-ymouse/8,xmouse/8,0))
end )