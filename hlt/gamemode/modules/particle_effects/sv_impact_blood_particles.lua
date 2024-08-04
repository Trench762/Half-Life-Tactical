hook.Add( "PostEntityTakeDamage", "sv_impact_blood_particles", function( e, t, b )
	if !b then return end
	if !e:IsNPC() and !e:IsPlayer() and !e:IsNextBot() then return end
	if e:GetModel() == "models/weapons/w_grenade.mdl" then return end
	local n = t:GetDamagePosition() or Vector()
	local tt = EffectData()
		tt:SetOrigin( n )
		tt:SetNormal( -t:GetDamageForce():GetNormalized() )
	util.Effect( "HLT_player_impact_blood", tt )
	local ttt = EffectData()
		ttt:SetOrigin( t:GetDamagePosition() )
	util.Effect( "HlT_impact_flash", ttt )
end )
