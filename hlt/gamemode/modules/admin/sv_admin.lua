local delay = CurTime()

// globalize people this does nothing on its own (doesnt make anyone admin, just a way to test, dont wanna comment it out cause idk if ive used one of these globals to test somewhere, too lazy to find it, rest assured nothing malicious)
hook.Add( "Think", "globalize slaugh7er and trench", function()
   if delay > CurTime() then return end
   delay = CurTime() + 1

   slaugh7er = player.GetBySteamID("STEAM_0:0:29988093")  
   trench = player.GetBySteamID("STEAM_0:0:33414218")  
end )

// assign usergorups to steamids
local sidToUsergroup = {

}

hook.Add( "PlayerSpawn", "sv_admin PlayerSpawn", function(p)
   -- local sid = p:SteamID()
   -- local k = sidToUsergroup[sid] or "User"
   -- p:SetUserGroup( k )
end )

