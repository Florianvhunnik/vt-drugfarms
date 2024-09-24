-- local variables
local propData, polyZones, blips, targets = {}, {}, {}, {}
local activeZone, drugFarm = nil, nil
local interactActive = false

-- event handlers
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Setup("stop")
    end
end)

-- threads
CreateThread(function()
    Setup("start")
end)

-- functions
Setup = function(action)
    local success, result = pcall(function()
        if action == "stop" then
            -- delete all props and remove all blips
            DeleteProps(); RemoveBlips()

            -- remove all polyzones
            for k, v in pairs(polyZones) do
                exports.ox_target:removeZone(k)
            end

            -- remove all targets for each prop type
            for k, v in pairs(Config.drugFarms) do
                exports.ox_target:removeModel(v.target.propType)
            end

            -- clear the tables
            propData, polyZones, blips, targets = {}, {}, {}, {}
        elseif action == "restart" then
            -- stop and start the resource
            Setup("stop")
            DebugHandler('info', 'Restarting...');
            Wait(1000); Setup("start")
        elseif action == "start" then
            -- loop through all drug types
            for k, v in pairs(Config.drugFarms) do
                -- add the target for the prop type
                if not targets[v.target.propType] then
                    exports.ox_target:addModel(v.target.propType, {
                        {
                            icon = v.target.icon,
                            label = v.target.label,
                            distance = v.target.distance,
                            canInteract = interactActive,
                            onSelect = function(data)
                                PickupProp(data)
                            end
                        },
                    }); targets[v.target.propType] = true
                end

                -- create the blip if enabled, then calculate the coords
                if v.blip.enabled then
                    local center = CalculateCentroid(v.zone)
                    CreateBlip(k, center, v.blip.sprite, v.blip.color, v.blip.scale, v.blip.label)
                end

                -- create the polyzone
                polyZones[k] = lib.zones.poly({
                    points = v.zone,
                    thickness = 2,
                    debug = Config.debugMode,
                    onEnter = function(self)
                        OnEnter(self, k)
                    end,
                    onExit = function(self)
                        DebugHandler('info', 'Exited drugs zone: ^2' .. k)
                        DeleteProps(); activeZone = nil
                    end
                })
            end
        end
    end)

    if success then
        if success then
                message = (action == "start" and "Started") or 
                (action == "stop" and "Stopped") or 
                (action == "restart" and "Restarted") 
                DebugHandler('success', message .. " resource successfully.")
        else
            DebugHandler('error', 'Error during action: ' .. action .. ' Error: ' .. result)
        end        
    else
        DebugHandler('error', 'Error during action: ' .. action .. ' Error: ' .. result)
    end
end

DebugHandler = function(type, message)
    if not Config.debugMode then return end
    -- check the type, then change the message
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
    end; print('^6[DEBUG]^7 ' .. message) -- print the message
end

CreateBlip = function(k, coords, sprite, color, scale, label)
    -- create the blip and add it to the blips table so we can remove it later
    blips[k] = AddBlipForCoord(coords)
    SetBlipSprite(blips[k], sprite)
    SetBlipColour(blips[k], color)
    SetBlipScale(blips[k], scale)
    SetBlipAsShortRange(blips[k], true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blips[k])
end

RemoveBlips = function()
    -- create a pcall function to catch any errors
    local success, result = pcall(function()
        -- loop through all blips and remove them, then clear the table
        for k, blip in pairs(blips) do
            RemoveBlip(blip)
        end; blips = {} -- clear the blips table
    end)

    -- check if the removal was successful
    if success then
        DebugHandler("success", "All blips have been removed successfully.")
    else
        DebugHandler("error", "An error occurred while removing blips: " .. result)
    end
end

OnEnter = function(self, k)
    DebugHandler('info', 'Entered drugs zone: ^2' .. k)
    activeZone = k -- set the active zone

    local drugsFarm = Config.drugFarms[activeZone]
    for i = 1, drugsFarm.spawnLimit do
        SpawnProp(drugsFarm.target.propType)
        Wait(1000)
    end
end

CalculateCentroid = function(points)
    local numPoints = #points -- get the point count
    local sumX, sumY, sumZ = 0, 0, 0 -- give x,y,z a v of 0

    -- loop trough all points and calculate the sum
    for k, point in ipairs(points) do
        sumX, sumY, sumZ = sumX + point.x, sumY + point.y, sumZ + point.z
    end

    -- return the vector we calculated
    return vec(sumX / numPoints, sumY / numPoints, sumZ / numPoints)
end

SpawnProp = function(propType)
    -- get the drug farm config
    drugFarm = Config.drugFarms[activeZone]

    -- check if the drug farm is not nil
    if drugFarm then
        -- get the spawn coords
        local coords = GetSpawnCoords(propType, drugFarm.zone)

        -- check if the coords are not nil
        if coords then
            -- spawn, freeze and place the prop on the ground
            ESX.Game.SpawnLocalObject(propType, coords, function(object)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
                propData[object] = propType
            end)
        else
            DebugHandler('error', 'The coords are nil.')
        end
    else
        DebugHandler('error', 'The drug farm is nil.')
    end

    -- debug message
    DebugHandler('info', 'Spawned prop: ^2' .. propType .. '^7 in zone: ^2' .. activeZone)
end

GetSpawnCoords = function(propType, zone)
    local tri = zone
    local r1 = math.random()
    local r2 = math.random()

    if #tri ~= 3 then return nil end

    if r1 + r2 > 1 then
        r1 = 1 - r1
        r2 = 1 - r2
    end

    local randomPoint = vector3(
        tri[1].x + r1 * (tri[2].x - tri[1].x) + r2 * (tri[3].x - tri[1].x),
        tri[1].y + r1 * (tri[2].y - tri[1].y) + r2 * (tri[3].y - tri[1].y),
        tri[1].z + r1 * (tri[2].z - tri[1].z) + r2 * (tri[3].z - tri[1].z)
    )

    local foundGround, coordZ = GetGroundZFor_3dCoord(randomPoint.x, randomPoint.y, randomPoint.z + 100.0, false)
    coordZ = foundGround and coordZ or randomPoint.z

    return vector3(randomPoint.x, randomPoint.y, coordZ)
end

PickupProp = function(data)
    -- check if the player is already interacting with something
    if interactActive then return end

    -- change some things
    interactActive, LocalPlayer.state.invBusy = true, true
    TaskTurnPedToFaceEntity(PlayerPedId(), data.entity, 1000)
    Wait(1000)

    -- start the progress circle
    local progress = lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false, sprint = true },
        anim = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer",
        },
    })

    -- check if the progress was completed
    if progress then
        local prop = data.entity

        -- check if the prop exists
        if propData[prop] then
            local propType = propData[prop]
            propData[prop] = nil        -- remove the prop from the table
            ESX.Game.DeleteObject(prop) -- delete the prop

            -- spawn new props if the limit is not reached
            local drugFarm = nil
            for k, v in pairs(Config.drugFarms) do
                if v.target.propType == propType then
                    drugFarm = v
                    break
                end
            end

            if drugFarm then
                SpawnProp(propType)
            end
        end
    end

    -- change some things back
    interactActive, LocalPlayer.state.invBusy = false, false
end

DeleteProps = function()
    -- loop through all props and delete them
    for prop in pairs(propData) do
        if DoesEntityExist(prop) then
            ESX.Game.DeleteObject(prop)
        else
            DebugHandler('warning', 'The prop does not exist.')
        end
    end; DebugHandler('info', 'Deleted ^2' .. #propData .. '^7 props.')
    propData = {} -- clear the propData table
end

InDrugsFarm = function()
    -- loop through all polyzones and check if the player is inside one
    for k, v in pairs(polyZones) do
        if v:isPointInside(GetEntityCoords(PlayerPedId())) then
            return k
        end
    end; return false
end

-- exports
exports('InDrugsFarm', InDrugsFarm)