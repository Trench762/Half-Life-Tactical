local _disableinputonfocus = false
hook.Add( "Think", "disableinputonfocus", function()
   _disableinputonfocus = !system.HasFocus()
end )

hook.Add( "PlayerBindPress", "disableinputonfocus", function()
   if _disableinputonfocus then return true end
end )


