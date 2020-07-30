RegisterNetEvent("shop:prompt")
AddEventHandler(
  "shop:prompt",
  function(result)
    if result ~= "" then
      SendNuiMessage(
        json.encode(
          {
            type = "ggtoaster",
            toasterMessage = result,
            toasterTop = true,
            toasterPosition = "center"
          }
        )
      )
    end
  end
)

Citizen.CreateThread(
  function()
    AddTextEntry("FE_THDR_GTAO", "Gun Game V")
  end
)
