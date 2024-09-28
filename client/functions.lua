-- Debug handler
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

-- Setup function for starting/stopping the resource
Setup = function(action)
    local success, result = pcall(function()
        if action == "stop" then
            DeleteProps(); RemoveBlips()
            for k, v in pairs(polyZones) do
                exports.ox_target:removeZone(k)
            end
            for k, v in pairs(Config.drugFarms) do
                exports.ox_target:removeModel(v.target.propType)
            end
        elseif action == "start" then
            for k, v in pairs(Config.drugFarms) do
                if v.blip.enabled then
                    local center = CalculateCentroid(v.zone)
                    CreateBlip(k, center, v.blip.sprite, v.blip.color, v.blip.scale, v.blip.label)
                end

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
        DebugHandler('success', action:capitalize() .. " resource successfully.")
    else
        DebugHandler('error', 'Error during ' .. action .. ': ' .. result)
    end
end

OnEnter = function(self, k)
    DebugHandler('info', 'Entered drugs zone: ^2' .. k)
    activeZone = k

    local drugsFarm = Config.drugFarms[activeZone]
    for i = 1, drugsFarm.spawnLimit do
        SpawnProp(drugsFarm.target.propType)
        Wait(1000)
    end
end

-- Blip creation and management
CreateBlip = function(k, coords, sprite, color, scale, label)
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
    local success, result = pcall(function()
        for k, blip in pairs(blips) do
            RemoveBlip(blip)
        end; blips = {}
    end)

    if success then
        DebugHandler("success", "All blips have been removed successfully.")
    else
        DebugHandler("error", "An error occurred while removing blips: " .. result)
    end
end

-- Prop management
SpawnProp = function(propType)
    drugFarm = Config.drugFarms[activeZone]

    if drugFarm then
        local coords = GetSpawnCoords(propType, drugFarm.zone)

        if coords then
            local success, result = pcall(function()
                ESX.Game.SpawnLocalObject(propType, coords, function(object)
                    PlaceObjectOnGroundProperly(object)
                    FreezeEntityPosition(object, true)
                    propData[object] = propType
                end)
            end)

            if success then
                DebugHandler('info', 'Spawned prop: ^2' .. propType .. '^7 in zone: ^2' .. activeZone)
            else
                DebugHandler('error', 'Error while spawning prop: ' .. result)
            end
        else
            DebugHandler('error', 'The coords are nil.')
        end
    else
        DebugHandler('error', 'The drug farm is nil.')
    end
end

PickupProp = function(data)
    if interactActive then return end

    interactActive, LocalPlayer.state.invBusy = true, true
    TaskTurnPedToFaceEntity(PlayerPedId(), data.entity, 1000)
    Wait(1000)

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

    if progress then
        local prop = data.entity
        if propData[prop] then
            local propType = propData[prop]
            propData[prop] = nil
            ESX.Game.DeleteObject(prop)
            SpawnProp(propType)
        end
    end

    interactActive, LocalPlayer.state.invBusy = false, false
end

DeleteProps = function()
    for prop in pairs(propData) do
        if DoesEntityExist(prop) then
            ESX.Game.DeleteObject(prop)
        else
            DebugHandler('warning', 'The prop does not exist.')
        end
    end; DebugHandler('info', 'Deleted ^2' .. #propData .. '^7 props.')
    propData = {}
end

-- Calculate some stuff
CalculateCentroid = function(points)
    local numPoints = #points
    local sumX, sumY, sumZ = 0, 0, 0

    for k, point in ipairs(points) do
        sumX, sumY, sumZ = sumX + point.x, sumY + point.y, sumZ + point.z
    end

    return vec(sumX / numPoints, sumY / numPoints, sumZ / numPoints)
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

-- export functions
InDrugsFarm = function()
    return activeZone and true or false
end

GetActiveZone = function()
    return activeZone or nil
end