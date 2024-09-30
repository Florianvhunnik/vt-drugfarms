-- Local variables


-- Event handlers
AddEventHandler('onResourceStop', function(resource)
    local requiredResources = { es_extended = true, ox_lib = true, ox_target = true, ox_inventory = true }

    if requiredResources[resource] then
        DebugHandler('error', 'The resource: ' .. resource .. ' is required for this resource to work! Stopping resource...')
        StopResource(GetCurrentResourceName())
    end
end)

-- Callbacks
lib.callback.register(Config.resourceName .. ':spawnItem', function(source, item, count)
    DebugHandler('info', 'Spawning item: ' .. item .. ' for player id: ' .. source .. ' with count: ' .. count)
    return exports.ox_inventory:AddItem(source, item, count)
end)