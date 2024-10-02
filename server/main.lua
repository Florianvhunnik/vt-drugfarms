-- Local variables
local inv = exports.ox_inventory

-- Event handlers
AddEventHandler('onResourceStop', function(resource)
    local requiredResources = { es_extended = true, ox_lib = true, ox_target = true, ox_inventory = true }

    if requiredResources[resource] then
        DebugHandler('error', 'The resource: ' .. resource .. ' is required for this resource to work! Stopping resource...')
        StopResource(GetCurrentResourceName())
    end
end)

-- Callbacks
lib.callback.register(Config.resourceName .. ':spawnItem', function(source, activeZone)
    local config = Config.drugFarms[activeZone].item
    local count = math.random(config.randomized.min, config.randomized.max)
    DebugHandler('info', 'Spawning item: ' .. config.spawnName .. ' for player id: ' .. source .. ' with count: ' .. count)
    return inv:AddItem(source, config.spawnName, count)
end)