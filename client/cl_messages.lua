local firstSpawn = true

local periodicMessages = {
    "See a cheater? 🤬 Report them with ^1/report [id] [reason]^7",
    "See a cheater? 🤬 Report them with ^1/report [id] [reason]^7",
    "See a cheater? 🤬 Report them with ^1/report [id] [reason]^7",
    "Increase your weapon level by getting kills 🔫",
    "Respawn faster by clicking your mouse 🖱️",
    "🎮 Join our Discord ^2https://discord.gg/r5q7MHQ^7",
    "🐓 Winner, winner, chicken dinner! Or not...",
    "Don't give up! Practice makes perfect 💪",
    "Found a bug? 🐛 Report it on our Discord",
    "📜 Hold ^1Z^7 to bring up the scoreboard",
    "Check if a player dies before accussing them of cheating.",
    "Always treat people the way you want to be treated ❣️",
    "You win some, you lose... a lot 😥",
    "🛒 Want to support us? ^2https://beta.gungame.store^7",
    "Did you spawn under the map or inside a wall? ^1/die^7 to respawn",
    "Gain XP by killing other players 🔫",
    "You cannot choose weapons. Progress by getting kills 🔫",
    "🙏 Support & Donate on ^2https://beta.gungame.store^7",
    "👑 Get EXCLUSIVE OUTFITS! ^2https://beta.gungame.store^7",
    "Our other servers #2 (EU) and #3 (USA) are on the server list",
    "👕 Outfits Shop - Press HOME or ^2/shop^7 for FREE outfits",
    "You can spend your 💰 money in our 👕 Shop! Press ^2HOME^7",
    "👕 Get new outfits at certain levels in our shop",
    "👕 Spend your $ in our shop - Press HOME or ^2/shop^7 to open",
    "🛒 Get XP, Exclusive outfits and more at ^2https://beta.gungame.store^7!",
    "🛒 Queue passes for as low as $2.00 ^2https://beta.gungame.store^7"
}

local interval = 5
local lastMessage = ""

RegisterNetEvent("spawn")
AddEventHandler(
    "spawn",
    function()
        if firstSpawn then
            local welcomeMessages = {
                "👑 Welcome to Gun Game V, ^7" .. GetPlayerName(PlayerId()) .. "!",
                "🛒 Store - ^2https://beta.gungame.store^7",
                "🎮 Discord - ^2https://discord.gg/r5q7MHQ^7",
                "🧡 Servers - #1 (EU) #2 (EU) #3 (USA)",
                "👕 Outfits - ^7Press ^2HOME^7 or type ^2/shop^7"
            }

            for i = 1, #welcomeMessages do
                local message = welcomeMessages[i]
                TriggerEvent(
                    "chat:addMessage",
                    {
                        templateId = "welcome",
                        color = {255, 255, 255},
                        multiline = true,
                        args = {message, ""}
                    }
                )
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Wait(60000 * interval)
            local periodicMessage = ""
            local index = math.random(#periodicMessages)
            periodicMessage = periodicMessages[index]

            if periodicMessage and periodicMessage ~= "" then
                TriggerEvent(
                    "chat:addMessage",
                    {
                        templateId = "periodic",
                        color = {255, 255, 255},
                        multiline = true,
                        args = {periodicMessage, ""}
                    }
                )
            end
            lastMessage = periodicMessage
        end
    end
)

RegisterCommand(
    "discord",
    function()
        TriggerEvent(
            "chat:addMessage",
            {
                templateId = "help",
                color = {255, 255, 255},
                multiline = true,
                args = {"🎮 Discord - ^2https://discord.gg/r5q7MHQ^r^7", ""}
            }
        )
    end,
    false
)

RegisterCommand(
    "donate",
    function()
        TriggerEvent(
            "chat:addMessage",
            {
                templateId = "help",
                color = {255, 255, 255},
                multiline = true,
                args = {"🙏 Keep the server running - ^2https://beta.gungame.store^r^7", ""}
            }
        )
    end,
    false
)
