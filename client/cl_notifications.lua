-- UNUSED RIGHT NOW SO DONT EVEN BOTHER INCLUDING THIS CODE. SAVE SOME BYTES!!! :P
-- RegisterNetEvent("notify")
-- AddEventHandler(
--   "notify",
--   function(message, advanced, killer)
--     Citizen.CreateThread(
--       function()
--         BeginTextCommandThefeedPost("STRING")
--         AddTextComponentSubstringPlayerName(message)
--         local headshot = nil
--         local handle = 0

--         if advanced == true then
--           local player = GetPlayerFromServerId(killer)
--           local ped = GetPlayerPed(player)

--           if ped ~= 0 then
--             handle = RegisterPedheadshot(ped)

--             while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
--               Wait(1)
--             end
--             headshot = GetPedheadshotTxdString(handle)
--             EndTextCommandThefeedPostMessagetext(headshot, headshot, false, 0, "", "")
--           end
--         end

--         EndTextCommandThefeedPostTicker(false, true)

--         if headshot ~= nil then
--           UnregisterPedheadshot(handle)
--         end
--       end
--     )
--   end
-- )
