RegisterNetEvent("setTimeWeather")
AddEventHandler(
  "setTimeWeather",
  function(h, m, s, w)
    ClearWeatherTypePersist()
    PauseClock(false)
    local chance = math.random(0, 100)
    if chance <= 50.0 then
      SetWeatherTypeNow(w)
      SetWeatherTypeOvertimePersist(w, 1)
      NetworkOverrideClockTime(h, m, s)
    else
      SetWeatherTypeNow("HALLOWEEN")
      SetWeatherTypeOvertimePersist("HALLOWEEN", 1)
      TriggerEvent(
        "chat:addMessage",
        {
          templateId = "help",
          color = {255, 255, 255},
          multiline = true,
          args = {"Halloween weather! 🎃 Oh no, spooky...", ""}
        }
      )
      NetworkOverrideClockTime(0, 0, 0)
    end
    PauseClock(true)
  end
)
