local AvatarUrl = "https://pbs.twimg.com/profile_images/847824193899167744/J1Teh4Di_400x400.jpg" -- Replace this at some point

Config = {
  IsConfigured = false
}

Citizen.CreateThread(
  function()
    Config.WebhookUrl = GetConvar("gg_discord_webhook", "false")
    Config.ServerNumber = GetConvar("gg_server_number", "0")

    if (Config.WebhookUrl == "false" or Config.ServerNumber == "0") then
      PrintLog("[Common] Discord webhook URL or server number not set correctly. Skipping Discord logging.^7", "error")
    else
      PrintLog("[Common] Discord logging set up.^7", "info")
      Config.IsConfigured = true
    end
  end
)

function Log(title, message, toDiscord)
  if (toDiscord == true) then
    if (Config.IsConfigured == false) then
      return
    else
      local time = os.date("%d/%m/%Y %H:%M:%S")
      local embed = {
        {
          ["author"] = {
            name = "Gun Game",
            icon_url = "https://i.imgur.com/wwB6LyY.jpg"
          },
          ["color"] = 6908265,
          ["title"] = title,
          ["description"] = message,
          ["footer"] = {
            text =   "Server #" .. Config.ServerNumber .. " • Sent " .. time .. ""
          }
        }
      }
      PerformHttpRequest(
        Config.WebhookUrl,
        function(err, text, headers)
        end,
        "POST",
        json.encode({username = "GG Logger", embeds = embed, avatar_url = AvatarUrl}),
        {["Content-Type"] = "application/json"}
      )
    end
  end

  PrintLog("" .. title .. " " .. message)
end

function PrintLog(message, color)
  local time = os.date("%d/%m/%Y %H:%M:%S")
  if (not color) then
    color = ""
  elseif (color == "error") then
    color = "^1"
  elseif (color == "info") then
    color = "^2"
  else
    color = ""
  end
  print(color .. "[" .. time .. "] " .. message .. "^7")
end

AddEventHandler("playerDropped", function(reason)
  local _source = source
  local name =  GetPlayerName(_source)
  if reason ~= "Disconnected." and reason ~= "Reconnecting." and reason ~= "Quit." and reason ~= "Exiting" then
    Log("Game Crash by " .. name, reason, true)  
  end
end)