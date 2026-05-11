-- Auto-generated module for m995 panel
local m = _G.m995
local Rayfield          = m.Rayfield
local Window            = m.Window
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

-- TAB 11: Game
local GameTab = Window:CreateTab("Game", "gamepad2")

GameTab:CreateSection("Performance Metrics")

local fpsLabel = GameTab:CreateLabel("FPS: Calculating...")
local pingLabel = GameTab:CreateLabel("Ping: Calculating...")

-- FPS Counter
local frameCount = 0
local lastSecond = tick()
local currentFPS = 0

game:GetService("RunService").RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    
    if currentTime - lastSecond >= 1 then
        currentFPS = frameCount
        frameCount = 0
        lastSecond = currentTime
    end
end)

-- Update FPS label every frame
game:GetService("RunService").RenderStepped:Connect(function()
    if fpsLabel then
        fpsLabel:Set("FPS: " .. tostring(currentFPS))
    end
end)

-- Ping Counter (approximation using heartbeat)
local lastPingUpdate = tick()
local estimatedPing = 0

game:GetService("RunService").Heartbeat:Connect(function()
    local currentTime = tick()
    if currentTime - lastPingUpdate >= 0.5 then
        -- Estimate ping based on network latency
        local stats = game:GetService("Stats")
        if stats then
            pcall(function()
                local networkReplicator = stats:FindFirstChild("Network") or stats:FindFirstChild("Replicator")
                if networkReplicator then
                    local ping = networkReplicator:FindFirstChild("ReceiveReplicationLag")
                    if ping then
                        estimatedPing = math.floor(ping.Value * 1000) -- Convert to milliseconds
                    end
                end
            end)
        end
        
        if pingLabel and estimatedPing > 0 then
            pingLabel:Set("Ping: " .. tostring(estimatedPing) .. " ms")
        end
        
        lastPingUpdate = currentTime
    end
end)

GameTab:CreateSection("Performance Status")

GameTab:CreateButton({
    Name = "📊 Refresh Stats",
    Callback = function()
        Rayfield:Notify({
            Title = "Game Stats",
            Content = "FPS: " .. currentFPS .. " | Ping: " .. estimatedPing .. " ms",
            Duration = 2,
        })
        print("[Game] Current FPS: " .. currentFPS .. " | Estimated Ping: " .. estimatedPing .. " ms")
    end,
})

GameTab:CreateLabel("📌 Stats update in real-time")
GameTab:CreateLabel("⚠ Ping is approximated from network lag")

-- TAB 12: Panel Changelogs
local PanelChangelogTab = Window:CreateTab("Panel Changelogs", "book")

PanelChangelogTab:CreateSection("m995 Panel Updates")
PanelChangelogTab:CreateLabel("Track all panel versions and features")
PanelChangelogTab:CreateLabel("Current Version: 7.4.0")

local panelChangelogText = "Loading changelog..."
local panelChangelogLoaded = false

PanelChangelogTab:CreateButton({
    Name = "📋 Fetch Panel Changelog",
    Callback = function()
        Rayfield:Notify({
            Title = "Panel Changelog",
            Content = "Fetching latest updates...",
            Duration = 2,
        })
        
        task.spawn(function()
            pcall(function()
                local response = game:HttpGet("https://raw.githubusercontent.com/windbreaker7/Arena-bloxoutlol/refs/heads/main/m995_panel_Update.md?token=GHSAT0AAAAAADXXQUGEOBZY7XVC2QBGCGOK2QBQ6UQ", true)
                if response then
                    panelChangelogText = response
                    panelChangelogLoaded = true
                    print("[Panel] Changelog loaded successfully!")
                    Rayfield:Notify({
                        Title = "Panel Changelog",
                        Content = "✅ Changelog loaded! Check console for details.",
                        Duration = 2,
                    })
                    -- Print to console for viewing
                    print("\n" .. string.rep("=", 60))
                    print("m995 PANEL - CHANGELOG")
                    print(string.rep("=", 60))
                    print(response)
                    print(string.rep("=", 60) .. "\n")
                else
                    Rayfield:Notify({
                        Title = "Panel Changelog",
                        Content = "❌ Failed to fetch changelog",
                        Duration = 2,
                    })
                end
            end)
        end)
    end,
})

PanelChangelogTab:CreateButton({
    Name = "📄 Print Panel Changelog to Console",
    Callback = function()
        if panelChangelogLoaded then
            print("\n" .. string.rep("=", 60))
            print("m995 PANEL - CHANGELOG")
            print(string.rep("=", 60))
            print(panelChangelogText)
            print(string.rep("=", 60) .. "\n")
            
            Rayfield:Notify({
                Title = "Panel Changelog",
                Content = "Printed to console (F9)",
                Duration = 2,
            })
        else
            Rayfield:Notify({
                Title = "Panel Changelog",
                Content = "Click 'Fetch Panel Changelog' first!",
                Duration = 2,
            })
        end
    end,
})

PanelChangelogTab:CreateSection("Version History")
PanelChangelogTab:CreateLabel("Latest: v7.4.0")
PanelChangelogTab:CreateLabel("Released: May 2026")
PanelChangelogTab:CreateLabel("")
PanelChangelogTab:CreateLabel("Major Features:")
PanelChangelogTab:CreateLabel("✅ Decompiler Integration")
PanelChangelogTab:CreateLabel("✅ Tools & Item Database")
PanelChangelogTab:CreateLabel("✅ User Info Display")
PanelChangelogTab:CreateLabel("✅ Drama/Trolling Tab")
PanelChangelogTab:CreateLabel("✅ Key Authentication")
PanelChangelogTab:CreateLabel("✅ 19 Tabs Total")
PanelChangelogTab:CreateLabel("")
PanelChangelogTab:CreateLabel("File Size: 172 KB")
PanelChangelogTab:CreateLabel("Goal: 1 MB by EOY")

-- TAB 13: Decompiler
local DecompilerTab = Window:CreateTab("Decompiler", "code")

DecompilerTab:CreateSection("Script Scanner & Decompiler")
DecompilerTab:CreateLabel("MEGGD Script Scanner Mobile")
DecompilerTab:CreateLabel("Scans and decompiles game scripts")

DecompilerTab:CreateButton({
    Name = "🔍 Start Script Scanner",
    Callback = function()
        Rayfield:Notify({
            Title = "Decompiler",
            Content = "Launching MEGGD Script Scanner...",
            Duration = 2,
        })
        
        -- Execute the MEGGD Script Scanner Mobile via loadstring from GitHub
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/windbreaker7/MEGGD-Script-Scanner/refs/heads/main/Device/MEGGD_Script_Scanner_Mobile.lua", true))()
        end)
        
        print("[Decompiler] ✅ MEGGD Script Scanner Mobile loaded!")
        
        Rayfield:Notify({
            Title = "Decompiler",
            Content = "✅ Script Scanner is now active!",
            Duration = 2,
        })
    end,
})

DecompilerTab:CreateSection("Changelog & Updates")

local changelogText = "Loading changelog..."
local changelogLoaded = false

DecompilerTab:CreateButton({
    Name = "📋 Fetch Changelog",
    Callback = function()
        Rayfield:Notify({
            Title = "Changelog",
            Content = "Fetching latest updates...",
            Duration = 2,
        })
        
        task.spawn(function()
            pcall(function()
                local response = game:HttpGet("https://raw.githubusercontent.com/windbreaker7/MEGGD-Script-Scanner/refs/heads/main/Update%20(1).md", true)
                if response then
                    changelogText = response
                    changelogLoaded = true
                    print("[Decompiler] Changelog loaded successfully!")
                    Rayfield:Notify({
                        Title = "Changelog",
                        Content = "✅ Changelog loaded! Check console for details.",
                        Duration = 2,
                    })
                    -- Print to console for viewing
                    print("\n" .. string.rep("=", 60))
                    print("MEGGD SCRIPT SCANNER - CHANGELOG")
                    print(string.rep("=", 60))
                    print(response)
                    print(string.rep("=", 60) .. "\n")
                else
                    Rayfield:Notify({
                        Title = "Changelog",
                        Content = "❌ Failed to fetch changelog",
                        Duration = 2,
                    })
                end
            end)
        end)
    end,
})

DecompilerTab:CreateButton({
    Name = "📄 Print Changelog to Console",
    Callback = function()
        if changelogLoaded then
            print("\n" .. string.rep("=", 60))
            print("MEGGD SCRIPT SCANNER - CHANGELOG")
            print(string.rep("=", 60))
            print(changelogText)
            print(string.rep("=", 60) .. "\n")
            
            Rayfield:Notify({
                Title = "Changelog",
                Content = "Printed to console (F9)",
                Duration = 2,
            })
        else
            Rayfield:Notify({
                Title = "Changelog",
                Content = "Click 'Fetch Changelog' first!",
                Duration = 2,
            })
        end
    end,
})

DecompilerTab:CreateSection("Information")
DecompilerTab:CreateLabel("📝 Features:")
DecompilerTab:CreateLabel("• Scan all scripts in workspace")
DecompilerTab:CreateLabel("• Decompile LocalScripts & ModuleScripts")
DecompilerTab:CreateLabel("• Search & filter scripts")
DecompilerTab:CreateLabel("• Copy decompiled code")
DecompilerTab:CreateLabel("• Export to file")
DecompilerTab:CreateLabel("")
DecompilerTab:CreateLabel("📌 Latest Version: 1.3.1")
DecompilerTab:CreateLabel("⚠ Note: Opens in separate GUI window")

-- TAB 14: Info
local InfoTab = Window:CreateTab("Info", "info")
InfoTab:CreateSection("m995 panel")
InfoTab:CreateLabel("Version: v7.4 (Real Ammo System - ACS_Settings)")
InfoTab:CreateLabel("A full-featured ESP suite built for ACS-based games.")
InfoTab:CreateLabel("Optimized for MEGGD customized ACS framework.")
InfoTab:CreateSection("From the Creator")
InfoTab:CreateLabel("\"Even though the game has a mod panel, it don't have a function I hope so I created this.\"")
InfoTab:CreateSection("Credits")
InfoTab:CreateLabel("Script by: millionlikes_9677")
InfoTab:CreateLabel("Discord: Bfgc#7234")
InfoTab:CreateLabel("AI assistance: Claude (Anthropic)")
InfoTab:CreateSection("Features")
InfoTab:CreateLabel("• Loot ESP with value filtering & presets")
InfoTab:CreateLabel("• Player ESP with health, bones & injury detection")
InfoTab:CreateLabel("• Armor durability tracking")
InfoTab:CreateLabel("• Thermal / Face Shield detection")
InfoTab:CreateLabel("• Weapon & ammo display")
InfoTab:CreateLabel("• Bot AI & corpse tracking")
InfoTab:CreateLabel("• Local ammo HUD")
InfoTab:CreateLabel("• Extraction zone ESP")
InfoTab:CreateLabel("• World Loot & Spawn ESP")
InfoTab:CreateLabel("• Player Info tab (name, UserID, account age)")
InfoTab:CreateLabel("• Health bar ESP (players & bots)")
InfoTab:CreateLabel("• Music Player (local files via getcustomasset)")
InfoTab:CreateSection("Keybinds")
InfoTab:CreateLabel("ALT - Toggle ESP on/off")
InfoTab:CreateLabel("ALT+R - Cycle loot preset")

-- ==========================================
-- INITIALIZATION
-- ==========================================
task.spawn(function()
    local lootF = workspace:WaitForChild("Lootables", 10)
    if lootF then
        for _, obj in ipairs(lootF:GetChildren()) do setupGenericContainer(obj) end
        trackConnection(lootF.ChildAdded:Connect(setupGenericContainer))
    end

    local extF = workspace:WaitForChild("ExtractionZones", 10)
    if extF then
        for _, z in ipairs(extF:GetChildren()) do setupExtraction(z) end
        trackConnection(extF.ChildAdded:Connect(setupExtraction))
    end

    -- Wait for ACS_WorkSpace so bots aren't missed if it loads after the script
    local acsWS = workspace:WaitForChild("ACS_WorkSpace", 15)
    if acsWS then
        local ai = acsWS:WaitForChild("AI", 10)
        if ai then
            for _, bot in ipairs(ai:GetChildren()) do
                createBotESPTag(bot)
            end
            trackConnection(ai.ChildAdded:Connect(createBotESPTag))
            trackConnection(ai.ChildRemoving:Connect(removeBotESPTag))
        end

        local ammoFolder = acsWS:FindFirstChild("Ammo")
        if ammoFolder then
            for _, ammo in ipairs(ammoFolder:GetChildren()) do
                createAmmoESPTag(ammo)
            end
            trackConnection(ammoFolder.ChildAdded:Connect(createAmmoESPTag))
        end

        local function isCorpse(obj)
            -- Match any Model whose name contains the word "Corpse" (case-insensitive)
            return obj:IsA("Model")
                and obj.Name:lower():find("corpse") ~= nil
        end

        for _, obj in ipairs(workspace:GetChildren()) do
            if isCorpse(obj) then createCorpseESPTag(obj) end
        end
        trackConnection(workspace.ChildAdded:Connect(function(obj)
            if isCorpse(obj) then createCorpseESPTag(obj) end
        end))
        trackConnection(workspace.ChildRemoving:Connect(function(obj)
            removeCorpseESPTag(obj)
        end))
    end

    -- World Loot ESP — workspace.ACS_WorkSpace.Server.Dropped
    local droppedFolder = acsWS and acsWS:FindFirstChild("Server") and acsWS.Server:FindFirstChild("Dropped")
    if droppedFolder then
        for _, model in ipairs(droppedFolder:GetChildren()) do
            if worldLootEnabled then setupWorldLootESP(model) end
        end
        trackConnection(droppedFolder.ChildAdded:Connect(function(model)
            if worldLootEnabled then setupWorldLootESP(model) end
        end))
        trackConnection(droppedFolder.ChildRemoving:Connect(function(model)
            local anchor = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if anchor then removeWorldESPTag(anchor, worldLootTags) end
        end))
    end

    -- Spawn ESP — workspace.Spawns and workspace.SpawnBaseParts
    local spawnsFolder = workspace:FindFirstChild("Spawns")
    if spawnsFolder then
        for _, obj in ipairs(spawnsFolder:GetChildren()) do
            if spawnESPEnabled then setupSpawnESP(obj) end
        end
        trackConnection(spawnsFolder.ChildAdded:Connect(function(obj)
            if spawnESPEnabled then setupSpawnESP(obj) end
        end))
    end

    local spawnBaseParts = workspace:FindFirstChild("SpawnBaseParts")
    if spawnBaseParts then
        for _, obj in ipairs(spawnBaseParts:GetChildren()) do
            if spawnESPEnabled then setupSpawnESP(obj) end
        end
        trackConnection(spawnBaseParts.ChildAdded:Connect(function(obj)
            if spawnESPEnabled then setupSpawnESP(obj) end
        end))
    end

    for _, player in ipairs(Players:GetPlayers()) do
        setupPlayerTools(player)
        setupPlayerESP(player)
    end

    trackConnection(Players.PlayerAdded:Connect(function(player)
        setupPlayerTools(player)
        setupPlayerESP(player)
    end))

    trackConnection(Players.PlayerRemoving:Connect(function(player)
        removeAmmoTag(player)
        removePlayerESPTag(player)
        removeArmorESPTag(player)
        removeThermalESPTag(player)
        removeWeaponESPTag(player)
        removeBoneLines(player)
        removePlayerCham(player)
        removePlayerBoxESP(player)
        local conns = enemyAmmoConnections[player]
        if conns then
            cleanupConnections(conns)
            enemyAmmoConnections[player] = nil
        end
        ammoTags[player] = nil
        playerESPTags[player] = nil
    end))
end)

if LocalPlayer.Character then setupLocalCharacter(LocalPlayer.Character) end
trackConnection(LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0)
    setupLocalCharacter(character)
end))

-- ==========================================
-- KEYBINDS
-- ==========================================
trackConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        local on = toggleESP()
        Rayfield:Notify({
            Title = "ESP",
            Content = on and "✅ Enabled" or "❌ Disabled",
            Duration = 2,
        })
    elseif input.KeyCode == Enum.KeyCode.R and
           (UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) then
        local preset = cyclePreset()
        Rayfield:Notify({
            Title = "Preset",
            Content = "-> " .. preset,
            Duration = 2,
        })
    end
end))

Rayfield:Notify({
    Title = "m995 panel",
    Content = "All systems online",
    Duration = 5,
})

print("[m995 panel v7.4] MEGGD ACS updated + Real Ammo System (ACS_Settings) + Live Ammo Counter!")
