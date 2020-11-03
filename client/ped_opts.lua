local FirstSpawn = true

RegisterNetEvent("spawn")
AddEventHandler(
  "spawn",
  function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)

    if (FirstSpawn) then
      NetworkSetTalkerProximity(30.0)
      SetGarbageTrucks(false)
      SetRandomBoats(false)

      for service = 1, 15 do
        EnableDispatchService(service, false)
      end

      ClearPlayerWantedLevel(Cache.ClientPlayerId)
      SetMaxWantedLevel(0)

      print("[Common] Disabled dispatch services, garbage trucks, boats, and set talker proximity (30m radius).")

      FirstSpawn = false
    end
  end
)

Citizen.CreateThread(
  function()
    Wait(0)
    SetPedPopulationBudget(0.0)
    SetVehiclePopulationBudget(0.0)
    while true do
      Wait(0)
      HideHudComponentThisFrame(6)
      HideHudComponentThisFrame(7)
      HideHudComponentThisFrame(8)
      HideHudComponentThisFrame(9)

      if IsPedArmed(Cache.ClientPedId, 6) then
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
      end
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      Wait(1000)
      SetDeepOceanScaler(0.0)
      N_0xc54a08c85ae4d410(1.0)
    end
  end
)
