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

        local itemsConfig = conversion.givenItems
        if type(itemsConfig) == "table" and itemsConfig.random then
            local pool = {}
            for _, itemData in ipairs(itemsConfig) do
                local chance = itemData.chance ~= nil and itemData.chance or 100
                if chance > 0 and chance < 1 then
                    chance = chance * 100
                end
                chance = math.max(0, math.min(chance, 100))
                if math.random(100) <= chance then
                    pool[#pool + 1] = itemData
                end
            end

            local count = tonumber(itemsConfig.items) or 1
            if count > #pool then
                count = #pool
            end

            for i = #pool, 2, -1 do
                local j = math.random(1, i)
                pool[i], pool[j] = pool[j], pool[i]
            end

            for i = 1, count do
                local givenItemData = pool[i]
                if givenItemData then
                    local amount = type(givenItemData.amount) == "table" and math.random(givenItemData.amount[1], givenItemData.amount[2]) or givenItemData.amount
                    Player.Functions.AddItem(givenItemData.givenItem, amount)

                    local addedItemInfo = QBCore.Shared.Items[givenItemData.givenItem]
                    if addedItemInfo then
                        TriggerClientEvent('qb-inventory:client:ItemBox', source, addedItemInfo, 'add')
                    end
                end
            end
        else
            for _, givenItemData in ipairs(itemsConfig) do
                local chance = givenItemData.chance ~= nil and givenItemData.chance or 100
                if chance > 0 and chance < 1 then
                    chance = chance * 100
                end
                chance = math.max(0, math.min(chance, 100))
                if math.random(100) <= chance then
                    local amount = type(givenItemData.amount) == "table" and math.random(givenItemData.amount[1], givenItemData.amount[2]) or givenItemData.amount
                    Player.Functions.AddItem(givenItemData.givenItem, amount)

                    local addedItemInfo = QBCore.Shared.Items[givenItemData.givenItem]
                    if addedItemInfo then
                        TriggerClientEvent('qb-inventory:client:ItemBox', source, addedItemInfo, 'add')
                    end
                end
            end
        end

    end)
end
