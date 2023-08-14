-- Function to create a legendary animal at a specified location with specific attributes.
function CreateLegendaryAnimal(modelHash, outfit, coords, isnetwork, haveBlip)
    -- Create the animal using given modelHash and coordinates and set its outfit preset.
    local animal = Feather.Ped:Create(modelHash, coords.x, coords.y, coords.z, 0, 'world', true, nil, nil, isnetwork)
    animal:ChangeOutfitPreset(outfit)
    --Citizen.InvokeNative(0xCE6B874286D640BB, animal:GetPed(), quality)

    -- Retrieve the animal's networked entity.
    local ent = Entity(NetworkGetEntityFromNetworkId(animal:GetPed()))

    -- Set the 'isLegendary' state for the animal to true. This might be used for other scripts to check the legendary status.
    ent.state:set('isLegendary', true, true)

    -- If the 'haveBlip' parameter is true, set a blip on the map for the legendary animal.
    if haveBlip then
        animal:SetBlip(joaat('blip_animal'), 'Legendary animal')
    end

    -- Return the created animal.
    return animal
end

-- Export the 'CreateLegendaryAnimal' function so it can be used in other scripts or resources.
exports('CreateLegendaryAnimal', CreateLegendaryAnimal)


--! Temporary fonction to test
RegisterCommand("animal", function(source, args, rawCommand)
    if #args == 2 then
        local modelHash = args[1]
        local animal = CreateLegendaryAnimal(modelHash, tonumber(args[2]), vector4(-350.03, 786.39, 115.94, 149.6), true,
            true)
        animal:Freeze()
    end
end, false)
