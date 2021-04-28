--[[
  This module has commands that are to be used for general things like forcing a respawn/death.
]]
local set_entity_invincible = SetEntityInvincible
local set_entity_health = SetEntityHealth

function Respawn()
    local ped = Cache.ClientPedId
    set_entity_invincible(ped, false)
    set_entity_health(ped, 0)
end

RegisterCommand("suicide", Respawn, false)
RegisterCommand("die", Respawn, false)
RegisterCommand("respawn", Respawn, false)

RegisterKeyMapping("suicide", "Force Respawn", "keyboard", "f1")
