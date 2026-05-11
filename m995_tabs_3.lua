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

-- TAB 10: View
local ViewTab = Window:CreateTab("Palantir", "eye")

-- ==========================================
-- VIEW / SPECTATE
-- ==========================================
local viewTarget   = nil   -- Player object currently being viewed
local viewMode     = "none" -- "none" | "orbit" | "pov"
local viewConn     = nil   -- Heartbeat connection for POV mode

local function exitView()
    viewTarget = nil
    viewMode   = "none"
    if viewConn then
        viewConn:Disconnect()
        viewConn = nil
    end
    -- Restore camera to local player
    Camera.CameraType    = Enum.CameraType.Custom
    Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or nil
    Rayfield:Notify({ Title = "View", Content = "Returned to your camera.", Duration = 2 })
end

local function orbitPlayer(player)
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Rayfield:Notify({ Title = "View", Content = player.Name .. " has no character.", Duration = 3 })
        return
    end
    -- Disconnect any active POV connection first
    if viewConn then viewConn:Disconnect() viewConn = nil end

    viewTarget = player
    viewMode   = "orbit"

    -- Custom + subject on their HumanoidRootPart lets the engine handle
    -- free orbit while keeping the camera locked to their position
    Camera.CameraType    = Enum.CameraType.Custom
    Camera.CameraSubject = hrp

    Rayfield:Notify({
        Title   = "View - Orbit",
        Content = "Orbiting " .. player.Name .. "\nPress E to exit.",
        Duration = 3,
    })
end

local function povPlayer(player)
    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if not head then
        Rayfield:Notify({ Title = "View", Content = player.Name .. " has no character.", Duration = 3 })
        return
    end
    if viewConn then viewConn:Disconnect() viewConn = nil end

    viewTarget = player
    viewMode   = "pov"

    Camera.CameraType = Enum.CameraType.Scriptable

    viewConn = RunService.Heartbeat:Connect(function()
        if not viewTarget or viewMode ~= "pov" then return end
        local c     = viewTarget.Character
        local h     = c and c:FindFirstChild("Head")
        if not h then return end
        -- Position camera at head, looking in the direction the head faces
        Camera.CFrame = CFrame.new(h.Position, h.Position + h.CFrame.LookVector * 10)
    end)

    Rayfield:Notify({
        Title   = "View - POV",
        Content = "Viewing POV of " .. player.Name .. "\nPress E to exit.",
        Duration = 3,
    })
end

-- E keybind to exit view
trackConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E and viewMode ~= "none" then
        exitView()
    end
end))

-- -- UI -----------------------------------------------------------------------
ViewTab:CreateSection("Current View")
local viewStatusLabel = ViewTab:CreateLabel("Status: Not viewing anyone")

-- Update status label every 0.5s
local lastViewUpdate = 0
RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if (now - lastViewUpdate) < 0.5 then return end
    lastViewUpdate = now
    if viewMode == "none" or not viewTarget then
        pcall(function() viewStatusLabel:Set("Status: Not viewing anyone") end)
    else
        pcall(function()
            viewStatusLabel:Set(string.format(
                "Status: %s - %s\nPress E or use button below to exit.",
                viewMode == "orbit" and "Orbiting" or "POV",
                viewTarget.Name
            ))
        end)
    end
end)

ViewTab:CreateSection("Exit")

ViewTab:CreateButton({
    Name = "🚪  Exit View  (or press E)",
    Callback = function()
        if viewMode == "none" then
            Rayfield:Notify({ Title = "View", Content = "Not currently viewing anyone.", Duration = 2 })
        else
            exitView()
        end
    end,
})

ViewTab:CreateSection("Players")
ViewTab:CreateLabel("Press Refresh to load current players.")
ViewTab:CreateLabel("Then pick a player and a view mode.")

-- Holds the dynamically created player buttons so we can track them
local viewPlayerButtons = {}

local function refreshViewPlayers()
    -- Rayfield doesn't support removing individual elements,
    -- so we rebuild the section by re-creating the tab section label
    -- and re-generating buttons. We mark stale entries and skip them.
    viewPlayerButtons = {}

    local players = Players:GetPlayers()
    -- Filter out local player
    local others = {}
    for _, p in ipairs(players) do
        if p ~= LocalPlayer then table.insert(others, p) end
    end

    if #others == 0 then
        Rayfield:Notify({ Title = "View", Content = "No other players in server.", Duration = 3 })
        return
    end

    for _, player in ipairs(others) do
        local name = player.Name

        ViewTab:CreateButton({
            Name = "👁  " .. name .. "  -  Orbit",
            Callback = function()
                orbitPlayer(player)
            end,
        })

        ViewTab:CreateButton({
            Name = "🎥  " .. name .. "  -  POV",
            Callback = function()
                povPlayer(player)
            end,
        })
    end

    Rayfield:Notify({
        Title   = "View",
        Content = "Loaded " .. #others .. " player(s).",
        Duration = 2,
    })
end

ViewTab:CreateButton({
    Name = "🔄  Refresh Player List",
    Callback = function()
        refreshViewPlayers()
    end,
})

-- Auto-refresh when tab loads
task.spawn(function()
    task.wait(1)
    refreshViewPlayers()
end)

-- TAB: Moderation
local ModTab = Window:CreateTab("Moderation", "shield")

-- ==========================================
-- LOOK LINE
-- ==========================================
local lookLines = {}   -- { [player] = LineHandleAdornment }
local LOOK_LINE_LENGTH = 50  -- studs

local function removeLookLine(player)
    if lookLines[player] then
        pcall(function() lookLines[player]:Destroy() end)
        lookLines[player] = nil
    end
end

local function createLookLine(player)
    removeLookLine(player)
    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end

    local line = Instance.new("LineHandleAdornment")
    line.Name        = "LookLine_" .. player.Name
    line.Adornee     = head
    line.Color3      = SETTINGS.LookLineColor
    line.Thickness   = 3
    line.AlwaysOnTop = true
    line.From        = Vector3.zero
    line.To          = Vector3.new(0, 0, -LOOK_LINE_LENGTH) -- updated each frame
    line.Parent      = TargetContainer

    lookLines[player] = line
end

local function clearAllLookLines()
    for player in pairs(lookLines) do
        removeLookLine(player)
    end
end

-- Update look lines every heartbeat
local LOOK_LINE_INTERVAL = 0
RunService.Heartbeat:Connect(function()
    if not SETTINGS.SHOW_LOOK_LINE then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then
            removeLookLine(player)
            continue
        end

        -- Create line if it doesn't exist yet
        if not lookLines[player] then
            createLookLine(player)
        end

        local line = lookLines[player]
        if not line or not line.Parent then continue end

        -- Update color in case it was changed in settings
        line.Color3 = SETTINGS.LookLineColor

        -- Draw from head in the direction the head is looking (local space)
        -- Line.From is always Vector3.zero (origin of adornee)
        -- Line.To is in adornee-local space, so we transform the look direction
        local lookWorld = head.CFrame.LookVector * LOOK_LINE_LENGTH
        line.To = head.CFrame:VectorToObjectSpace(lookWorld) -- always (0,0,-length) but keeps it correct if head rolls
    end
end)

-- Clean up look lines when player leaves
trackConnection(Players.PlayerRemoving:Connect(function(player)
    removeLookLine(player)
end))

-- Clean up when character removed
trackConnection(Players.PlayerAdded:Connect(function(player)
    player.CharacterRemoving:Connect(function()
        removeLookLine(player)
    end)
end))
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterRemoving:Connect(function()
            removeLookLine(player)
        end)
    end
end

-- -- UI -----------------------------------------------------------------------
ModTab:CreateSection("Look Direction Line")
ModTab:CreateLabel("Draws a line from each player's head")
ModTab:CreateLabel("in the direction they are looking.")
ModTab:CreateLabel("Useful for detecting ESP (tracking through walls).")
ModTab:CreateLabel("Color can be changed in the Colors tab.")

ModTab:CreateToggle({
    Name         = "Show Look Lines",
    CurrentValue = SETTINGS.SHOW_LOOK_LINE,
    Flag         = "Toggle_LookLine",
    Callback     = function(val)
        SETTINGS.SHOW_LOOK_LINE = val
        if not val then
            clearAllLookLines()
        end
    end,
})

ModTab:CreateSlider({
    Name         = "Line Length",
    Range        = {10, 200},
    Increment    = 5,
    Suffix       = " studs",
    CurrentValue = LOOK_LINE_LENGTH,
    Flag         = "LookLineLength",
    Callback     = function(val)
        LOOK_LINE_LENGTH = val
    end,
})

ModTab:CreateSection("Actions")

ModTab:CreateButton({
    Name = "🔄  Refresh Look Lines",
    Callback = function()
        clearAllLookLines()
        if SETTINGS.SHOW_LOOK_LINE then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createLookLine(player)
                end
            end
            Rayfield:Notify({ Title = "Moderation", Content = "Look lines refreshed.", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Moderation", Content = "Enable Look Lines first.", Duration = 2 })
        end
    end,
})

ModTab:CreateButton({
    Name = "🗑  Clear All Look Lines",
    Callback = function()
        clearAllLookLines()
        Rayfield:Notify({ Title = "Moderation", Content = "Look lines cleared.", Duration = 2 })
    end,
})

ModTab:CreateButton({
    Name = "🗑  Clear All Look Lines",
    Callback = function()
        clearAllLookLines()
        Rayfield:Notify({ Title = "Moderation", Content = "Look lines cleared.", Duration = 2 })
    end,
})

-- TAB: Flagged Players
local FlaggedTab = Window:CreateTab("Flagged", "shield-alert")

-- ==========================================
-- ANTI-CHEAT / FLAG DETECTION
-- ==========================================
local FLING_THRESHOLD    = 200   -- studs/s
local SPEED_THRESHOLD    = 25    -- WalkSpeed limit
local AIRTIME_THRESHOLD  = 1.0   -- seconds in air with horizontal movement
local HORIZ_MOVE_MIN     = 2     -- min horizontal studs/s to count as moving

-- { [player] = { flags = {reason→true}, label = RayfieldLabel, airtimer = number } }
local flaggedPlayers = {}

-- Per-player tracking state (not necessarily flagged yet)
-- { [player] = { airTime = 0, lastPos = Vector3, lastVelMag = 0 } }
local playerTrack = {}

local flagSectionLabel -- updated to show count

local function formatFlags(flagTable)
    local parts = {}
    for reason in pairs(flagTable) do
        table.insert(parts, reason)
    end
    table.sort(parts)
    return table.concat(parts, "  |  ")
end

local function buildFlagText(player, flagTable)
    return string.format("? %s\n  %s", player.Name, formatFlags(flagTable))
end

local function addOrUpdateFlag(player, reason)
    if player == LocalPlayer then return end

    local existing = flaggedPlayers[player]
    if existing then
        if existing.flags[reason] then return end  -- already flagged for this reason
        existing.flags[reason] = true
        pcall(function()
            existing.label:Set(buildFlagText(player, existing.flags))
        end)
    else
        local flags = { [reason] = true }
        local label = FlaggedTab:CreateLabel(buildFlagText(player, flags))
        flaggedPlayers[player] = { flags = flags, label = label }
    end

    -- Notify
    Rayfield:Notify({
        Title   = "? Flag: " .. player.Name,
        Content = reason,
        Duration = 5,
    })

    -- Update section label count
    local count = 0
    for _ in pairs(flaggedPlayers) do count = count + 1 end
    pcall(function()
        flagSectionLabel:Set("Flagged players: " .. count)
    end)
end

-- -- Detection ----------------------------------------------------------------
local function checkNoclip(player)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Method 1: HRP CanCollide off
    if not hrp.CanCollide then
        addOrUpdateFlag(player, "Noclip (HRP CanCollide=false)")
    end

    -- Method 2: Any character BasePart has CanCollide off
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part ~= hrp and not part.CanCollide then
            addOrUpdateFlag(player, "Noclip (Part CanCollide=false: " .. part.Name .. ")")
            break
        end
    end

    -- Method 3: Spatial — check if HRP overlaps geometry it shouldn't
    -- Use GetPartsInPart to detect intersection with non-character parts
    local overlapParams = OverlapParams.new()
    overlapParams.FilterDescendantsInstances = { char }
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    local touching = workspace:GetPartsInPart(hrp, overlapParams)
    -- If any solid, non-passthrough part overlaps them they're inside geometry
    for _, part in ipairs(touching) do
        if part:IsA("BasePart") and not part.CanTouch == false and part.CanCollide then
            addOrUpdateFlag(player, "Noclip (Inside geometry: " .. part.Name .. ")")
            break
        end
    end
end

local DETECTION_INTERVAL = 0.5
local lastDetection = 0

RunService.Heartbeat:Connect(function(dt)
    local now = os.clock()

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then
            playerTrack[player] = nil
            continue
        end

        -- Init tracking state
        if not playerTrack[player] then
            playerTrack[player] = { airTime = 0, lastPos = hrp.Position }
        end
        local track = playerTrack[player]

        -- -- Fling detection (every frame — velocity spikes are momentary) --
        local vel = hrp.AssemblyLinearVelocity.Magnitude
        if vel >= FLING_THRESHOLD then
            addOrUpdateFlag(player, string.format("Fling (%.0f studs/s)", vel))
        end

        -- -- Airtime + horizontal movement --
        local horizVel = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z).Magnitude
        if hum.FloorMaterial == Enum.Material.Air and horizVel > HORIZ_MOVE_MIN then
            track.airTime = (track.airTime or 0) + dt
            if track.airTime >= AIRTIME_THRESHOLD then
                addOrUpdateFlag(player, string.format("Airtime (%.1fs airborne + moving)", track.airTime))
            end
        else
            track.airTime = 0
        end

        track.lastPos = hrp.Position

        -- -- Throttled checks (every 0.5s) --
        if (now - lastDetection) >= DETECTION_INTERVAL then
            -- WalkSpeed
            if hum.WalkSpeed > SPEED_THRESHOLD then
                addOrUpdateFlag(player, string.format("Speed (WalkSpeed=%.0f)", hum.WalkSpeed))
            end

            -- Noclip
            checkNoclip(player)
        end
    end

    if (now - lastDetection) >= DETECTION_INTERVAL then
        lastDetection = now
    end

    -- Clean up tracking for players who left
    for player in pairs(playerTrack) do
        if not player.Parent then
            playerTrack[player] = nil
        end
    end
end)

-- Clean up flagged entries when player leaves
trackConnection(Players.PlayerRemoving:Connect(function(player)
    flaggedPlayers[player] = nil
    playerTrack[player]    = nil
end))

-- -- UI -----------------------------------------------------------------------
FlaggedTab:CreateSection("Status")
flagSectionLabel = FlaggedTab:CreateLabel("Flagged players: 0")

FlaggedTab:CreateSection("Thresholds")
FlaggedTab:CreateLabel("WalkSpeed limit: " .. SPEED_THRESHOLD)
FlaggedTab:CreateLabel("Fling threshold: " .. FLING_THRESHOLD .. " studs/s")
FlaggedTab:CreateLabel("Airtime threshold: " .. AIRTIME_THRESHOLD .. "s (horizontal movement required)")

FlaggedTab:CreateSection("Actions")

FlaggedTab:CreateButton({
    Name = "🗑  Clear All Flags",
    Callback = function()
        flaggedPlayers = {}
        playerTrack    = {}
        pcall(function() flagSectionLabel:Set("Flagged players: 0") end)
        Rayfield:Notify({ Title = "Flagged", Content = "All flags cleared.", Duration = 2 })
    end,
})

FlaggedTab:CreateButton({
    Name = "📋  Print Flags to Console",
    Callback = function()
        local count = 0
        print("=== m995 panel - Flagged Players ===")
        for player, data in pairs(flaggedPlayers) do
            count = count + 1
            print(string.format("  %s:", player.Name))
            for reason in pairs(data.flags) do
                print("    - " .. reason)
            end
        end
        if count == 0 then print("  No flagged players.") end
        print("====================================")
        Rayfield:Notify({
            Title   = "Flagged",
            Content = "Printed " .. count .. " flagged player(s) to console (F9)",
            Duration = 3,
        })
    end,
})

FlaggedTab:CreateSection("Flagged List")
FlaggedTab:CreateLabel("Players flagged during this session appear below.")
FlaggedTab:CreateLabel("Use Clear All Flags to reset.")

-- TAB: Israel
local IsraelTab = Window:CreateTab("Israel", "radio")

-- ==========================================
-- RADAR
-- ==========================================
local RADAR_SIZE        = 160   -- px diameter
local RADAR_RANGE       = 150   -- studs radius shown on radar
local DOT_SIZE          = 8     -- px diameter of each dot
local RADAR_POS_X       = 0.5   -- screen X anchor (0.5 = center)
local RADAR_POS_Y       = 0.08  -- screen Y anchor

local radarEnabled      = false
local radarShowPlayers  = true
local radarShowBots     = true
local radarShowLoot     = true
local radarShowExtracts = true

local radarGui     = nil
local radarCircle  = nil
local radarDots    = {}   -- pool of dot frames { frame, inUse }

local function removeRadar()
    if radarGui and radarGui.Parent then
        pcall(function() radarGui:Destroy() end)
    end
    radarGui    = nil
    radarCircle = nil
    radarDots   = {}
end

local function createRadar()
    removeRadar()

    local sg = Instance.new("ScreenGui")
    sg.Name           = "IsraelRadar"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder   = 15
    sg.Parent         = TargetContainer

    -- Outer circle
    local circle = Instance.new("Frame")
    circle.Name                   = "RadarCircle"
    circle.Size                   = UDim2.new(0, RADAR_SIZE, 0, RADAR_SIZE)
    circle.Position               = UDim2.new(RADAR_POS_X, -RADAR_SIZE/2, RADAR_POS_Y, 0)
    circle.BackgroundColor3       = Color3.fromRGB(10, 10, 10)
    circle.BackgroundTransparency = 0.4
    circle.BorderSizePixel        = 0
    circle.ClipsDescendants       = true
    circle.Parent                 = sg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent       = circle

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent    = circle

    -- Crosshair lines
    local function makeLine(horizontal)
        local line = Instance.new("Frame")
        line.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = 0.7
        line.BorderSizePixel        = 0
        if horizontal then
            line.Size     = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0.5, 0)
        else
            line.Size     = UDim2.new(0, 1, 1, 0)
            line.Position = UDim2.new(0.5, 0, 0, 0)
        end
        line.Parent = circle
    end
    makeLine(true)
    makeLine(false)

    -- Center dot (local player)
    local center = Instance.new("Frame")
    center.Name                   = "CenterDot"
    center.Size                   = UDim2.new(0, DOT_SIZE, 0, DOT_SIZE)
    center.Position               = UDim2.new(0.5, -DOT_SIZE/2, 0.5, -DOT_SIZE/2)
    center.BackgroundColor3       = Color3.fromRGB(0, 200, 255)
    center.BorderSizePixel        = 0
    center.ZIndex                 = 3
    center.Parent                 = circle

    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent       = center

    radarGui    = sg
    radarCircle = circle
end

-- Dot pool — reuse frames instead of creating/destroying every frame
local function getDot()
    for _, entry in ipairs(radarDots) do
        if not entry.inUse then
            entry.inUse = true
            entry.frame.Visible = true
            return entry
        end
    end
    -- Create a new dot
    local frame = Instance.new("Frame")
    frame.Size            = UDim2.new(0, DOT_SIZE, 0, DOT_SIZE)
    frame.BorderSizePixel = 0
    frame.ZIndex          = 2
    frame.Parent          = radarCircle

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent       = frame

    local entry = { frame = frame, inUse = true }
    table.insert(radarDots, entry)
    return entry
end

local function releaseDots()
    for _, entry in ipairs(radarDots) do
        entry.inUse         = false
        entry.frame.Visible = false
    end
end

local function worldToRadar(worldPos, rootPos, camCF)
    local rel    = worldPos - rootPos
    -- Project onto XZ plane
    local flat   = Vector3.new(rel.X, 0, rel.Z)
    local dist2D = flat.Magnitude
    if dist2D > RADAR_RANGE then return nil end

    -- Rotate relative to camera yaw
    local camFlat  = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
    local angle    = math.atan2(camFlat.X, camFlat.Z)

    local cosA, sinA = math.cos(-angle), math.sin(-angle)
    local rx = flat.X * cosA - flat.Z * sinA
    local rz = flat.X * sinA + flat.Z * cosA

    -- Normalize to -1..1 then to pixel offset
    local nx = rx / RADAR_RANGE
    local ny = rz / RADAR_RANGE
    local half = RADAR_SIZE / 2

    return UDim2.new(0, half + nx * half - DOT_SIZE/2,
                     0, half + ny * half - DOT_SIZE/2)
end

local function placeDot(pos2D, color, label)
    if not pos2D then return end
    local entry = getDot()
    entry.frame.Position        = pos2D
    entry.frame.BackgroundColor3 = color

    -- Label inside dot
    local lbl = entry.frame:FindFirstChild("DotLabel")
    if not lbl then
        lbl = Instance.new("TextLabel")
        lbl.Name                   = "DotLabel"
        lbl.BackgroundTransparency = 1
        lbl.Size                   = UDim2.new(0, 60, 0, 14)
        lbl.Position               = UDim2.new(0, DOT_SIZE + 2, 0.5, -7)
        lbl.TextColor3             = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeTransparency = 0.4
        lbl.TextSize               = 10
        lbl.Font                   = Enum.Font.GothamBold
        lbl.TextXAlignment         = Enum.TextXAlignment.Left
        lbl.ZIndex                 = 3
        lbl.Parent                 = entry.frame
    end
    lbl.Text = label or ""
end

local RADAR_INTERVAL  = 0.1
local lastRadarUpdate = 0

RunService.Heartbeat:Connect(function()
    if not radarEnabled then return end
    if not radarGui or not radarGui.Parent then return end

    local now = os.clock()
    if (now - lastRadarUpdate) < RADAR_INTERVAL then return end
    lastRadarUpdate = now

    local root  = getCachedRoot()
    if not root then return end
    local camCF = Camera.CFrame

    releaseDots()

    -- Players
    if radarShowPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos2D = worldToRadar(hrp.Position, root.Position, camCF)
                placeDot(pos2D, Color3.fromRGB(0, 255, 80), player.Name)
            end
        end
    end

    -- Bots
    if radarShowBots then
        local acsWS = workspace:FindFirstChild("ACS_WorkSpace")
        local ai    = acsWS and acsWS:FindFirstChild("AI")
        if ai then
            for _, bot in ipairs(ai:GetChildren()) do
                if bot:IsA("Model") then
                    local hrp = bot:FindFirstChild("HumanoidRootPart")
                          or bot:FindFirstChildWhichIsA("BasePart", true)
                    if hrp then
                        local pos2D = worldToRadar(hrp.Position, root.Position, camCF)
                        placeDot(pos2D, Color3.fromRGB(255, 50, 50), "")
                    end
                end
            end
        end
    end

    -- Loot
    if radarShowLoot then
        local lootF = workspace:FindFirstChild("Lootables")
        if lootF then
            for _, container in ipairs(lootF:GetChildren()) do
                local anchor = container.PrimaryPart
                             or container:FindFirstChildWhichIsA("BasePart", true)
                if anchor then
                    local pos2D = worldToRadar(anchor.Position, root.Position, camCF)
                    placeDot(pos2D, Color3.fromRGB(255, 215, 0), "")
                end
            end
        end
    end

    -- Extractions
    if radarShowExtracts then
        local extF = workspace:FindFirstChild("ExtractionZones")
        if extF then
            for _, zone in ipairs(extF:GetChildren()) do
                if zone:IsA("BasePart") then
                    local pos2D = worldToRadar(zone.Position, root.Position, camCF)
                    placeDot(pos2D, Color3.fromRGB(0, 255, 180), "")
                end
            end
        end
    end
end)

-- -- Israel Tab UI -------------------------------------------------------------
IsraelTab:CreateSection("Radar")
IsraelTab:CreateLabel("Circular radar - rotates with your camera.")
IsraelTab:CreateLabel("🔵 You  🟢 Player  🔴 Bot  🟡 Loot  🟩 Extract")

IsraelTab:CreateToggle({
    Name = "Enable Radar", CurrentValue = radarEnabled,
    Flag = "Toggle_Radar",
    Callback = function(val)
        radarEnabled = val
        if val then
            createRadar()
        else
            removeRadar()
        end
    end,
})

IsraelTab:CreateSection("Radar Entities")

IsraelTab:CreateToggle({
    Name = "Show Players", CurrentValue = radarShowPlayers,
    Flag = "Radar_Players",
    Callback = function(val) radarShowPlayers = val end,
})

IsraelTab:CreateToggle({
    Name = "Show Bots", CurrentValue = radarShowBots,
    Flag = "Radar_Bots",
    Callback = function(val) radarShowBots = val end,
})

IsraelTab:CreateToggle({
    Name = "Show Loot", CurrentValue = radarShowLoot,
    Flag = "Radar_Loot",
    Callback = function(val) radarShowLoot = val end,
})

IsraelTab:CreateToggle({
    Name = "Show Extractions", CurrentValue = radarShowExtracts,
    Flag = "Radar_Extracts",
    Callback = function(val) radarShowExtracts = val end,
})

IsraelTab:CreateSection("Radar Settings")

IsraelTab:CreateSlider({
    Name = "Radar Range", Range = {50, 500}, Increment = 25, Suffix = " studs",
    CurrentValue = RADAR_RANGE, Flag = "Radar_Range",
    Callback = function(val) RADAR_RANGE = val end,
})

IsraelTab:CreateSlider({
    Name = "Radar Size", Range = {100, 300}, Increment = 10, Suffix = "px",
    CurrentValue = RADAR_SIZE, Flag = "Radar_Size",
    Callback = function(val)
        RADAR_SIZE = val
        -- Recreate to apply new size
        if radarEnabled then createRadar() end
    end,
})

-- TAB 11: Drama (Trolling)
local DramaTab = Window:CreateTab("Drama", "drama")

DramaTab:CreateSection("⚠ TROLLING & DRAMA")
DramaTab:CreateLabel("Disclaimer: This tab is for trolling purposes only!")
DramaTab:CreateLabel("Use responsibly and expect retaliation 😈")

DramaTab:CreateSection("Self Kick")

local kickReason = "Skill issue"

DramaTab:CreateInput({
    Name = "Kick Reason",
    PlaceholderText = "Skill issue",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        kickReason = text
    end,
})

DramaTab:CreateButton({
    Name = "🔫 Kick Yourself",
    Callback = function()
        local reason = kickReason ~= "" and kickReason or "Skill issue"
        
        Rayfield:Notify({
            Title = "Drama",
            Content = "Getting kicked for: " .. reason,
            Duration = 3,
        })
        
        print("[Drama] Kicking yourself for reason: " .. reason)
        
        -- Method 1: Use disconnect (cleanest)
        task.wait(1)
        game:Shutdown()
        
        -- If that doesn't work, try leaving
        game:GetService("Players"):LeaveGame()
    end,
})

DramaTab:CreateSection("Troll Messages")

local trollMessages = {
    "this game sucks",
    "i'm hacking, gonna ban everyone LOL",
    "server lagging af",
    "skill issue fr fr",
    "this gun is broken",
    "mods are trash",
    "game is p2w",
    "dev is a clown",
    "imma report everyone",
    "k bye",
}

local selectedMessage = trollMessages[1]

DramaTab:CreateDropdown({
    Name = "Troll Message",
    Options = trollMessages,
    CurrentOption = trollMessages[1],
    Flag = "TrollMsg",
    Callback = function(option)
        selectedMessage = option
    end,
})

DramaTab:CreateButton({
    Name = "💬 Spam Message in Chat",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local chatService = LocalPlayer:FindFirstChildOfClass("Chat")
        
        if chatService then
            for i = 1, 5 do
                chatService:Chat(selectedMessage)
                task.wait(0.3)
            end
            
            Rayfield:Notify({
                Title = "Drama",
                Content = "Spammed: " .. selectedMessage,
                Duration = 2,
            })
        else
            Rayfield:Notify({
                Title = "Drama",
                Content = "No chat service found",
                Duration = 2,
            })
        end
    end,
})

DramaTab:CreateSection("Drama Stat Tracker")

DramaTab:CreateButton({
    Name = "Print Drama Stats",
    Callback = function()
        print("\n" .. string.rep("=", 50))
        print("DRAMA STATISTICS")
        print(string.rep("=", 50))
        print("Last Kick Reason: " .. kickReason)
        print("Current Drama Message: " .. selectedMessage)
        print("Estimated Chaos Level: 🔴🔴🔴🔴🔴")
        print("Expect to be reported: YES")
        print("Will you get banned: MAYBE")
        print("Is it worth it: ABSOLUTELY")
        print(string.rep("=", 50) .. "\n")
        
        Rayfield:Notify({
            Title = "Drama",
            Content = "Drama stats printed to console!",
            Duration = 2,
        })
    end,
})

DramaTab:CreateSection("Fair Warning")
DramaTab:CreateLabel("🚨 Using these features may result in:")
DramaTab:CreateLabel("• Getting reported")
DramaTab:CreateLabel("• Being kicked from the server")
DramaTab:CreateLabel("• Account restrictions")
DramaTab:CreateLabel("• Group blacklist")
DramaTab:CreateLabel("")
DramaTab:CreateLabel("✅ Use at your own risk!")

-- TAB 12: User Info (Script Executor)
local UserInfoTab = Window:CreateTab("User Info", "user")

UserInfoTab:CreateSection("Account Information")

local function getAccountInfo()
    local player = LocalPlayer
    local username = player.Name
    local userId = player.UserId
    local accountAge = player.AccountAge
    
    return {
        username = username,
        userId = userId,
        accountAge = accountAge,
    }
end

local function getPremiumStatus()
    local player = LocalPlayer
    local marketplaceService = game:GetService("MarketplaceService")
    local success, isPremium = pcall(function()
        return marketplaceService:UserOwnsGamePassAsync(player.UserId, 0)
    end)
    return success and isPremium or false
end

local function getPlayTime()
    -- Get session start time (approximate)
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    if stats then
        local playtime = stats:FindFirstChild("PlayTime")
        if playtime then
            return playtime.Value
        end
    end
    return 0
end

local accountInfo = getAccountInfo()

UserInfoTab:CreateLabel("Username: " .. accountInfo.username)
UserInfoTab:CreateLabel("User ID: " .. tostring(accountInfo.userId))
UserInfoTab:CreateLabel("Account Age: " .. tostring(accountInfo.accountAge) .. " days")

local premiumStatus = getPremiumStatus() and "✅ Premium" or "❌ Regular"
UserInfoTab:CreateLabel("Premium Status: " .. premiumStatus)

UserInfoTab:CreateSection("Social Information")

local function getFriendCount()
    local friendsService = game:GetService("Friends")
    local success, friends = pcall(function()
        return friendsService:GetFriendCount(LocalPlayer.UserId)
    end)
    return success and friends or "Unknown"
end

local function getFollowerCount()
    -- This would require API call, approximate
    return "Unknown (API required)"
end

local friendCount = getFriendCount()
UserInfoTab:CreateLabel("Friends Count: " .. tostring(friendCount))
UserInfoTab:CreateLabel("Followers: " .. getFollowerCount())

UserInfoTab:CreateSection("Activity Information")

local function getLastOnline()
    -- Last online is from character existence
    return "Currently Online"
end

local function getJoinDate()
    local player = LocalPlayer
    -- AccountAge tells us how old, but not exact date
    local daysAgo = player.AccountAge
    local today = os.date("*t")
    local created = os.date("*t", os.time() - (daysAgo * 86400))
    return string.format("%d-%d-%d", created.month, created.day, created.year)
end

UserInfoTab:CreateLabel("Join Date: ~" .. getJoinDate())
UserInfoTab:CreateLabel("Last Online: " .. getLastOnline())

local playTime = getPlayTime()
local playTimeStr = playTime > 0 and (math.floor(playTime / 60) .. " minutes") or "Calculating..."
UserInfoTab:CreateLabel("Session Play Time: " .. playTimeStr)

UserInfoTab:CreateSection("Character Information")

local function getCharacterInfo()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local health = humanoid and math.floor(humanoid.Health) or 0
    local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 100
    
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    local pos = humanoidRootPart and humanoidRootPart.Position or Vector3.new(0, 0, 0)
    
    return {
        health = health,
        maxHealth = maxHealth,
        x = math.floor(pos.X),
        y = math.floor(pos.Y),
        z = math.floor(pos.Z),
    }
end

local charInfo = getCharacterInfo()
if charInfo then
    UserInfoTab:CreateLabel("Health: " .. charInfo.health .. "/" .. charInfo.maxHealth)
    UserInfoTab:CreateLabel("Position: (" .. charInfo.x .. ", " .. charInfo.y .. ", " .. charInfo.z .. ")")
end

UserInfoTab:CreateSection("Quick Actions")

UserInfoTab:CreateButton({
    Name = "Print User Info to Console",
    Callback = function()
        local info = getAccountInfo()
        local premium = getPremiumStatus()
        local friends = getFriendCount()
        
        print("\n" .. string.rep("=", 60))
        print("USER INFORMATION")
        print(string.rep("=", 60))
        print("Username: " .. info.username)
        print("User ID: " .. info.userId)
        print("Account Age: " .. info.accountAge .. " days")
        print("Join Date: ~" .. getJoinDate())
        print("Premium Status: " .. (premium and "✅ Premium" or "❌ Regular"))
        print("Friends Count: " .. tostring(friends))
        print("Last Online: " .. getLastOnline())
        
        local charInfo = getCharacterInfo()
        if charInfo then
            print("Health: " .. charInfo.health .. "/" .. charInfo.maxHealth)
            print("Position: (" .. charInfo.x .. ", " .. charInfo.y .. ", " .. charInfo.z .. ")")
        end
        print(string.rep("=", 60) .. "\n")
        
        Rayfield:Notify({
            Title = "User Info",
            Content = "Printed to console (F9)",
            Duration = 2,
        })
    end,
})

UserInfoTab:CreateButton({
    Name = "Refresh Info",
    Callback = function()
        -- Refresh the info by re-reading values
        local info = getAccountInfo()
        local charInfo = getCharacterInfo()
        
        print("[User Info] Refreshed!")
        Rayfield:Notify({
            Title = "User Info",
            Content = "Information refreshed",
            Duration = 2,
        })
    end,
})

