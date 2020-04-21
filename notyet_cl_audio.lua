local pack = "female"

RegisterNetEvent("ggcommon:setPack")
AddEventHandler(
    "ggcommon:setPack",
    function(type)
        if not type or type ~= "male" or type ~= "female" then
            print("[Audio] Invalid Audio pack!")
        else
            pack = type
        end
    end
)

local validTypes = {
    ["triple"] = 3,
    ["hattrick"] = 3,
    ["multi"] = 5,
    ["spree"] = 5,
    ["rampage"] = 6,
    ["mega"] = 7,
    ["monster"] = 7,
    ['unstoppable'] = 8,
    ["holy"] = 10,
    ["godlike"] = 10,
    ["ludicrous"] = 11,
    ["wickedsick"] = 11,
}

RegisterNetEvent("ggcommon:quake")
AddEventHandler(
    "ggcommon:quake",
    function(streak)
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
                json.encode({
                    type = "ggsound",
                    transactionPack = pack,
                    transactionFile = selectedFile
                })
            )

        end
    end
)

-- Citizen.CreateThread(function()
--     local count = 3
--     while true do
--         print('playing streak ' .. count .. '')
--         TriggerEvent("ggcommon:quake", count)
--         count = count + 1
--         if count > 11 then count = 3 end
--         Citizen.Wait(5000)
--     end
-- end)