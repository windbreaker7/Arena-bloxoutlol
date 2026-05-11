-- Auto-generated module for m995 panel
local m = _G.m995
local Rayfield          = m.Rayfield
local UserInputService  = m.UserInputService
local RunService        = m.RunService
local Players           = m.Players
local LocalPlayer       = m.LocalPlayer
local TargetContainer   = m.TargetContainer
local Camera            = m.Camera
local SETTINGS          = m.SETTINGS
local _raw              = m._raw
local PRESETS           = m.PRESETS
local RED               = m.RED
local espTags           = m.espTags
local ammoTags          = m.ammoTags
local playerESPTags     = m.playerESPTags
local corpseESPTags     = m.corpseESPTags
local botESPTags        = m.botESPTags
local armorESPTags      = m.armorESPTags
local thermalESPTags    = m.thermalESPTags
local weaponESPTags     = m.weaponESPTags
local playerChams       = m.playerChams
local botChams          = m.botChams
local corpseChams       = m.corpseChams
local injuryLabels      = m.injuryLabels
local playerBoxESPs     = m.playerBoxESPs
local botBoxESPs        = m.botBoxESPs
local boneLines         = m.boneLines
local boneOwners        = m.boneOwners
local allConnections    = m.allConnections
local worldLootTags     = m.worldLootTags
local spawnTags         = m.spawnTags
local getCachedRoot          = m.getCachedRoot
local trackConnection        = m.trackConnection
local cleanupConnections     = m.cleanupConnections
local toggleESP              = m.toggleESP
local cyclePreset            = m.cyclePreset
local dumpLoot               = m.dumpLoot
local createPlayerCham       = m.createPlayerCham
local createBotCham          = m.createBotCham
local createCorpseCham       = m.createCorpseCham
local removePlayerCham       = m.removePlayerCham
local removeBotCham          = m.removeBotCham
local removeCorpseCham       = m.removeCorpseCham
local createPlayerESPTag     = m.createPlayerESPTag
local removePlayerESPTag     = m.removePlayerESPTag
local createBotESPTag        = m.createBotESPTag
local removeBotESPTag        = m.removeBotESPTag
local createCorpseESPTag     = m.createCorpseESPTag
local removeCorpseESPTag     = m.removeCorpseESPTag
local setupPlayerESP         = m.setupPlayerESP
local setupPlayerTools       = m.setupPlayerTools
local setupBoneESP           = m.setupBoneESP
local removeBoneLines        = m.removeBoneLines
local removePlayerBoxESP     = m.removePlayerBoxESP
local removeBotBoxESP        = m.removeBotBoxESP
local removeAmmoTag          = m.removeAmmoTag
local removeArmorESPTag      = m.removeArmorESPTag
local removeThermalESPTag    = m.removeThermalESPTag
local removeWeaponESPTag     = m.removeWeaponESPTag
local setupGenericContainer  = m.setupGenericContainer
local setupExtraction        = m.setupExtraction
local createAmmoESPTag       = m.createAmmoESPTag
local setupWorldLootESP      = m.setupWorldLootESP
local setupSpawnESP          = m.setupSpawnESP
local setupLocalCharacter    = m.setupLocalCharacter
local espEnabled             = m.espEnabled
local chamEnabled            = m.chamEnabled
local worldLootEnabled       = m.worldLootEnabled
local spawnESPEnabled        = m.spawnESPEnabled
local enemyAmmoConnections   = m.enemyAmmoConnections
local enemyMaxMag            = m.enemyMaxMag
local refreshCallbacks       = m.refreshCallbacks

-- RAYFIELD UI
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "m995 panel",
    LoadingTitle = "m995 panel",
    LoadingSubtitle = "Loading systems...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "m995_panel",
        FileName = "config.json"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})
-- Expose Window to all other modules
_G.m995.Window = Window

-- TAB 1: Loot
local LootTab = Window:CreateTab("Loot", "box")
LootTab:CreateSection("Loot Configuration")

LootTab:CreateSlider({
    Name = "Minimum Value",
    Range = {0, 20000}, Increment = 100, Suffix = "$",
    CurrentValue = SETTINGS.MIN_VALUE,
    Flag = "MinValue",
    Callback = function(Value) SETTINGS.MIN_VALUE = Value end,
})

LootTab:CreateSlider({
    Name = "High Value Threshold",
    Range = {0, 50000}, Increment = 500, Suffix = "$",
    CurrentValue = SETTINGS.HIGH_VALUE_THRESHOLD,
    Flag = "HighValueThreshold",
    Callback = function(Value) SETTINGS.HIGH_VALUE_THRESHOLD = Value end,
})

LootTab:CreateToggle({
    Name = "Show Distance", CurrentValue = SETTINGS.SHOW_DISTANCE,
    Flag = "ShowDistance",
    Callback = function(Value) SETTINGS.SHOW_DISTANCE = Value end,
})

LootTab:CreateToggle({
    Name = "Show Total Value", CurrentValue = SETTINGS.SHOW_TOTAL,
    Flag = "ShowTotal",
    Callback = function(Value) SETTINGS.SHOW_TOTAL = Value end,
})

LootTab:CreateToggle({
    Name = "Show Rarity", CurrentValue = SETTINGS.SHOW_RARITY,
    Flag = "ShowRarity",
    Callback = function(Value) SETTINGS.SHOW_RARITY = Value end,
})

LootTab:CreateToggle({
    Name = "Show Extraction Zones", CurrentValue = SETTINGS.SHOW_EXTRACTION,
    Flag = "ShowExtraction",
    Callback = function(Value) SETTINGS.SHOW_EXTRACTION = Value end,
})

LootTab:CreateButton({
    Name = "Dump Nearby Loot",
    Callback = function() dumpLoot() end,
})

-- TAB 2: Players
local PlayerTab = Window:CreateTab("Players", "user")
PlayerTab:CreateSection("Player & NPC ESP")

local playerToggles = {
    { name = "Player ESP",      key = "SHOW_PLAYER_ESP"  },
    { name = "Bone ESP",        key = "SHOW_BONE_ESP"    },
    { name = "Enemy Ammo",      key = "SHOW_ENEMY_AMMO"  },
    { name = "Armor ESP",       key = "SHOW_ARMOR_ESP"   },
    { name = "Thermal/Shield",  key = "SHOW_THERMAL_ESP" },
    { name = "Weapon Name",     key = "SHOW_WEAPON_ESP"  },
    { name = "Bot ESP",         key = "SHOW_BOT_ESP"     },
    { name = "Corpse ESP",      key = "SHOW_CORPSE_ESP"  },
    { name = "Health Bar",      key = "SHOW_HEALTH_BAR"  },
}

for _, toggle in ipairs(playerToggles) do
    PlayerTab:CreateToggle({
        Name = toggle.name, CurrentValue = _raw[toggle.key],
        Flag = "Toggle_" .. toggle.key,
        Callback = function(val) SETTINGS[toggle.key] = val end,
    })
end

PlayerTab:CreateSection("Box ESP")

PlayerTab:CreateToggle({
    Name = "Player Box ESP", CurrentValue = _raw.SHOW_PLAYER_BOX,
    Flag = "Toggle_SHOW_PLAYER_BOX",
    Callback = function(val) SETTINGS.SHOW_PLAYER_BOX = val end,
})

PlayerTab:CreateToggle({
    Name = "Bot Box ESP", CurrentValue = _raw.SHOW_BOT_BOX,
    Flag = "Toggle_SHOW_BOT_BOX",
    Callback = function(val) SETTINGS.SHOW_BOT_BOX = val end,
})

PlayerTab:CreateSection("Chams")

PlayerTab:CreateToggle({
    Name = "Enable Chams",
    CurrentValue = chamEnabled,
    Flag = "ChamEnabled",
    Callback = function(val)
        chamEnabled = val
        if not val then
            -- Remove all existing chams and injury labels
            for player, box in pairs(playerChams) do
                if box and box.Parent then pcall(function() box:Destroy() end) end
                playerChams[player] = nil
            end
            for bot, box in pairs(botChams) do
                if box and box.Parent then pcall(function() box:Destroy() end) end
                botChams[bot] = nil
            end
            for corpse, box in pairs(corpseChams) do
                if box and box.Parent then pcall(function() box:Destroy() end) end
                corpseChams[corpse] = nil
            end
            for target, gui in pairs(injuryLabels) do
                if gui and gui.Parent then pcall(function() gui:Destroy() end) end
                injuryLabels[target] = nil
            end
        else
            -- Re-apply chams and injury labels to all currently tracked players, bots and corpses
            for player, data in pairs(playerESPTags) do
                if data and data.character and data.character.Parent then
                    createPlayerCham(player, data.character)
                end
            end
            for bot in pairs(botESPTags) do
                if bot and bot.Parent then
                    createBotCham(bot)
                end
            end
            for corpse in pairs(corpseESPTags) do
                if corpse and corpse.Parent then
                    createCorpseCham(corpse)
                end
            end
        end
    end,
})

PlayerTab:CreateToggle({
    Name = "Player Chams", CurrentValue = _raw.SHOW_PLAYER_CHAM,
    Flag = "Toggle_SHOW_PLAYER_CHAM",
    Callback = function(val) SETTINGS.SHOW_PLAYER_CHAM = val end,
})

PlayerTab:CreateToggle({
    Name = "Bot Chams", CurrentValue = _raw.SHOW_BOT_CHAM,
    Flag = "Toggle_SHOW_BOT_CHAM",
    Callback = function(val) SETTINGS.SHOW_BOT_CHAM = val end,
})

PlayerTab:CreateToggle({
    Name = "Corpse Chams", CurrentValue = _raw.SHOW_CORPSE_CHAM,
    Flag = "Toggle_SHOW_CORPSE_CHAM",
    Callback = function(val) SETTINGS.SHOW_CORPSE_CHAM = val end,
})

PlayerTab:CreateSection("Counter Bar")
PlayerTab:CreateLabel("Shows Player / Bot / Remain count at top of screen.")

-- ==========================================
-- COUNTER BAR HUD
-- ==========================================
local counterHUD        = nil
local counterBarEnabled = false
local botFilterEnabled  = false

local labelPlayer = nil
local labelBot    = nil
local labelRemain = nil

local function removeCounterHUD()
    if counterHUD and counterHUD.Parent then
        pcall(function() counterHUD:Destroy() end)
    end
    counterHUD   = nil
    labelPlayer  = nil
    labelBot     = nil
    labelRemain  = nil
end

local function createCounterHUD()
    removeCounterHUD()

    local sg = Instance.new("ScreenGui")
    sg.Name           = "CounterBarHUD"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder   = 10
    sg.Parent         = TargetContainer

    local frame = Instance.new("Frame")
    frame.Name                   = "CounterFrame"
    frame.Size                   = UDim2.new(0, 260, 0, 30)
    frame.Position               = UDim2.new(0.5, -130, 0, 8)
    frame.BackgroundColor3       = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel        = 0
    frame.Parent                 = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent       = frame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection       = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment   = Enum.VerticalAlignment.Center
    layout.Padding             = UDim.new(0, 16)
    layout.Parent              = frame

    local function makeLabel(text, color)
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size                   = UDim2.new(0, 70, 1, 0)
        lbl.Text                   = text
        lbl.TextColor3             = color
        lbl.TextSize               = 14
        lbl.Font                   = Enum.Font.GothamBold
        lbl.TextXAlignment         = Enum.TextXAlignment.Center
        lbl.TextStrokeTransparency = 0.5
        lbl.Parent                 = frame
        return lbl
    end

    labelPlayer = makeLabel("Player: 0", Color3.fromRGB(255, 255, 255))
    labelBot    = makeLabel("Bot: 0",    Color3.fromRGB(255, 130, 0))
    labelRemain = makeLabel("Remain: 0", Color3.fromRGB(100, 255, 100))

    counterHUD = sg
end

local function countBots()
    local acsWS = workspace:FindFirstChild("ACS_WorkSpace")
    local ai    = acsWS and acsWS:FindFirstChild("AI")
    if not ai then return 0 end
    local count = 0
    for _, obj in ipairs(ai:GetChildren()) do
        if obj:IsA("Model") then count = count + 1 end
    end
    return count
end

local function updateCounterBar()
    if not counterHUD or not counterHUD.Parent then return end
    if not labelPlayer or not labelBot or not labelRemain then return end

    local playerCount = #Players:GetPlayers()
    local botCount    = countBots()
    local remain      = botFilterEnabled and (playerCount + botCount) or playerCount

    labelPlayer.Text = "Player: " .. playerCount
    labelBot.Text    = "Bot: "    .. botCount
    labelRemain.Text = "Remain: " .. remain

    labelRemain.TextColor3 = remain <= 0
        and Color3.fromRGB(255, 60, 60)
        or  Color3.fromRGB(100, 255, 100)
end

local lastCounterUpdate = 0
RunService.Heartbeat:Connect(function()
    if not counterBarEnabled then return end
    local now = os.clock()
    if (now - lastCounterUpdate) < 1 then return end
    lastCounterUpdate = now
    updateCounterBar()
end)

PlayerTab:CreateToggle({
    Name         = "Counter Bar",
    CurrentValue = counterBarEnabled,
    Flag         = "Toggle_CounterBar",
    Callback     = function(val)
        counterBarEnabled = val
        if val then
            createCounterHUD()
            updateCounterBar()
        else
            removeCounterHUD()
        end
    end,
})

PlayerTab:CreateToggle({
    Name         = "Bot Filter Counter",
    CurrentValue = botFilterEnabled,
    Flag         = "Toggle_BotFilter",
    Callback     = function(val)
        botFilterEnabled = val
        updateCounterBar()
    end,
})

-- TAB 3: Ammo
local AmmoTab = Window:CreateTab("Ammo", "zap")
AmmoTab:CreateSection("Ammo Display")

AmmoTab:CreateToggle({
    Name = "Local Ammo HUD", CurrentValue = _raw.SHOW_AMMO,
    Flag = "Toggle_SHOW_AMMO",
    Callback = function(val)
        SETTINGS.SHOW_AMMO = val
        -- FIX: apply visibility immediately since there's no onSettingChanged listener for this key
        if localAmmoHUD and localAmmoHUD.Parent then
            local frame = localAmmoHUD:FindFirstChild("AmmoFrame")
            if frame then frame.Visible = val and espEnabled end
        end
    end,
})

AmmoTab:CreateToggle({
    Name = "Live Ammo Counter", CurrentValue = liveAmmoEnabled,
    Flag = "Toggle_LIVE_AMMO",
    Callback = function(val) liveAmmoEnabled = val end,
})

AmmoTab:CreateToggle({
    Name = "Projectile Ammo ESP", CurrentValue = _raw.SHOW_AMMO_ESP,
    Flag = "Toggle_SHOW_AMMO_ESP",
    Callback = function(val) SETTINGS.SHOW_AMMO_ESP = val end,
})

-- TAB 4: Advanced
local AdvTab = Window:CreateTab("Advanced", "sliders")
AdvTab:CreateSection("Distance & Text")

AdvTab:CreateSlider({
    Name = "Max ESP Distance",
    Range = {100, 2000}, Increment = 50, Suffix = " studs",
    CurrentValue = SETTINGS.MaxDistance,
    Flag = "MaxDistance",
    Callback = function(Value) SETTINGS.MaxDistance = Value end,
})

AdvTab:CreateSlider({
    Name = "Text Size",
    Range = {8, 24}, Increment = 1,
    CurrentValue = SETTINGS.TextSize,
    Flag = "TextSize",
    Callback = function(Value) SETTINGS.TextSize = Value end,
})

-- TAB 5: Colors
local ColTab = Window:CreateTab("Colors", "palette")
ColTab:CreateSection("ESP Colors")

local colorDefs = {
    { name = "Loot",            key = "LootColor"        },
    { name = "High Value",      key = "HighValueColor"   },
    { name = "Extraction",      key = "ExtractionColor"  },
    { name = "Player",          key = "PlayerColor"      },
    { name = "Corpse",          key = "CorpseColor"      },
    { name = "Bot",             key = "BotColor"         },
    { name = "Armor",           key = "ArmorColor"       },
    { name = "Thermal",         key = "ThermalColor"     },
    { name = "Weapon",          key = "WeaponColor"      },
    { name = "Ammo",            key = "AmmoColor"        },
    { name = "Player Cham",     key = "PlayerChamColor"  },
    { name = "Bot Cham",        key = "BotChamColor"     },
    { name = "Corpse Cham",     key = "CorpseChamColor"  },
    { name = "Player Box",      key = "PlayerBoxColor"   },
    { name = "Bot Box",         key = "BotBoxColor"      },
    { name = "Look Line",       key = "LookLineColor"    },
}

for _, def in ipairs(colorDefs) do
    ColTab:CreateColorPicker({
        Name = def.name .. " Color", Color = _raw[def.key],
        Flag = "Color_" .. def.key,
        Callback = function(val) SETTINGS[def.key] = val end,
    })
end

-- TAB 6: World ESP
local WorldTab = Window:CreateTab("World ESP", "map")

WorldTab:CreateSection("Loot World ESP")
WorldTab:CreateLabel("Scans: workspace.ACS_WorkSpace.Server.Dropped")

WorldTab:CreateToggle({
    Name = "Loot World ESP", CurrentValue = worldLootEnabled,
    Flag = "Toggle_WorldLootESP",
    Callback = function(val)
        worldLootEnabled = val
        if not val then
            clearAllWorldLootTags()
        else
            -- Re-scan on enable
            local dropped = workspace:FindFirstChild("ACS_WorkSpace")
                and workspace.ACS_WorkSpace:FindFirstChild("Server")
                and workspace.ACS_WorkSpace.Server:FindFirstChild("Dropped")
            if dropped then
                for _, model in ipairs(dropped:GetChildren()) do
                    setupWorldLootESP(model)
                end
            end
        end
    end,
})

WorldTab:CreateSection("Spawn ESP")
WorldTab:CreateLabel("Scans: workspace.Spawns (SpawnLocation)")
WorldTab:CreateLabel("Scans: workspace.SpawnBaseParts (Part)")

WorldTab:CreateToggle({
    Name = "Spawn ESP", CurrentValue = spawnESPEnabled,
    Flag = "Toggle_SpawnESP",
    Callback = function(val)
        spawnESPEnabled = val
        if not val then
            clearAllSpawnTags()
        else
            -- Re-scan on enable
            local spawns = workspace:FindFirstChild("Spawns")
            if spawns then
                for _, obj in ipairs(spawns:GetChildren()) do
                    setupSpawnESP(obj)
                end
            end
            local spawnParts = workspace:FindFirstChild("SpawnBaseParts")
            if spawnParts then
                for _, obj in ipairs(spawnParts:GetChildren()) do
                    setupSpawnESP(obj)
                end
            end
        end
    end,
})

-- TAB 7: Tools
local ToolTab = Window:CreateTab("Tools", "hammer")
ToolTab:CreateSection("Quick Actions")

ToolTab:CreateButton({
    Name = "Toggle ESP (Alt)",
    Callback = function()
        local on = toggleESP()
        Rayfield:Notify({
            Title = "ESP",
            Content = on and "✅ Enabled" or "❌ Disabled",
            Duration = 2,
        })
    end,
})

ToolTab:CreateButton({
    Name = "Cycle Preset (Alt+R)",
    Callback = function()
        local preset = cyclePreset()
        Rayfield:Notify({
            Title = "Preset",
            Content = "-> " .. preset,
            Duration = 2,
        })
    end,
})

ToolTab:CreateSection("Diagnostics")

ToolTab:CreateButton({
    Name = "Active Tag Counts",
    Callback = function()
        local info = string.format(
            "Loot: %d | Players: %d | Ammo: %d | Bots: %d | Corpses: %d | Bone Lines: %d",
            countTable(espTags), countTable(playerESPTags), countTable(ammoTags),
            countTable(botESPTags), countTable(corpseESPTags), countTable(boneLines)
        )
        print("[ESP] " .. info)
        Rayfield:Notify({ Title = "Tag Counts", Content = info, Duration = 5 })
    end,
})

ToolTab:CreateButton({
    Name = "Purge Dead Tags",
    Callback = function()
        local removed = 0
        for k, tag in pairs(espTags) do
            if not tag or not tag.Parent then espTags[k] = nil; removed += 1 end
        end
        for k, tag in pairs(ammoTags) do
            if not tag or not tag.Parent then ammoTags[k] = nil; removed += 1 end
        end
        for k, tag in pairs(playerESPTags) do
            if not tag or not tag.gui or not tag.gui.Parent then playerESPTags[k] = nil; removed += 1 end
        end
        Rayfield:Notify({
            Title = "Purge",
            Content = "Cleaned " .. removed .. " dead tags",
            Duration = 3,
        })
    end,
})

-- ==========================================
-- ITEM LISTING (GUNS & LOOTS ONLY)
-- ==========================================
ToolTab:CreateSection("Item Database")

local gunList = {}
local lootList = {}

local function scanAllItems()
    gunList = {}
    lootList = {}
    
    -- SCAN LOOTS (from containers)
    local lootables = workspace:FindFirstChild("Lootables")
    if lootables then
        for _, container in ipairs(lootables:GetChildren()) do
            local loot = container:FindFirstChild("Loot")
            if loot then
                for _, item in ipairs(loot:GetChildren()) do
                    local itemName = item.Name
                    local moneyValue = 0
                    local itemChild = item:FindFirstChild("Item")
                    if itemChild then
                        moneyValue = itemChild:FindFirstChild("MoneyValue")
                        if moneyValue then
                            moneyValue = moneyValue.Value
                        else
                            moneyValue = 0
                        end
                    end
                    table.insert(lootList, {
                        name = itemName,
                        value = moneyValue,
                        location = container.Name
                    })
                end
            end
        end
    end
    
    -- SCAN GUNS (weapons from players + dropped)
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                table.insert(gunList, {
                    name = tool.Name,
                    owner = player.Name,
                    location = "Player Inventory"
                })
            end
        end
    end
    
    -- Scan ACS_WorkSpace dropped weapons
    local acsWS = workspace:FindFirstChild("ACS_WorkSpace")
    if acsWS then
        local dropped = acsWS:FindFirstChild("Server") and acsWS.Server:FindFirstChild("Dropped")
        if dropped then
            for _, model in ipairs(dropped:GetChildren()) do
                table.insert(gunList, {
                    name = model.Name,
                    owner = "World",
                    location = "ACS_WorkSpace.Server.Dropped"
                })
            end
        end
    end
    
    -- Sort by name
    table.sort(gunList, function(a, b) return a.name < b.name end)
    table.sort(lootList, function(a, b) return a.value > b.value end)
    
    return #gunList, #lootList
end

ToolTab:CreateButton({
    Name = "Scan Guns & Loots",
    Callback = function()
        local gunCount, lootCount = scanAllItems()
        Rayfield:Notify({
            Title = "Item Scan",
            Content = "Guns: " .. gunCount .. " | Loots: " .. lootCount,
            Duration = 3,
        })
        print("[Scanner] Found " .. gunCount .. " guns and " .. lootCount .. " loots")
    end,
})

ToolTab:CreateButton({
    Name = "Print Guns List",
    Callback = function()
        if #gunList == 0 then
            Rayfield:Notify({
                Title = "Guns",
                Content = "No guns scanned. Click 'Scan Guns & Loots' first!",
                Duration = 2,
            })
            return
        end
        
        print("\n" .. string.rep("=", 70))
        print("GUNS LIST (" .. #gunList .. " guns)")
        print(string.rep("=", 70))
        for i, gun in ipairs(gunList) do
            print(string.format("[%3d] %-40s | Owner: %-15s | %s",
                i, gun.name, gun.owner, gun.location))
        end
        print(string.rep("=", 70) .. "\n")
        
        Rayfield:Notify({
            Title = "Guns",
            Content = "Printed " .. #gunList .. " guns to console",
            Duration = 2,
        })
    end,
})

ToolTab:CreateButton({
    Name = "Print Loots List",
    Callback = function()
        if #lootList == 0 then
            Rayfield:Notify({
                Title = "Loots",
                Content = "No loots scanned. Click 'Scan Guns & Loots' first!",
                Duration = 2,
            })
            return
        end
        
        print("\n" .. string.rep("=", 70))
        print("LOOTS LIST (" .. #lootList .. " loots)")
        print(string.rep("=", 70))
        for i, loot in ipairs(lootList) do
            print(string.format("[%3d] %-40s | Value: %6d | Container: %s",
                i, loot.name, loot.value, loot.location))
        end
        print(string.rep("=", 70) .. "\n")
        
        Rayfield:Notify({
            Title = "Loots",
            Content = "Printed " .. #lootList .. " loots to console",
            Duration = 2,
        })
    end,
})

ToolTab:CreateLabel("Guns: " .. tostring(#gunList))
ToolTab:CreateLabel("Loots: " .. tostring(#lootList))

-- TAB 7: ACSmessing
local ACSTab = Window:CreateTab("ACSmessing", "settings")

-- ==========================================
-- NO RECOIL & NO SPREAD
-- ==========================================
ACSTab:CreateSection("Recoil Control")

ACSTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(enabled)
        if enabled then
            task.spawn(function()
                while Rayfield and Rayfield:Get("NoRecoil") == true do
                    pcall(function()
                        -- Hook into ACS framework's shooting
                        if _G.Shoot then
                            -- Try to reduce recoil by hooking Shoot
                            _G._NoRecoilActive = true
                        end
                        
                        -- Alternative: Try to modify via RepValues if available
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("RepValues") then
                            -- Monitor for recoil values
                            local repVals = tool.RepValues
                            -- Note: Recoil is handled by ACS framework internally
                            -- This is informational
                        end
                    end)
                    task.wait(0.1)
                end
                _G._NoRecoilActive = false
            end)
            
            Rayfield:Notify({
                Title = "No Recoil",
                Content = "⚠ Limited effect - ACS recoil is server-side",
                Duration = 3,
            })
        end
    end,
})

ACSTab:CreateLabel("Note: Recoil is handled by ACS framework")
ACSTab:CreateLabel("Client-side modification has limited effect")

ACSTab:CreateSection("Spread Control")

ACSTab:CreateToggle({
    Name = "No Spread",
    CurrentValue = false,
    Flag = "NoSpread",
    Callback = function(enabled)
        if enabled then
            task.spawn(function()
                while Rayfield and Rayfield:Get("NoSpread") == true do
                    pcall(function()
                        -- Hook into ACS framework
                        if _G.Shoot then
                            _G._NoSpreadActive = true
                        end
                    end)
                    task.wait(0.1)
                end
                _G._NoSpreadActive = false
            end)
            
            Rayfield:Notify({
                Title = "No Spread",
                Content = "⚠ Limited effect - ACS spread is server-side",
                Duration = 3,
            })
        end
    end,
})

ACSTab:CreateLabel("Note: Spread is handled by ACS framework")
ACSTab:CreateLabel("Client-side modification has limited effect")

ACSTab:CreateSection("ACS Engine Status")
ACSTab:CreateLabel("_G.Shoot: " .. tostring(_G.Shoot ~= nil))
ACSTab:CreateLabel("_G.t2: " .. tostring(_G.t2 ~= nil))
ACSTab:CreateLabel("Status: Not exposed to _G")

-- TAB 8: Debug
local DebugTab = Window:CreateTab("Debug", "terminal")

DebugTab:CreateSection("ESP Paths")
DebugTab:CreateLabel("Player ESP → Players[name].Character")
DebugTab:CreateLabel("Bot ESP → workspace.ACS_WorkSpace.AI[name]")
DebugTab:CreateLabel("Corpse ESP → workspace (Model + Humanoid + HRP, no player)")
DebugTab:CreateLabel("Armor ESP → Character.ACS_Client.Armor")
DebugTab:CreateLabel("Thermal ESP → Character.ACS_Client.Thermal")
DebugTab:CreateLabel("Weapon ESP → Character:FindFirstChildOfClass(\"Tool\")")
DebugTab:CreateLabel("Ammo ESP → workspace.ACS_WorkSpace.Ammo[name]")
DebugTab:CreateLabel("Extraction ESP → workspace.ACS_WorkSpace.Extractions[name]")
DebugTab:CreateLabel("Loot ESP → workspace.Lootables[container].Loot[item].MoneyValue")

DebugTab:CreateSection("Injury Detection Paths")
DebugTab:CreateLabel("Root → Character.ACS_Client.Body")
DebugTab:CreateLabel("Head → Body.Head → {Bleeding, Fractured, Injured}")
DebugTab:CreateLabel("Torso → Body.Thorax → {Bleeding, Fractured, Injured}")
DebugTab:CreateLabel("L.Arm → Body.LeftArm → {Bleeding, Fractured, Injured}")
DebugTab:CreateLabel("R.Arm → Body.RightArm → {Bleeding, Fractured, Injured}")
DebugTab:CreateLabel("L.Leg → Body.LeftLeg → {Bleeding, Fractured, Injured}")
DebugTab:CreateLabel("R.Leg → Body.RightLeg → {Bleeding, Fractured, Injured}")

DebugTab:CreateSection("Ammo Paths")
DebugTab:CreateLabel("Enemy Ammo → Character[Tool].RepValues.Mag / StoredAmmo / Chambered")
DebugTab:CreateLabel("Local Ammo → Character[Tool].ACS_Settings.AmmoInGun / StoredAmmo (REAL)")
DebugTab:CreateLabel("Max Mag → Character[Tool].GunStats.MagSize")

DebugTab:CreateSection("Bone ESP Attachments")
DebugTab:CreateLabel("Format → Part[JointName + RigAttachment].WorldPosition")
DebugTab:CreateLabel("Example → LeftFoot.LeftAnkleRigAttachment")
DebugTab:CreateLabel("Example → UpperTorso.LeftShoulderRigAttachment")
DebugTab:CreateLabel("Both ends of a joint share the same RigAttachment name")

DebugTab:CreateSection("Cham System")
DebugTab:CreateLabel("Type → Highlight (DepthMode: AlwaysOnTop)")
DebugTab:CreateLabel("Parent → inside the target Model")
DebugTab:CreateLabel("Player Cham → chamTable[player] = Highlight")
DebugTab:CreateLabel("Bot Cham → chamTable[bot] = Highlight")
DebugTab:CreateLabel("Corpse Cham → chamTable[corpse] = Highlight")
DebugTab:CreateLabel("Injury Label → BillboardGui in TargetContainer, Adornee = HRP")
DebugTab:CreateLabel("Injury update interval → 0.2s throttled heartbeat")

DebugTab:CreateSection("Live Counts")
DebugTab:CreateButton({
    Name = "Print Live State to Console",
    Callback = function()
        local function count(t) local n = 0; for _ in pairs(t) do n += 1 end; return n end
        print("=== m995 panel debug dump ===")
        print("ESP enabled:", espEnabled, "| Cham enabled:", chamEnabled)
        print("Player ESP tags:", count(playerESPTags))
        print("Bot ESP tags:", count(botESPTags))
        print("Corpse ESP tags:", count(corpseESPTags))
        print("Player chams:", count(playerChams))
        print("Bot chams:", count(botChams))
        print("Corpse chams:", count(corpseChams))
        print("Injury labels:", count(injuryLabels))
        print("Bone lines:", count(boneLines))
        print("Armor tags:", count(armorESPTags))
        print("Thermal tags:", count(thermalESPTags))
        print("Weapon tags:", count(weaponESPTags))
        print("Ammo tags:", count(ammoTags))
        print("Active connections:", #allConnections)
        print("=== end dump ===")
    end,
})

