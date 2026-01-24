-- Bridge Loader
local function loadBridge(file)
    local code = LoadResourceFile(GetCurrentResourceName(), 'bridge/' .. file)
    if not code then
        error('Failed to load bridge/' .. file)
        return nil
    end
    return load(code)()
end

-- Initialize Bridges
local Framework = loadBridge('framework.lua')
Framework:init()

local Inventory = loadBridge('inventory.lua')
Inventory:init(Framework)

-- Player cooldown tracking
local PlayerCooldowns = {}

-- Utility function for logging
local function LogAction(source, action, item, result)
    if not Config.EnableLogging then return end
    local playerName = Framework:getPlayerName(source)
    print("^2[OPENABLES]^0 Player: ^3" .. playerName .. "^0 | Source: ^3" .. source .. "^0 | Action: ^3" .. action .. "^0 | Item: ^3" .. item .. "^0 | Result: ^3" .. result .. "^0")
end

-- Validate item exists (just trust the config, no need to check player inventory during validation)
local function ValidateItem(itemName)
    if not Config.CheckItemExists then return true end
    -- For now, trust that items in config exist. Additional validation could check framework item definitions
    return itemName ~= nil and itemName ~= ""
end

-- Check if player has inventory space
local function HasInventorySpace(source, requiredSlots)
    if not Config.CheckInventorySpace then return true end
    -- Try to add and immediately remove to test space
    local canCarry = Inventory:canCarryItem(source, 'cash', 1)
    return canCarry
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
    
    local playerJob = Framework:getPlayerJob(source)
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

for _, conversion in pairs(Config.ItemsToConvert) do
    if Framework.type == 'qb' or Framework.type == 'qbox' then
        -- QB-Core and QBox use CreateUseableItem
        local QBCore = Framework._instance
        QBCore.Functions.CreateUseableItem(conversion.usedItem, function(source, item)
            HandleItemUse(source, item, conversion)
        end)
    elseif Framework.type == 'esx' then
        -- ESX uses item callbacks
        TriggerEvent('esx:registerUsableItem', conversion.usedItem, function(source)
            HandleItemUse(source, {name = conversion.usedItem}, conversion)
        end)
    end
end

function HandleItemUse(source, item, conversion)
    -- Check rate limit
    if not CheckCooldown(source) then
        Framework:notify(source, "Error", "You are using items too quickly!", "error")
        LogAction(source, "BLOCKED", item.name, "Rate limit exceeded")
        return
    end

    -- Check job whitelist
    if not CheckJobWhitelist(source, conversion) then
        Framework:notify(source, "Error", "You don't have permission to use this item.", "error")
        LogAction(source, "BLOCKED", item.name, "Job whitelist check failed")
        return
    end

    -- Check item in inventory
    local itemCount = Inventory:getItemCount(source, item.name)
    if itemCount < 1 then
        LogAction(source, "FAILED", item.name, "Item not found in inventory")
        return
    end

    -- Remove item from inventory
    Inventory:removeItem(source, item.name, 1)

    -- Get item's display label for progress bar
    local itemLabel = item.label or item.name
    
    -- Trigger client animation (pass item label for progress bar label)
    TriggerClientEvent('lb-openables:client:ProgressBar', source, conversion.prop.model, conversion.prop.animation.dict, conversion.prop.animation.anim, conversion.prop.animation.flags, conversion.prop.bone, conversion.prop.propPlacement, itemLabel)

    Wait(5000)

    -- Process given items
    local itemsConfig = conversion.givenItems
    if type(itemsConfig) == "table" and itemsConfig.random then
        local pool = PreCalculatedPools[_] or {}
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
            if givenItemData then
                -- Validate item before adding
                if not ValidateItem(givenItemData.givenItem) then
                    goto continue
                end
                
                local amount = type(givenItemData.amount) == "table" and math.random(givenItemData.amount[1], givenItemData.amount[2]) or givenItemData.amount
                local success = Inventory:addItem(source, givenItemData.givenItem, amount)
                
                if success then
                    LogAction(source, "ADDED", givenItemData.givenItem, "Success")
                else
                    LogAction(source, "FAILED", givenItemData.givenItem, "Inventory full")
                    Framework:notify(source, "Error", "Inventory full! Could not receive all items.", "error")
                end
                
                ::continue::
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
                -- Validate item before adding
                if not ValidateItem(givenItemData.givenItem) then
                    goto skip_item
                end
                
                local amount = type(givenItemData.amount) == "table" and math.random(givenItemData.amount[1], givenItemData.amount[2]) or givenItemData.amount
                local success = Inventory:addItem(source, givenItemData.givenItem, amount)
                
                if success then
                    LogAction(source, "ADDED", givenItemData.givenItem, "Success")
                else
                    LogAction(source, "FAILED", givenItemData.givenItem, "Inventory full")
                    Framework:notify(source, "Error", "Inventory full! Could not receive all items.", "error")
                end
                
                ::skip_item::
            end
        end
    end
    
    LogAction(source, "COMPLETED", item.name, "Item conversion finished")
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
