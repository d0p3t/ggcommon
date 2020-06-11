local createdBlips = {}
local joinedPlayers = {}

local function has_value(tab, val)
  for i = 1, #tab do
    local value = tab[i]
    if value == val then
      return true
    end
  end

  return false
end

local myFirstSpawn = true

Citizen.CreateThread(
  function()
    Wait(2000)
    while true do
      Wait(0)

      local playerId = PlayerId()
      local players = GetActivePlayers()
      local blipsActive = {}

      for i = 1, #players do
        local player = players[i]

        if player ~= playerId then
          if myFirstSpawn or has_value(joinedPlayers, player) then
            local ped = GetPlayerPed(player)
            if ped ~= 0 then
              local blip = GetBlipFromEntity(ped)

              if blip == 0 then
                blip = AddBlipForEntity(ped)
                table.insert(createdBlips, blip)
              end

              table.insert(blipsActive, blip)

              if not IsEntityDead(ped) then
                SetBlipScale(blip, 0.86)
                SetBlipSprite(blip, 1)
                SetBlipColour(blip, 6)
                SetBlipCategory(blip, 7)
                ShowHeadingIndicatorOnBlip(blip, true)
              else
                ShowHeadingIndicatorOnBlip(blip, false)
                SetBlipScale(blip, 0.86)
                SetBlipSprite(blip, 274)
                SetBlipColour(blip, 40)
              end
            end
          end
        end
      end

      for i = 1, #createdBlips do
        local blip = createdBlips[i]
        if not has_value(blipsActive, blip) then
          createdBlips[i] = nil
          RemoveBlip(blip)
        end
      end

      myFirstSpawn = false
    end
  end
)

RegisterNetEvent("playerFirstSpawn")
AddEventHandler(
  "playerFirstSpawn",
  function(netId)
    local player = GetPlayerFromServerId(netId)
    table.insert(joinedPlayers, player)
  end
)

RegisterNetEvent("playerLeft")
AddEventHandler(
  "playerLeft",
  function(netId)
    local player = GetPlayerFromServerId(netId)
    for i = 1, #joinedPlayers do
      local joinedPlayer = joinedPlayers[i]
      if joinedPlayer == player then
        joinedPlayers[i] = nil
      end
    end
  end
)
