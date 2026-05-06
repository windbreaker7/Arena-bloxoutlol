# Arena-bloxoutlol
I'm encrypting this later lol (Because diddy developer are going to notice)

## 📋 Features
- Highlights loot containers through walls with item names and values
- Live distance tracker per container
- Elite loot color differentiation
- Extraction zone ESP with live timer updates
- Hot-swappable settings (change values mid-game, ESP updates instantly)
- Filter presets to quickly switch minimum value thresholds
- Nearby loot dump to console sorted by distance
- Full PC & Mobile support with no GUI clutter

---

## 🎮 Controls

| Action       | PC           | Mobile          |
|--------------|--------------|-----------------|
| Toggle ESP   | Left Alt     | [ESP] button    |
| Cycle Preset | Right Alt    | [PRESET] button |
| Dump Loot    | Right Shift  | [DUMP] button   |

---

## ⚙️ Settings

All settings are found at the top of the script and can be changed at runtime.

| Key                    | Default | Description                         |
|------------------------|---------|-------------------------------------|
| `MIN_VALUE`            | `1000`  | Minimum item value to display       |
| `HIGH_VALUE_THRESHOLD` | `5000`  | Value threshold for elite color     |
| `MaxDistance`          | `700`   | Max distance in studs to show ESP   |
| `SHOW_DISTANCE`        | `true`  | Show stud distance below each label |
| `SHOW_RARITY`          | `true`  | Show item rarity tag if available   |
| `SHOW_TOTAL`           | `true`  | Show total loot value per container |
| `SHOW_EXTRACTION`      | `true`  | Show extraction zone ESP            |

---

## 🔄 Hot-Swap at Runtime

Any setting can be changed mid-game and all active ESP tags update instantly:

```lua
SETTINGS.MIN_VALUE = 1500
SETTINGS.SHOW_DISTANCE = false
SETTINGS.MaxDistance = 1000
📦 Filter Presets
Cycle through presets with Right Alt (PC) or the [PRESET] button (Mobile).
Preset
Min Value
All Loot
$0
Budget
$500
Standard
$1000
High Value
$3000
Elite Only
$7500
🛠️ Setup
The script requires minimal configuration before use. Open the script and adjust the SETTINGS block at the top to match the game you are targeting. No other changes are needed.
💻 Platform Support
Platform
Supported
PC
✅
Mobile
✅
Console
❌
