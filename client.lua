local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('lb-openables:client:ProgressBar')
AddEventHandler('lb-openables:client:ProgressBar', function(propModel)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local prop = nil

    local model = GetHashKey(propModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    prop = CreateObject(model, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 60309), 0.1, 0.0, 0.0, -90.0, 90.0, 0.0, true, true, false, true, 1, true)

    QBCore.Functions.Progressbar("open", "Opening..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'mp_arresting',
        anim = 'a_uncuff',
        flags = 1,
    }, {}, {}, function()
        ClearPedTasks(playerPed)
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end, function()
        QBCore.Functions.Notify("You changed your mind.", "error")
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end)
end)
