# GLDNRMZ: Openables

**QB-Core**

I've seen many differnt scripts for gift boxes, cigarettes, and ammo boxes. So why not one that does them all. This script will allow you to create any item that can be opened into any amount of configurable items and the amount received per item. 

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

**Config**
```lua
    {
        usedItem = "pistolammobox", -- Name of item being opened
        prop = "v_ret_gc_ammo5", -- Name of prop (you can comment out if you dont want to use a prop)
        givenItems = {
            { givenItem = "pistol_ammo", amount = 4 }, -- Items and amounts given
            -- You can add any additional items below and the amounts.
        }
    },
```

* [preview]

**You have permission to use this in your server and edit for your personal needs but are not allowed to redistribute.**
