
local EFFECT = {} 
function EFFECT:Init( t )
	local e = ParticleEmitter( t:GetOrigin() )
	timer.Simple( 0, function() if e and e.Finish then e:Finish() end end )
	for i=1, 1 do // smoke
		local p = e:Add(  "particle/particle_noisesphere", t:GetOrigin() )
		p:SetDieTime( 1 )
		p:SetStartSize( 16 )
		p:SetEndSize( 32 )
		p:SetStartAlpha( 255 )
		p:SetEndAlpha( 0 )
		p:SetRollDelta( math.Rand(-.3, .3) )
		p:SetColor( 200, 0, 0 ) 
	end
end
function EFFECT:Think() return false end
function EFFECT:Render() end 
effects.Register(EFFECT, "HLT_player_impact_blood")



local EFFECT = {} 
function EFFECT:Init( t )
	local e = ParticleEmitter( t:GetOrigin() )
	timer.Simple( 0, function() if e and e.Finish then e:Finish() end end )
	for i=1, 1 do
		local p = e:Add( "effects/blueflare1", t:GetOrigin() )
		p:SetDieTime( .05 )
		p:SetStartSize( 32 )
		p:SetEndSize( 0 )
		p:SetStartAlpha( 255 )
		p:SetEndAlpha( 0 )
		p:SetRollDelta( math.Rand(-1,1) )
		p:SetColor( 255, 200, 200 )
	end
end
function EFFECT:Think() return false end
function EFFECT:Render() end 
effects.Register(EFFECT, "HLT_impact_flash")



