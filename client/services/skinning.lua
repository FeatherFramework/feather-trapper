-- Create a new thread to listen to a specific event
Citizen.CreateThread(function()
    -- Register an event listener for the 'EVENT_LOOT_COMPLETE' event
    Feather.EventsAPI:RegisterEventListener('EVENT_LOOT_COMPLETE', function(args)
        -- Print information when the event is triggered
        print("EVENT TRIGGERED: EVENT_LOOT_COMPLETE", args[1], args[2], args[3])

        -- Extract necessary data based on the triggered event's arguments
        local modelHash = GetEntityModel(args[2]) -- Retrieve the model hash of the entity involved in the event
        local player = PlayerPedId()              -- Get the player's ped ID
        local isPlayerGathered = player == tonumber(args[1])                     -- Determine if the current player is the one who gathered the loot
        local animal = Loots[modelHash]                               -- Fetch animal details from a predefined configuration using the modelHash
        
        -- If the details about the animal are available, and specific conditions are met, process further
        if animal and args[3] == 1 and isPlayerGathered then
            -- Determine if the looted animal is a legendary animal based on its state
            animal.isLegendary = Entity(args[2]).state.isLegendary
            -- If the state did not provide the legendary status, default to false
            print('is legendary Animal ? ', animal.isLegendary)
            if animal.isLegendary == nil then
                animal.isLegendary = false
            else
                local carrying = false
                while not carrying do
                    Citizen.Wait(0)
                    if Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId()) then
                        local object = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
                        local ent = Entity(NetworkGetEntityFromNetworkId(object))
                        ent.state:set('isLegendary', true, true)
                        carrying = true

                        print('ADD is legendary to the object: ', ent.state.isLegendary)
                    end
                end
            end

            -- These print statements (currently commented) will display detailed information about the animal and its loot
            -- Consider moving this logic to the server side when inventory systems are in place
            -- print('Animal modelHash :', tostring(modelHash))
            -- print('Animal name :', tostring(animal.name))
            -- print('Animal is legendary :', tostring(animal.isLegendary))

            for _, item in ipairs(animal.items) do
                -- Loop through the regular loot items of the animal and print (or process) them
                -- print('Animal loot :', tostring(item.label), tostring(item.id))
            end

            -- If the animal is legendary and has special legendary items
            if animal.isLegendary and animal.legendItems then
                if #animal.legendItems > 0 then
                    for _, item in ipairs(animal.legendItems) do
                        -- Loop through the legendary loot items of the animal and print (or process) them
                        -- print('Animal Legendary loot :', tostring(item.label), tostring(item.id))
                    end
                end
            end
        end
    end)
end)
