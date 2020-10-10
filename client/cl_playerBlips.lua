local createdBlips = {}

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
local playerId = 0
local myCoords = 0
local amIDead = false

Citizen.CreateThread(
  function()
    while true do
      activePlayers = GetActivePlayers()
      playerId = PlayerId()
      local myPed = PlayerPedId()
      myCoords = GetEntityCoords(myPed)
      amIDead = IsEntityDead(myPed)
      Wait(250)
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      Wait(0)
      -- local blipsActive = {}
      if not amIDead then
        for _, player in ipairs(activePlayers) do
          if player ~= playerId then
            local ped = GetPlayerPed(player)
            if ped ~= 0 then
              local blip = GetBlipFromEntity(ped)

              if blip < 1 then
                blip = AddBlipForEntity(ped)
                SetBlipScale(blip, 0.86)
                ShowHeadingIndicatorOnBlip(blip, true)
                SetBlipCategory(blip, 7)
                SetBlipSprite(blip, 1)
                SetBlipColour(blip, 6)
              -- table.insert(createdBlips, blip)
              end

              -- table.insert(blipsActive, blip)
              local pedCoords = GetEntityCoords(ped)
              local distance = #(myCoords - pedCoords)
              if distance < 10000 then
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
        end
      end

      -- for _, blip in ipairs(createdBlips) do
      --   if not has_value(blipsActive, blip) then
      --     createdBlips[_] = nil
      --     if DoesBlipExist(blip) then
      --       RemoveBlip(blip)
      --     end
      --   end
      -- end
    end
  end
)
