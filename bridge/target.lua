---@class Target
local Target = {}
Target.type = nil

-- Detect available target system
local function detectTarget()
    if GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        return 'qb-target'
    end
    return 'none'
end

-- Initialize the target bridge
function Target:init()
    local configTarget = Config.Target or 'auto'
    
    if configTarget == 'auto' then
        self.type = detectTarget()
    else
        self.type = configTarget
    end
    
    if self.type == 'none' then
        print("^3[gldnrmz-buyers] No target system detected. Targeting disabled.^7")
    else
        print(string.format("^2[gldnrmz-buyers] Target system initialized: %s^7", self.type))
    end
    return self
end

-- Normalize options for different target systems
local function normalizeOptions(options)
    if Target.type == 'ox_target' then
        return options
    elseif Target.type == 'qb-target' then
        -- Convert ox_target options to qb-target format
        local qbOptions = {}
        for _, option in ipairs(options) do
            local qbOption = {
                num = option.name or 'option',
                type = 'client',
                event = option.event,
                icon = option.icon,
                label = option.label,
                targeticon = option.icon,
                canInteract = option.canInteract,
                action = option.action,
            }
            
            -- Handle server events
            if option.serverEvent then
                qbOption.type = 'server'
                qbOption.event = option.serverEvent
            end
            
            table.insert(qbOptions, qbOption)
        end
        return qbOptions
    end
    return options
end

-- Add target to model
function Target:addModel(model, options)
    if self.type == 'none' then return end
    
    local normalizedOptions = normalizeOptions(options)
    
    if self.type == 'ox_target' then
        exports.ox_target:addModel(model, normalizedOptions)
    elseif self.type == 'qb-target' then
        exports['qb-target']:AddTargetModel(model, {
            options = normalizedOptions,
            distance = 2.0
        })
    end
end

-- Remove target from model
function Target:removeModel(model)
    if self.type == 'none' then return end
    
    if self.type == 'ox_target' then
        exports.ox_target:removeModel(model)
    elseif self.type == 'qb-target' then
        exports['qb-target']:RemoveTargetModel(model)
    end
end

-- Add target to entity
function Target:addEntity(entity, options)
    if self.type == 'none' then return end
    
    local normalizedOptions = normalizeOptions(options)
    
    if self.type == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, normalizedOptions)
    elseif self.type == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = normalizedOptions,
            distance = 2.0
        })
    end
end

-- Remove target from entity
function Target:removeEntity(entity, targetName)
    if self.type == 'none' then return end
    
    if self.type == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity, targetName)
    elseif self.type == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity)
    end
end

-- Add target to box (area)
function Target:addBox(coords, size, options)
    if self.type == 'none' then return end
    
    local normalizedOptions = normalizeOptions(options)
    
    if self.type == 'ox_target' then
        exports.ox_target:addBoxZone({
            coords = coords,
            size = size,
            options = normalizedOptions,
            distance = 2.0
        })
    elseif self.type == 'qb-target' then
        exports['qb-target']:AddBoxZone(
            'zone_' .. tostring(coords),
            coords,
            size.x,
            size.y,
            {
                name = 'zone_' .. tostring(coords),
                heading = 0,
                debugPoly = false,
            },
            {
                options = normalizedOptions,
                distance = 2.0
            }
        )
    end
end

return Target
