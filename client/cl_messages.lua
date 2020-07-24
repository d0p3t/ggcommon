Citizen.CreateThread(
  function()
    Wait(5000)

    local welcomeMessages = {
      "👑 Welcome to Gun Game V, ^7" .. GetPlayerName(PlayerId()) .. "!",
      "🙏 Donations - https://donate.gungame.store",
      "💬 Discord - https://discord.gungame.store or Invite Code r5q7MHQ",
      "🧡 Servers - We have servers in EU, Brazil and USA",
      "👕 Outfits - ^7Type ^2/claim^7 for FREE outfits and ^2/outfits^7 to list"
    }

    for i = 1, #welcomeMessages do
      local message = welcomeMessages[i]
      TriggerEvent(
        "chat:addMessage",
        {
          color = {197, 179, 88},
          multiline = true,
          args = {message, ""}
        }
      )
    end
  end
)

local periodicMessages = {
  "🤬 See a cheater? Report them with /report [id] [reason]",
  "🤬 See a cheater? Report them with /report [id] [reason]",
  "🤬 See a cheater? Report them with /report [id] [reason]",
  "🤬 See a cheater? Report them with /report [id] [reason]",
  "🤬 See a cheater? Report them with /report [id] [reason]",
  "Increase your weapon level by getting kills 🔫",
  "Respawn faster using your 🖱️",
  "🎮 Join our Discord https://discord.gungame.store or Invite Code r5q7MHQ",
  "Got any suggestions? Leave them on our Discord",
  "🐓 Winner, winner, chicken dinner! Or not...",
  "Don't give up 🤬",
  "🐞 Found a bug? Report it on our Discord",
  "📜 Hold Z to bring up the scoreboard",
  "Check if a player dies before accussing them of cheating.",
  "Always treat people the way you want to be treated ❣️",
  "You win some, you lose... a lot 😥",
  "🙏 Want to support us? Donate on https://donate.gungame.store",
  "Did you spawn under the map or inside a wall? /suicide to respawn",
  "Gain XP by killing other players 🔫",
  "You cannot choose weapons. Progress by getting kills 🔫",
  "🙏 Support & Donate on https://donate.gungame.store",
  "🙏 Want lower pings? Donate so we can open up new servers https://donate.gungame.store",
  "🙏 Donate and get an 👑 EXCLUSIVE HALO OUTFIT 👑! https://donate.gungame.store",
  "🧡 Look for our other servers in EU, Brazil or USA on the server list",
  "👕 Outfits - Type /claim for FREE outfits and /outfits to list",
  "👕 Outfits - Type /claim for FREE outfits and /outfits to list",
  "👕 Outfits - Type /claim for FREE outfits and /outfits to list",
  "You cannot spend your 💰 money yet, but you can /claim free 👕 outfits!",
  "👕 Did you lose your outfits? Claim them with /claim",
  "👕 Did you lose your outfits? Claim them with /claim",
  "👕 Get new outfits at level 10, 25, 50, 75, 100, 150 with /claim"
}

local interval = 5
local lastMessage = ""

Citizen.CreateThread(
  function()
    while true do
      Wait(60000 * interval)
      local periodicMessage = ""
      while periodicMessage == lastMessage do
        periodicMessage = periodicMessages[math.random(#periodicMessages)]
      end
      TriggerEvent(
        "chat:addMessage",
        {
          color = {197, 179, 88},
          multiline = true,
          args = {periodicMessage, ""}
        }
      )
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
        color = {255, 0, 0},
        multiline = true,
        args = {"💬 Discord - https://discord.d0p3t.nl or Invite Code r5q7MHQ", ""}
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
        color = {255, 0, 0},
        multiline = true,
        args = {"🙏 Donate - Keep the server running by donating to https://donorbox.org/gun-game", ""}
      }
    )
  end,
  false
)
