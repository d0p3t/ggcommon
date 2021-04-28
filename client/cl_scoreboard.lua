Scoreboard = {}

local scoreboard = {}

local get_player_server_id = GetPlayerServerId
local get_player_from_server_id = GetPlayerFromServerId
local network_is_player_talking = NetworkIsPlayerTalking
local draw_sprite = DrawSprite
local string_format = string.format

function Scoreboard.GetPlayer(playerId)
    local serverId = get_player_server_id(playerId)
    local player =
        table.find_if(
        scoreboard,
        function(player)
            return player.id == serverId
        end
    )
    return player or nil
end

-- function Scoreboard.GetPlayerPatreonTier(playerId)
-- 	local serverId = GetPlayerServerId(playerId)
-- 	local player = table.find_if(scoreboard, function(player) return player.id == serverId end)
-- 	return player and player.patreonTier or nil
-- end

function Scoreboard.GetPlayerRank(playerId)
    local serverId = get_player_server_id(playerId)
    local player =
        table.find_if(
        scoreboard,
        function(player)
            return player.id == serverId
        end
    )
    return player and player.rank or nil
end

-- function Scoreboard.GetPlayerPrestige(playerId)
-- 	local serverId = GetPlayerServerId(playerId)
-- 	local player = table.find_if(scoreboard, function(player) return player.id == serverId end)
-- 	return player and player.prestige or nil
-- end

function Scoreboard.GetPlayerKillstreak(playerId)
    local serverId = get_player_server_id(playerId)
    local player =
        table.find_if(
        scoreboard,
        function(player)
            return player.id == serverId
        end
    )
    return player and player.killstreak or nil
end

-- Sizes
local headerTableSpacing = 0.0075

local tableSpacing = 0.001875
local tableHeight = 0.02625
local tablePositionWidth = 0.13125
local tableCashWidth = 0.075
local tableKdRatioWidth = 0.075
local tableKillsWidth = 0.075
local tableDeathsWidth = 0.075
local tableKillstreakWidth = 0.075
local tableTextHorizontalMargin = 0.00225
local tableTextVerticalMargin = 0.00245
local playerStatusWidth = 0.00225
local rankWidth = 0.0175
local rankHeight = 0.0325

local voiceIndicatorWidth = 0.004
local playerNameMargin = 0.006
local enableVoiceChat = true
if enableVoiceChat then
    voiceIndicatorWidth = 0.01
    playerNameMargin = 0.0125
end

local tableWidth =
    tablePositionWidth + tableCashWidth + tableKdRatioWidth + tableKillsWidth + tableDeathsWidth + tableKillstreakWidth

local headerScale = 0.2625
local positionScale = 0.375
local rankScale = 0.325
local cashScale = 0.2625
local kdRatioScale = 0.2625
local killsScale = 0.2625
local deathsScale = 0.2625
local killstreakScale = 0.2625

-- Colors
-- local tableHeaderColor = {["r"] = 131, ["g"] = 123, ["b"] = 99, ["a"] = 255}
local tableHeaderColor = {["r"] = 93, ["g"] = 64, ["b"] = 55, ["a"] = 255}

local tableHeaderTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

local tablePositionTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

local tableCashColor = {["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 180}
local tableCashTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

local tableKdRatioColor = {["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 180}
local tableKdRatioTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

local tableKillsColor = {["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 180}
local tableKillsTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

local tableDeathsColor = {["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 180}
local tableDeathsTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

local tableKillstreakColor = {["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 180}
local tableKillstreakTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

local activeVoiceIndicatorColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}
local inactiveVoiceIndicatorColor = {["r"] = 10, ["g"] = 10, ["b"] = 10, ["a"] = 255}

local prestigeColor = {["r"] = 240, ["g"] = 200, ["b"] = 80, ["a"] = 255}
local maxPrestigeColor = {["r"] = 224, ["g"] = 50, ["b"] = 50, ["a"] = 255}
-- local prestigeBlendColor = {
-- 	['r'] = math.floor((maxPrestigeColor.r - prestigeColor.r) / Settings.maxPrestige),
-- 	['g'] = math.floor((maxPrestigeColor.g - prestigeColor.g) / Settings.maxPrestige),
-- 	['b'] = math.floor((maxPrestigeColor.b - prestigeColor.b) / Settings.maxPrestige),
-- 	['a'] = 255,
-- }

local rankColor = {["r"] = 44, ["g"] = 109, ["b"] = 184, ["a"] = 255}
local rankTextColor = {["r"] = 255, ["g"] = 255, ["b"] = 255, ["a"] = 255}

RegisterNetEvent("gg:updateScoreboard")
AddEventHandler(
    "gg:updateScoreboard",
    function(serverScoreboard)
        scoreboard =
            table.filter(
            serverScoreboard,
            function(player)
                local id = get_player_from_server_id(player.id)
                return id == PlayerId() or NetworkIsPlayerActive(id)
            end
        )
    end
)

AddEventHandler(
    "onClientResourceStart",
    function(resource)
        if GetCurrentResourceName() ~= resource then
            return
        end

        AddTextEntry("MONEY_ENTRY", "$~1~")

        Streaming.RequestStreamedTextureDict("mpleaderboard")
        Streaming.RequestStreamedTextureDict("mprankbadge")
    end
)

function Scoreboard.DisplayThisFrame()
    local scoreboardPosition = {["x"] = (1.0 - tableWidth) / 2, ["y"] = SafeZone.Top()}

    local tableHeader = {["y"] = scoreboardPosition.y + tableHeight / 2}
    local tableHeaderText = {["y"] = tableHeader.y - tableHeight / 2 + tableTextVerticalMargin}

    local tablePositionHeader = {["x"] = scoreboardPosition.x + tablePositionWidth / 2, ["y"] = tableHeader.y}
    --local tableCashHeader = { ['x'] = tablePositionHeader.x + tablePositionWidth / 2 + tableCashWidth / 2 , ['y'] = tableHeader.y }
    --local tableKdRatioHeader = { ['x'] = tableCashHeader.x + tableCashWidth / 2 + tableKdRatioWidth / 2 , ['y'] = tableHeader.y }
    local tableKdRatioHeader = {
        ["x"] = tablePositionHeader.x + tablePositionWidth / 2 + tableCashWidth / 2,
        ["y"] = tableHeader.y
    }
    local tableKillsHeader = {
        ["x"] = tableKdRatioHeader.x + tableKdRatioWidth / 2 + tableKillsWidth / 2,
        ["y"] = tableHeader.y
    }
    local tableDeathsHeader = {
        ["x"] = tableKillsHeader.x + tableKillsWidth / 2 + tableDeathsWidth / 2,
        ["y"] = tableHeader.y
    }
    local tableKillstreakHeader = {
        ["x"] = tableDeathsHeader.x + tableDeathsWidth / 2 + tableKillstreakWidth / 2,
        ["y"] = tableHeader.y
    }

    -- Draw 'POSITION' header
    Gui.DrawRect(tablePositionHeader, tablePositionWidth, tableHeight, tableHeaderColor)
    Gui.SetTextParams(0, tableHeaderTextColor, headerScale, false, false, true)
    Gui.DrawText("PLAYER", {["x"] = tablePositionHeader.x, ["y"] = tableHeaderText.y})

    -- Draw 'CASH' header -- TEMPORARILY DISABLED
    -- Gui.DrawRect(tableCashHeader, tableCashWidth, tableHeight, tableHeaderColor)
    -- Gui.SetTextParams(0, tableHeaderTextColor, headerScale, false, false, true)
    -- Gui.DrawText('MONEY', { ['x'] = tableCashHeader.x, ['y'] = tableHeaderText.y })

    -- Draw 'KILLSTREAK' header
    Gui.DrawRect(tableKdRatioHeader, tableKdRatioWidth, tableHeight, tableHeaderColor)
    Gui.SetTextParams(0, tableHeaderTextColor, headerScale, false, false, true)
    Gui.DrawText("K/D RATIO", {["x"] = tableKdRatioHeader.x, ["y"] = tableHeaderText.y})

    -- Draw 'KILLS' header
    Gui.DrawRect(tableKillsHeader, tableKillsWidth, tableHeight, tableHeaderColor)
    Gui.SetTextParams(0, tableHeaderTextColor, headerScale, false, false, true)
    Gui.DrawText("KILLS", {["x"] = tableKillsHeader.x, ["y"] = tableHeaderText.y})

    -- Draw 'DEATHS' header
    Gui.DrawRect(tableDeathsHeader, tableDeathsWidth, tableHeight, tableHeaderColor)
    Gui.SetTextParams(0, tableHeaderTextColor, headerScale, false, false, true)
    Gui.DrawText("DEATHS", {["x"] = tableDeathsHeader.x, ["y"] = tableHeaderText.y})

    -- Draw 'KILLSTREAK' header
    Gui.DrawRect(tableKillstreakHeader, tableKillstreakWidth, tableHeight, tableHeaderColor)
    Gui.SetTextParams(0, tableHeaderTextColor, headerScale, false, false, true)
    Gui.DrawText("KILLSTREAK", {["x"] = tableKillstreakHeader.x, ["y"] = tableHeaderText.y})

    local tablePosition = {["y"] = tablePositionHeader.y + tableHeight + headerTableSpacing}
    local tableAvatarPositionWidth = (tableHeight * 9 / 12)

    local myPlayerId = Cache.ClientPlayerId
    table.foreach(
        scoreboard,
        function(player)
            local avatarPosition = {
                ["x"] = scoreboardPosition.x + tableAvatarPositionWidth / 2,
                ["y"] = tablePosition.y
            }
            local playerPosition = {["x"] = avatarPosition.x + tablePositionWidth / 2, ["y"] = tablePosition.y}
            local voiceIndicatorPosition = {
                ["x"] = (scoreboardPosition.x + tableAvatarPositionWidth / 2) + 0.017,
                ["y"] = tablePosition.y
            }
            local rankPosition = {
                ["x"] = (scoreboardPosition.x + tableAvatarPositionWidth / 2 + voiceIndicatorWidth) + 0.017,
                ["y"] = tablePosition.y + 0.001
            }
            local playerNamePosition = {
                ["x"] = (avatarPosition.x + tablePositionWidth / 2 + rankWidth / 2) + playerNameMargin,
                ["y"] = tablePosition.y
            }
            local playerStatusPosition = {
                ["x"] = avatarPosition.x + tableAvatarPositionWidth / 2 + playerStatusWidth / 2,
                ["y"] = tablePosition.y
            }
            --local cashPosition = { ['x'] = tableCashHeader.x, ['y'] = tablePosition.y }
            local kdRatioPosition = {["x"] = tableKdRatioHeader.x, ["y"] = tablePosition.y}
            local killsPosition = {["x"] = tableKillsHeader.x, ["y"] = tablePosition.y}
            local deathsPosition = {["x"] = tableDeathsHeader.x, ["y"] = tablePosition.y}
            local killstreakPosition = {["x"] = tableKillstreakHeader.x, ["y"] = tablePosition.y}

            local tableText = {["y"] = tablePosition.y - tableHeight / 2}

            -- Draw player id
            Gui.DrawRect(avatarPosition, tableAvatarPositionWidth, tableHeight, tableCashColor)
            Gui.SetTextParams(0, tableCashTextColor, cashScale, false, false, true)
            Gui.DrawNumeric(player.id, {["x"] = avatarPosition.x, ["y"] = tableText.y + tableTextVerticalMargin})

            -- Draw player name
            local isDonator = player.donator
            local playerColor = Color.GetHudFromBlipColor(Color.BLIP_GREY)
            if player.id == get_player_server_id(myPlayerId) then
                playerColor = Color.GetHudFromBlipColor(Color.BLIP_BROWN)
            end
            -- if Player.IsCrewMember(player.id) then
            -- 	playerColor = Color.GetHudFromBlipColor(Color.BLIP_LIGHT_BLUE)
            -- if isDonator then
            -- 	playerColor = Color.GetHudFromBlipColor(Color.BLIP_PURPLE)
            -- -- elseif player.id == Player.ServerId() then
            -- -- 	playerColor = Color.GetHudFromBlipColor(Color.BLIP_BLUE)
            -- end

            -- local isModerator = player.moderator
            -- if isModerator then
            -- 	playerColor = Color.GetHudFromBlipColor(Color.BLIP_GREEN)
            -- end

            local tablePositionColor = {
                ["r"] = playerColor.r,
                ["g"] = playerColor.g,
                ["b"] = playerColor.b,
                ["a"] = isDonator and 228 or 160
            }
            Gui.DrawRect(playerPosition, tablePositionWidth - tableAvatarPositionWidth, tableHeight, tablePositionColor)
            Gui.SetTextParams(4, tablePositionTextColor, positionScale, false, isDonator)
            Gui.DrawText(
                player.name,
                {
                    ["x"] = playerNamePosition.x - (tablePositionWidth - tableAvatarPositionWidth) / 2 +
                        playerStatusWidth +
                        tableTextHorizontalMargin,
                    ["y"] = tableText.y
                }
            )

            -- Draw voice chat indicator
            if enableVoiceChat then
                local localPlayerId = get_player_from_server_id(player.id)
                local isPlayerTalking = network_is_player_talking(localPlayerId)
                local voiceIndicatorColor = isPlayerTalking and activeVoiceIndicatorColor or inactiveVoiceIndicatorColor
                draw_sprite(
                    "mpleaderboard",
                    isPlayerTalking and "leaderboard_audio_3" or "leaderboard_audio_inactive",
                    voiceIndicatorPosition.x,
                    voiceIndicatorPosition.y,
                    voiceIndicatorWidth,
                    tableHeight,
                    0.0,
                    voiceIndicatorColor.r,
                    voiceIndicatorColor.g,
                    voiceIndicatorColor.b,
                    voiceIndicatorColor.a
                )
            end

            -- Draw rank
            local playerRankColor = rankColor
            local rank = player.rank
            if rank >= 25 and rank < 50 then
                playerRankColor = Color.GetHudFromBlipColor(Color.BLIP_ORANGE)
            elseif rank >= 50 then
                playerRankColor = Color.GetHudFromBlipColor(Color.BLIP_RED)
            end
            -- if player.prestige ~= 0 then playerRankColor = {
            -- 	r = prestigeColor.r + prestigeBlendColor.r * player.prestige,
            -- 	g = prestigeColor.g + prestigeBlendColor.g * player.prestige,
            -- 	b = prestigeColor.b + prestigeBlendColor.b * player.prestige,
            -- 	a = prestigeBlendColor.a }
            -- end
            draw_sprite(
                "mprankbadge",
                "rankglobe_21x21_colour",
                rankPosition.x,
                rankPosition.y,
                rankWidth,
                rankHeight,
                0.0,
                playerRankColor.r,
                playerRankColor.g,
                playerRankColor.b,
                playerRankColor.a
            )
            Gui.SetTextParams(4, rankTextColor, rankScale, false, false, true)
            Gui.DrawNumeric(player.rank, {["x"] = rankPosition.x, ["y"] = tableText.y + tableTextVerticalMargin / 1.25})

            -- Draw player status
            local playerStatusColor = Color.GetHudFromBlipColor(Color.BLIP_WHITE)
            if isDonator then
                playerStatusColor = Color.GetHudFromBlipColor(Color.BLIP_PURPLE)
            end
            if player.moderator then
                playerStatusColor = Color.GetHudFromBlipColor(Color.BLIP_GREEN)
            end
            Gui.DrawRect(playerStatusPosition, playerStatusWidth, tableHeight, playerStatusColor)

            -- Draw cash -- TEMPORARILY DISABLE
            --Gui.DrawRect(cashPosition, tableCashWidth, tableHeight, tableCashColor)
            --Gui.SetTextParams(0, tableCashTextColor, cashScale, false, false, true)
            --Gui.DrawTextEntry('MONEY_ENTRY', { ['x'] = tableCashHeader.x, ['y'] = tableText.y + tableTextVerticalMargin }, player.cash)

            -- Draw kdRatio
            Gui.DrawRect(kdRatioPosition, tableKdRatioWidth, tableHeight, tableKdRatioColor)
            Gui.SetTextParams(0, tableKdRatioTextColor, kdRatioScale, false, false, true)
            local kdRatio = "-"
            if player.kdRatio then
                kdRatio = string_format("%.2f", player.kdRatio)
            end
            Gui.DrawText(kdRatio, {["x"] = tableKdRatioHeader.x, ["y"] = tableText.y + tableTextVerticalMargin})

            -- Draw kills
            Gui.DrawRect(killsPosition, tableKillsWidth, tableHeight, tableKillsColor)
            Gui.SetTextParams(0, tableKillsTextColor, killsScale, false, false, true)
            Gui.DrawNumeric(player.kills, {["x"] = tableKillsHeader.x, ["y"] = tableText.y + tableTextVerticalMargin})

            -- Draw deaths
            Gui.DrawRect(deathsPosition, tableDeathsWidth, tableHeight, tableDeathsColor)
            Gui.SetTextParams(0, tableDeathsTextColor, deathsScale, false, false, true)
            Gui.DrawNumeric(player.deaths, {["x"] = tableDeathsHeader.x, ["y"] = tableText.y + tableTextVerticalMargin})

            -- Draw killstreak
            Gui.DrawRect(killstreakPosition, tableKillstreakWidth, tableHeight, tableKillstreakColor)
            Gui.SetTextParams(0, tableKillstreakTextColor, killstreakScale, false, false, true)
            Gui.DrawNumeric(
                player.killstreak,
                {["x"] = tableKillstreakHeader.x, ["y"] = tableText.y + tableTextVerticalMargin}
            )

            -- Update table position
            tablePosition.y = tablePosition.y + tableSpacing + tableHeight
        end
    )
end

local is_control_pressed = IsControlPressed

Citizen.CreateThread(
    function()
        while true do
            Wait(0)
            if is_control_pressed(0, 20) then
                Scoreboard.DisplayThisFrame()
            end
        end
    end
)
