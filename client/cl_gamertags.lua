-- Modified from https://github.com/citizenfx/cfx-server-data/blob/master/resources/%5Bgameplay%5D/playernames/playernames_cl.lua
local gamerTags = {}

local get_entity_coords = GetEntityCoords
local create_fake_mp_gamer_tag = CreateFakeMpGamerTag
local remove_mp_gamer_tag = RemoveMpGamerTag
local set_mp_gamer_tag_visibility = SetMpGamerTagVisibility
local set_mp_gamer_tag_colour = SetMpGamerTagColour
local set_mp_gamer_tag_alpha = SetMpGamerTagAlpha
local set_mp_gamer_tag_health_bar_colour = SetMpGamerTagHealthBarColour
local get_player_server_id = GetPlayerServerId
local get_player_name = GetPlayerName
local has_entity_clear_los_to_entity = HasEntityClearLosToEntity
local network_is_player_talking = NetworkIsPlayerTalking
local is_player_free_aiming_at_entity = IsPlayerFreeAimingAtEntity

Citizen.CreateThread(
  function()
    Wait(5000)

    while true do
      Wait(200)
      myPed = Cache.ClientPedId
      myPlayer = Cache.ClientPlayerId
      myCoords = get_entity_coords(myPed, false)
      for _, player in ipairs(Cache.ActivePlayers) do
        if player ~= myPlayer then
          local playerData = Cache.ActivePlayersData[tostring(player)]
          if playerData ~= nil then
            local ped = playerData.ped
            local pedCoords = playerData.coords
            local distance = #(pedCoords - myCoords)

            if distance < 200 then
              local isDonator = false
              local isModerator = false
              -- only continue if this player is on the scoreboard already
              local data = Scoreboard.GetPlayer(player)
              if data then
                isDonator = data.donator
                isModerator = data.moderator
              end

              local color = 0

              if isModerator then
                color = 18
              elseif isDonator then
                color = 21
              end

              if not gamerTags[player] then
                gamerTags[player] = {
                  tag = create_fake_mp_gamer_tag(
                    ped,
                    "#" .. tostring(get_player_server_id(player)) .. " " .. get_player_name(player),
                    false,
                    false,
                    "",
                    0
                  ),
                  ped = ped
                }
                local gamerTag = gamerTags[player].tag
                set_mp_gamer_tag_colour(gamerTag, 0, 0)
                set_mp_gamer_tag_colour(gamerTag, 2, 18)
                set_mp_gamer_tag_health_bar_colour(gamerTag, 18)
                set_mp_gamer_tag_alpha(gamerTag, 0, 255)
                set_mp_gamer_tag_alpha(gamerTag, 2, 255)
                set_mp_gamer_tag_alpha(gamerTag, 4, 255)
                set_mp_gamer_tag_alpha(gamerTag, 10, 255)
              end

              local gamerTag = gamerTags[player].tag

              if distance < 100 and has_entity_clear_los_to_entity(myPed, ped, 17) then
                local isTalking = network_is_player_talking(player)
                local isDead = playerData.isDead
                local isHealthBarVisible = not isDead and is_player_free_aiming_at_entity(myPlayer, ped)
                set_mp_gamer_tag_colour(gamerTag, 10, color)
                set_mp_gamer_tag_colour(gamerTag, 4, color)
                set_mp_gamer_tag_visibility(gamerTag, 0, isHealthBarVisible) -- GAMER_NAME
                set_mp_gamer_tag_visibility(gamerTag, 2, isHealthBarVisible) -- HEALTH/ARMOR
                set_mp_gamer_tag_visibility(gamerTag, 4, isHealthBarVisible and isTalking) -- AUDIO_ICON

                if isDonator or isModerator then
                  set_mp_gamer_tag_visibility(gamerTag, 10, isHealthBarVisible and (isDonator or isModerator)) -- MP_TAGGED CIRCLE
                else
                  set_mp_gamer_tag_visibility(gamerTag, 10, false) -- MP_TAGGED CIRCLE
                end
              else
                set_mp_gamer_tag_visibility(gamerTag, 0, false) -- GAMER_NAME
                set_mp_gamer_tag_visibility(gamerTag, 2, false) -- HEALTH/ARMOR
                set_mp_gamer_tag_visibility(gamerTag, 4, false) -- AUDIO_ICON
                set_mp_gamer_tag_visibility(gamerTag, 10, false) -- MP_TAGGED CIRCLE
              end
            elseif gamerTags[player] then
              remove_mp_gamer_tag(gamerTags[player].tag)
              gamerTags[player] = nil
            end
          end
        end
      end
    end
  end
)
