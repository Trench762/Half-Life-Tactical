// spawn spawned entities in front of player when in play mode
local function _placeSpawnedInfrontOfPlayer(p,e)
    
    timer.Simple( 0, function()
        if !IsValid(p) or !IsValid(e) then return end
        if p:isNoClipping() then return end
        e:SetPos( p:GetPos() + Vector(0,0,16) + Angle(0,p:EyeAngles().y,0):Forward()*128 )
    end )
    
end
hook.Add( "PlayerSpawnedProp", "_placeSpawnedInfrontOfPlayer PlayerSpawnedProp", function(p,_,e) _placeSpawnedInfrontOfPlayer(p,e) end ) 
hook.Add( "PlayerSpawnedNPC", "_placeSpawnedInfrontOfPlayer PlayerSpawnedNPC", function(p,e) _placeSpawnedInfrontOfPlayer(p,e) end ) 
hook.Add( "PlayerSpawnedSENT", "_placeSpawnedInfrontOfPlayer PlayerSpawnedSENT", function(p,e) _placeSpawnedInfrontOfPlayer(p,e) end ) 
hook.Add( "PlayerSpawnedSWEP", "_placeSpawnedInfrontOfPlayer PlayerSpawnedSWEP", function(p,e) _placeSpawnedInfrontOfPlayer(p,e) end ) 