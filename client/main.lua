-- local variables
local propData, polyZones, blips, targets = {}, {}, {}, {}
local activeZone, drugFarm = nil, nil
local interactActive = false

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

-- exports
exports('InDrugsFarm', InDrugsFarm)
exports('GetActiveZone', GetActiveZone)