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