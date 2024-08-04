if SERVER then
    hook.Add( "PlayerDeathSound", "HLT Mute Default Death Sound", function( ply )
        return true 
    end )
end