-- Modified from https://github.com/citizenfx/cfx-server-data/blob/master/resources/%5Bgameplay%5D/playernames/playernames_cl.lua
local gamerTags = {}
Citizen.CreateThread(
  function()
    Wait(5000)

    while true do
      Wait(0)
      local myPed = PlayerPedId()
      local myPlayer = PlayerId()
      local myCoords = GetEntityCoords(myPed)
      local players = GetActivePlayers()
      for i = 1, #players do
        local player = players[i]
        if player ~= myPlayer then
          local data = Scoreboard.GetPlayer(player)

          local isDead = IsPlayerDead(player)
          local ped = GetPlayerPed(player)
          local pedCoords = GetEntityCoords(ped)
          local isHealthBarVisible = not isDead and IsPlayerFreeAimingAtEntity(myPlayer, ped)
          local isDonator = false
          local isModerator = false
          -- only continue if this player is on the scoreboard already
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

          if not gamerTags[player] or gamerTags[player].ped ~= ped or not IsMpGamerTagActive(gamerTags[player].tag) then
            if gamerTags[player] then
              RemoveMpGamerTag(gamerTags[player].tag)
            end

            gamerTags[player] = {
              tag = CreateFakeMpGamerTag(ped, GetPlayerName(player), false, false, "", 0),
              ped = ped
            }
            local gamerTag = gamerTags[player].tag

            -- SetMpGamerTagName(gamerTags[player].tag, GetPlayerName(player))
            SetMpGamerTagColour(gamerTag, 0, 0)
            SetMpGamerTagColour(gamerTag, 2, 18)
            SetMpGamerTagColour(gamerTag, 4, color)
            SetMpGamerTagColour(gamerTag, 10, color)
            SetMpGamerTagHealthBarColour(gamerTag, 18)

            SetMpGamerTagAlpha(gamerTag, 0, 255)
            SetMpGamerTagAlpha(gamerTag, 2, 255)
            SetMpGamerTagAlpha(gamerTag, 4, 255)
            SetMpGamerTagAlpha(gamerTag, 10, 255)
          end

          local gamerTag = gamerTags[player].tag

          local distance = #(pedCoords - myCoords)

          if distance < 100 and HasEntityClearLosToEntity(myPed, ped, 17) then
            local isTalking = NetworkIsPlayerTalking(player)

            SetMpGamerTagColour(gamerTag, 10, color)
            SetMpGamerTagColour(gamerTag, 4, color)
            SetMpGamerTagVisibility(gamerTag, 0, isHealthBarVisible) -- GAMER_NAME
            SetMpGamerTagVisibility(gamerTag, 2, isHealthBarVisible) -- HEALTH/ARMOR
            SetMpGamerTagVisibility(gamerTag, 4, isHealthBarVisible and isTalking) -- AUDIO_ICON

            if (isDonator or isModerator) then
              SetMpGamerTagVisibility(gamerTag, 10, isHealthBarVisible and (isDonator or isModerator)) -- MP_TAGGED CIRCLE
            else
              SetMpGamerTagVisibility(gamerTag, 10, false) -- MP_TAGGED CIRCLE
            end
          else
            SetMpGamerTagVisibility(gamerTag, 0, false) -- GAMER_NAME
            SetMpGamerTagVisibility(gamerTag, 2, false) -- HEALTH/ARMOR
            SetMpGamerTagVisibility(gamerTag, 4, false) -- AUDIO_ICON
            SetMpGamerTagVisibility(gamerTag, 10, false) -- MP_TAGGED CIRCLE
          end
        elseif gamerTags[player] then
          RemoveMpGamerTag(gamerTags[player].tag)
          gamerTags[player] = nil
        end
      end
    end
  end
)
