--
-- Sentry Issue Tracker
--
---

local hextable = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f'}

local function RandomHex(length)
  local s = ""
  for i = 1, length do
    math.randomseed(os.clock()^5)
    s = s..hextable[math.random(1,16)]
  end
  return s
end

local function GenerateUUID()
  return string.format("%s6%s2%s%s", RandomHex(10), RandomHex(5), RandomHex(2), RandomHex(13))
end

local function ISODate(time)
	return os.date("!%Y-%m-%dT%H:%M:%S", time);
end

--
-- Setup Sentry
--
---
Citizen.CreateThread(function()
  Config.SentryPub = GetConvar("sentry_pub", "0")
  Config.SentryPriv = GetConvar("sentry_priv", "0")
  Config.SentryId = GetConvar("sentry_id", "0")
  Config.SentryEndpoint = GetConvar("sentry_ip", "127.0.0.1:30120")
  Config.SentryVersion = GetConvar("sentry_version", "v0000")
  Config.SentryOS = GetConvar("sentry_os", "Windows")

  if(Config.SentryPub == "0" or Config.SentryPriv == "0" or Config.SentryId == "0") then
    PrintLog("[Common] Sentry not configured correctly. Please check ConVars.")
    Config.SentryEnabled = true
  end
end)

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
  if not Config.SentryEnabled then return end

  local data = {
    ["event_id"] = GenerateUUID(),
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
    ["release"] = "v1",
    ["environment"] = "production",
    ["level"] = level,
    ["server_name"] = Config.SentryEndpoint
  }


  local headers = {
    ["Content-Type"] = 'application/json',
    ["User-Agent"] = 'ggcommon/1.0',
    ["X-Sentry-Auth"] = sentryAuthHeader()
  }

  PerformHttpRequest("https://sentry.io/api/" .. Config.SentryId .. "/store/", function(statusCode, data, headers)
    if statusCode ~= 200 then
      PrintLog("" .. statusCode .. "Error occurred when sending Issue to Sentry -> " .. data .. "", "error")
    end
  end, "POST", json.encode(data), headers)
end

local function getContexts()
	return {
		os = {
			name = Config.SentryOS,
		},
		runtime = {
			name = "FXServer",
			version = Config.SentryVersion,
		}
	}
end

local function getUserContext(source)
  if source == 0 or source == nil then return nil end

  local name = GetPlayerName(source)
  local endpoint = GetPlayerEndpoint(source)
  local identifiers = GetPlayerIdentifiers(source)
  local license = 0

  for k, v in pairs(identifiers) do
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
 return "Sentry sentry_version=7,sentry_timestamp="..os.time()..",sentry_key="..Config.SentryPub..",sentry_secret="..Config.SentryPriv..",sentry_client=ggcommon/1.0"
end

local function getSDKData()
  return {
    ["name"] = "GGCommon.Sentry",
    ["version"] = "0.0.1"
  }
end