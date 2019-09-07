Citizen.CreateThread(
    function()
        local appId = GetConvar("gg_discord_app_id", "")

        if(appId == "") then print("[Common] discord_app_id not set in server.cfg. Please report this to Administrators") return end

        SetDiscordAppId(appId)
        SetDiscordRichPresenceAsset("big")
        SetDiscordRichPresenceAssetText("Gun Game DM on FiveM. Play now!")

        print("[Common] Set Discord Rich Presence configuration. Updating every 10 seconds.")

        while true do
            local numPlayers = NetworkGetNumConnectedPlayers()
            local playerString = "Players"
            if (numPlayers == 1) then
                playerString = "Player"
            end

            SetRichPresence("" .. numPlayers .. "/32 " .. playerString .. "")
            Citizen.Wait(10000)
        end
    end
)
