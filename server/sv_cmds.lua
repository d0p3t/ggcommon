local recentReports = {}

RegisterCommand(
    "report",
    function(source, args, raw)
        local _source = source

        if recentReports[_source] ~= nil then
            local now = GetGameTimer()
            local since = (now - recentReports[_source]) / 1000.0

            if since < 60 then
                TriggerClientEvent(
                    "chat:addMessage",
                    _source,
                    {args = {"REPORT", "You cannot report for another " .. since .. " seconds."}, color = {255, 0, 0}}
                )
                CancelEvent()
                return
            end

            recentReports[_source] = nil -- Reset the cooldown
        end

        if (_source == 0 or args[1] == nil) then
            TriggerClientEvent("chat:addMessage", _source, {args = {"REPORT", "You did not specify a Player ID."}, color = {255, 0, 0}})
            CancelEvent()
            return
        end

        local reporting = args[1]
        local reportingName = GetPlayerName(args[1])

        if (reporting == nil or reportingName == nil) then
            TriggerClientEvent(
                "chat:addMessage",
                _source,
                {args = {"REPORT", "Invalid Player ID. Check scoreboard (Press + Hold Z)."}, color = {255, 0, 0}}
            )
            CancelEvent()
            return
        end

        local reason = ""

        table.remove(args, 1)

        if (args[1] ~= nil) then
            reason = table.concat(args, " ")
        end

        local reportedBy = GetPlayerName(_source)

        local steam = ""
        local license = ""
        local discord = ""
        local xbl = ""
        local live = ""
        local fivem = ""

        local identifiers = GetPlayerIdentifiers(reporting)
        for i = 1, #identifiers do
            local v = identifiers[i]
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
                                                                live .. "\n**Discord:** " .. discord .. "\n**FiveM:** " .. fivem .. "",
            true
        )

        TriggerClientEvent("chat:addMessage", _source, {args = {"REPORT", "Your report has been received."}, color = {255, 0, 0}})

        recentReports[_source] = GetGameTimer()
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

        local bannedBy = "console"
        if source ~= 0 then
            bannedBy = "Moderator " .. GetPlayerName(_source)
        end

        TriggerEvent("ggac:banMe", amountOfHours, reason, netId, nil, bannedBy)
    end,
    true
)

RegisterCommand(
    "kick",
    function(source, args, raw)
        local _source = source

        if (args[2] == nil) then
            if (_source ~= 0) then
                TriggerClientEvent("chat:addMessage", _source, {args = {"KICK", "Did not specify netId or a reason"}, color = {255, 0, 0}})
            else
                print("[KICK COMMAND] Did not specify netId or a reason.")
            end
            CancelEvent()
            return
        end

        local netId = args[1]
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

        local index = 2
        local reason = ""
        while args[index] ~= nil do
            reason = reason .. args[index] .. " "
            index = index + 1
        end

        local kickedBy = "console"
        if source ~= 0 then
            kickedBy = "Moderator " .. GetPlayerName(_source)
        end

        local steam = ""
        local license = ""
        local discord = ""
        local xbl = ""
        local live = ""
        local fivem = ""

        local identifiers = GetPlayerIdentifiers(netId)
        for i = 1, #identifiers do
            local v = identifiers[i]
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
            "Player Kicked",
            "\n**Name:** " ..
                playerName ..
                    "\n**By:** " ..
                        kickedBy ..
                            "\n**Reason:** " ..
                                reason ..
                                    "\n**License:** " ..
                                        license ..
                                            "\n**Steam:**" ..
                                                steam ..
                                                    "\n**XBL:** " ..
                                                        xbl ..
                                                            "\n**Live:** " ..
                                                                live .. "\n**Discord:** " .. discord .. "\n**FiveM:** " .. fivem .. "",
            true
        )

        DropPlayer(netId, reason)
    end,
    true
)

AddEventHandler(
    "playerDropped",
    function()
        recentReports[source] = nil
    end
)

RegisterCommand(
    "players",
    function()
        local players = GetPlayers()
        if #players > 0 then
            print("^3-------------------------")
            print("------ PLAYER LIST ------")
            print("-------------------------\n")

            for i = 1, #players do
                local player = players[i]
                print("[ID " .. player .. "] [NAME " .. GetPlayerName(player) .. "]\n")
            end
            print("-----------END-----------^7")
        else
            print("[[---- NO PLAYERS ----]]")
        end
    end,
    true
)
