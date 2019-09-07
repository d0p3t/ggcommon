AddEventHandler(
    "onServerResourceStart",
    function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end

        -- TriggerEvent("ggcommon:ss", GetPlayers()[1])
        -- Log("Test title", "Test message")
    end
)
