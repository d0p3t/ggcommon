local firstSpawn = true

local hide_hud_component_this_frame = HideHudComponentThisFrame
local disable_control_action = DisableControlAction
local is_ped_armed = IsPedArmed

local network_set_friendly_fire_option = NetworkSetFriendlyFireOption
local set_can_attack_friendly = SetCanAttackFriendly
local network_set_talker_proximity = NetworkSetTalkerProximity
local set_garbage_trucks = SetGarbageTrucks
local set_random_boats = SetRandomBoats
local enable_dispatch_service = EnableDispatchService
local clear_player_wanted_level = ClearPlayerWantedLevel
local set_max_wanted_level = SetMaxWantedLevel

RegisterNetEvent("spawn")
AddEventHandler(
  "spawn",
  function()
    network_set_friendly_fire_option(true)
    set_can_attack_friendly(Cache.ClientPedId, true, true)

    if (firstSpawn) then
      network_set_talker_proximity(30.0)
      set_garbage_trucks(false)
      set_random_boats(false)

      for service = 1, 15 do
        enable_dispatch_service(service, false)
      end

      clear_player_wanted_level(Cache.ClientPlayerId)
      set_max_wanted_level(0)

      print("[Common] Disabled dispatch services, garbage trucks, boats, and set talker proximity (30m radius).")

      firstSpawn = false
    end
  end
)

Citizen.CreateThread(
  function()
    Wait(50)
    SetPedPopulationBudget(0.0)
    SetVehiclePopulationBudget(0.0)
    while true do
      Wait(0)
      hide_hud_component_this_frame(7)
      hide_hud_component_this_frame(9)

      if is_ped_armed(Cache.ClientPedId, 6) then
        disable_control_action(1, 140, true)
        disable_control_action(1, 141, true)
        disable_control_action(1, 142, true)
      end
    end
  end
)
