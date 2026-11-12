local Inventory = exports.ox_inventory
local resourceName = GetCurrentResourceName()

local busy = {}     -- [source] = true while a player is opening something
local lastOpen = {} -- [source] = GetGameTimer() of their last open
local itemDefs = {} -- [configured name] = ox_inventory item definition (valid rewards only)

local function notify(source, description, notifyType)
    TriggerClientEvent('ox_lib:notify', source, { title = 'Openables', description = description, type = notifyType or 'error' })
end

local function log(source, message, ...)
    if Config.Debug then lib.print.info(('[%s] %s'):format(source, message)) end
    if Config.Logging then lib.logger(source, 'openables', message, ...) end
end

---------------------
-- Reward rolling  --
---------------------

-- chance is a percent (1-100). Values between 0 and 1 are read as fractions (0.25 = 25%).
local function rollChance(chance)
    chance = chance or 100
    if chance > 0 and chance < 1 then chance = chance * 100 end
    return math.random() * 100 < chance
end

local function rollAmount(amount)
    if type(amount) == 'table' then return math.random(amount[1], amount[2]) end
    return amount or 1
end

--- Rolls a fresh set of rewards for one open.
---@return { name: string, count: integer, weight: number }[]
local function rollRewards(rewards)
    local pool = {}

    for i = 1, #rewards do
        local entry = rewards[i]
        if itemDefs[entry.item] and rollChance(entry.chance) then
            pool[#pool + 1] = entry
        end
    end

    -- "pick" mode: keep a random subset of whatever passed its chance roll
    if rewards.pick then
        local count = math.min(rewards.pick, #pool)
        for i = 1, count do
            local j = math.random(i, #pool)
            pool[i], pool[j] = pool[j], pool[i]
        end
        for i = #pool, count + 1, -1 do pool[i] = nil end
    end

    -- Merge duplicates (e.g. two money rolls) into one add
    local result, byName = {}, {}
    for i = 1, #pool do
        local def = itemDefs[pool[i].item]
        local name = def.name
        local amount = rollAmount(pool[i].amount)

        if byName[name] then
            byName[name].count += amount
        else
            byName[name] = { name = name, count = amount, weight = def.weight or 0 }
            result[#result + 1] = byName[name]
        end
    end

    return result
end

local function canCarry(source, rewards, freedWeight)
    if not Config.CheckInventorySpace then return true end

    local weight = 0
    for i = 1, #rewards do
        local reward = rewards[i]
        if not Inventory:CanCarryItem(source, reward.name, reward.count) then return false end
        weight += reward.weight * reward.count
    end

    return Inventory:CanCarryWeight(source, weight - freedWeight)
end

local function giveRewards(source, rewards)
    local leftovers = {}

    for i = 1, #rewards do
        local reward = rewards[i]
        if Inventory:AddItem(source, reward.name, reward.count) then
            log(source, ('received %dx %s'):format(reward.count, reward.name), 'item:' .. reward.name)
        else
            leftovers[#leftovers + 1] = { reward.name, reward.count }
        end
    end

    -- Never lose rewards: anything that would not fit goes on the ground
    if #leftovers > 0 then
        local ped = GetPlayerPed(source)
        Inventory:CustomDrop('Openable', leftovers, GetEntityCoords(ped), nil, nil, GetPlayerRoutingBucket(source))
        notify(source, 'Some items did not fit and were dropped at your feet.', 'inform')
        log(source, ('dropped %d reward(s) on the ground'):format(#leftovers))
    end
end

-------------
-- Opening --
-------------

local function open(source, itemName, slot)
    local openable = Config.Openables[itemName]
    local now = GetGameTimer()

    if busy[source] then return end

    if lastOpen[source] and now - lastOpen[source] < Config.Cooldown then
        return notify(source, 'You are opening items too quickly.')
    end

    if openable.job and not exports.qbx_core:HasGroup(source, openable.job) then
        return notify(source, "You don't have permission to open this.")
    end

    local slotData = Inventory:GetSlot(source, slot.slot)
    if not slotData or slotData.name ~= itemName then return end

    local rewards = rollRewards(openable.rewards)
    local unitWeight = (slotData.weight or 0) / math.max(slotData.count or 1, 1)

    if not canCarry(source, rewards, unitWeight) then
        return notify(source, 'Your inventory is too full to open this.')
    end

    busy[source] = true
    lastOpen[source] = now

    local label = slotData.metadata?.label or slot.label or itemName
    local finished = lib.callback.await('gldnrmz-openables:open', source, itemName, label)
    local elapsed = GetGameTimer() - now

    if not busy[source] then return end -- player left mid-open
    busy[source] = nil

    if not finished then return end

    -- The client reports success; make sure it actually waited the full duration
    if elapsed < openable.duration * 0.9 then
        lib.print.warn(('player %s finished opening %s in %dms (expected %dms)'):format(source, itemName, elapsed, openable.duration))
        log(source, ('skipped progress bar on %s'):format(itemName), 'exploit')
        return
    end

    -- Consume from the exact slot used. Fails if the item moved or was dropped meanwhile.
    if not Inventory:RemoveItem(source, itemName, 1, nil, slot.slot) then
        return notify(source, 'The item is no longer in your inventory.')
    end

    log(source, ('opened %s'):format(itemName), 'item:' .. itemName)

    if #rewards == 0 then
        return notify(source, 'It was empty.', 'inform')
    end

    giveRewards(source, rewards)
end

-------------
-- Startup --
-------------

local function validateRewards()
    local missing = {}

    for openableName, openable in pairs(Config.Openables) do
        if not Inventory:Items(openableName) then
            missing[#missing + 1] = ('%s (the openable itself)'):format(openableName)
        end

        for i = 1, #openable.rewards do
            local name = openable.rewards[i].item
            local def = Inventory:Items(name)

            if def then
                itemDefs[name] = def
            elseif not itemDefs[name] then
                itemDefs[name] = false
                missing[#missing + 1] = ('%s (reward in %s)'):format(name, openableName)
            end
        end
    end

    for i = 1, #missing do
        lib.print.warn(('item "%s" is not registered in ox_inventory and will be skipped'):format(missing[i]))
    end
end

local function parseVersion(version)
    local major, minor, patch = (version or ''):match('(%d+)%.(%d+)%.(%d+)')
    return (tonumber(major) or 0) * 1e6 + (tonumber(minor) or 0) * 1e3 + (tonumber(patch) or 0)
end

local function checkVersion()
    local url = ('https://raw.githubusercontent.com/GLDNRMZ/%s/main/version.txt'):format(resourceName)

    PerformHttpRequest(url, function(status, body)
        if status ~= 200 or not body then return end

        local latest = body:gsub('%s', '')
        local current = GetResourceMetadata(resourceName, 'version', 0)

        if parseVersion(latest) > parseVersion(current) then
            lib.print.warn(('update available: %s (running %s)'):format(latest, current))
        end
    end, 'GET')
end

validateRewards()

for itemName in pairs(Config.Openables) do
    exports.qbx_core:CreateUseableItem(itemName, function(source, slot)
        -- Run outside ox_inventory's useItem callback so it is not held open for the whole animation
        CreateThread(function() open(source, itemName, slot) end)
    end)
end

AddEventHandler('playerDropped', function()
    busy[source] = nil
    lastOpen[source] = nil
end)

if Config.VersionCheck then checkVersion() end
