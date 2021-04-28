local stat_set_int = StatSetInt

local stats = {
  `SP0_STAMINA`,
  `SP0_STRENGTH`,
  `SP0_LUNG_CAPACITY`,
  `SP0_WHEELIE_ABILITY`,
  `SP0_FLYING_ABILITY`,
  `SP0_SHOOTING_ABILITY`,
  `SP0_STEALTH_ABILITY`
}

local firstSpawn = true

RegisterNetEvent("spawn")
local spawnEvent = AddEventHandler(
    "spawn",
    function()
        if firstSpawn then
            for i = 1, #stats do
                stat_set_int(stats[i], 100, false)
            end
            firstSpawn = false
            RemoveEventHandler(spawnEvent)
        end
    end
)
