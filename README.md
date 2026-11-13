# gldnrmz-openables

Use one item (ammo box, cigarette pack, starter kit, gift box...) to receive one or more reward items, with an animation, held prop and cancellable progress bar.

Works with Qbox, QBCore and ESX, and any inventory supported by [community_bridge](https://github.com/TheOrderFivem/community_bridge).

## Requirements

- `ox_lib`
- `community_bridge` **0.13.6 or newer** (with Qbox, QBCore or ESX and a supported inventory)

## Installation

1. Ensure `ox_lib` and `community_bridge` start before this resource.
2. Make sure every openable item and every reward exists in your inventory's item list. Missing names are listed in the console on start and skipped.
3. Copy the PNGs in `images/` to your inventory's image folder if you have not already.

With ox_inventory, rewards that don't fit are dropped at the player's feet and the total carry weight is checked. Other inventories check each item.

## How it works

1. The player uses the item.
2. The server checks cooldown, job and inventory space, and rolls the rewards.
3. The client plays the progress bar (prop + animation via `lib.progressBar`).
4. **Cancelled:** nothing is taken.
   **Finished:** the item is removed from the exact slot used and the rewards are given.
5. Any reward that no longer fits is dropped on the ground instead of being lost.

The server also checks the progress bar actually ran for its full duration, so a modified client cannot skip it.

## Settings (`config.lua`)

| Setting | Description |
| --- | --- |
| `Config.Debug` | Extra console output |
| `Config.Logging` | Sends opens and rewards to `lib.logger` (set the `ox:logger` convar) |
| `Config.VersionCheck` | Checks GitHub for a newer version on start |
| `Config.Cooldown` | Milliseconds between opens per player |
| `Config.CheckInventorySpace` | Refuses to open if the rewards will not fit |
| `Config.Defaults` | Default duration, label, animation and prop placement |

## Adding an openable

```lua
Config.Openables = {
    pistolammobox = {
        prop = 'v_ret_gc_ammo5',
        rewards = { { item = 'ammo-45', amount = 100 } },
    },

    pdstarterbox = {
        job = 'police',                  -- or { 'police', 'sheriff' } or { police = 2 } (min grade)
        prop = 'bkr_prop_duffel_bag_01a',
        rewards = {
            { item = 'WEAPON_GLOCK17', amount = 1 },
            { item = 'radio', amount = 1 },
        },
    },

    giftbox = {
        prop = { model = 'xm3_prop_xm3_present_01a', pos = vec3(0.1, 0.0, 0.0), rot = vec3(-90.0, 90.0, 0.0) },
        duration = 7000,
        anim = { dict = 'mp_arresting', clip = 'a_uncuff', flag = 1 },
        rewards = {
            pick = 3, -- roll every chance, then keep 3 of the ones that passed
            { item = 'lockpick', amount = 4, chance = 50 },
            { item = 'money', amount = { 4000, 7000 }, chance = 25 },
        },
    },
}
```

- `amount`: a number, or `{ min, max }`.
- `chance`: percent, default 100. Values from 1 up can have decimals (`1.5` = 1.5%). Values between 0 and 1 are read as fractions (`0.25` = 25%).
- Without `pick`, every reward rolls its own chance independently.
- Rewards are rolled fresh on every open.
- Cash rewards use the `money` item. On ox_inventory that's the cash item; on inventories without one (qb-inventory, ESX default) it's paid into the player's cash account instead.
- Item names are matched regardless of case, and ox_inventory names are translated for other inventories: `ammo-9` / `ammo-45` -> `pistol_ammo`, `ammo-rifle` -> `rifle_ammo`, `ammo-shotgun` -> `shotgun_ammo`, `ammo-sniper` -> `snp_ammo`, `black_money` -> `markedbills`, `WEAPON_TASER` -> `weapon_stungun`.

## Changes in 2.1.0

- Runs on Qbox, QBCore and ESX through community_bridge.
- Cash rewards work on inventories without a money item; ox ammo names and a few weapon names are translated automatically.
- Item names are matched regardless of case.
