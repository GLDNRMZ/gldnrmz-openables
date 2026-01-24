# GLDNRMZ: Openables

**QB-Core**

I've seen many different scripts for gift boxes, cigarettes, and ammo boxes. So why not one that does them all. This script will allow you to create any item that can be opened into any amount of configurable items and the amount received per item.

## Features

- ✅ **Customizable Animations** - Define unique animation per item
- ✅ **Bone Attachment** - Attach props to specific player bones
- ✅ **Prop Placement** - Fine-tune positioning and rotation
- ✅ **Security Features** - Rate limiting, job restrictions, inventory validation
- ✅ **Random Item Pools** - Support for randomized loot tables
- ✅ **Performance Optimized** - Pre-loaded models and pre-calculated pools
- ✅ **Detailed Logging** - Track all conversions for admin oversight

## Items 

qb-core/shared/items.lua
```lua
pistolammobox = {name = 'pistolammobox', label = 'Pistol Ammo Box', weight = 200, type = 'item', image = 'pistolammobox.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Bulk Pistol Ammo'},
smgammobox = {name = 'smgammobox', label = 'SMG Ammo Box', weight = 200, type = 'item', image = 'smgammobox.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Bulk SMG Ammo'},
rifleammobox = {name = 'rifleammobox', label = 'Rifle Ammo Box', weight = 200, type = 'item', image = 'rifleammobox.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Bulk Rifle Ammo'},
shotgunammobox = {name = 'shotgunammobox', label = 'Shotgun Ammo Box', weight = 200, type = 'item', image = 'shotgunammobox.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Bulk Shotgun Ammo'},
sniperammobox = {name = 'sniperammobox', label = 'Sniper Ammo Box', weight = 200, type = 'item', image = 'sniperammobox.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Bulk Sniper Ammo'},
giftbox = {name = 'giftbox', label = 'Gift Box', weight = 250, type = 'item', image = 'giftbox.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Box-O-Goodies'},
redwoodcigs = {name = 'redwoodcigs', label = 'Redwood Cigarettes', weight = 250, type = 'item', image = 'redwoodcigs.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Pack of Cigarettes, Made in USA'},
cardiaquecigs = {name = 'cardiaquecigs', label = 'Cardiaque Cigarettes', weight = 250, type = 'item', image = 'cardiaquecigs.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Pack of Cigarettes, Made in USA'},
yukoncigs = {name = 'yukoncigs', label = 'Yukon Cigarettes', weight = 250, type = 'item', image = 'yukoncigs.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Pack of Menthol Cigarettes, Made in USA'},
pdstarterbox = {name = 'pdstarterbox', label = 'PD Starter Box', weight = 200, type = 'item', image = 'pdstarterbox.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Everything your Cadet needs.'},
emsstarterbox = {name = 'emsstarterbox', label = 'EMS Starter Box', weight = 200, type = 'item', image = 'emsstarterbox.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Everything your Trainee needs.'},

--ADD IF NEEDED--
--cigarette = {name = 'cigarette', label = 'Cigarette', weight = 250, type = 'item', image = 'cigarette.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Smokeable Tobacco'},

```

## Config Examples

### Basic Item Conversion
```lua
{
    usedItem = "pistolammobox",
    prop = {
        model = "v_ret_gc_ammo5",           -- Prop to display during animation
        bone = 60309,                       -- Right hand bone
        propPlacement = { 
            x = 0.1, y = 0.0, z = 0.0,    -- Position offset
            rotX = -90.0, rotY = 90.0, rotZ = 0.0  -- Rotation
        },
        animation = { 
            dict = 'mp_arresting',         -- Animation dictionary
            anim = 'a_uncuff',             -- Animation name
            flags = 1                       -- Animation flags
        },
    },
    givenItems = {
        { givenItem = "ammo-45", amount = 100 }
    }
}
```

### Job-Restricted Item (Police Only)
```lua
{
    usedItem = "pdstarterbox",
    job = "police",                        -- Only police can use
    prop = {
        model = "bkr_prop_duffel_bag_01a",
        bone = 60309,
        propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
        animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
    },
    givenItems = {
        { givenItem = "weapon_colbaton", amount = 1 },
        { givenItem = "WEAPON_GLOCK17", amount = 1 },
        { givenItem = "ammo-9", amount = 100 },
        -- ... more items
    }
}
```

### Random Item Pool
```lua
{
    usedItem = "giftbox",
    prop = {
        model = "xm3_prop_xm3_present_01a",
        bone = 60309,
        propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
        animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
    },
    givenItems = {
        random = true,                     -- Enable random selection
        items = 3,                         -- Pick 3 random items
        { givenItem = "lockpick", amount = 4, chance = 50 },      -- 50% chance
        { givenItem = "cigarette", amount = 20, chance = 50 },
        { givenItem = "cash", amount = 4000, chance = 25 },       -- 25% chance
        { givenItem = "cash", amount = 100000, chance = 1 },      -- 1% chance (rare)
        { givenItem = "ammo-9", amount = 100 },                   -- 100% chance (default)
    }
}
```

### Randomized Amount
```lua
{
    usedItem = "markedbills",
    prop = {
        model = "prop_money_bag_01",
        bone = 60309,
        propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
        animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
    },
    givenItems = {
        { givenItem = "black_money", amount = {8000, 12000} }  -- Random 8k-12k
    }
}
```

## Config Reference

### Prop Settings
| Setting | Type | Description |
|---------|------|-------------|
| `model` | string | GTA model name for the prop |
| `bone` | int | Ped bone index (60309 = right hand) |
| `propPlacement.x/y/z` | float | Position offset from bone |
| `propPlacement.rotX/Y/Z` | float | Rotation in degrees |
| `animation.dict` | string | Animation dictionary |
| `animation.anim` | string | Animation name |
| `animation.flags` | int | Animation flags (1 = play once) |

### Item Settings
| Setting | Type | Description |
|---------|------|-------------|
| `usedItem` | string | Item name being opened |
| `job` | string | (Optional) Job required to use |
| `givenItems` | table | Items to give on use |
| `givenItems.random` | bool | Enable random selection |
| `givenItems.items` | int | Number of random items to give |
| `givenItem` | string | Item to give |
| `amount` | int/table | Amount (or {min, max} for range) |
| `chance` | int/float | 0-100 percent or 0-1 decimal |

### Security Settings (config.lua)
```lua
Config.EnableLogging = true           -- Log all conversions
Config.EnableRateLimit = true         -- Prevent spam (cooldown)
Config.GlobalCooldown = 1000          -- Milliseconds between uses
Config.CheckInventorySpace = true     -- Validate inventory space
Config.CheckItemExists = true         -- Verify items exist
Config.JobWhitelistEnabled = true     -- Enforce job restrictions
Config.PreLoadModels = true           -- Pre-load props on startup
```

## Random Selection Logic

- When `random = true` is present, entries are first filtered by `chance` (if provided)
- The list is shuffled and the first `items` entries are selected
- `chance` can be `0–100` (percent) or `0–1` (decimal). If omitted, defaults to `100`
- `amount` supports ranges: use `{min, max}` to get a random amount within the range
