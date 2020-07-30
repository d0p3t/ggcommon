local AvatarUrl = "https://i.imgur.com/wwB6LyY.jpg"

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

function Log(title, message, toDiscord, screenshot)
  if (toDiscord == true) then
    if (Config.IsConfigured == false or Config.ServerNumber == "DEV") then
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
            text = "Server #" .. Config.ServerNumber .. " • Sent " .. time .. ""
          }
        }
      }

      if (screenshot ~= nil) then
        embed[1].image = {
          url = screenshot
        }
      end

      PerformHttpRequest(
        Config.WebhookUrl,
        function(err, text, headers)
        end,
        "POST",
        json.encode({username = "GG Logger", embeds = embed, avatar_url = AvatarUrl}),
        {["Content-Type"] = "application/json"}
      )
    end
  else
    PrintLog("" .. title .. " " .. message)
  end
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

function Screenshot(player)
  if (player == 0 or player == nil) then
    return
  end

  local identifiers = GetPlayerIdentifiers(player)
  local license = 0

  for i = 1, #identifiers do
    local v = identifiers[i]
    if string.sub(v, 1, string.len("license:")) == "license:" then
      license = v
      break
    end
  end

  local name = "screenshots/ss-" .. license .. "-" .. os.time(os.date("!*t")) .. ".jpg"

  exports["screenshot-basic"]:requestClientScreenshot(
    player,
    {fileName = name},
    function(err, data)
      if err ~= false then
        Log("Screenshot", "**Status:** Error \n**Player:** " .. license .. "\n**Filepath:** " .. name .. "\n**Error:** " .. err .. "", true)
      else
        Log(
          "Screenshot",
          "**Status:** Saved \n**Player:** " ..
            license .. "\n**Filepath:** " .. name .. "\n**URL:** https://gungame.store/screenshots/" .. name .. "",
          true,
          "https://gungame.store/screenshots/" .. name .. ""
        )
      end
    end
  )
end

RegisterCommand(
  "requestss",
  function(source, args, raw)
    if (args[1] == nil) then
      return
    end

    Screenshot(args[1])
  end,
  true
)

AddEventHandler(
  "playerDropped",
  function(reason)
    local _source = source
    local name = GetPlayerName(_source)
    if
      reason ~= "Disconnected." and reason ~= "Reconnecting" and reason ~= "Quit." and reason ~= "Exiting" and
        reason ~= "Connecting to another server." and
        reason ~= "Timed out after 60 seconds." and
        reason ~= "Game crashed: leopard-crazy-table (GTA5+7A6478)" and
        reason ~= "Le jeu a cessé de fonctionner : leopard-crazy-table (GTA5+7A6478)" and
        reason ~= "Game crashed: table-music-pip (GTA5+5FE118)" and
        reason ~= "Game crashed: red-low-lima (GTA5+7A6472)" and
        reason ~= "Game crashed: jersey-green-black (GTA5+1571F45)" and
        reason ~= "Game crashed: pip-yellow-mango (GTA5+8D5451)" and
        string.find(reason, "banned") == nil and
        string.find(reason, "kicked") == nil and
        string.find(reason, "Could not connect to session provider.") == nil and
        string.find(reason, "(GTA5+7A6478)") == nil and
        string.find(reason, "Failed to getinfo server after 3 attempts.") == nil and
        string.find(reason, "DLC count mismatch") == nil and
        string.find(reason, "Failed to connect") == nil
     then
      SentryIssue("gamecrash", reason, "warning", {}, _source)
    end
  end
)
