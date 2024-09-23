lib.callback.register('gain-test:spawnObjet', function(test)
    local exists, object = false, nil
    local heading = 0.0
    local model = test[1]
    local coords = test[2]

    print(coords)

    ESX.OneSync.SpawnObject(model, coords, heading, function(obj)
        Wait(100); object = obj; exists = DoesEntityExist(obj) 
    end)
    
    return {
        exists = exists,
        object = object
    }
end)