hook.Add("CanUndo", "HLT Disable Undo", function(ply)
    if ply:isNoClipping() then return true end
    return false
end)