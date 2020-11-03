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

local waitInterval = 500
Citizen.CreateThread(
  function()
    while true do
      Wait(waitInterval)

      if not Cache.ClientPedDead then
        waitInterval = 0
        for _, player in ipairs(Cache.ActivePlayers) do
          if player ~= Cache.ClientPlayerId then
            local pedData = Cache.ActivePlayersData[tostring(player)]
            if pedData ~= nil then
              local ped = pedData.ped
              if ped ~= 0 then
                local blip = GetBlipFromEntity(ped)

                if blip < 1 then
                  blip = AddBlipForEntity(ped)
                  SetBlipScale(blip, 0.86)
                  ShowHeadingIndicatorOnBlip(blip, true)
                  SetBlipCategory(blip, 7)
                  SetBlipSprite(blip, 1)
                  SetBlipColour(blip, 6)
                end

                local pedData = Cache.ActivePlayersData[tostring(player)]

                local pedCoords = pedData.coords
                local distance = #(Cache.ClientPedCoords - pedCoords)
                if distance < 10000 then
                  local blipSprite = GetBlipSprite(blip)
                  if not pedData.isDead and blipSprite ~= 1 then
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
      else
        waitInterval = 250
      end
    end
  end
)
