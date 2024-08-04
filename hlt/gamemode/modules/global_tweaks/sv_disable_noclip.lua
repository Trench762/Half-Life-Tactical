hook.Add( "PlayerNoClip", "HLT Handle Noclip", function( ply, desiredState )
	if ( desiredState == false ) then -- the player wants to turn noclip off
		ply:setIsNoClipping(false)
		return true -- always allow
	elseif ( ply:IsAdmin() ) then
		ply:setIsNoClipping(true)
		return true -- allow administrators to enter noclip
	end
	return false
end )