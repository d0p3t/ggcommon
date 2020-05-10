--[[
  This module has commands that are to be used for general things like forcing a respawn/death.
]]

function Respawn()
  local ped = PlayerPedId()
  SetEntityInvincible(ped, true)
  SetEntityHealth(ped, 0)
end

RegisterCommand("suicide", Respawn() , false)
RegisterCommand("die", Respawn() , false)
RegisterCommand("respawn", Respawn() , false)