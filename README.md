# gldnrmz-openables

Turn one usable item into one or more reward items with animation + progress bar support.

This resource is framework/inventory-agnostic through `community_bridge` and is built for common FiveM roleplay stacks.

## Features

- Registers all items in `Config.ItemsToConvert` as usable items.
- Plays a client animation with a held prop while opening.
- Supports fixed rewards and random reward pools.
- Supports amount ranges (example: `{8000, 12000}`).
- Optional job restriction per openable (starter kits, etc.).
- Optional anti-spam cooldown and inventory space checks.
- Optional debug and server-side conversion logging.
- Startup config validation + version check.

## Requirements

- FiveM server (Cerulean)
- `community_bridge`
- A compatible framework via bridge (`qb`, `qbox`, `esx`, or standalone mode)
- A compatible inventory module (auto-detected by bridge/manual config)

## Installation

1. Place this resource in your server resources folder.
2. Ensure `community_bridge` starts before this resource.
3. Add to your server config:

```cfg
ensure community_bridge
ensure gldnrmz-openables
```

4. Configure conversions in `config.lua`.
5. Restart the resource/server.

## Configuration

All settings are in `config.lua`.

### Core Settings

- `Config.Framework`: `auto`, `qb`, `qbox`, `esx`, `none`
- `Config.Inventory`: `auto`, `ox_inventory`, `framework`, `none`
- `Config.EnableLogging`: print conversion logs in server console
- `Config.EnableRateLimit`: enable anti-spam cooldown
- `Config.GlobalCooldown`: cooldown in milliseconds
- `Config.CheckInventorySpace`: verifies carry capacity before consuming openable
- `Config.CheckItemExists`: basic validation for configured reward names
- `Config.JobWhitelistEnabled`: enforce `job` field on conversion entries
- `Config.PreLoadModels`: toggles preload behavior message/model flow
- `Config.Debug`: extra debug output

### Conversion Entry Format

Each object in `Config.ItemsToConvert` supports:

- `usedItem` (string): item that gets consumed
- `job` (string, optional): required job to use this conversion
- `prop` (table): model + animation + attachment settings
- `givenItems` (table): reward definition

`givenItems` can be either:

1. **Static list** (every entry can have `chance`)
2. **Random pool mode** using:
	 - `random = true`
	 - `items = <number to pick>`
	 - reward entries with optional `chance`

Reward `amount` supports:

- Fixed: `amount = 5`
- Random range: `amount = {min, max}`

## Example Conversion

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
				random = true,
				items = 3,
				{ givenItem = "lockpick", amount = 4, chance = 50 },
				{ givenItem = "cash", amount = {4000, 7000}, chance = 25 },
		}
}
```

## How It Works

1. Player uses `usedItem`.
2. Server checks cooldown/job/inventory space.
3. Item is removed.
4. Client plays 5s opening animation + prop.
5. Rewards are granted after the progress completes.

## Notes

- If inventory is full, the openable is not consumed.
- `chance` accepts either percent-style values (`25`) or decimal (`0.25`).
- For random mode, pools are pre-calculated at startup and fallback-calculated if needed.

## Troubleshooting

- **"community_bridge is not ready"**
	- Ensure `community_bridge` is installed and started before this resource.
- **Openable does nothing**
	- Confirm the `usedItem` exists in your item database and is registered as usable through the bridge.
- **No rewards received**
	- Check inventory space and verify reward item names exist in your inventory/framework.
- **Job restricted item fails**
	- Confirm player job exactly matches the conversion `job` value.

## Version

Current resource version: `1.0.0`
