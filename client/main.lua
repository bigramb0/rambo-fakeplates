local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rambo-fakeplates:client:changeplate', function()
  local vehicle = QBCore.Functions.GetClosestVehicle()
  local citizenId = QBCore.Functions.GetPlayerData().citizenid
  TruePlate =  GetVehicleNumberPlateText(vehicle)
  
  QBCore.Functions.TriggerCallback('rambo-fakeplates:server:checkOwnership', function(result)
    if result then
      QBCore.Functions.TriggerCallback('rambo-fakeplates:server:getTrunkItems', function(result)
          local trunkItems = result
          if vehicle ~= nil and vehicle ~= 0 then
          local ped = PlayerPedId()
          local pos = GetEntityCoords(ped)
          local vehpos = GetEntityCoords(vehicle)
          if #(pos - vehpos) < 5.0 and not IsPedInAnyVehicle(ped) then
            local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
              QBCore.Functions.Progressbar("change_plate", "Swapping Plates", math.random(1,2), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_player",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
                QBCore.Functions.Notify("Fake plate applied!")
                local newTrunk = SetVehicleNumberPlateText(vehicle, (math.random(11111111, 99999999)))
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                TriggerServerEvent('qb-vehiclefailure:removeItem', "fakeplate")
                TriggerServerEvent("rambo-fakeplates:server:setTruePlate", TruePlate)
                TriggerServerEvent('rambo-fakeplates:server:setTrunkItems', GetVehicleNumberPlateText(vehicle), trunkItems)
            end, function() -- Cancel
                StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
                QBCore.Functions.Notify("Failed!", "error")
            end)
          else
            if #(pos - vehpos) > 4.9 then
              QBCore.Functions.Notify("You are too far from the vehicle!", "error")
            else
              QBCore.Functions.Notify("You cannot change the plates from the inside!", "error")
            end
          end
        else
          QBCore.Functions.Notify("You are not near a vehicle!", "error")
        end
      end, TruePlate)  
    else
      QBCore.Functions.Notify('You can\'t change the plate on a vehicle you don\'t own!', 'error', 7500)
    end
  end, TruePlate, citizenId)
end)

RegisterNetEvent("rambo-fakeplates:client:restorePlate", function(item)
  QBCore.Functions.TriggerCallback('rambo-fakeplates:server:getOriginPlate', function(result)
      local originPlate = result
      local vehicle = QBCore.Functions.GetClosestVehicle()
      if vehicle ~= nil and vehicle ~= 0 then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local vehpos = GetEntityCoords(vehicle)
        if #(pos - vehpos) < 5.0 and not IsPedInAnyVehicle(ped) then
          local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
            QBCore.Functions.Progressbar("change_plate", "Swapping Plates", math.random(1,2 ), false, true, {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          }, {
              animDict = "mini@repair",
              anim = "fixing_a_player",
              flags = 16,
          }, {}, {}, function() -- Done
              local fake = GetVehicleNumberPlateText(vehicle)
              StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
              QBCore.Functions.Notify("Original plate applied!")
              SetVehicleNumberPlateText(vehicle, tostring(originPlate))
              TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
              TriggerServerEvent('rambo-fakeplates:server:removeFakePlate', fake)
          end, function() -- Cancel
              StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
              QBCore.Functions.Notify("Failed!", "error")
          end)
        else
          if #(pos - vehpos) > 4.9 then
            QBCore.Functions.Notify("You are too far from the vehicle!", "error")
          else
            QBCore.Functions.Notify("You cannot change the plates from the inside!", "error")
          end
        end
      else
        QBCore.Functions.Notify("You are not near a vehicle!", "error")
      end
  end)
end)