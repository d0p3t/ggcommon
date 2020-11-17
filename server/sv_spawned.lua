RegisterServerEvent('spawned')
AddEventHandler('spawned', function()
  local _source = source

  TriggerClientEvent('onPlayerRespawned', -1, _source)
end)