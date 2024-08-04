-- Block the default chat box from opening and call our own detour function to create our own chat box.
hook.Add("PlayerBindPress", "HLT Custom Chat Detect Chat Button Pressed", function(ply, bind)
    if(!IsValid(ply)) then return end
    if (bind == "messagemode" or bind == "messagemode2") then 
        return true -- TODO: Call detour function here
    end
end)

-- Block default chat box.
hook.Add( "ChatText", "HLT Block Default Chat", function( index, name, text, type )
    return true
end )