local lib = exports.ox_lib

RegisterNetEvent('lb-openables:client:ProgressBar')
AddEventHandler('lb-openables:client:ProgressBar', function(propModel, animDict, animName, animFlags, boneId, propPlacement, itemName)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local prop = nil

    -- Use defaults if not provided
    animDict = animDict or 'mp_arresting'
    animName = animName or 'a_uncuff'
    animFlags = animFlags or 1
    boneId = boneId or 60309
    propPlacement = propPlacement or { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 }
    itemName = itemName or 'Item'

    local model = GetHashKey(propModel)
    
    -- Validate model hash
    if model == 0 then
        if Config.Debug then
            print("^1[OPENABLES]^0 Invalid prop model: " .. propModel)
        end
        return
    end
    
    -- Load model
    RequestModel(model)
    local modelTimeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > modelTimeout then
            if Config.Debug then
                print("^1[OPENABLES]^0 Failed to load prop model: " .. propModel)
            end
            return
        end
        Wait(10)
    end

    -- Create prop object
    prop = CreateObject(model, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    
    if not DoesEntityExist(prop) then
        if Config.Debug then
            print("^1[OPENABLES]^0 Failed to create prop object")
        end
        return
    end
    
    -- Attach prop to player bone
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, boneId), 
        propPlacement.x, propPlacement.y, propPlacement.z, 
        propPlacement.rotX, propPlacement.rotY, propPlacement.rotZ, 
        true, true, false, true, 1, true)

    -- Request animation dict
    RequestAnimDict(animDict)
    local animTimeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(animDict) do
        if GetGameTimer() > animTimeout then
            if Config.Debug then
                print("^1[OPENABLES]^0 Failed to load animation dict: " .. animDict)
            end
            if DoesEntityExist(prop) then
                DeleteEntity(prop)
            end
            return
        end
        Wait(10)
    end
    
    -- Play animation
    TaskPlayAnim(playerPed, animDict, animName, 8.0, 8.0, 5000, animFlags, 0, false, false, false)
    RemoveAnimDict(animDict)
    
    -- Show progress bar
    if GetResourceState('ox_lib') == 'started' then
        local startTime = GetGameTimer()
        exports['ox_lib']:progressBar({
            duration = 5000,
            label = 'Opening ' .. itemName .. '...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = false,
                move = true,
                combat = true,
            },
        })
    end
    
    -- Clean up - stop animation and delete prop
    ClearPedTasks(playerPed)
    if DoesEntityExist(prop) then
        DetachEntity(prop, true, false)
        DeleteEntity(prop)
    end
end)
