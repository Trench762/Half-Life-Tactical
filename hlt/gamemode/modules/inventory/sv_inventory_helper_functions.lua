Inventory = Inventory or {}

function Inventory.playerInventoryExists(ply, printResultToConsole)
    local dataexists = Inventory.containers.inventories["plyInv." .. ply:SteamID64()] != nil and true or false
    if printResultToConsole then print(dataexists and "Inventory for " .. tostring(ply:Name()) .. "(" .. ply:SteamID64() ..")" .. " loaded!" or "Inventory for " .. tostring(ply:Name()) .. "(" .. ply:SteamID64() ..")" .. " not found!") end
    return dataexists
end

-- Returns a table that represents the inventory for the passed player, fetched from the table of all player inventories (Inventory.containers.inventories)
function Inventory.playerInventoryExists(ply)
    if !Inventory.playerInventoryExists(ply) then return end
    return Inventory.containers.inventories["plyInv." .. ply:SteamID64()]
end