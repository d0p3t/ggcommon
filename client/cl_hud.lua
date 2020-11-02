local currentMapName = ""

RegisterNetEvent("onRoundEnded")
AddEventHandler(
  "onRoundEnded",
  function()
    currentMapName = ""
  end
)

RegisterNetEvent("mapName")
AddEventHandler(
  "mapName",
  function(name)
    if name ~= nil then
      currentMapName = name
    else
      currentMapName = ""
    end
  end
)

Citizen.CreateThread(
  function()
    Wait(100)
    AddTextEntry("FE_THDR_GTAO", "Gun Game V")
    AddTextEntry("MAP_NAME_LABEL", "Map: ~a~")
    while true do
      Wait(0)
      if currentMapName ~= "" then
        SetTextFont(4)
        SetTextScale(0.3, 0.3)
        SetTextColour(255, 255, 255, 180)
        BeginTextCommandDisplayText("MAP_NAME_LABEL")
        AddTextComponentSubstringPlayerName(currentMapName)
        EndTextCommandDisplayText(0.015, 0.981)
      end
    end
  end
)
