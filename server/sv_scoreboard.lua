Scoreboard = {}

-- Format: { id, name, cash, kdRatio, kills, deaths }
local scoreboard = {}
local lastScoreboard = {}

-- Natives
local get_player_name = GetPlayerName
local get_player_identifiers = GetPlayerIdentifiers

local xpTable = {
  [0] = 1,
  [1] = 80,
  [2] = 323,
  [3] = 728,
  [4] = 1294,
  [5] = 2022,
  [6] = 2912,
  [7] = 3964,
  [8] = 5177,
  [9] = 6552,
  [10] = 8090,
  [11] = 9788,
  [12] = 11649,
  [13] = 13672,
  [14] = 15856,
  [15] = 18202,
  [16] = 20710,
  [17] = 23380,
  [18] = 26211,
  [19] = 29204,
  [20] = 32360,
  [21] = 35676,
  [22] = 39155,
  [23] = 42796,
  [24] = 46598,
  [25] = 50562,
  [26] = 54688,
  [27] = 58976,
  [28] = 63425,
  [29] = 68036,
  [30] = 72810,
  [31] = 77744,
  [32] = 82841,
  [33] = 88100,
  [34] = 93520,
  [35] = 99102,
  [36] = 104846,
  [37] = 110752,
  [38] = 116819,
  [39] = 123048,
  [40] = 129440,
  [41] = 135992,
  [42] = 142707,
  [43] = 149584,
  [44] = 156622,
  [45] = 163822,
  [46] = 171184,
  [47] = 178708,
  [48] = 186393,
  [49] = 194240,
  [50] = 202250,
  [51] = 210420,
  [52] = 218753,
  [53] = 227248,
  [54] = 235904,
  [55] = 244722,
  [56] = 253702,
  [57] = 262844,
  [58] = 272147,
  [59] = 281612,
  [60] = 291240,
  [61] = 301028,
  [62] = 310979,
  [63] = 321092,
  [64] = 331366,
  [65] = 341802,
  [66] = 352400,
  [67] = 363160,
  [68] = 374081,
  [69] = 385164,
  [70] = 396410,
  [71] = 407816,
  [72] = 419385,
  [73] = 431116,
  [74] = 443008,
  [75] = 455062,
  [76] = 467278,
  [77] = 479656,
  [78] = 492195,
  [79] = 504896,
  [80] = 517760,
  [81] = 530784,
  [82] = 543971,
  [83] = 557320,
  [84] = 570830,
  [85] = 584502,
  [86] = 598336,
  [87] = 612332,
  [88] = 626489,
  [89] = 640808,
  [90] = 655290,
  [91] = 669932,
  [92] = 684737,
  [93] = 699704,
  [94] = 714832,
  [95] = 730122,
  [96] = 745574,
  [97] = 761188,
  [98] = 776963,
  [99] = 792900,
  [100] = 809000,
  [101] = 825260,
  [102] = 841683,
  [103] = 858268,
  [104] = 875014,
  [105] = 891922,
  [106] = 908992,
  [107] = 926224,
  [108] = 943617,
  [109] = 961172,
  [110] = 978890,
  [111] = 996768,
  [112] = 1014809,
  [113] = 1033012,
  [114] = 1051376,
  [115] = 1069902,
  [116] = 1088590,
  [117] = 1107440,
  [118] = 1126451,
  [119] = 1145624,
  [120] = 1164960,
  [121] = 1184456,
  [122] = 1204115,
  [123] = 1223936,
  [124] = 1243918,
  [125] = 1264062,
  [126] = 1284368,
  [127] = 1304836,
  [128] = 1325465,
  [129] = 1346256,
  [130] = 1367210,
  [131] = 1388324,
  [132] = 1409601,
  [133] = 1431040,
  [134] = 1452640,
  [135] = 1474402,
  [136] = 1496326,
  [137] = 1518412,
  [138] = 1540659,
  [139] = 1563068,
  [140] = 1585640,
  [141] = 1608372,
  [142] = 1631267,
  [143] = 1654324,
  [144] = 1677542,
  [145] = 1700922,
  [146] = 1724464,
  [147] = 1748168,
  [148] = 1772033,
  [149] = 1796060,
  [150] = 1820250,
  [151] = 1844600,
  [152] = 1869113,
  [153] = 1893788,
  [154] = 1918624,
  [155] = 1943622,
  [156] = 1968782,
  [157] = 1994104,
  [158] = 2019587,
  [159] = 2045232,
  [160] = 2071040,
  [161] = 2097008,
  [162] = 2123139,
  [163] = 2149432,
  [164] = 2175886,
  [165] = 2202502,
  [166] = 2229280,
  [167] = 2256220,
  [168] = 2283321,
  [169] = 2310584,
  [170] = 2338010,
  [171] = 2365596,
  [172] = 2393345,
  [173] = 2421256,
  [174] = 2449328,
  [175] = 2477562,
  [176] = 2505958,
  [177] = 2534516,
  [178] = 2563235,
  [179] = 2592116,
  [180] = 2621160,
  [181] = 2650364,
  [182] = 2679731,
  [183] = 2709260,
  [184] = 2738950,
  [185] = 2768802,
  [186] = 2798816,
  [187] = 2828992,
  [188] = 2859329,
  [189] = 2889828,
  [190] = 2920490,
  [191] = 2951312,
  [192] = 2982297,
  [193] = 3013444,
  [194] = 3044752,
  [195] = 3076222,
  [196] = 3107854,
  [197] = 3139648,
  [198] = 3171603,
  [199] = 3203720,
  [200] = 3236000,
  [201] = 3268440,
  [202] = 3301043,
  [203] = 3333808,
  [204] = 3366734,
  [205] = 3399822,
  [206] = 3433072,
  [207] = 3466484,
  [208] = 3500057,
  [209] = 3533792,
  [210] = 3567690,
  [211] = 3601748,
  [212] = 3635969,
  [213] = 3670352,
  [214] = 3704896,
  [215] = 3739602,
  [216] = 3774470,
  [217] = 3809500,
  [218] = 3844691,
  [219] = 3880044,
  [220] = 3915560,
  [221] = 3951236,
  [222] = 3987075,
  [223] = 4023076,
  [224] = 4059238,
  [225] = 4095562,
  [226] = 4132048,
  [227] = 4168696,
  [228] = 4205505,
  [229] = 4242476,
  [230] = 4279610,
  [231] = 4316904,
  [232] = 4354361,
  [233] = 4391980,
  [234] = 4429760,
  [235] = 4467702,
  [236] = 4505806,
  [237] = 4544072,
  [238] = 4582499,
  [239] = 4621088,
  [240] = 4659840,
  [241] = 4698752,
  [242] = 4737827,
  [243] = 4777064,
  [244] = 4816462,
  [245] = 4856022,
  [246] = 4895744,
  [247] = 4935628,
  [248] = 4975673,
  [249] = 5015880,
  [250] = 5056250
}

local function sortScoreboard(l, r)
  if not l then
    return false
  end
  if not r then
    return true
  end

  -- if l.donator > r.donator then return true end
  -- if l.donator < r.donator then return false end

  --if l.prestige > r.prestige then return true end
  --if l.prestige < r.prestige then return false end

  if l.rank > r.rank then
    return true
  end
  if l.rank < r.rank then
    return false
  end

  -- if l.experience > r.experience then
  --     return true
  -- end
  -- if l.experience < r.experience then
  --     return false
  -- end

  -- if l.cash > r.cash then
  --     return true
  -- end
  -- if l.cash < r.cash then
  --     return false
  -- end

  if l.kills > r.kills then
    return true
  end
  if l.kills < r.kills then
    return false
  end

  if l.deaths > r.deaths then
    return false
  end
  if l.deaths < r.deaths then
    return true
  end

  if not l.kdRatio then
    return false
  end
  if not r.kdRatio then
    return true
  end

  if l.kdRatio > r.kdRatio then
    return true
  end
  if l.kdRatio < r.kdRatio then
    return false
  end

  if l.name and r.name then
    return l.name < r.name
  end

  return true
end

local function calculateKdRatio(kills, deaths)
  if kills + deaths < 50 then
    return nil
  else
    return kills / deaths
  end
end

local function updateScoreboard()
  local clientScoreboard = {}

  for _, player in pairs(scoreboard) do
    table.insert(clientScoreboard, player)
  end

  table.sort(clientScoreboard, sortScoreboard)

  local limitedScoreboard = {}
  local amount = 1
  for _, player in pairs(clientScoreboard) do
    if amount <= 32 then
      table.insert(limitedScoreboard, player);
    end
    amount = amount + 1
  end

  TriggerLatentClientEvent("gg:updateScoreboard", -1, 100, limitedScoreboard)
  -- TriggerClientEvent("gg:updateScoreboard", -1, clientScoreboard)
end

function Scoreboard.AddPlayer(player, playerStats)
  if not scoreboard[player] then
    local playerName = get_player_name(player)

    if not playerName then
      playerName = ""
    end
    scoreboard[player] = {
      id = player,
      --patreonTier = playerStats.PatreonTier,
      moderator = playerStats.Moderator,
      name = playerName,
      --cash = playerStats.Cash, -- TEMPORARILY DISABLE
      kdRatio = calculateKdRatio(playerStats.Kills, playerStats.Deaths),
      kills = playerStats.Kills,
      deaths = playerStats.Deaths,
      killstreak = 0,
      --experience = playerStats.Experience,
      rank = playerStats.Rank
      --prestige = playerStats.Prestige,
    }

  -- updateScoreboard()
  end
end

function Scoreboard.RemovePlayer(player)
  if scoreboard[player] then
    scoreboard[player] = nil
  -- updateScoreboard()
  end
end

function Scoreboard.GetPlayersCount()
  return table.length(scoreboard)
end

function Scoreboard.IsPlayerOnline(player)
  return scoreboard[player]
end

function Scoreboard.GetPlayerIdentifier(player)
  return table.find_if(
    get_player_identifiers(player),
    function(id)
      return string.find(id, "license")
    end
  )
end

function Scoreboard.GetRandomPlayer()
  return table.random(scoreboard).id
end

function Scoreboard.IsPlayerModerator(player)
  return scoreboard[player].moderator
end

function Scoreboard.GetPlayerModeratorLevel(player)
  return scoreboard[player].moderator
end

-- function Scoreboard.GetPatreonTier(player)
-- 	return scoreboard[player].patreonTier
-- end

function Scoreboard.GetPlayerCash(player)
  return scoreboard[player].cash
end

function Scoreboard.GetPlayerRank(player)
  return scoreboard[player].rank
end

-- function Scoreboard.GetPlayerPrestige(player)
-- 	return scoreboard[player].prestige
-- end

function Scoreboard.GetPlayerKillstreak(player)
  return scoreboard[player].killstreak
end

function Scoreboard.GetPlayerKills(player)
  return scoreboard[player].kills
end

function Scoreboard.UpdateCash(player, cash)
  scoreboard[player].cash = scoreboard[player].cash + cash
  -- updateScoreboard()
end

function Scoreboard.UpdateExperience(player, experience)
  scoreboard[player].experience = scoreboard[player].experience + experience
  if Rank.CalculateRank(scoreboard[player].experience) > scoreboard[player].rank then
    local rank = scoreboard[player].rank + 1
    scoreboard[player].rank = rank
  --TriggerClientEvent('lsv:playerRankedUp', player, rank, Stat.CalculateStats(rank))
  --Crate.TrySpawn(player)
  -- updateScoreboard()
  end
end

function Scoreboard.UpdateKills(player)
  if scoreboard[player] then
    scoreboard[player].kills = scoreboard[player].kills + 1
    scoreboard[player].kdRatio = calculateKdRatio(scoreboard[player].kills, scoreboard[player].deaths)
    scoreboard[player].killstreak = scoreboard[player].killstreak + 1

  -- updateScoreboard()
  end
end

function Scoreboard.UpdateDeaths(player)
  if scoreboard[player] then
    scoreboard[player].deaths = scoreboard[player].deaths + 1
    scoreboard[player].kdRatio = calculateKdRatio(scoreboard[player].kills, scoreboard[player].deaths)
    scoreboard[player].killstreak = 0

  -- updateScoreboard()
  end
end

AddEventHandler(
  "ggcommon:scoreboardUpdate",
  function(player, kills, deaths, killstreak, xp, cash)
    if scoreboard[player] then
      scoreboard[player].kills = kills
      scoreboard[player].deaths = deaths
      scoreboard[player].kdRatio = calculateKdRatio(scoreboard[player].kills, scoreboard[player].deaths)
      scoreboard[player].killstreak = killstreak
    --scoreboard[player].experience = xp
    --scoreboard[player].cash = cash
    end
  end
)

local function calculateRank(xp)
  local rank = 0

  if xp < xpTable[0] then
    return rank
  end

  for level, xpRequired in pairs(xpTable) do
    if not xpTable[level + 1] then
      rank = level
      break
    end

    if xp > xpRequired and xp < xpTable[level + 1] then
      rank = level
      break
    end
  end

  return rank
end

AddEventHandler(
  "ggcommon:scoreboardUpdateAll",
  function(serialized)
    local data = json.decode(serialized)

    for _, user in pairs(data) do
      if not scoreboard[user.netId] then
        scoreboard[user.netId] = {
          id = user.netId,
          moderator = user.moderator,
          donator = user.donator,
          name = get_player_name(user.netId),
          --cash = user.money,
          kdRatio = calculateKdRatio(user.kills, user.deaths),
          kills = user.kills,
          deaths = user.deaths,
          killstreak = user.killstreak,
          --experience = user.xp,
          rank = calculateRank(user.xp)
        }
      else
        --scoreboard[user.netId].cash = user.money
        scoreboard[user.netId].kdRatio = calculateKdRatio(user.kills, user.deaths)
        scoreboard[user.netId].kills = user.kills
        scoreboard[user.netId].deaths = user.deaths
        scoreboard[user.netId].killstreak = user.killstreak
        --scoreboard[user.netId].experience = user.xp
        scoreboard[user.netId].rank = calculateRank(user.xp)
      end
    end
  end
)

Citizen.CreateThread(
  function()
    while true do
      Wait(10000)
      updateScoreboard()
    end
  end
)

AddEventHandler(
  "playerDropped",
  function()
    scoreboard[source] = nil
  end
)
