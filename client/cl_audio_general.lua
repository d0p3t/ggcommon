Citizen.CreateThread(function()
  Wait(1)
  SetAudioFlag('LoadMPData', true)
  RequestScriptAudioBank('DLC_BIKER/BKR_KQ_01', false)
  RequestScriptAudioBank('GTAO_FM_Events_Soundset', true)
end)

RegisterNetEvent('playSound')
AddEventHandler('playSound', function(soundName, soundSet)
  if(not HasSoundFinished(-1)) then StopSound(-1) end

  PlaySoundFrontend(-1, soundName, soundSet, true)
end)