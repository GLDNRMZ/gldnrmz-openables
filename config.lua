Config = {}

-- Framework Configuration
Config.Framework = 'auto'  -- 'auto' = auto-detect, 'qb' = QB-Core, 'qbox' = QBox, 'esx' = ESX, 'none' = standalone
Config.Inventory = 'auto'  -- 'auto' = auto-detect, 'ox_inventory', 'framework', 'none'

-- Security & Performance Settings
Config.EnableLogging = false                -- Enable detailed logging of conversions
Config.EnableRateLimit = true              -- Enable cooldown system
Config.GlobalCooldown = 1000               -- Milliseconds between uses (prevents spam)
Config.CheckInventorySpace = true          -- Validate inventory space before adding items
Config.CheckItemExists = true              -- Verify items exist in database
Config.JobWhitelistEnabled = true          -- Enable job restrictions for starter kits
Config.PreLoadModels = true                -- Pre-load prop models on startup
Config.Debug = false                       -- Enable debug messages

Config.ItemsToConvert = {
    --------------
    --AMMO BOXES--
    --------------
    {
        usedItem = "pistolammobox",
        prop = {
            model = "v_ret_gc_ammo5",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "ammo-45", amount = 100 }
        }
    },
    {
        usedItem = "smgammobox",
        prop = {
            model = "v_ret_gc_ammo5",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "ammo-9", amount = 100 }
        }
    },
    {
        usedItem = "rifleammobox",
        prop = {
            model = "v_ret_gc_ammo4",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "ammo-rifle", amount = 80 }
        }
    },
    {
        usedItem = "shotgunammobox",
        prop = {
            model = "prop_ld_ammo_pack_02",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "ammo-shotgun", amount = 20 }
        }
    },
    {
        usedItem = "sniperammobox",
        prop = {
            model = "v_ret_gc_ammo4",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "ammo-sniper", amount = 40 }
        }
    },

    {
        usedItem = "pdstarterbox",
        job = "police",
        prop = {
            model = "bkr_prop_duffel_bag_01a",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "weapon_colbaton", amount = 1 },
            { givenItem = "WEAPON_GLOCK17", amount = 1 },
            { givenItem = "WEAPON_TASER", amount = 1 },
            { givenItem = "ammo-9", amount = 100 },
            { givenItem = "ammo_taser", amount = 10 },
            { givenItem = "handcuffs", amount = 1 },
            { givenItem = "ifaks", amount = 5 },
            { givenItem = "weapon_flashlight", amount = 1 },
            { givenItem = "empty_evidence_bag", amount = 20 },
            { givenItem = "radio", amount = 1 },
            { givenItem = "heavyarmor", amount = 5 },
            { givenItem = "evidence_camera", amount = 1 },
            { givenItem = "policetablet", amount = 1 },
            { givenItem = "body_cam", amount = 1 },
            { givenItem = "notepad", amount = 1 },
            { givenItem = "policepouches", amount = 1 },
            { givenItem = "camera", amount = 1 },
            { givenItem = "gsr_test_kit", amount = 3 },
            { givenItem = "uv_light", amount = 1 },
            { givenItem = "dnaswab", amount = 3 },
            { givenItem = "spike_strip", amount = 1 },
        }
    },
    {
        usedItem = "emsstarterbox",
        job = "ems",
        prop = {
            model = "xm_prop_x17_bag_med_01a",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "medbag", amount = 1 },
            { givenItem = "defib", amount = 20 },
            { givenItem = "medikit", amount = 20 },
            { givenItem = "radio", amount = 1 },
            { givenItem = "weapon_flashlight", amount = 1 },
            { givenItem = "fitbit", amount = 1 },
            { givenItem = "ems_mdt", amount = 1 },
        }
    },
    --------------
    --CIGARETTES--
    --------------
    {
        usedItem = "redwoodcigs",
        prop = {
            model = "v_ret_ml_cigs",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "cigarette", amount = 20 }
        }
    },
    {
        usedItem = "cardiaquecigs",
        prop = {
            model = "v_ret_ml_cigs5",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "cigarette", amount = 20 }
        }
    },
    {
        usedItem = "debonairecigs",
        prop = {
            model = "v_ret_ml_cigs3",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "cigarette", amount = 20 }
        }
    },

    --------------
    --MARKEDBILLS-
    --------------
    {
        usedItem = "markedbills",
        prop = {
            model = "prop_money_bag_01",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "black_money", amount = {8000,12000} }
        }
    },

    {
        usedItem = "markedbills2",
        prop = {
            model = "prop_money_bag_01",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            { givenItem = "black_money", amount = {20000,25000} }
        }
    },
    ------------
    --Random BOX--
    ------------
    {
        usedItem = "giftbox",
        prop = {
            model = "xm3_prop_xm3_present_01a",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            random = true,
            items = 3,
            { givenItem = "lockpick", amount = 4, chance = 50 },
            { givenItem = "cigarette", amount = 20, chance = 50 },
            { givenItem = "plastic", amount = 50, chance = 50 },
            { givenItem = "rubber", amount = 50, chance = 50 },
            { givenItem = "glass", amount = 50, chance = 50 },
            { givenItem = "aluminum", amount = 50, chance = 50 },
            { givenItem = "iron", amount = 50, chance = 50 },
            { givenItem = "ammo-9", amount = 100, chance = 50 },
            { givenItem = "advancedlockpick", amount = 4, chance = 25 },
            { givenItem = "cash", amount = 4000, chance = 25 },
            { givenItem = "cash", amount = 50000, chance = 2 },
            { givenItem = "cash", amount = 100000, chance = 1 },
            { givenItem = "customizableplate", amount = 1, chance = 3 },
            { givenItem = "shitgpu", amount = 1, chance = 10 },
            { givenItem = "1050gpu", amount = 1, chance = 10 },
            { givenItem = "1060gpu", amount = 1, chance = 5 },
            { givenItem = "1080gpu", amount = 1, chance = 5 },
            { givenItem = "2080gpu", amount = 1, chance = 3 },
            { givenItem = "3060gpu", amount = 1, chance = 3 },
            { givenItem = "4090gpu", amount = 1, chance = 1 },
            { givenItem = "5090gpu", amount = 1, chance = 1 },
            { givenItem = "knife_crate", amount = 1, chance = 3 },
            { givenItem = "knife_crate2", amount = 1, chance = 3 },
            { givenItem = "knife_crate3", amount = 1, chance = 3 },
            { givenItem = "racingtablet", amount = 1, chance = 3 },
            { givenItem = "boostingtablet", amount = 1, chance = 3 },
            { givenItem = "x_device", amount = 1, chance = 5 },
            { givenItem = "x_circuittester", amount = 1, chance = 5 },
            { givenItem = "x_harddrive", amount = 1, chance = 5 },
            { givenItem = "thermite", amount = 1, chance = 5 },
            { givenItem = "x_trojanusb2", amount = 1, chance = 5 },
            { givenItem = "x_laptop", amount = 1, chance = 5 },
            { givenItem = "potty_tp", amount = 1, chance = 5 },
            { givenItem = "sealed_cache", amount = 1, chance = 5 },
            { givenItem = "saw", amount = 1, chance = 1 },
        }
    },
    {
        usedItem = "fishshoe",
        prop = {
            model = "prop_old_boot",
            bone = 60309,
            propPlacement = { x = 0.1, y = 0.0, z = 0.0, rotX = -90.0, rotY = 90.0, rotZ = 0.0 },
            animation = { dict = 'mp_arresting', anim = 'a_uncuff', flags = 1 },
        },
        givenItems = {
            random = true,
            items = 3,
            { givenItem = "lockpick", amount = 4, chance = 50 },
            { givenItem = "cigarette", amount = 20, chance = 50 },
            { givenItem = "plastic", amount = 50, chance = 50 },
            { givenItem = "rubber", amount = 50, chance = 50 },
            { givenItem = "glass", amount = 50, chance = 50 },
            { givenItem = "aluminum", amount = 50, chance = 50 },
            { givenItem = "iron", amount = 50, chance = 50 },
            { givenItem = "ammo-9", amount = 100, chance = 50 },
            { givenItem = "advancedlockpick", amount = 4, chance = 25 },
            { givenItem = "cash", amount = 4000, chance = 25 },
            { givenItem = "cash", amount = 50000, chance = 2 },
            { givenItem = "cash", amount = 100000, chance = 1 },
            { givenItem = "customizableplate", amount = 1, chance = 3 },
            { givenItem = "shitgpu", amount = 1, chance = 10 },
            { givenItem = "1050gpu", amount = 1, chance = 10 },
            { givenItem = "1060gpu", amount = 1, chance = 5 },
            { givenItem = "1080gpu", amount = 1, chance = 5 },
            { givenItem = "2080gpu", amount = 1, chance = 3 },
            { givenItem = "3060gpu", amount = 1, chance = 3 },
            { givenItem = "4090gpu", amount = 1, chance = 1 },
            { givenItem = "5090gpu", amount = 1, chance = 1 },
            { givenItem = "knife_crate", amount = 1, chance = 3 },
            { givenItem = "knife_crate2", amount = 1, chance = 3 },
            { givenItem = "knife_crate3", amount = 1, chance = 3 },
            { givenItem = "racingtablet", amount = 1, chance = 3 },
            { givenItem = "boostingtablet", amount = 1, chance = 3 },
            { givenItem = "x_device", amount = 1, chance = 5 },
            { givenItem = "x_circuittester", amount = 1, chance = 5 },
            { givenItem = "x_harddrive", amount = 1, chance = 5 },
            { givenItem = "thermite", amount = 1, chance = 5 },
            { givenItem = "x_trojanusb2", amount = 1, chance = 5 },
            { givenItem = "x_laptop", amount = 1, chance = 5 },
            { givenItem = "potty_tp", amount = 1, chance = 5 },
            { givenItem = "sealed_cache", amount = 1, chance = 5 },
            { givenItem = "saw", amount = 1, chance = 1 },
        }
    },
}
