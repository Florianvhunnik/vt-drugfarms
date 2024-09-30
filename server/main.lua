-- local variables


-- event handlers
AddEventHandler('onResourceStop', function(resource)
    local requiredResources = { es_extended = true, ox_lib = true, ox_target = true }

    if requiredResources[resource] then
        DebugHandler('error', 'The resource: ' .. resource .. ' is required for this resource to work! Stopping resource...')
        StopResource(GetCurrentResourceName())
    end
end)