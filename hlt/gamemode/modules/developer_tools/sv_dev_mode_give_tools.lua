// give nocliping admin tools
local _tools = { "gmod_tool", "weapon_physgun" }
local delay = CurTime()

hook.Add( "Think", "av_admin give tools", function()
	if delay > CurTime() then return end
    delay = CurTime() + 0.5
	
    for _, p in pairs( player.GetAll() ) do 
        if !p:IsAdmin() then continue end
        local b = p:isNoClipping()
        for _, v in pairs( _tools ) do
            if b then 
                p:Give( v )
            else
                p:StripWeapon( v )
            end
        end
    end

end )
