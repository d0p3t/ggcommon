AddEventHandler(
    "ggcommon:ss",
    function(player)
        if (player == -1 or player == nil) then
            Log("Screenshot", "**Status:** Cancelled \n**Player:** " .. player .. "", true)
            CancelEvent()
            return
        end

        local identifiers = GetPlayerIdentifiers(player)
        local license = 0

        for i = 1, #identifiers do
            local v = identifiers[i]
            if string.sub(v, 1, string.len("license:")) == "license:" then
                license = string.sub(v, string.len("license:") + 1)
                break
            end
        end

        local name = "screenshots/ss-" .. license .. "-" .. os.time(os.date("!*t")) .. ".jpg"

        exports["screenshot-basic"]:requestClientScreenshot(
            player,
            {fileName = name},
            function(err, data)
                if err ~= false then
                    print("err", err)
                    Log(
                        "Screenshot",
                        "**Status:** Error \n**Player:** " .. license .. "\n**Filepath:** " .. name .. "\n**Error:** " .. err .. "",
                        true
                    )
                else
                    print("^3[Common] Saved screenshot of " .. license .. " to " .. name .. "^7")
                    Log("Screenshot", "**Status:** Saved \n**Player:** " .. license .. "\n**Filepath:** " .. name .. "", true)
                end
            end
        )
    end
)
