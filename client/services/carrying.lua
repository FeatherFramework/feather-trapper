Citizen.CreateThread(function()
    -- Setting up the prompt group for user interactions
    local PromptGroup = Feather.Prompt:SetupPromptGroup()

    -- Registering the prompt to load something onto the horse
    local horseprompt = PromptGroup:RegisterPrompt("Load ", Keys["R"], 1, 1, true, 'hold',
        { timedeventhash = "SHORT_TIMED_EVENT_MP" })

    -- Main loop to constantly check the conditions for prompts and actions
    while true do
        -- Check what the player is carrying
        local somethingToLoad = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId()) -- GetFirstEntityPedIsCarrying
        local isPelt = Citizen.InvokeNative(0x255B6DB4E3AD3C3E, somethingToLoad)

        -- If the player isn't carrying anything, wait for a longer period and continue the loop
        if not somethingToLoad or not isPelt then
            Citizen.Wait(1000) -- Waiting for 1 second before checking again. You can adjust this time as needed.
            goto continue_loop
        end

        Citizen.Wait(0)

        -- Retrieving the last horse the player mounted
        local horse = Citizen.InvokeNative(0x4C8B59171957BCF7, PlayerPedId()) -- GetLastMount

        -- If the player has mounted a horse previously
        if horse then
            local ent = Entity(horse)

            -- Get coordinates of horse and player
            local sHorse = GetEntityCoords(horse)
            local sPlayer = GetEntityCoords(PlayerPedId())

            -- Check what the player is carrying

            local somethingToLoadModel = GetEntityModel(somethingToLoad)
            local somethingToLoadQuality = Citizen.InvokeNative(0x31FEF6A20F00B963, somethingToLoad) -- GetCarriableFromEntity = Quality of the pelt
            local sDistance = #(sPlayer - sHorse)


            -- Check conditions to display the load prompt to the player
            if sDistance < 2 and (somethingToLoad and isPelt and not IsXLargePelt(somethingToLoadModel)) and (not ent.state.pelt3 or not ent.state.pelt2 or not ent.state.pelt1) then
                PromptGroup:ShowGroup("Horse")
                horseprompt:TogglePrompt(true)
            else
                horseprompt:TogglePrompt(false)
            end

            -- Check if the player has completed the load prompt and load animation to put pelt onto the horse
            if horseprompt:HasCompleted() then
                Citizen.InvokeNative(0x6D3D87C57B3D52C7, PlayerPedId(), somethingToLoad, horse, 1) -- TaskPlaceCarriedEntityOnMount

                -- Storing pelts on the horse in order of availability
                if ent.state.pelt1 then
                    if ent.state.pelt2 then
                        ent.state:set('pelt3', { somethingToLoad, somethingToLoadQuality, somethingToLoadModel }, true)
                        print("Load pelt :", Dump(ent.state.pelt3))
                    else
                        ent.state:set('pelt2', { somethingToLoad, somethingToLoadQuality, somethingToLoadModel }, true)
                        print("Load pelt :", Dump(ent.state.pelt2))
                    end
                else
                    ent.state:set('pelt1', { somethingToLoad, somethingToLoadQuality, somethingToLoadModel }, true)
                    print("Load pelt :", Dump(ent.state.pelt1))
                end
            end
        end

        ::continue_loop:: -- Continue label for the loop
    end
end)