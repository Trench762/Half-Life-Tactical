util.AddNetworkString("HLT Disable Flashlight On Death")
util.AddNetworkString("HLT Notify Server Player Flashlight Toggled")

----------------- Disable Default Flashlight ----------------------
hook.Add( "PlayerSwitchFlashlight", "HLT Disable Flashlight", function( ply, enabled )
	return false
end )

net.Receive("HLT Notify Server Player Flashlight Toggled", function(len, ply)
    ply:setPlyHasFlashLightEnabled(net.ReadBool())
end)

hook.Add("PlayerDeath", "sv_flashlight Disable Flashlight On Death", function(ply)
    net.Start("HLT Disable Flashlight On Death")
    net.Send(ply)
end)