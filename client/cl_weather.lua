local clear_weather_type_persist = ClearWeatherTypePersist
local pause_clock = PauseClock
local set_weather_type_now = SetWeatherTypeNow
local set_weather_type_overtime_persist = SetWeatherTypeNowPersist
local network_override_clock_time = NetworkOverrideClockTime

RegisterNetEvent("setTimeWeather")
AddEventHandler(
  "setTimeWeather",
  function(h, m, s, w)
    clear_weather_type_persist()
    pause_clock(false)
    set_weather_type_now(w)
    set_weather_type_overtime_persist(w, 1)
    network_override_clock_time(h, m, s)
    pause_clock(true)
  end
)
