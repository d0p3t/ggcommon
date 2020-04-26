Citizen.CreateThread(
    function()
        local appId = GetConvar("gg_discord_app_id", "")

        if (appId == "") then
            print("[Common] discord_app_id not set in server.cfg. Please report this to Administrators")
            return
        end

        SetDiscordAppId(appId)
        SetDiscordRichPresenceAsset("big")
        SetDiscordRichPresenceAssetText("Play Now! 64.190.90.120:30120")

        while true do
            local numPlayers = #GetActivePlayers()
            SetRichPresence("" .. numPlayers .. "/32 Players")
            Citizen.Wait(10000)
        end
    end
)
