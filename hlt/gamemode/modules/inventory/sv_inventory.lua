Inventory = Inventory or {}
Inventory.containers = Inventory.containers or {}
Inventory.containers.inventories = Inventory.containers.inventories or {}   -- Pulled from disc, key is: "plyInv.SteamID"
Inventory.containers.stashes = Inventory.containers.stashes or {}           -- Pulled from disc, key is: "plyStash.SteamID"
Inventory.containers.lootcontainers = Inventory.containers.lootcontainers or {}                   -- Volatile, unsaved (only ever in memory)

-------------------------------------------------------------------------------------------------------
-----------------------------Player Inventory Interface------------------------------------------------
-------------------------------------------------------------------------------------------------------
function Inventory.loadPlayerInventory(ply)
    -- If an inventory already exists in the database, load it, if not, use the deault one
    local plyInvFileName = "die_right/inventories/" .. ply:SteamID64() .. ".txt"  
    local plyInv = file.Read(plyInvFileName, "DATA" ) or false
    Inventory.containers.inventories["plyInv." .. ply:SteamID64()]= plyInv != false and util.JSONToTable(plyInv) or {}
end

function Inventory.savePlayerInventory(ply)
    if !Inventory.playerInventoryExists(ply, true) then return end
    local data = util.TableToJSON(Inventory.getPlayerInventory(ply))
    -- TODO: left off here save the data
end

function Inventory.queueSavePlyInventory(ply)
    timer.Create("Inventory.queueSavePlyInventory() Delay." .. ply:EntIndex(), 2, 0, function() Inventory.savePlayerInventory(ply) end)
end

-------------------------------------------------------------------------------------------------------
-----------------------------Player Stash Interface----------------------------------------------------
-------------------------------------------------------------------------------------------------------
function Inventory.loadPlayerStash(ply)
    --TODO
end

function Inventory.savePlayerStash(ply)
    --TODO
end

function Inventory.queueSavePlyStash(ply)
    timer.Create("Inventory.queueSavePlyStash() Delay." .. ply:EntIndex(), 2, 0, function() Inventory.savePlayerStash(ply) end)
end



