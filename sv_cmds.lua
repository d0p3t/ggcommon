local lastReport = GetGameTimer()

RegisterCommand(
    "report",
    function(source, args, raw)
        local _source = source

        if (_source == 0 or args[1] == nil or GetGameTimer() - lastReport < 60000) then
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

        -- Screenshot(reporting)

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

        lastReport = GetGameTimer()
    end,
    false
)

RegisterCommand(
    "ban",
    function(source, args, raw)
        local _source = source
        if (args[2] == nil) then
            if (_source ~= 0) then
                TriggerClientEvent(
                    "chat:addMessage",
                    _source,
                    {args = {"BAN", "Did not specify netId and/or amount of days"}, color = {255, 0, 0}}
                )
            else
                print("[BAN COMMAND] Did not specify netId and/or amount of days.")
            end
            CancelEvent()
            return
        end

        local netId = args[1]
        local amountOfHours = tonumber(args[2])

        if (netId == nil or amountOfHours == nil) then
            if (_source ~= 0) then
                TriggerClientEvent("chat:addMessage", _source, {args = {"BAN", "Invalid input."}, color = {255, 0, 0}})
            else
                print("[BAN COMMAND] Invalid input.")
            end
            CancelEvent()
            return
        end

        local playerName = GetPlayerName(netId)

        if (playerName == nil) then
            if (_source ~= 0) then
                TriggerClientEvent(
                    "chat:addMessage",
                    _source,
                    {args = {"BAN", "Did not find player with netId " .. netId .. "."}, color = {255, 0, 0}}
                )
            else
                print("[BAN COMMAND] Did not find player with netId " .. netId .. ".")
            end
            CancelEvent()
            return
        end

        local index = 3
        local reason = ""
        while args[index] ~= nil do
            reason = reason .. args[index] .. " "
            index = index + 1
        end

        TriggerEvent("ggac:banMe", amountOfHours, reason, netId)
    end,
    true
)
