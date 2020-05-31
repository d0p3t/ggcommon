RegisterNetEvent("setTimeWeather")
AddEventHandler(
  "setTimeWeather",
  function(h, m, s, w)
    ClearWeatherTypePersist()
    SetWeatherTypeNow(w)
    SetWeatherTypeOvertimePersist(w, 1)
    PauseClock(false)
    NetworkOverrideClockTime(h, m, s)
    PauseClock(true)
  end
)
