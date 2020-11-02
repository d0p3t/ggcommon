RegisterNetEvent("setTimeWeather")
AddEventHandler(
  "setTimeWeather",
  function(h, m, s, w)
    ClearWeatherTypePersist()
    PauseClock(false)
    SetWeatherTypeNow(w)
    SetWeatherTypeOvertimePersist(w, 1)
    NetworkOverrideClockTime(h, m, s)
    PauseClock(true)
  end
)
