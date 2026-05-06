-- ==========================================
-- 1. STARTUP NOTIFICATION & CLEANUP
-- ==========================================
print("--------------------------------------------------")
print("ESP LOADED SUCCESSFULLY")
print("PC Controls:")
print("  Left Alt    → Toggle ESP on/off")
print("  Right Alt   → Cycle filter presets")
print("  Right Shift → Dump nearby loot to console")
print("Mobile Controls:")
print("  Tap [ESP] button    → Toggle ESP on/off")
print("  Tap [PRESET] button → Cycle filter presets")
print("  Tap [DUMP] button   → Dump nearby loot")
print("--------------------------------------------------")

local TargetContainer = (gethui and gethui()) or game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
for _, obj in ipairs(TargetContainer:GetChildren()) do
    if obj.Name == "ESPTag" or obj.Name == "ESP_MobileUI" then obj:Destroy() end
end

local UserInputService = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer

-- ==========================================
-- 2. PLATFORM DETECTION
-- ==========================================
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

print("[PLATFORM] " .. (isMobile and "Mobile detected" or "PC detected"))

-- ==========================================
-- 3. HOT-SWAPPABLE SETTINGS
-- ==========================================
local _raw = {
    ExtractionColor      = Color3.fromRGB(0, 255, 127),
    LootColor            = Color3.fromRGB(255, 215, 0),
    HighValueColor       = Color3.fromRGB(255, 80, 80),
    TextSize             = 13,
    MaxDistance          = 700,
    MIN_VALUE            = 1000,
    HIGH_VALUE_THRESHOLD = 5000,
    SHOW_DISTANCE        = true,
    SHOW_TOTAL           = true,
    SHOW_RARITY          = true,
    SHOW_EXTRACTION      = true,
}

local _listeners = {}
local function onSettingChanged(callback)
    table.insert(_listeners, callback)
end

local SETTINGS = setmetatable({}, {
    __index = function(_, key) return _raw[key] end,
    __newindex = function(_, key, value)
        local old = _raw[key]
        if old == value then return end
        _raw[key] = value
        print(string.format("[SETTINGS] %s: %s → %s", tostring(key), tostring(old), tostring(value)))
        for _, cb in ipairs(_listeners) do cb(key, value) end
    end
})

-- ==========================================
-- 4. FILTER PRESETS
-- ==========================================
local PRESETS = {
    { name = "All Loot",   MIN_VALUE = 0    },
    { name = "Budget",     MIN_VALUE = 500  },
    { name = "Standard",   MIN_VALUE = 1000 },
    { name = "High Value", MIN_VALUE = 3000 },
    { name = "Elite Only", MIN_VALUE = 7500 },
}
local currentPreset = 3

local function applyPreset(index)
    local preset = PRESETS[index]
    SETTINGS.MIN_VALUE = preset.MIN_VALUE
    print(string.format("[PRESET] %s (Min: $%s)", preset.name, tostring(preset.MIN_VALUE)))
    return preset.name
end

-- ==========================================
-- 5. STATE
-- ==========================================
local espEnabled      = true
local espTags         = {}
local refreshCallbacks = {}

-- ==========================================
-- 6. SHARED ACTIONS (used by both PC & mobile)
-- ==========================================
local function toggleESP()
    espEnabled = not espEnabled
    for _, tag in pairs(espTags) do
        if tag and tag.Parent then tag.Enabled = espEnabled end
    end
    print("ESP: " .. (espEnabled and "ON" or "OFF"))
    return espEnabled
end

local function cyclePreset()
    currentPreset = (currentPreset % #PRESETS) + 1
    return applyPreset(currentPreset)
end

local function dumpLoot()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then print("[DUMP] No character found.") return end

    local lootables = workspace:FindFirstChild("Lootables")
    if not lootables then print("[DUMP] Lootables not found.") return end

    print("--------------------------------------------------")
    print("[NEARBY LOOT DUMP] Min Value: $" .. tostring(SETTINGS.MIN_VALUE))

    local results = {}
    for _, container in ipairs(lootables:GetChildren()) do
        local anchor = container.PrimaryPart or container:FindFirstChildWhichIsA("BasePart", true)
        local dist = anchor and math.floor((root.Position - anchor.Position).Magnitude) or 9999
        local lootFolder = container:FindFirstChild("Loot")
        if lootFolder then
            for _, item in ipairs(lootFolder:GetChildren()) do
                local moneyVal = item:FindFirstChild("MoneyValue")
                local price = moneyVal and moneyVal.Value or 0
                if price >= SETTINGS.MIN_VALUE then
                    table.insert(results, {
                        name = item.Name,
                        price = price,
                        dist = dist,
                        container = container.Name
                    })
                end
            end
        end
    end

    table.sort(results, function(a, b) return a.dist < b.dist end)

    if #results == 0 then
        print("  No loot found above $" .. tostring(SETTINGS.MIN_VALUE))
    else
        for _, r in ipairs(results) do
            print(string.format("  [%s] %s — $%s | %s studs", r.container, r.name, tostring(r.price), tostring(r.dist)))
        end
    end
    print("--------------------------------------------------")
end

-- ==========================================
-- 7. PC KEYBINDS
-- ==========================================
if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            toggleESP()
        elseif input.KeyCode == Enum.KeyCode.RightAlt then
            cyclePreset()
        elseif input.KeyCode == Enum.KeyCode.RightShift then
            dumpLoot()
        end
    end)
end

-- ==========================================
-- 8. MOBILE UI
-- ==========================================
if isMobile then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESP_MobileUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = TargetContainer

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 210, 0, 45)
    frame.Position = UDim2.new(0, 10, 1, -60) -- bottom left
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = frame

    -- Button factory
    local function makeButton(labelText, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 62, 0, 34)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = labelText
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- ESP Toggle button
    local espBtn = makeButton("[ESP] ON", Color3.fromRGB(0, 170, 80), function()
        local on = toggleESP()
        espBtn.Text = on and "[ESP] ON" or "[ESP] OFF"
        espBtn.BackgroundColor3 = on and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(170, 50, 50)
    end)

    -- Preset Cycle button
    local presetBtn = makeButton("STD", Color3.fromRGB(50, 100, 200), function()
        local name = cyclePreset()
        -- Shorten name to fit button
        local short = name:sub(1, 4):upper()
        presetBtn.Text = short
    end)

    -- Dump button
    makeButton("DUMP", Color3.fromRGB(150, 80, 200), function()
        dumpLoot()
    end)
end

-- ==========================================
-- 9. DISTANCE UTILITY
-- ==========================================
local function getDistance(part)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or not part then return math.huge end
    return math.floor((root.Position - part.Position).Magnitude)
end

-- ==========================================
-- 10. CORE ESP ENGINE
-- ==========================================
local function createESP(anchor, text, color)
    if not anchor or not anchor.Parent then return end

    local existing = espTags[anchor]
    if existing and existing.Parent then existing:Destroy() end

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ESPTag"
    bgui.Adornee = anchor
    bgui.Size = UDim2.new(0, 250, 0, 110)
    bgui.AlwaysOnTop = true
    bgui.MaxDistance = SETTINGS.MaxDistance
    bgui.Enabled = espEnabled
    bgui.Parent = TargetContainer

    local label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.Parent = bgui
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0.7, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.5
    label.TextSize = SETTINGS.TextSize
    label.Font = Enum.Font.SourceSansBold
    label.TextWrapped = true
    label.TextYAlignment = Enum.TextYAlignment.Center

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Parent = bgui
    distLabel.BackgroundTransparency = 1
    distLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distLabel.Position = UDim2.new(0, 0, 0.7, 0)
    distLabel.Text = "? studs"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextSize = SETTINGS.TextSize - 2
    distLabel.Font = Enum.Font.SourceSans
    distLabel.TextYAlignment = Enum.TextYAlignment.Center
    distLabel.Visible = SETTINGS.SHOW_DISTANCE

    espTags[anchor] = bgui

    anchor.AncestryChanged:Connect(function()
        if not anchor:IsDescendantOf(game) then
            bgui:Destroy()
            espTags[anchor] = nil
            refreshCallbacks[anchor] = nil
        end
    end)

    return bgui
end

-- ==========================================
-- 11. DISTANCE UPDATER
-- ==========================================
RunService.Heartbeat:Connect(function()
    for anchor, tag in pairs(espTags) do
        if not tag or not tag.Parent then
            espTags[anchor] = nil
            continue
        end
        if anchor and anchor.Parent then
            local distLabel = tag:FindFirstChild("DistLabel")
            if distLabel then
                distLabel.Visible = SETTINGS.SHOW_DISTANCE
                if SETTINGS.SHOW_DISTANCE then
                    local dist = getDistance(anchor)
                    distLabel.Text = dist == math.huge and "? studs" or (dist .. " studs")
                end
            end
        end
    end
end)

-- ==========================================
-- 12. FILTERED CONTENT SCANNER
-- ==========================================
local function generateFilteredList(container)
    local lootFolder = container:FindFirstChild("Loot")
    if not lootFolder then return nil, nil end

    local list = "[" .. container.Name:upper() .. "]"
    local foundHighValue = false
    local totalValue = 0
    local hasElite = false

    for _, item in ipairs(lootFolder:GetChildren()) do
        local moneyVal = item:FindFirstChild("MoneyValue")
        local price = moneyVal and moneyVal.Value or 0

        if price >= SETTINGS.MIN_VALUE then
            foundHighValue = true
            totalValue += price
            if price >= SETTINGS.HIGH_VALUE_THRESHOLD then hasElite = true end

            local rarity = item:FindFirstChild("Rarity")
            local rarityStr = (SETTINGS.SHOW_RARITY and rarity) and ("[" .. tostring(rarity.Value) .. "] ") or ""
            list = list .. string.format("\n• %s%s ($%s)", rarityStr, item.Name, tostring(price))
        end
    end

    if foundHighValue and SETTINGS.SHOW_TOTAL then
        list = list .. string.format("\nTotal: $%s", tostring(totalValue))
    end

    return foundHighValue and list or nil, hasElite
end

-- ==========================================
-- 13. HANDLERS
-- ==========================================
local function setupGenericContainer(model)
    if not model:IsA("Model") then return end
    task.spawn(function()
        local anchor = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if not anchor then return end

        local espTag = nil
        local lootFolder = model:WaitForChild("Loot", 5)

        local function refresh()
            local content, hasElite = generateFilteredList(model)
            local color = hasElite and SETTINGS.HighValueColor or SETTINGS.LootColor
            if content then
                if not espTag or not espTag.Parent then
                    espTag = createESP(anchor, content, color)
                else
                    local tl = espTag:FindFirstChild("TextLabel")
                    if tl then
                        tl.Text = content
                        tl.TextColor3 = color
                    end
                    if espEnabled then espTag.Enabled = true end
                end
            else
                if espTag and espTag.Parent then
                    espTag.Enabled = false
                end
            end
        end

        refreshCallbacks[anchor] = refresh

        if lootFolder then
            refresh()
            lootFolder.ChildAdded:Connect(refresh)
            lootFolder.ChildRemoved:Connect(refresh)

            for _, item in ipairs(lootFolder:GetChildren()) do
                local moneyVal = item:FindFirstChild("MoneyValue")
                if moneyVal then moneyVal.Changed:Connect(refresh) end
            end
            lootFolder.ChildAdded:Connect(function(item)
                local moneyVal = item:FindFirstChild("MoneyValue")
                if moneyVal then moneyVal.Changed:Connect(refresh) end
            end)
        end
    end)
end

local function setupExtraction(zone)
    if not zone:IsA("BasePart") then return end
    if not SETTINGS.SHOW_EXTRACTION then return end
    task.spawn(function()
        local n = zone:WaitForChild("extractname", 5)
        local t = zone:WaitForChild("ExtractTime", 5)
        local function buildText()
            return string.format("[%s]\n%s",
                (n and n.Value or "EXTRACT"),
                (t and tostring(t.Value) or "")
            )
        end
        createESP(zone, buildText(), SETTINGS.ExtractionColor)
        if t then
            t.Changed:Connect(function()
                local tag = espTags[zone]
                local tl = tag and tag:FindFirstChild("TextLabel")
                if tl then tl.Text = buildText() end
            end)
        end
    end)
end

-- ==========================================
-- 14. SETTINGS HOT-SWAP LISTENER
-- ==========================================
onSettingChanged(function(key, _)
    local lootKeys = {
        MIN_VALUE = true, LootColor = true, HighValueColor = true,
        HIGH_VALUE_THRESHOLD = true, SHOW_RARITY = true, SHOW_TOTAL = true
    }
    if lootKeys[key] then
        for _, refresh in pairs(refreshCallbacks) do
            task.spawn(refresh)
        end
        print("[HOT-SWAP] All ESP tags refreshed.")
    end
    if key == "MaxDistance" then
        for _, tag in pairs(espTags) do
            if tag and tag.Parent then tag.MaxDistance = _raw[key] end
        end
    end
    if key == "SHOW_DISTANCE" then
        for _, tag in pairs(espTags) do
            local dl = tag and tag:FindFirstChild("DistLabel")
            if dl then dl.Visible = _raw[key] end
        end
    end
end)

-- ==========================================
-- 15. INITIALIZATION
-- ==========================================
task.spawn(function()
    local lootF = workspace:WaitForChild("Lootables", 10)
    if lootF then
        for _, obj in ipairs(lootF:GetChildren()) do setupGenericContainer(obj) end
        lootF.ChildAdded:Connect(setupGenericContainer)
    else
        warn("Lootables folder not found!")
    end

    local extF = workspace:WaitForChild("ExtractionZones", 10)
    if extF then
        for _, z in ipairs(extF:GetChildren()) do setupExtraction(z) end
        extF.ChildAdded:Connect(setupExtraction)
    else
        warn("ExtractionZones folder not found!")
    end
end)
