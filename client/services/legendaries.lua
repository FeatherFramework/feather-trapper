LegendaryAPI = {}

-- Function to create a legendary animal at a specified location with specific attributes.
function LegendaryAPI:CreateLegendaryAnimal(modelHash, outfit, x, y, z, isnetwork, haveBlip)
    if IsOutfitValidForHash(modelHash, outfit) then
        -- Create the animal using given modelHash and coordinates and set its outfit preset.
        local animal = Feather.Ped:Create(modelHash, x, y, z, 0, 'world', true, nil, nil, isnetwork)
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
    else
        return false
    end
end

-- Export the function so it can be used in other scripts or resources.
exports('legendaryAnimal', function()
    return LegendaryAPI
end)
