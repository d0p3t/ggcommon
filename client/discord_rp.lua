Citizen.CreateThread(
  function()
    local appId = GetConvar("gg_discord_app_id", "")

    if (appId == "") then
      print("[Common] discord_app_id not set in server.cfg. Please report this to Administrators")
      return
    end

    SetDiscordAppId(appId)
    SetDiscordRichPresenceAsset("big")
    SetDiscordRichPresenceAssetText("Play Now on FiveM!")

    while true do
      local numPlayers = #Cache.ActivePlayers
      SetRichPresence("" .. numPlayers .. "/64 Players")
      SetPlayerTargetingMode(2)
      Citizen.Wait(10000)
    end
  end
)
