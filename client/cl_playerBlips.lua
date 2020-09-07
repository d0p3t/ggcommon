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

local activePlayers = {}
local playerId = PlayerId()

Citizen.CreateThread(function()
  while true do
    Wait(250)
    activePlayers = GetActivePlayers()
    playerId = PlayerId()
  end
end)

Citizen.CreateThread(
  function()
    while true do
      Wait(50)
      local blipsActive = {}

      for _, player in ipairs(activePlayers) do
        if player ~= playerId then
          local ped = GetPlayerPed(player)
          if ped ~= 0 then
            local blip = GetBlipFromEntity(ped)

            if blip == 0 then
              blip = AddBlipForEntity(ped)
              SetBlipScale(blip, 0.86)
              ShowHeadingIndicatorOnBlip(blip, true)
              SetBlipCategory(blip, 7)
              table.insert(createdBlips, blip)
            end

            table.insert(blipsActive, blip)

            if not IsEntityDead(ped) then
              SetBlipSprite(blip, 1)
              SetBlipColour(blip, 6)
            else
              SetBlipSprite(blip, 274)
              SetBlipColour(blip, 40)
            end
          end
        end
      end

      for _, blip in ipairs(createdBlips) do
        if not has_value(blipsActive, blip) then
          createdBlips[_] = nil
          if DoesBlipExist(blip) then
            RemoveBlip(blip)
          end
        end
      end
    end
  end
)
