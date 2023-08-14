ButcherNpcs = {}
Blips = {}
local currentButcher = nil

Citizen.CreateThread(function()
    -- Attente de l'événement "playerSpawned"
    local playerSpawned = false
    while not playerSpawned do
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            playerSpawned = true
            Citizen.Wait(5000) -- TODO ADD the character is spawned
        end
    end

    for _, butcher in ipairs(Butchers.npc) do
        -- Create a butcher NPC at the specified coordinates with specific attributes.
        local npc = Feather.Ped:Create(butcher.model, butcher.coords.x, butcher.coords.y, butcher.coords.z,
            butcher.heading, 'world', true, nil, nil, false)
        npc:Freeze()
        npc:Invincible()
        npc:CanBeDamaged(false)
        npc:SetPedCombatAttributes()
        npc:SetBlockingOfNonTemporaryEvents(true)

        -- Create a blip on the map for this butcher.
        local blip = Feather.Blip:SetBlip(
            butcher.name,
            butcher.blip,
            0.2,
            butcher.coords.x,
            butcher.coords.y,
            butcher.coords.z, nil)

        -- Store the created NPC and blip in their respective tables.
        table.insert(ButcherNpcs, npc)
        table.insert(Blips, blip)
    end
end)

-- Thread to handle selling interactions with butcher NPCs.
Citizen.CreateThread(function()
    local PromptGroup = Feather.Prompt:SetupPromptGroup()
    local butcherprompt = PromptGroup:RegisterPrompt("Sell", Keys["G"], 1, 1, true, 'hold',
        { timedeventhash = "SHORT_TIMED_EVENT_MP" })

    -- Infinite loop to check player's distance from butchers.
    while true do
        Citizen.Wait(500)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local lastMount = Citizen.InvokeNative(0x4C8B59171957BCF7, PlayerPedId())
        local nearButcher = false

        for _, butcher in ipairs(ButcherNpcs) do
            local butcherCoords = butcher:GetCoords()
            local sDistance = #(playerCoords - butcherCoords)

            if sDistance < 3 then
                nearButcher = true
                currentButcher = butcher
                break
            end
        end

        if nearButcher then
            while true do --* Inner loop for active prompt without delay
                Citizen.Wait(0)
                local currentCoords = GetEntityCoords(PlayerPedId())
                local currentDistance = #(currentCoords - currentButcher:GetCoords())
                if currentDistance < 3 then
                    PromptGroup:ShowGroup("Butcher")
                    butcherprompt:TogglePrompt(true)
                else
                    butcherprompt:TogglePrompt(false)
                    break
                end
                if butcherprompt:HasCompleted() then
                    if Citizen.InvokeNative(0xA911EE21EDF69DAF, PlayerPedId()) then
                        IsPlayerCarryingEntity()
                    end
                    if lastMount then
                        local sHorse = GetEntityCoords(lastMount)
                        local sDistance = #(playerCoords - sHorse)
                        if sDistance < 9 then
                            IsLastMountCarryingEntity(lastMount)
                        end
                    end
                end
            end
        end
    end
end)


function IsPlayerCarryingEntity()
    local entity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
    if not entity then return end

    local function calculatePrice(model, type, quality)
        local price = GetPrice(model, type) or 1
        local qualityMultipliers = Butchers.qualityPriceMultiplier
        price *= qualityMultipliers[quality] or qualityMultipliers.poor
        return RoundToTwoDecimals(price)
    end

    if Citizen.InvokeNative(0x255B6DB4E3AD3C3E, entity) then
        if Entity(entity).state.isLegendary then
            local entityHash = Citizen.InvokeNative(0x31FEF6A20F00B963, entity)
            local model, qualityType = FindPeltQuality(entityHash)
            qualityType = 'legend'
            if model then
                local priceType = qualityType or 'skin'
                local displayedPrice = calculatePrice(model, 'skin', qualityType)
                print('You sold legendary animal pelt ' .. priceType .. ' for $' .. displayedPrice)
            else
                if entityHash == false then
                    local priceType = qualityType or 'skin'
                    local displayedPrice = calculatePrice('default', 'skin', qualityType)
                    print('You sold legendary animal pelt ' .. priceType .. ' for $' .. displayedPrice)
                else
                    print("The legendary skin is not known from the sales list: ", entityHash)
                end
            end
        else
            local entityHash = Citizen.InvokeNative(0x31FEF6A20F00B963, entity)
            local model, qualityType = FindPeltQuality(entityHash)
            if model then
                local priceType = qualityType or 'skin'
                local displayedPrice = calculatePrice(model, 'skin', qualityType)
                print('You sold animal pelt ' .. priceType .. ' for $' .. displayedPrice)
            else
                print("The skin is not known from the sales list: ", entityHash)
            end
        end
    elseif Citizen.InvokeNative(0xEC9A1261BF0CE510, entity) == 3 then
        local model = GetEntityModel(entity)
        local PedDamaged = Citizen.InvokeNative(0x88EFFED5FE8B0B4A, entity)
        local displayedPrice
        if Entity(entity).state.isLegendary then
            displayedPrice = calculatePrice(model, 'body', 'legend')
        else
            displayedPrice = calculatePrice(model, 'body', PedDamaged)
        end
        print('You sold animal for $' .. displayedPrice)
    else
        print('Entity is AN HUMAN !!!')
        return false
    end

    -- TODO: Implement code to inform the server and give money to the player.
    DeleteEntity(entity)
end

function IsLastMountCarryingEntity(lastMount)
    local function calculatePrice(model, type, quality)
        local price = GetPrice(model, type) or 1
        local qualityMultipliers = Butchers.qualityPriceMultiplier
        price *= qualityMultipliers[quality] or qualityMultipliers.poor
        return RoundToTwoDecimals(price)
    end

    local function handleEntitySale(entity)
        if Citizen.InvokeNative(0x255B6DB4E3AD3C3E, entity) then
            if Entity(entity).state.isLegendary then
                local entityHash = Citizen.InvokeNative(0x31FEF6A20F00B963, entity)
                local model, qualityType = FindPeltQuality(entityHash)
                qualityType = 'legend'
                if model then
                    local priceType = qualityType or 'skin'
                    local displayedPrice = calculatePrice(model, 'skin', qualityType)
                    print('You sold legendary animal pelt ' .. priceType .. ' for $' .. displayedPrice)
                else
                    if entityHash == false then
                        local priceType = qualityType or 'skin'
                        local displayedPrice = calculatePrice('default', 'skin', qualityType)
                        print('You sold legendary animal pelt ' .. priceType .. ' for $' .. displayedPrice)
                    else
                        print("The legendary skin is not known from the sales list: ", entityHash)
                    end
                end
            else
                local entityHash = Citizen.InvokeNative(0x31FEF6A20F00B963, entity)
                local model, qualityType = FindPeltQuality(entityHash)
                local displayedPrice = calculatePrice(model, 'skin', qualityType)
                print('You sold ' .. (qualityType or 'skin') .. ' pelt for $' .. displayedPrice)
            end
            DeleteEntity(entity)
        elseif Citizen.InvokeNative(0xEC9A1261BF0CE510, entity) == 3 then
            local model = GetEntityModel(entity)
            local PedDamaged = Citizen.InvokeNative(0x88EFFED5FE8B0B4A, entity)
            local displayedPrice = calculatePrice(model, 'body', PedDamaged)
            print('You sold animal for $' .. displayedPrice)
            DeleteEntity(entity)
        else
            print('it\'s a Human !!!')
            Citizen.InvokeNative(0x36D188AECB26094B, entity)
            Citizen.Wait(1000)
        end
    end

    local function handlePeltSale(peltData, peltName)
        if peltData then
            if peltData[4] then
                local model, qualityType = FindPeltQuality(peltData[2])
                qualityType = 'legend'
                if model then
                    local displayedPrice = calculatePrice(model, 'skin', qualityType)
                    print(model .. ' ' .. (qualityType or 'skin') .. ' ' .. displayedPrice)
                else
                    print("The legendary skin is not known from the sales list: ", peltData[2])
                end
            else
                local model, qualityType = FindPeltQuality(peltData[2])
                local displayedPrice = calculatePrice(model, 'skin', qualityType)
                print(model .. ' ' .. (qualityType or 'skin') .. ' ' .. displayedPrice)
            end
            Citizen.InvokeNative(0x627F7F3A0C4C51FF, lastMount, peltData[2])
            Entity(lastMount).state:set(peltName, nil, true)
        end
    end

    Citizen.CreateThread(function()
        while Citizen.InvokeNative(0xA911EE21EDF69DAF, lastMount) do
            Citizen.Wait(200)
            local horseIsCarrying = Citizen.InvokeNative(0xD806CD2A4F2C2996, lastMount)
            if horseIsCarrying then
                handleEntitySale(horseIsCarrying)
            end
        end
    end)

    handlePeltSale(Entity(lastMount).state.pelt1, 'pelt1')
    handlePeltSale(Entity(lastMount).state.pelt2, 'pelt2')
    handlePeltSale(Entity(lastMount).state.pelt3, 'pelt3')

    -- TODO: Implement code to inform the server and give money to the player.
end

function GetPrice(entity, type)
    if entity == 'default' then
        return Butchers.animalPrices[000000000][type]
    else
        return Butchers.animalPrices[entity][type]
    end
end
