Citizen.CreateThread(
  function()
    Wait(0)
    SetAudioFlag("LoadMPData", true)
    RequestScriptAudioBank("DLC_BIKER/BKR_KQ_01", false)
    RequestScriptAudioBank("GTAO_FM_Events_Soundset", true)
    RequestScriptAudioBank("SCRIPT\\RAMPAGE_01", false);
    RequestScriptAudioBank("SCRIPT\\RAMPAGE_02", false);
    RequestScriptAudioBank("DLC_AWXM2018/AW_PTB_01", false);
    RequestScriptAudioBank("DLC_BIKER/BKR_DL_01", false);
    RequestScriptAudioBank("DLC_BIKER/BKR_DL_02", false);
  end
)

RegisterNetEvent("playSound")
AddEventHandler(
  "playSound",
  function(soundName, soundSet)
    if (not HasSoundFinished(-1)) then
      StopSound(-1)
    end

    CancelMusicEvent(soundName);
    PlaySoundFrontend(-1, soundName, soundSet, true)
  end
)

-- RegisterCommand('audio', function(source,args,raw)
--   if args[1] then
--     local sound = args[1]
--     local set = ""
--     if args[2] then
--       set = args[2]
--     end

--     print('playing ' .. sound .. ' from ' .. set)
--     -- PlaySoundFrontend(-1, sound, set, false)
--   end

--   Citizen.CreateThread(function()
--     for i=1,10 do
--       Wait(2000)
--         TriggerEvent('ShowWeaponPurchasedMessage', "Gained Level", "Vintage Pistol", "WEAPON_DAGGER", 2000)
--         TriggerEvent('showNextWeaponEffectsOnPlayer', GetPlayerServerId(PlayerId()), i - 1);
--     end
--   end)

--   --ShakeGameplayCam("LARGE_EXPLOSION_SHAKE", 0.01)
--   --AnimpostfxStopAll()
--   --AnimpostfxPlay("MP_SmugglerCheckpoint", 2000, false)

-- end, false)