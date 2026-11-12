Config = {}

Config.Debug = false              -- Extra console output
Config.Logging = true             -- Send opens/rewards to lib.logger (set the ox:logger convar to enable a backend)
Config.VersionCheck = true        -- Check GitHub for a newer version on start
Config.Cooldown = 1000            -- Milliseconds a player must wait between opens
Config.CheckInventorySpace = true -- Refuse to open if the rewards will not fit

-- Used by every openable unless the entry overrides it.
Config.Defaults = {
    duration = 5000,
    label = 'Opening %s...', -- %s = item label
    anim = { dict = 'mp_arresting', clip = 'a_uncuff', flag = 1 },
    prop = { bone = 60309, pos = vec3(0.1, 0.0, 0.0), rot = vec3(-90.0, 90.0, 0.0) },
}

--[[
    Config.Openables[itemName] = {
        prop     = 'model_name' or { model = 'x', bone = 60309, pos = vec3(...), rot = vec3(...) },
        anim     = { dict = 'x', clip = 'y', flag = 1 },   -- optional
        duration = 5000,                                   -- optional, ms
        job      = 'police' | { 'police', 'sheriff' } | { police = 2 }, -- optional (name or min grade)
        rewards  = {
            pick = 3,  -- optional: roll each chance, then pick this many at random from what passed
            { item = 'name', amount = 5 | { min, max }, chance = 1-100 (default 100) },
        },
    }
]]

-- Shared loot table for junk / mystery boxes.
local mysteryLoot = {
    pick = 3,
    { item = 'lockpick',          amount = 4,      chance = 50 },
    { item = 'cigarette',         amount = 20,     chance = 50 },
    { item = 'plastic',           amount = 50,     chance = 50 },
    { item = 'rubber',            amount = 50,     chance = 50 },
    { item = 'glass',             amount = 50,     chance = 50 },
    { item = 'aluminum',          amount = 50,     chance = 50 },
    { item = 'iron',              amount = 50,     chance = 50 },
    { item = 'ammo-9',            amount = 100,    chance = 50 },
    { item = 'advancedlockpick',  amount = 4,      chance = 25 },
    { item = 'money',             amount = 4000,   chance = 25 },
    { item = 'money',             amount = 50000,  chance = 2 },
    { item = 'money',             amount = 100000, chance = 1 },
    { item = 'customizableplate', amount = 1,      chance = 3 },
    { item = 'shitgpu',           amount = 1,      chance = 10 },
    { item = '1050gpu',           amount = 1,      chance = 10 },
    { item = '1060gpu',           amount = 1,      chance = 5 },
    { item = '1080gpu',           amount = 1,      chance = 5 },
    { item = '2080gpu',           amount = 1,      chance = 3 },
    { item = '3060gpu',           amount = 1,      chance = 3 },
    { item = '4090gpu',           amount = 1,      chance = 1 },
    { item = '5090gpu',           amount = 1,      chance = 1 },
    { item = 'knife_crate',       amount = 1,      chance = 3 },
    { item = 'knife_crate2',      amount = 1,      chance = 3 },
    { item = 'knife_crate3',      amount = 1,      chance = 3 },
    { item = 'racingtablet',      amount = 1,      chance = 3 },
    { item = 'boostingtablet',    amount = 1,      chance = 3 },
    { item = 'x_device',          amount = 1,      chance = 5 },
    { item = 'x_circuittester',   amount = 1,      chance = 5 },
    { item = 'x_harddrive',       amount = 1,      chance = 5 },
    { item = 'thermite',          amount = 1,      chance = 5 },
    { item = 'x_trojanusb2',      amount = 1,      chance = 5 },
    { item = 'x_laptop',          amount = 1,      chance = 5 },
    { item = 'potty_tp',          amount = 1,      chance = 5 },
    { item = 'sealed_cache',      amount = 1,      chance = 5 },
    { item = 'saw',               amount = 1,      chance = 1 },
}

---@class OpenableReward
---@field item string
---@field amount? integer | integer[]
---@field chance? number

---@class Openable
---@field prop string | { model: string, bone?: integer, pos?: vector3, rot?: vector3 }
---@field anim? { dict: string, clip: string, flag?: integer }
---@field duration? integer
---@field job? string | string[] | table<string, integer>
---@field rewards OpenableReward[] | { pick?: integer }

---@type table<string, Openable>
Config.Openables = {
    ----------------
    -- AMMO BOXES --
    ----------------
    pistolammobox  = { prop = 'v_ret_gc_ammo5',       rewards = { { item = 'ammo-45',      amount = 100 } } },
    smgammobox     = { prop = 'v_ret_gc_ammo5',       rewards = { { item = 'ammo-9',       amount = 100 } } },
    rifleammobox   = { prop = 'v_ret_gc_ammo4',       rewards = { { item = 'ammo-rifle',   amount = 80 } } },
    shotgunammobox = { prop = 'prop_ld_ammo_pack_02', rewards = { { item = 'ammo-shotgun', amount = 20 } } },
    sniperammobox  = { prop = 'v_ret_gc_ammo4',       rewards = { { item = 'ammo-sniper',  amount = 40 } } },

    ------------------
    -- STARTER KITS --
    ------------------
    pdstarterbox = {
        job = 'police',
        prop = 'bkr_prop_duffel_bag_01a',
        rewards = {
            { item = 'weapon_colbaton',    amount = 1 },  -- not an ox_inventory item yet
            { item = 'WEAPON_GLOCK17',     amount = 1 },
            { item = 'WEAPON_TASER',       amount = 1 },  -- not an ox_inventory item yet
            { item = 'ammo_taser',         amount = 10 }, -- not an ox_inventory item yet (taser_cartridge exists)
            { item = 'handcuffs',          amount = 1 },
            { item = 'ifaks',              amount = 5 },
            { item = 'weapon_flashlight',  amount = 1 },
            { item = 'empty_evidence_bag', amount = 20 },
            { item = 'radio',              amount = 1 },
            { item = 'heavyarmor',         amount = 5 },
            { item = 'evidence_camera',    amount = 1 },
            { item = 'policetablet',       amount = 1 },
            { item = 'body_cam',           amount = 1 },
            { item = 'notepad',            amount = 1 },
            { item = 'policepouches',      amount = 1 },
            { item = 'camera',             amount = 1 },
            { item = 'gsr_test_kit',       amount = 3 },
            { item = 'uv_light',           amount = 1 },
            { item = 'dnaswab',            amount = 3 },  -- not an ox_inventory item yet
            { item = 'spike_strip',        amount = 1 },
        },
    },
    emsstarterbox = {
        job = 'ambulance',
        prop = 'xm_prop_x17_bag_med_01a',
        rewards = {
            { item = 'medbag',            amount = 1 },
            { item = 'defib',             amount = 20 },
            { item = 'medikit',           amount = 20 },
            { item = 'radio',             amount = 1 },
            { item = 'weapon_flashlight', amount = 1 },
            { item = 'fitbit',            amount = 1 },
            { item = 'ems_mdt',           amount = 1 },
        },
    },

    ----------------
    -- CIGARETTES --
    ----------------
    redwoodcigs   = { prop = 'v_ret_ml_cigs',  rewards = { { item = 'cigarette', amount = 20 } } },
    cardiaquecigs = { prop = 'v_ret_ml_cigs5', rewards = { { item = 'cigarette', amount = 20 } } },
    debonairecigs = { prop = 'v_ret_ml_cigs3', rewards = { { item = 'cigarette', amount = 20 } } },

    ------------------
    -- MARKED BILLS --
    ------------------
    markedbills  = { prop = 'prop_money_bag_01', rewards = { { item = 'black_money', amount = { 8000, 12000 } } } },
    markedbills2 = { prop = 'prop_money_bag_01', rewards = { { item = 'black_money', amount = { 20000, 25000 } } } },

    -------------------
    -- MYSTERY BOXES --
    -------------------
    giftbox  = { prop = 'xm3_prop_xm3_present_01a', rewards = mysteryLoot },
    fishshoe = { prop = 'prop_old_boot',            rewards = mysteryLoot },
}
