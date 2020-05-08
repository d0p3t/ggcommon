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

            ClearPlayerWantedLevel(PlayerId())
            SetMaxWantedLevel(0)

            print("[Common] Disabled dispatch services, garbage trucks, boats, and set talker proximity (30m radius).")

            FirstSpawn = false
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)

            RestorePlayerStamina(PlayerId(), 1.0)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)

            Citizen.Wait(0)
        end
    end
)
