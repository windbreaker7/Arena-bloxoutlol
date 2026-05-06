# Arena-bloxoutlol
I'm encrypting this later lol (Because diddy developer are going to notice)



# 🔍 Loot ESP Script
A lightweight, no-GUI ESP script for Roblox written in Luau.
Supports both PC and Mobile with hot-swappable settings and filter presets.

---

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

You can change these at the top of the script or hot-swap them at runtime.

| Key                   | Default                  | Description                              |
|-----------------------|--------------------------|------------------------------------------|
| `MIN_VALUE`           | `1000`                   | Minimum item value to display            |
| `HIGH_VALUE_THRESHOLD`| `5000`                   | Value threshold for elite color          |
| `MaxDistance`         | `700`                    | Max distance in studs to show ESP        |
| `SHOW_DISTANCE`       | `true`                   | Show stud distance below each label      |
| `SHOW_RARITY`         | `true`                   | Show item rarity tag if available        |
| `SHOW_TOTAL`          | `true`                   | Show total loot value per container      |
| `SHOW_EXTRACTION`     | `true`                   | Show extraction zone ESP                 |
| `LootColor`           | `RGB(255, 215, 0)`       | Color for standard loot labels           |
| `HighValueColor`      | `RGB(255, 80, 80)`       | Color for elite loot labels              |
| `ExtractionColor`     | `RGB(0, 255, 127)`       | Color for extraction zone labels         |

---

## 🔄 Hot-Swap at Runtime

You can change any setting mid-game and all active ESP tags will update instantly:

```lua
SETTINGS.MIN_VALUE = 1500            -- raises filter threshold live
SETTINGS.SHOW_DISTANCE = false       -- hides distance labels instantly
SETTINGS.HIGH_VALUE_THRESHOLD = 3000 -- adjusts elite color threshold
SETTINGS.MaxDistance = 1000          -- extends ESP draw distance
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
🗂️ Expected Workspace Hierarchy
The script expects this structure in your Roblox game's Workspace:
Workspace
├── Lootables (Folder)
│   └── ContainerModel (Model)
│       └── Loot (Folder)
│           └── ItemName (BasePart or Model)
│               ├── MoneyValue (IntValue/NumberValue)
│               └── Rarity (StringValue) ← optional
└── ExtractionZones (Folder)
    └── ZonePart (BasePart)
        ├── extractname (StringValue)
        └── ExtractTime (StringValue/IntValue)
💻 Platform Support
Platform
Supported
PC
✅
Mobile
✅
Console
❌
Console is not supported as script executors are not available on PlayStation or Xbox.
