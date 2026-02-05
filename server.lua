local Bridge = exports.community_bridge:Bridge()
local Framework = Bridge.Framework
local Inventory = Bridge.Inventory
local Notify = Bridge.Notify

if not Framework or not Inventory then
    error('[OPENABLES] community_bridge is not ready or missing required modules.')
    return
end

-- Player cooldown tracking
local PlayerCooldowns = {}

-- Utility function for logging
local function GetPlayerName(source)
    local first, last = Framework.GetPlayerName(source)
    if first and last then
        return first .. " " .. last
    end
    return first or last or ("Player " .. tostring(source))
end

local function SendNotify(source, message, _type, time)
    if Notify and Notify.SendNotify then
        Notify.SendNotify(source, message, _type, time)
    else
        print("^3[OPENABLES]^0 Notify fallback: " .. message)
    end
end

local function LogAction(source, action, item, result)
    if not Config.EnableLogging then return end
    local playerName = GetPlayerName(source)
    print("^2[OPENABLES]^0 Player: ^3" .. playerName .. "^0 | Source: ^3" .. source .. "^0 | Action: ^3" .. action .. "^0 | Item: ^3" .. item .. "^0 | Result: ^3" .. result .. "^0")
end

-- Validate item exists (just trust the config, no need to check player inventory during validation)
local function ValidateItem(itemName)
    if not Config.CheckItemExists then return true end
    -- For now, trust that items in config exist. Additional validation could check framework item definitions
    return itemName ~= nil and itemName ~= ""
end

-- Check if player has inventory space
local InventoryResources = {
    'ox_inventory',
    'qb-inventory',
    'ps-inventory',
    'qs-inventory',
    'tgiann-inventory',
    'jpr-inventory',
    'codem-inventory',
    'core_inventory',
    'origen_inventory',
}

local function IsInventoryModuleActive()
    for _, resourceName in ipairs(InventoryResources) do
        if GetResourceState(resourceName) == 'started' then
            return true
        end
    end
    return false
end

local function CanCarryItem(source, itemName, amount)
    if not Config.CheckInventorySpace then return true end
    if not Inventory.CanCarryItem then return true end
    if not IsInventoryModuleActive() then return true end
    local ok, result = pcall(Inventory.CanCarryItem, source, itemName, amount)
    if not ok or result == nil then
        return true
    end
    return result
end

-- Check player cooldown
local function CheckCooldown(source)
    if not Config.EnableRateLimit then return true end
    local now = GetGameTimer()
    if PlayerCooldowns[source] and (now - PlayerCooldowns[source]) < Config.GlobalCooldown then
        return false
    end
    PlayerCooldowns[source] = now
    return true
end

-- Check job whitelist
local function CheckJobWhitelist(source, conversion)
    if not Config.JobWhitelistEnabled then return true end
    if not conversion.job then return true end -- No job restriction = everyone can use

    local playerJob = Framework.GetPlayerJob(source)
    return playerJob == conversion.job
end

-- Pre-load prop models (client-side, triggered when client is ready)
local function PreLoadPropModels()
    if not Config.PreLoadModels then return end
    -- Model preloading happens on client-side in progress bar handler
    print("^2[OPENABLES]^0 Prop models will be loaded on client demand")
end

-- Calculate random item pools once on startup
local PreCalculatedPools = {}
local function PreCalculateRandomPools()
    for idx, conversion in pairs(Config.ItemsToConvert) do
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
            PreCalculatedPools[idx] = pool
        end
    end
end

local function BuildRewards(conversion, conversionIndex)
    local rewards = {}
    local itemsConfig = conversion.givenItems

    if type(itemsConfig) == "table" and itemsConfig.random then
        local pool = PreCalculatedPools[conversionIndex] or {}
        if #pool == 0 then
            -- Fallback if pre-calculation failed
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
            if givenItemData and ValidateItem(givenItemData.givenItem) then
                local amount = type(givenItemData.amount) == "table" and math.random(givenItemData.amount[1], givenItemData.amount[2]) or givenItemData.amount
                rewards[#rewards + 1] = { item = givenItemData.givenItem, amount = amount }
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
                if ValidateItem(givenItemData.givenItem) then
                    local amount = type(givenItemData.amount) == "table" and math.random(givenItemData.amount[1], givenItemData.amount[2]) or givenItemData.amount
                    rewards[#rewards + 1] = { item = givenItemData.givenItem, amount = amount }
                end
            end
        end
    end

    return rewards
end

local function CanReceiveRewards(source, rewards)
    for _, reward in ipairs(rewards) do
        if not CanCarryItem(source, reward.item, reward.amount) then
            return false, reward.item
        end
    end
    return true
end

local function HandleItemUse(source, item, conversion, conversionIndex)
    -- Check rate limit
    if not CheckCooldown(source) then
        SendNotify(source, "You are using items too quickly!", "error", 5000)
        LogAction(source, "BLOCKED", item.name, "Rate limit exceeded")
        return
    end

    -- Check job whitelist
    if not CheckJobWhitelist(source, conversion) then
        SendNotify(source, "You don't have permission to use this item.", "error", 5000)
        LogAction(source, "BLOCKED", item.name, "Job whitelist check failed")
        return
    end

    -- Check item in inventory
    local itemCount = Inventory.GetItemCount(source, item.name)
    if itemCount < 1 then
        LogAction(source, "FAILED", item.name, "Item not found in inventory")
        return
    end

    -- Build rewards and check inventory space before consuming the item
    local rewards = BuildRewards(conversion, conversionIndex)
    local canReceive, blockedItem = CanReceiveRewards(source, rewards)
    if not canReceive then
        LogAction(source, "FAILED", item.name, "Inventory full")
        SendNotify(source, "Inventory full! Open space before using this item.", "error", 5000)
        return
    end

    -- Remove item from inventory
    Inventory.RemoveItem(source, item.name, 1)

    -- Get item's display label for progress bar
    local itemLabel = item.label or item.name
    
    -- Trigger client animation (pass item label for progress bar label)
    TriggerClientEvent('lb-openables:client:ProgressBar', source, conversion.prop.model, conversion.prop.animation.dict, conversion.prop.animation.anim, conversion.prop.animation.flags, conversion.prop.bone, conversion.prop.propPlacement, itemLabel)

    Wait(5000)

    -- Process given items
    for _, reward in ipairs(rewards) do
        local success = Inventory.AddItem(source, reward.item, reward.amount)
        if success then
            LogAction(source, "ADDED", reward.item, "Success")
        else
            LogAction(source, "FAILED", reward.item, "Inventory full")
            SendNotify(source, "Inventory full! Could not receive all items.", "error", 5000)
        end
    end
    
    LogAction(source, "COMPLETED", item.name, "Item conversion finished")
end

for idx, conversion in pairs(Config.ItemsToConvert) do
    Framework.RegisterUsableItem(conversion.usedItem, function(source, itemData)
        itemData = itemData or { name = conversion.usedItem }
        itemData.name = itemData.name or conversion.usedItem
        HandleItemUse(source, itemData, conversion, idx)
    end)
end

-- Validate config on startup
local function ValidateConfig()
    print("^3[OPENABLES]^0 Validating configuration...")
    local errorCount = 0
    
    if not Config.ItemsToConvert or type(Config.ItemsToConvert) ~= "table" then
        print("^1[OPENABLES ERROR]^0 Config.ItemsToConvert is missing or invalid!")
        return false
    end
    
    for idx, conversion in pairs(Config.ItemsToConvert) do
        if not conversion.usedItem or not conversion.prop then
            print("^1[OPENABLES ERROR]^0 Conversion #" .. idx .. " missing usedItem or prop!")
            errorCount = errorCount + 1
        end
        
        if not conversion.givenItems or type(conversion.givenItems) ~= "table" then
            print("^1[OPENABLES ERROR]^0 Conversion #" .. idx .. " (" .. (conversion.usedItem or "unknown") .. ") has invalid givenItems!")
            errorCount = errorCount + 1
        end
    end
    
    if errorCount == 0 then
        print("^2[OPENABLES]^0 Configuration validated successfully! (" .. #Config.ItemsToConvert .. " conversions found)")
        return true
    else
        print("^1[OPENABLES]^0 Configuration validation found " .. errorCount .. " error(s)")
        return false
    end
end

local function CheckVersion()
    -- Run version check asynchronously
    SetTimeout(100, function()
        PerformHttpRequest('https://raw.githubusercontent.com/GLDNRMZ/'..GetCurrentResourceName()..'/main/version.txt', function(errorCode, resultText, resultHeaders)
            if errorCode ~= 200 or not resultText then
                print('^3[OPENABLES]^0 Version check skipped (unable to fetch)')
                return
            end
            
            local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
            local result = resultText:gsub("\r", ""):gsub("\n", "")
            
            if result ~= currentVersion then
                print('^1[OPENABLES]^0 '..GetCurrentResourceName()..' is out of date! Latest: '..result..' | Current: '..currentVersion)
            else
                print('^2[OPENABLES]^0 '..GetCurrentResourceName()..' is up to date! ('..currentVersion..')')
            end
        end, 'GET')
    end)
end

-- Cleanup function for player disconnects
AddEventHandler('playerDropped', function()
    local source = source
    PlayerCooldowns[source] = nil
end)

-- Startup
Citizen.CreateThread(function()
    Wait(500) -- Wait for config to load
    ValidateConfig()
    PreLoadPropModels()
    PreCalculateRandomPools()
    CheckVersion()
end)
