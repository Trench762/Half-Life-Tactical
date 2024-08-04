hook.Add( "GetFallDamage", "HLT Realistic Fall Damage", function( ply, speed )
    return ( speed / 8 )
end )