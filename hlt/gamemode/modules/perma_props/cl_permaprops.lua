local saveStatus = {
    [1] = "You aren't authorized to save props",
    [2] = "Error encountered, props failed to save",
    [3] = "Props saved successfully..."
}

local function printSaveStatus(saveCode)
    print(saveStatus[saveCode])
end

net.Receive("HLT Perma Props Notify Player Of Prop Save Status", function()
    printSaveStatus(net.ReadInt(3))
end)

concommand.Add( "dr_save_props", function(ply)
    ply:ConCommand("dr_save_props")
end)