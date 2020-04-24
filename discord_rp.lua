Citizen.CreateThread(
    function()
        local appId = GetConvar("gg_discord_app_id", "")

        if(appId == "") then print("[Common] discord_app_id not set in server.cfg. Please report this to Administrators") return end

        SetDiscordAppId(appId)
        SetDiscordRichPresenceAsset("big")
        SetDiscordRichPresenceAssetText("Play Now! 64.190.90.120:30120")

        print("[Common] Set Discord Rich Presence configuration. Updating every 10 seconds.")

        while true do
            local numPlayers = #GetActivePlayers()
            local playerString = "Players"
            if (numPlayers == 1) then
                playerString = "Player"
            end

            SetRichPresence("" .. numPlayers .. "/32 " .. playerString .. "")
			N_0xc54a08c85ae4d410(1.0)
            Citizen.Wait(10000)
        end
    end
)
