-- Stop the resource from 'running' 
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Setup("stop")
    end
end)

-- Start the resource on load
CreateThread(function()
    Setup("start")
end)

-- Exports
exports('InDrugsFarm', InDrugsFarm)
exports('GetActiveZone', GetActiveZone)

-- Test commands
RegisterCommand('InDrugsFarm', function()
    if exports[GetCurrentResourceName()]:InDrugsFarm() then
        print('You are in a drug farm')
    else
        print('You are not in a drug farm')
    end
end)

RegisterCommand('GetActiveZone', function()
    local zone = exports[GetCurrentResourceName()]:GetActiveZone()
    if zone then
        print('You are in zone: ' .. zone)
    else
        print('You are not in a zone')
    end
end)