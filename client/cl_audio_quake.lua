local pack = "male"
local enabled = false

local validTypes = {
    ["triple"] = 3,
    ["hattrick"] = 3,
    ["multi"] = 5,
    ["spree"] = 5,
    ["rampage"] = 6,
    ["mega"] = 7,
    ["monster"] = 7,
    ["unstoppable"] = 8,
    ["holy"] = 10,
    ["godlike"] = 10,
    ["ludicrous"] = 11,
    ["wickedsick"] = 11
}

local network_is_session_started = NetworkIsSessionStarted

Citizen.CreateThread(
    function()
        while not network_is_session_started() do
            Wait(100)
        end

        enabled = GetResourceKvpInt("ggquakepack")
        if enabled == nil then
            enabled = false
        end
        pack = GetResourceKvpString("ggquakepacktype")
        if pack == nil or pack == "" then
            pack = "male"
        end
    end
)

RegisterCommand(
    "quake",
    function(source, args, rawCommand)
        if args[1] ~= nil then
            if args[1] == "female" or args[1] == "male" then
                pack = args[1]
                SetResourceKvpInt("ggquakepack", true)
                SetResourceKvp("ggquakepacktype", pack)
                enabled = true
                SendChatMessage("Success", "Enabled quake sounds and set audio pack to " .. args[1], {120, 190, 32})
                SendNuiMessage(
                    json.encode(
                        {
                            type = "ggsound",
                            transactionPack = "default",
                            transactionFile = "smb3_powerup"
                        }
                    )
                )
            else
                SendChatMessage("Error", "Audio pack must be 'male' or 'female'", {255, 0, 0})
            end
        else
            enabled = not enabled
            SetResourceKvpInt("ggquakepack", enabled)

            local set = "Disabled"
            if enabled then
                set = "Enabled"
                SendNuiMessage(
                    json.encode(
                        {
                            type = "ggsound",
                            transactionPack = "default",
                            transactionFile = "smb3_powerup"
                        }
                    )
                )
            end
            SendChatMessage("Success", set .. " quake sounds", {120, 190, 32})
        end
    end,
    false
)

Citizen.CreateThread(
    function()
        TriggerEvent(
            "chat:addSuggestion",
            "/quake",
            "Toggle quake sounds for killstreaks.",
            {
                {name = "pack", help = "(Optional) Set audio pack, 'male' or 'female'. Default: 'female'"}
            }
        )
    end
)

RegisterNetEvent("ggcommon:quake")
AddEventHandler(
    "ggcommon:quake",
    function(streak)
        if not enabled then
            return
        end

        local validAudio =
            table.filter(
            validTypes,
            function(amount)
                return amount == streak
            end
        )

        if table.length(validAudio) ~= 0 then
            local selectedStreak, selectedFile = table.random(validAudio)
            SendNuiMessage(
                json.encode(
                    {
                        type = "ggsound",
                        transactionPack = pack,
                        transactionFile = selectedFile
                    }
                )
            )
        end
    end
)
