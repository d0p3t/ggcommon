local set_rich_presence = SetRichPresence
local wait = Wait
local set_player_targeting_mode = SetPlayerTargetingMode

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
      set_rich_presence("" .. numPlayers .. "/64 Players")
      set_player_targeting_mode(2)
      wait(10000)
    end
  end
)
