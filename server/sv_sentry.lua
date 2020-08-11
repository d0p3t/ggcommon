--
-- Sentry Issue Tracker
--
---
-- Based on sentryio-fivem and gmod-sentry
---
local function ISODate(time)
  return os.date("!%Y-%m-%dT%H:%M:%S", time)
end

local function getContexts()
  return {
    os = {
      name = Config.SentryOS,
      version = Config.SentryOSVersion
    },
    runtime = {
      name = "FXServer",
      version = Config.SentryVersion
    }
  }
end

local function getUserContext(source)
  if source == 0 or source == nil then
    return nil
  end

  local name = GetPlayerName(source)
  local endpoint = GetPlayerEndpoint(source)
  local identifiers = GetPlayerIdentifiers(source)
  local license = 0

  for i = 1, #identifiers do
    local v = identifiers[i]
    if string.sub(v, 1, string.len("license:")) == "license:" then
      license = v
      break
    end
  end

  return {
    id = license,
    username = name,
    ip_address = endpoint
  }
end

local function sentryAuthHeader()
  return "Sentry sentry_version=7,sentry_timestamp=" ..
    os.time() .. ",sentry_key=" .. Config.SentryPub .. ",sentry_secret=" .. Config.SentryPriv .. ",sentry_client=ggcommon/1.0"
end

local function getSDKData()
  return {
    ["name"] = "GGCommon.Sentry",
    ["version"] = "0.0.1"
  }
end

--
-- Setup Sentry
--
---
Citizen.CreateThread(
  function()
    Config.SentryPub = GetConvar("sentry_pub", "0")
    Config.SentryPriv = GetConvar("sentry_priv", "0")
    Config.SentryId = GetConvar("sentry_id", "0")
    Config.SentryEndpoint = GetConvar("sentry_ip", "127.0.0.1:30120")
    Config.SentryVersion = GetConvar("sentry_version", "v0000")
    Config.SentryOS = GetConvar("sentry_os", "Windows")
    Config.SentryOSVersion = GetConvar("sentry_os_version", "Unknown")
    Config.SentryRelease = GetConvar("sentry_release", "1.0.0")

    if (Config.SentryPub == "0" or Config.SentryPriv == "0" or Config.SentryId == "0") then
      PrintLog("[Common] Sentry not configured correctly. Please check ConVars.")
    else
      Config.SentryEnabled = true
    end
  end
)

--
--  Send Sentry issue
--
---
-- Send new issue to sentry
-- @param errorType Type of error e.g. "crash"
-- @param error Value for the error e.g. "blue-green-red" for crashes
-- @param level Severity of issue e.g. "warning", "error", "fatal"
-- @param tags Table of tags
-- @param source Player source if applicable
function SentryIssue(errorType, error, level, tags, source)
  if not Config.SentryEnabled then
    return
  end

  local data = {
    ["event_id"] = uuid(),
    ["timestamp"] = ISODate(os.time()),
    ["logger"] = "sentry",
    ["platform"] = "other",
    ["sdk"] = getSDKData(),
    ["exception"] = {
      ["type"] = errorType,
      ["value"] = error
    },
    ["user"] = getUserContext(source),
    ["contexts"] = getContexts(),
    ["tags"] = tags,
    ["release"] = Config.SentryRelease,
    ["environment"] = "production",
    ["level"] = level,
    ["server_name"] = Config.SentryEndpoint
  }

  local headers = {
    ["Content-Type"] = "application/json",
    ["User-Agent"] = "ggcommon/1.0",
    ["X-Sentry-Auth"] = sentryAuthHeader()
  }

  PerformHttpRequest(
    "https://sentry.d0p3t.nl/api/" .. Config.SentryId .. "/store/",
    function(statusCode, data, headers)
      if statusCode ~= 200 then
        PrintLog("" .. statusCode .. "Error occurred when sending Issue to Sentry -> " .. data .. "", "error")
      end
    end,
    "POST",
    json.encode(data),
    headers
  )
end
