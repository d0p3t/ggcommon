local createdPlayerBlips = {}

local function createBlip(player)
  if player == Cache.ClientPlayerId then
    return
  end

  local ped = GetPlayerPed(player)
  local blip = GetBlipFromEntity(ped)

  if blip == 0 then
    blip = AddBlipForEntity(ped)
    SetBlipScale(blip, 0.86)
    ShowHeadingIndicatorOnBlip(blip, true)
    SetBlipCategory(blip, 7)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 6)
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

        local blip = GetBlipFromEntity(victim)

        if blip ~= 0 then
          SetBlipSprite(blip, 274)
          SetBlipColour(blip, 40)
        end
      end
    end
  end
)

RegisterNetEvent("onPlayerRespawned")
AddEventHandler(
  "onPlayerRespawned",
  function(netId)
    local player = GetPlayerFromServerId(netId)

    if player == Cache.ClientPlayerId then
      return
    end

    local ped = GetPlayerPed(player)
    local blip = GetBlipFromEntity(ped)

    if blip ~= 0 then
      SetBlipSprite(blip, 1)
      SetBlipColour(blip, 6)
    else
      createBlip(player)
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      Wait(1000)
      for _, player in ipairs(GetActivePlayers()) do
        if not createdPlayerBlips[player] then
          createBlip(player)
        end
      end

      for player, blip in pairs(createdPlayerBlips) do
        -- check if player is still active
        if not NetworkIsPlayerActive(player) or GetPlayerPed(player) == 0 then
          if DoesBlipExist(blip) then
            RemoveBlip(blip)
          end
          createdPlayerBlips[player] = nil
        end
      end
    end
  end
)
