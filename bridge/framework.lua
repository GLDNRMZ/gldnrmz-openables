---@class Framework
local Framework = {}
Framework.type = nil
Framework._instance = nil

-- Detect available framework
local function detectFramework()
    if GetResourceState('qb-core') == 'started' then
        return 'qb', exports['qb-core']:GetCoreObject()
    elseif GetResourceState('qbox') == 'started' then
        return 'qbox', exports['qbox']:GetCoreObject()
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx', exports['es_extended']:getSharedObject()
    end
    return 'none', nil
end

-- Initialize the framework bridge
function Framework:init()
    local configFramework = Config.Framework or 'auto'
    
    if configFramework == 'auto' then
        self.type, self._instance = detectFramework()
    else
        self.type = configFramework
        
        if self.type == 'qb' then
            self._instance = exports['qb-core']:GetCoreObject()
        elseif self.type == 'qbox' then
            self._instance = exports['qbox']:GetCoreObject()
        elseif self.type == 'esx' then
            self._instance = exports['es_extended']:getSharedObject()
        end
    end
    
    print(string.format("^2[gldnrmz-buyers] Framework initialized: %s^7", self.type))
    return self
end

-- Get player object based on framework
local function getPlayer(src)
    if not Framework._instance then return nil end
    
    if Framework.type == 'qb' or Framework.type == 'qbox' then
        return Framework._instance.Functions.GetPlayer(src)
    elseif Framework.type == 'esx' then
        return Framework._instance.GetPlayerFromId(src)
    end
    return nil
end

-- Get player money
function Framework:getPlayerMoney(src)
    local player = getPlayer(src)
    if not player then return 0 end
    
    if self.type == 'qb' or self.type == 'qbox' then
        return player.PlayerData.money.cash or 0
    elseif self.type == 'esx' then
        return player.getMoney() or 0
    end
    return 0
end

-- Add money to player
function Framework:addMoney(src, amount)
    if amount <= 0 then return false end
    
    local player = getPlayer(src)
    if not player then return false end
    
    if self.type == 'qb' or self.type == 'qbox' then
        player.Functions.AddMoney('cash', amount)
        return true
    elseif self.type == 'esx' then
        player.addMoney(amount)
        return true
    end
    return false
end

-- Remove money from player
function Framework:removeMoney(src, amount)
    if amount <= 0 then return false end
    
    local player = getPlayer(src)
    if not player then return false end
    
    if self.type == 'qb' or self.type == 'qbox' then
        player.Functions.RemoveMoney('cash', amount)
        return true
    elseif self.type == 'esx' then
        player.removeMoney(amount)
        return true
    end
    return false
end

-- Send notification to player
function Framework:notify(src, title, desc, notificationType)
    if self.type == 'qb' or self.type == 'qbox' then
        TriggerClientEvent('QBCore:Notify', src, desc, notificationType or 'primary')
    elseif self.type == 'esx' then
        TriggerClientEvent('esx:showNotification', src, desc)
    else
        TriggerClientEvent('ox_lib:notify', src, { type = notificationType or 'info', description = desc })
    end
end

-- Get player job
function Framework:getPlayerJob(src)
    local player = getPlayer(src)
    if not player then return nil end
    
    if self.type == 'qb' or self.type == 'qbox' then
        return player.PlayerData.job.name
    elseif self.type == 'esx' then
        return player.getJob().name
    end
    return nil
end

-- Get player name
function Framework:getPlayerName(src)
    local player = getPlayer(src)
    if not player then return 'Unknown' end
    
    if self.type == 'qb' or self.type == 'qbox' then
        return player.PlayerData.name
    elseif self.type == 'esx' then
        return player.getName()
    end
    return 'Unknown'
end

return Framework
