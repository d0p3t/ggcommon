local currentMapName = ""

local set_text_scale = SetTextScale
local begin_text_command_display_text = BeginTextCommandDisplayText
local add_text_component_substring_player_name = AddTextComponentSubstringPlayerName
local end_text_command_display_text = EndTextCommandDisplayText

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
        set_text_scale(0.2, 0.2)
        begin_text_command_display_text("MAP_NAME_LABEL")
        add_text_component_substring_player_name(currentMapName)
        end_text_command_display_text(0.015, 0.981)
      end
    end
  end
)
