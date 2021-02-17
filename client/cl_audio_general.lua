local request_script_audio_bank = RequestScriptAudioBank
local has_sound_finished = HasSoundFinished
local stop_sound = StopSound
local cancel_music_event = CancelMusicEvent
local play_sound_frontend = PlaySoundFrontend

Citizen.CreateThread(
  function()
    Wait(0)
    SetAudioFlag("LoadMPData", true)
    request_script_audio_bank("DLC_BIKER/BKR_KQ_01", false)
    request_script_audio_bank("GTAO_FM_Events_Soundset", true)
    request_script_audio_bank("SCRIPT\\RAMPAGE_01", false);
    request_script_audio_bank("SCRIPT\\RAMPAGE_02", false);
    request_script_audio_bank("DLC_AWXM2018/AW_PTB_01", false);
    request_script_audio_bank("DLC_BIKER/BKR_DL_01", false);
    request_script_audio_bank("DLC_BIKER/BKR_DL_02", false);
  end
)

RegisterNetEvent("playSound")
AddEventHandler(
  "playSound",
  function(soundName, soundSet)
    if not has_sound_finished(-1) then
      stop_sound(-1)
    end

    cancel_music_event(soundName);
    play_sound_frontend(-1, soundName, soundSet, true)
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