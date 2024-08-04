hook.Add("OnPhysgunPickup", "HLT No Collide Phys Gunned Props Disable", function(ply, ent)
    if!IsValid(ply) or !IsValid(ent) then return end
    ent:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
end)

hook.Add("PhysgunDrop", "HLT No Collide Phys Gunned Props Enable After Drop", function(ply, ent)
    ent:SetCollisionGroup( COLLISION_GROUP_NONE )
end)
