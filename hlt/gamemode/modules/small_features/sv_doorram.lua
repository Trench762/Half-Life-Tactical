local DEBUG = false -- "developer_1" concommand must be on for debug visualizations to work!
    
local function hitRammableEntity(ent)
    if !IsValid(ent) then return end
    local entClass = ent:GetClass()
    if entClass == "prop_door_rotating" or entClass == "func_door" or entClass == "func_door_rotating" or entClass == "func_breakable_surf" then 
        return true 
    else 
        return false 
    end
end

local handleRam = {
    ["prop_door_rotating"] = function(ply, ent)
        local oldSpeed = ent:GetInternalVariable("speed")
        local oldDir = ent:GetInternalVariable( "opendir")
        ent:SetKeyValue("opendir", 0)
        ent:Fire("SetSpeed", 700, 0)
        ent:Fire("OpenAwayFrom", "Door_Rammer_" .. ply:EntIndex(), 0) 
        timer.Create("reset_door_speed" .. ent:EntIndex(), 0.25, 1, function()
            if !IsValid(ent) then return end
            ent:Fire("SetSpeed", oldSpeed, 0)
            ent:SetKeyValue("opendir", oldDir)
        end)

        -- Check if it's a double door, if it is, then open that one too.
        local props = ents.FindInSphere(ent:GetPos(), 48)
        for k, v in pairs(props) do
            if v:GetClass() == "prop_door_rotating" then
                local oldSpeed = v:GetInternalVariable("speed")
                local oldDir = v:GetInternalVariable( "opendir")
                v:SetKeyValue("opendir", 0)
                v:Fire("SetSpeed", 700, 0)
                v:Fire("OpenAwayFrom", "Door_Rammer_" .. ply:EntIndex(), 0)
                timer.Create("reset_door_speed" .. v:EntIndex(), 0.25, 1, function()
                    if !IsValid(v) then return end
                    v:Fire("SetSpeed", oldSpeed, 0)
                    v:SetKeyValue("opendir", oldDir)
                end)
            end
        end

        -- Flavor & Effects
        if ent:GetMaterialType() == MAT_WOOD then
            ent:EmitSound("physics/wood/wood_panel_break1.wav", 90, math.random(95,105), 100, CHAN_AUTO)
        else
            ent:EmitSound("physics/wood/wood_panel_impact_hard1.wav", 90, math.random(95,105), 100, CHAN_AUTO)
        end

        ply:ViewPunch( Angle(math.random(15,20),0,0) )
    end,
    ["func_door_rotating"] = function(ply, ent)
        local oldSpeed = ent:GetInternalVariable("speed")
        ent:Fire("SetSpeed", 700, 0)
        ent:Fire("Open", "", 0)
        timer.Create("reset_door_speed" .. ent:EntIndex(), 0.25, 1, function()
            if !IsValid(ent) then return end
            ent:Fire("SetSpeed", oldSpeed, 0)
        end)

        -- Flavor & Effects
        if ent:GetMaterialType() == MAT_WOOD then
            ent:EmitSound("physics/wood/wood_panel_break1.wav", 90, math.random(95,105), 100, CHAN_AUTO)
        else
            ent:EmitSound("physics/wood/wood_panel_impact_hard1.wav", 90, math.random(95,105), 100, CHAN_AUTO)
        end

        ply:ViewPunch( Angle(math.random(-10,-5),0,0) )
    end,
    ["func_breakable_surf"] = function(ply, ent)
        ent:Fire("Shatter", "0.5 0.5 " .. ent:BoundingRadius())
    end,
}

hook.Add("SetupMove", "HLT Door Ram Check", function(ply, movedata, cmd)
    if ply.justRammedDoor then return end
    if !IsFirstTimePredicted() then return end
    if !ply.doorRamDelay then ply.doorRamDelay = CurTime() + 0.0625 end
    if ply.doorRamDelay > CurTime() then return end
    ply.doorRamDelay = CurTime() + 0.0625
    
    local plyPos = ply:GetPos() + Vector(0,0,48)
    local velocity = movedata:GetVelocity()
    local direction = velocity:GetNormalized()
    if velocity:Length() <= HLT.playerWalkSpeed + 5 then return end -- Don't allow ramming under certain speed
    if ply:isNoClipping() then return end

    -- Do the trace
    local tr = util.QuickTrace(plyPos + direction * 5, direction * 70, ply)
    if DEBUG then debugoverlay.Line(tr.StartPos, tr.HitPos, 1, Color( 9, 255, 0)) end

    -- Check if we hit something valid
    if !hitRammableEntity(tr.Entity) then return end

    -- Handle the hit based on what was hit
    ply:SetName("Door_Rammer_" .. ply:EntIndex())
    
    local ramFunc = handleRam[tr.Entity:GetClass()]
    if !ramFunc then return end
    
    ramFunc(ply, tr.Entity) 
    ply.justRammedDoor = true
    -- NOTE: Timers like this are deadly with prediction but since this is purely serverside its ok, if this ever is moved shared, this should be done with a think
    timer.Create("door ram delay reset" .. ply:EntIndex(), 0.5, 1, function() 
        if !IsValid(ply) then return end
        ply.justRammedDoor = false
    end)
end)