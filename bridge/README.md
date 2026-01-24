# Framework Bridge System

This folder contains framework-agnostic bridges that allow the gldnrmz-buyers script to work with multiple frameworks without code duplication.

## Overview

The bridge pattern abstracts framework-specific logic into unified interfaces, allowing the main script code to remain framework-agnostic. Configuration in `config.lua` determines which framework/inventory/target system to use.

## Bridge Files

### framework.lua (Server-Side)
Abstracts QB-Core, QBox, and ESX frameworks with a unified interface.

**Unified Methods:**
- `init()` - Initialize framework detection/configuration
- `getPlayerMoney(src)` - Get player cash amount
- `addMoney(src, amount)` - Add cash to player
- `removeMoney(src, amount)` - Remove cash from player
- `notify(src, title, desc, type)` - Send notification to player
- `getPlayerJob(src)` - Get player's job name
- `getPlayerName(src)` - Get player's display name

**Supported Frameworks:**
- QB-Core (qb-core)
- QBox (qbox)
- ESX (es_extended)

**Auto-Detection Order:** qb-core → qbox → es_extended

### target.lua (Client-Side)
Abstracts ox_target and qb-target interaction systems.

**Unified Methods:**
- `init()` - Initialize target system detection
- `addModel(model, options)` - Add interaction target to model
- `removeModel(model)` - Remove interaction from model
- `addEntity(entity, options)` - Add interaction to specific entity
- `removeEntity(entity, targetName)` - Remove interaction from entity
- `addBox(coords, size, options)` - Add interaction zone

**Supported Systems:**
- ox_target (ox_target)
- qb-target (qb-target)

**Auto-Detection Order:** ox_target → qb-target

### inventory.lua (Server-Side)
Abstracts ox_inventory and framework-native inventory systems.

**Unified Methods:**
- `init(framework)` - Initialize inventory system detection
- `addItem(src, item, amount)` - Add item to player
- `removeItem(src, item, amount)` - Remove item from player
- `getItemCount(src, item)` - Get item quantity in inventory
- `canCarryItem(src, item, amount)` - Check if player has room
- `getInventoryItems(src)` - Get all inventory items

**Supported Systems:**
- ox_inventory (ox_inventory)
- Framework-native inventory (QB-Core, QBox, ESX)

**Auto-Detection Order:** ox_inventory → framework-native

## Configuration

Edit `config.lua` to control framework selection:

```lua
Config.Framework = 'auto'    -- 'auto', 'qb', 'qbox', 'esx', 'none'
Config.Target = 'auto'       -- 'auto', 'ox_target', 'qb-target', 'none'
Config.Inventory = 'auto'    -- 'auto', 'ox_inventory', 'framework', 'none'
```

**Auto Mode:** Automatically detects and uses available frameworks in priority order (recommended).

**Manual Mode:** Set to specific framework name to force that system.

**None Mode:** Disables the system entirely (if supported).

## Usage Examples

### Server-Side

```lua
-- Load bridges
local function loadBridge(file)
    local code = LoadResourceFile(GetCurrentResourceName(), 'bridge/' .. file)
    if not code then error('Failed to load bridge/' .. file) end
    return load(code)()
end

local Framework = loadBridge('framework.lua')
Framework:init()

local Inventory = loadBridge('inventory.lua')
Inventory:init(Framework)

-- Use unified methods
Framework:addMoney(playerId, 5000)
Framework:notify(playerId, 'Success', 'Money received!', 'success')
Inventory:addItem(playerId, 'diamond', 1)
```

### Client-Side

```lua
-- Load bridge
local function loadBridge(file)
    local code = LoadResourceFile(GetCurrentResourceName(), 'bridge/' .. file)
    if not code then error('Failed to load bridge/' .. file) end
    return load(code)()
end

local Target = loadBridge('target.lua')
Target:init()

-- Use unified methods
Target:addEntity(pedEntity, {
    {
        name = "my_interaction",
        label = "Interact",
        icon = "fa-solid fa-hand",
        onSelect = function() print("Interacted!") end
    }
})
```

## Implementation Notes

### Framework Bridge
- Uses internal `getPlayer(src)` helper to get framework player objects
- Handles QB-Core/QBox's "PlayerData.money.cash" vs ESX's "getMoney()"
- All money operations work with cash/bank automatically

### Target Bridge
- Normalizes option structures between systems
- ox_target options pass through unchanged
- qb-target options are converted from ox_target format
- Server events are automatically converted to correct format

### Inventory Bridge
- Handles both ox_inventory exports and framework-native methods
- Compatible with QB's item "amount" and ESX's "count" field names
- Graceful fallback for systems without carry capacity checks

## Adding New Framework Support

1. Add framework detection to `detectFramework()` in framework.lua
2. Add method implementations in `getPlayer()` and other functions
3. Follow existing patterns for consistency
4. Test with new framework

## Troubleshooting

**Framework not detected:** Check resource names and ensure they're started before this script.

**Inventory not working:** Verify ox_inventory is started or framework is properly initialized.

**Target interactions not showing:** Ensure target resource is running and system type is detected correctly.

**Check logs:** Initialize prints detection results - check console for `^2[gldnrmz-buyers]` messages.

## Migration Guide

### Replacing Direct Framework Calls

❌ **Old Code:**
```lua
local Player = exports['qb-core']:GetCoreObject().Functions.GetPlayer(src)
Player.Functions.AddMoney('cash', amount)
exports.ox_inventory:RemoveItem(src, item, amount)
```

✅ **New Code:**
```lua
Framework:addMoney(src, amount)
Inventory:removeItem(src, item, amount)
```

## Performance

- Bridges use caching for framework objects (stored in `self._instance`)
- Detection only runs once at resource start
- No overhead on subsequent calls (direct method dispatch)
