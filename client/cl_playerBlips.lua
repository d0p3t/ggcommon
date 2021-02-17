local createdPlayerBlips = {}

local get_player_from_server_id = GetPlayerFromServerId
local get_player_ped = GetPlayerPed
local get_blip_from_entity = GetBlipFromEntity
local add_blip_for_entity = AddBlipForEntity
local network_is_player_active = NetworkIsPlayerActive
local does_blip_exist = DoesBlipExist
local remove_blip = RemoveBlip
local set_blip_sprite = SetBlipSprite
local set_blip_colour = SetBlipColour
local set_blip_scale = SetBlipScale
local set_blip_category = SetBlipCategory
local set_blip_as_short_range = SetBlipAsShortRange
local show_heading_indicator_on_blip = ShowHeadingIndicatorOnBlip

local function createBlip(player)
  if player == Cache.ClientPlayerId or player == -1 then
    return
  end

  local ped = get_player_ped(player)

  local blip = get_blip_from_entity(ped)

  if blip <= 0 then
    blip = AddBlipForEntity(ped)
    set_blip_scale(blip, 0.75)
    show_heading_indicator_on_blip(blip, false)
    set_blip_category(blip, 7)
    set_blip_sprite(blip, 1)
    set_blip_colour(blip, 6)
    set_blip_as_short_range(blip, true)
    createdPlayerBlips[player] = blip
  end
end

AddEventHandler(
  "gameEventTriggered",
  function(name, args)
    if name == "CEventNetworkEntityDamage" then
      local isDead = args[4] == 1

      if isDead then
        local victim = args[1]
        if victim == Cache.ClientPedId then
          return
        end

        local blip = get_blip_from_entity(victim)

        if blip > 0 then
          set_blip_sprite(blip, 274)
          set_blip_colour(blip, 40)
        end
      end
    end
  end
)

RegisterNetEvent("onPlayerRespawned")
AddEventHandler(
  "onPlayerRespawned",
  function(netId)
    local player = get_player_from_server_id(netId)

    if player == Cache.ClientPlayerId then
      return
    end

    local ped = get_player_ped(player)
    local blip = get_blip_from_entity(ped)

    if blip > 0 then
      set_blip_sprite(blip, 1)
      set_blip_colour(blip, 6)
    else
      createBlip(player)
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      Wait(1000)
      for _, player in ipairs(Cache.ActivePlayers) do
        if player ~= -1 then
          if not createdPlayerBlips[player] then
            createBlip(player)
          end
        end
      end

      for player, blip in pairs(createdPlayerBlips) do
        -- check if player is still active
        if not network_is_player_active(player) and player ~= -1 then
          if does_blip_exist(blip) then
            remove_blip(blip)
          end
          createdPlayerBlips[player] = nil
        end
      end
    end
  end
)
