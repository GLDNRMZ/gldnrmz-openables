Config = {}

Config.ItemsToConvert = {
    --------------
    --AMMO BOXES--
    --------------
    {
        usedItem = "pistolammobox",
        prop = "v_ret_gc_ammo5",
        givenItems = {
            { givenItem = "ammo-9", amount = 100 }
        }
    },
    {
        usedItem = "smgammobox",
        prop = "v_ret_gc_ammo5",
        givenItems = {
            { givenItem = "ammo-9", amount = 100 }
        }
    },
    {
        usedItem = "rifleammobox",
        prop = "v_ret_gc_ammo4",
        givenItems = {
            { givenItem = "ammo-rifle", amount = 80 }
        }
    },
    {
        usedItem = "shotgunammobox",
        prop = "prop_ld_ammo_pack_02",
        givenItems = {
            { givenItem = "ammo-shotgun", amount = 20 }
        }
    },
    {
        usedItem = "sniperammobox",
        prop = "v_ret_gc_ammo4",
        givenItems = {
            { givenItem = "ammo-sniper", amount = 40 }
        }
    },
    ------------
    --GIFT BOX--
    ------------
    {
        usedItem = "giftbox",
        prop = "bkr_prop_coke_dollbox",
        givenItems = {
            { givenItem = "lockpick", amount = 4 },
        }
    },
    --------------------
    --JOB STARTER KITS--
    --------------------
    --qb-policejob/r-14evidence--
    {
        usedItem = "pdstarterbox",
        prop = "bkr_prop_duffel_bag_01a",
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
        prop = "xm_prop_x17_bag_med_01a",
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
        prop = "v_ret_ml_cigs",
        givenItems = {
            { givenItem = "cigarette", amount = 20 }
        }
    },
    {
        usedItem = "cardiaquecigs",
        prop = "v_ret_ml_cigs5",
        givenItems = {
            { givenItem = "cigarette", amount = 20 }
        }
    },
    {
        usedItem = "debonairecigs",
        prop = "v_ret_ml_cigs3",
        givenItems = {
            { givenItem = "cigarette", amount = 20 }
        }
    },

    --------------
    --MARKEDBILLS-
    --------------
    {
        usedItem = "markedbills",
        prop = "prop_money_bag_01",
        givenItems = {
            { givenItem = "black_money", amount = {8000,12000} }
        }
    },

    {
        usedItem = "markedbills2",
        prop = "prop_money_bag_01",
        givenItems = {
            { givenItem = "black_money", amount = {20000,25000} }
        }
    },
}
