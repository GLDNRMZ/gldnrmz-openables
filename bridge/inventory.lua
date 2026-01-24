---@class Inventory
local Inventory = {}
Inventory.type = nil
Inventory._framework = nil

-- Detect available inventory system
local function detectInventory()
    if GetResourceState('ox_inventory') == 'started' then
        return 'ox_inventory'
    else
        return 'framework'
    end
end

-- Initialize the inventory bridge
function Inventory:init(framework)
    self._framework = framework
    local configInventory = Config.Inventory or 'auto'
    
    if configInventory == 'auto' then
        self.type = detectInventory()
    else
        self.type = configInventory
    end
    
    print(string.format("^2[gldnrmz-buyers] Inventory system initialized: %s^7", self.type))
    return self
end

-- Add item to player inventory
function Inventory:addItem(src, item, amount)
    if amount <= 0 then return false end
    
    if self.type == 'ox_inventory' then
        return exports.ox_inventory:AddItem(src, item, amount)
    elseif self.type == 'framework' then
        local player = self._framework._instance.Functions.GetPlayer(src)
        if not player then return false end
        
        if self._framework.type == 'qb' or self._framework.type == 'qbox' then
            return player.Functions.AddItem(item, amount)
        elseif self._framework.type == 'esx' then
            player.addInventoryItem(item, amount)
            return true
        end
    end
    return false
end

-- Remove item from player inventory
function Inventory:removeItem(src, item, amount)
    if amount <= 0 then return false end
    
    if self.type == 'ox_inventory' then
        return exports.ox_inventory:RemoveItem(src, item, amount)
    elseif self.type == 'framework' then
        local player = self._framework._instance.Functions.GetPlayer(src)
        if not player then return false end
        
        if self._framework.type == 'qb' or self._framework.type == 'qbox' then
            return player.Functions.RemoveItem(item, amount)
        elseif self._framework.type == 'esx' then
            player.removeInventoryItem(item, amount)
            return true
        end
    end
    return false
end

-- Get item count in player inventory
function Inventory:getItemCount(src, item)
    if self.type == 'ox_inventory' then
        return exports.ox_inventory:Search(src, 'count', item) or 0
    elseif self.type == 'framework' then
        local player = self._framework._instance.Functions.GetPlayer(src)
        if not player then return 0 end
        
        if self._framework.type == 'qb' or self._framework.type == 'qbox' then
            local itemData = player.Functions.GetItemByName(item)
            return (itemData and itemData.amount) or 0
        elseif self._framework.type == 'esx' then
            local itemData = player.getInventoryItem(item)
            return (itemData and itemData.count) or 0
        end
    end
    return 0
end

-- Check if player can carry item(s)
function Inventory:canCarryItem(src, item, amount)
    if amount <= 0 then return false end
    
    if self.type == 'ox_inventory' then
        return exports.ox_inventory:CanCarryItem(src, item, amount)
    elseif self.type == 'framework' then
        local player = self._framework._instance.Functions.GetPlayer(src)
        if not player then return false end
        
        if self._framework.type == 'qb' or self._framework.type == 'qbox' then
            return player.Functions.CanCarryItem(item, amount)
        elseif self._framework.type == 'esx' then
            -- ESX doesn't have a direct check, so allow it
            return true
        end
    end
    return false
end

-- Get all inventory items
function Inventory:getInventoryItems(src)
    if self.type == 'ox_inventory' then
        return exports.ox_inventory:GetInventoryItems(src) or {}
    elseif self.type == 'framework' then
        local player = self._framework._instance.Functions.GetPlayer(src)
        if not player then return {} end
        
        if self._framework.type == 'qb' or self._framework.type == 'qbox' then
            return player.Functions.GetInventory() or {}
        elseif self._framework.type == 'esx' then
            return player.getInventory() or {}
        end
    end
    return {}
end

return Inventory
