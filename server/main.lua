-- local variables


-- event handlers
AddEventHandler('onResourceStop', function(resource)
    local requiredResources = { es_extended = true, ox_lib = true, ox_target = true }

    if requiredResources[resource] then
        DebugHandler('error', 'The resource: ' .. resource .. ' is required for this resource to work! Stopping resource...')
        StopResource(GetCurrentResourceName())
    end
end)

-- functions
DebugHandler = function(type, message)
    if not Config.debugMode then return end
    if type == 'info' then
        message = "^5[INFO]^7 " .. message
    elseif type == 'error' then
        message = "^1[ERROR]^7 " .. message
    elseif type == 'warning' then
        message = "^3[WARNING]^7 " .. message
    elseif type == 'success' then
        message = "^2[SUCCESS]^7 " .. message
    else
        return false
    end; print('^6[DEBUG]^7 ' .. message)
end