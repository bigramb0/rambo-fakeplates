local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("fakeplate", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("rambo-fakeplates:client:changeplate", source, item, true)
end)

QBCore.Functions.CreateUseableItem("licenseplate", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("rambo-fakeplates:client:restorePlate", source, item)
end)

RegisterNetEvent("rambo-fakeplates:server:setTruePlate", function(TruePlate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local info = {
        label = TruePlate
    }
    Player.Functions.AddItem("licenseplate", 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["licenseplate"], "add")
   
end)

QBCore.Functions.CreateCallback('rambo-fakeplates:server:getTrunkItems', function(source, cb, plate)
    local items = exports['lj-inventory']:GetTrunkItems(plate)
    cb(items)
end)

RegisterNetEvent('rambo-fakeplates:server:removeFakePlate', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if plate then
        Player.Functions.RemoveItem("licenseplate", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["licenseplate"], "remove")
        Player.Functions.AddItem("fakeplate", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["fakeplate"], "add")
    end
end)
RegisterNetEvent('rambo-fakeplates:server:setTrunkItems', function(plate, items)
    local src = source
    TriggerEvent('inventory:server:addTrunkItems', plate, items)
    TriggerEvent('inventory:server:addGloveboxItems', plate, items)
end)

QBCore.Functions.CreateCallback('rambo-fakeplates:server:checkOwnership', function(source, cb, plate, citizenId)
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid', {
        ['@plate'] = plate,
        ['@citizenid'] = citizenId
    })
    if result[1] then cb(true) else cb(false) end
end)

QBCore.Functions.CreateCallback('rambo-fakeplates:server:getOriginPlate', function(source, cb, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName("licenseplate")
    local ItemData = Player.Functions.GetItemBySlot(item.slot)
    originPlate = ItemData.info.label
    cb(originPlate)
end)