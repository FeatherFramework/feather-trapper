AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, butcher in ipairs(ButcherNpcs) do
            butcher:Remove()
        end
        for _, blip in ipairs(Blips) do
            blip:Remove()
        end
    end
end)
