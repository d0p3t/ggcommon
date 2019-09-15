AddEventHandler(
    "onServerResourceStart",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end

        -- TriggerEvent("ggcommon:ss", GetPlayers()[1])
        -- Log("Test title", "Test message")
    end
)

RegisterCommand(
    "report",
    function(source, args, raw)
        local _source = source

        if (_source == 0 or args[1] == nil) then
            CancelEvent()
            return
        end

        local reporting = args[1]
        local reportingName = GetPlayerName(args[1])

        if (reporting == nil or reportingName == nil) then
            TriggerClientEvent(
                "chat:addMessage",
                _source,
                {args = {"REPORT", "Invalid Player ID. Make sure it's correct (Press + Hold Z)"}, color = {255, 0, 0}}
            )
            CancelEvent()
            return
        end

        local reason = ""

        table.remove(args, 1)

        if (args[1] ~= nil) then
            reason = table.concat(args)
        end

        local reportedBy = GetPlayerName(_source)

        local steam = ""
        local license = ""
        local discord = ""
        local xbl = ""
        local live = ""
        local fivem = ""

        for k, v in pairs(GetPlayerIdentifiers(reporting)) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steam = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                xbl = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                live = v
            elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
                fivem = v
            end
        end

        Log(
            "Player Report",
            "**Reported by:** " ..
                reportedBy ..
                    "\n**Reporting:** " ..
                        reportingName ..
                            "\n**Reason:** " ..
                                reason ..
                                    "\n**License:** " ..
                                        license ..
                                            "\n**Steam:**" ..
                                                steam ..
                                                    "\n**XBL:** " ..
                                                        xbl ..
                                                            "\n**Live:** " ..
                                                                live ..
                                                                    "\n**Discord:** " ..
                                                                        discord .. "\n**FiveM:** " .. fivem .. "",
            true
        )

        TriggerClientEvent(
            "chat:addMessage",
            _source,
            {args = {"REPORT", "Staff will handle your report."}, color = {255, 0, 0}}
        )
    end,
    false
)
