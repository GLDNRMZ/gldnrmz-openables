local QBCore = exports['qb-core']:GetCoreObject()

for _, conversion in pairs(Config.ItemsToConvert) do
    QBCore.Functions.CreateUseableItem(conversion.usedItem, function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)

        if not Player then
            return
        end

        local itemFound, itemSlot = Player.Functions.GetItemByName(item.name)

        if not itemFound then
            return
        end

        Player.Functions.RemoveItem(item.name, 1)
        
        local removedItemInfo = QBCore.Shared.Items[item.name]
        if removedItemInfo then
            TriggerClientEvent('qb-inventory:client:ItemBox', source, removedItemInfo, 'remove')
        end

        TriggerClientEvent('lb-openables:client:ProgressBar', source, conversion.prop)

        Wait(5000)

        for _, givenItemData in ipairs(conversion.givenItems) do
            local amount = type(givenItemData.amount) == "table" and math.random(givenItemData.amount[1], givenItemData.amount[2]) or givenItemData.amount
            Player.Functions.AddItem(givenItemData.givenItem, amount)

            local addedItemInfo = QBCore.Shared.Items[givenItemData.givenItem]
            if addedItemInfo then
                TriggerClientEvent('qb-inventory:client:ItemBox', source, addedItemInfo, 'add')
            end
        end

    end)
end
