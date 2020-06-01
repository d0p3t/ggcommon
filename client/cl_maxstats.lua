local stats = {
  `SP0_STAMINA`,
  `SP0_STRENGTH`,
  `SP0_LUNG_CAPACITY`,
  `SP0_WHEELIE_ABILITY`,
  `SP0_FLYING_ABILITY`,
  `SP0_SHOOTING_ABILITY`,
  `SP0_STEALTH_ABILITY`
}

RegisterNetEvent('spawn')
AddEventHandler('spawn', function()
  for i = 1, #stats do
    local stat = stats[i]
    print(stat)
    StatSetInt(stat, 100, false)
  end
end)