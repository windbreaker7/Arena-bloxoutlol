-- ==========================================
-- m995 panel — v4 Complete
-- Script by: millionlikes_9677
-- AI assistance: Claude (Anthropic)
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ==========================================
-- CLEANUP
-- ==========================================
local TargetContainer = (gethui and gethui())
    or game:GetService("CoreGui")
    or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local CLEANUP_NAMES = {
    ESPTag=true, ToolTag=true, AmmoTag=true, AmmoHUD=true,
    PlayerESPTag=true, BotESPTag=true, CorpseESPTag=true,
    ThermalESPTag=true, WeaponESPTag=true, AmmoESPTag=true, ArmorESPTag=true
}

for _, obj in ipairs(TargetContainer:GetChildren()) do
    if CLEANUP_NAMES[obj.Name] or obj.Name:find("^ArmorESPTag_") or obj.Name:find("^BoneESP_") then
        pcall(function() obj:Destroy() end)
    end
end

-- ==========================================
-- SERVICES
-- ==========================================
local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- SETTINGS
-- ==========================================
local _raw = {
    ExtractionColor      = Color3.fromRGB(0, 255, 127),
    LootColor            = Color3.fromRGB(255, 215, 0),
    HighValueColor       = Color3.fromRGB(255, 80, 80),
    PlayerColor          = Color3.fromRGB(0, 150, 255),
    TextSize             = 13,
    MaxDistance          = 700,
    MIN_VALUE            = 1000,
    HIGH_VALUE_THRESHOLD = 5000,
    SHOW_DISTANCE        = true,
    SHOW_TOTAL           = true,
    SHOW_RARITY          = true,
    SHOW_EXTRACTION      = true,
    SHOW_AMMO            = true,
    SHOW_ENEMY_AMMO      = true,
    SHOW_PLAYER_ESP      = true,
    SHOW_BONE_ESP        = true,
    SHOW_CORPSE_ESP      = true,
    CorpseColor          = Color3.fromRGB(150, 150, 150),
    SHOW_BOT_ESP         = true,
    BotColor             = Color3.fromRGB(255, 100, 0),
    SHOW_ARMOR_ESP       = true,
    ArmorColor           = Color3.fromRGB(200, 200, 100),
    SHOW_THERMAL_ESP     = true,
    ThermalColor         = Color3.fromRGB(255, 100, 255),
    SHOW_WEAPON_ESP      = true,
    WeaponColor          = Color3.fromRGB(100, 200, 255),
    SHOW_AMMO_ESP        = true,
    AmmoColor            = Color3.fromRGB(150, 255, 150),
}

local _listeners = {}
local function onSettingChanged(callback)
    _listeners[#_listeners+1] = callback
end

local SETTINGS = setmetatable({}, {
    __index    = function(_, k) return _raw[k] end,
    __newindex = function(_, k, v)
        if _raw[k] == v then return end
        _raw[k] = v
        for _, cb in ipairs(_listeners) do pcall(cb, k, v) end
    end,
})

local PRESETS = {
    { name = "All Loot",   MIN_VALUE = 0    },
    { name = "Budget",     MIN_VALUE = 500  },
    { name = "Standard",   MIN_VALUE = 1000 },
    { name = "High Value", MIN_VALUE = 3000 },
    { name = "Elite Only", MIN_VALUE = 7500 },
}

-- ==========================================
-- STATE
-- ==========================================
local currentPreset        = 3
local espEnabled           = true  -- FIX: was false; must match Rayfield toggle default (true)
local espTags              = {}
local ammoTags             = {}
local playerESPTags        = {}
local corpseESPTags        = {}
local botESPTags           = {}
local armorESPTags         = {}
local thermalESPTags       = {}
local weaponESPTags        = {}
local ammoESPTags          = {}
local refreshCallbacks     = {}
local localAmmoHUD         = nil
local currentTool          = nil
local enemyMaxMag          = {}
local enemyAmmoConnections = {}
local toolTags             = {} -- kept for removeToolTag call-sites; tool ESP removed but cleanup still safe
local localAmmoConnections = {}
local boneLines            = {}
local boneOwners           = {}
local boneLineCount        = 0  -- reliable counter since boneLines is sparse after removals
local allConnections       = {}

local RED = Color3.fromRGB(255, 50, 50)
local injuryCache = {}
local INJURY_INTERVAL = 0.3

-- ==========================================
-- HELPERS
-- ==========================================
local cachedRoot = nil
local function getCachedRoot()
    local char = LocalPlayer.Character
    if not char then cachedRoot = nil; return nil end
    if cachedRoot and cachedRoot.Parent == char then return cachedRoot end
    cachedRoot = char:FindFirstChild("HumanoidRootPart")
    return cachedRoot
end

local function getAmmoColor(current, max)
    if type(current) == "number" and type(max) == "number" and max > 0 then
        local r = current / max
        if r > 0.5  then return Color3.fromRGB(100, 255, 100) end
        if r > 0.25 then return Color3.fromRGB(255, 200, 0)   end
        return Color3.fromRGB(255, 60, 60)
    end
    return Color3.fromRGB(255, 255, 255)
end

local function getMaxMag(tool)
    local rep = tool and tool:FindFirstChild("RepValues")
    if not rep then return 0 end
    local v = rep:FindFirstChild("MaxMag") or rep:FindFirstChild("MagSize")
           or rep:FindFirstChild("MaxAmmo") or rep:FindFirstChild("AmmoMax")
    return (v and type(v.Value) == "number" and v.Value > 0) and v.Value or 0
end

local function hasInjury(part)
    if not part then return false end
    local now    = os.clock()
    local cached = injuryCache[part]
    if cached and (now - cached[2]) < INJURY_INTERVAL then return cached[1] end
    -- Part may have been destroyed; if so, clear cache and return false
    if not part.Parent then
        injuryCache[part] = nil
        return false
    end
    local result = false
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BoolValue") and child.Value and
           (child.Name == "Bleeding" or child.Name == "Fractured" or child.Name == "Injured") then
            result = true; break
        end
    end
    injuryCache[part] = {result, now}
    return result
end

local function countTable(t)
    local n = 0; for _ in pairs(t) do n += 1 end; return n
end

local function trackConnection(conn)
    if conn then allConnections[#allConnections+1] = conn end
    return conn
end

local function cleanupConnections(list)
    if not list then return end
    for _, conn in ipairs(list) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
end

-- ==========================================
-- MAIN HEARTBEAT
-- ==========================================
local lastDistUpdate  = {}
local lastBoneUpdate  = 0
local BONE_INTERVAL   = 0.05
local lastCorpseUpdate = 0
local CORPSE_INTERVAL  = 0.2

RunService.Heartbeat:Connect(function()
    if not espEnabled then return end
    local now  = os.clock()
    local root = getCachedRoot()

    -- Distance labels (loot)
    if SETTINGS.SHOW_DISTANCE then
        for anchor, tag in pairs(espTags) do
            if not tag or not tag.Parent then
                espTags[anchor] = nil
                lastDistUpdate[anchor] = nil
                continue
            end
            if not anchor.Parent then continue end
            local dl = tag:FindFirstChild("DistLabel")
            if not dl then continue end
            local last = lastDistUpdate[anchor] or 0
            if (now - last) >= 0.1 then
                if root then
                    local dist = (root.Position - anchor.Position).Magnitude
                    dl.Text = dist > 10000 and "? studs" or math.floor(dist) .. " studs"
                end
                lastDistUpdate[anchor] = now
            end
        end
    end

    -- Corpse distances (throttled)
    if SETTINGS.SHOW_CORPSE_ESP and (now - lastCorpseUpdate) >= CORPSE_INTERVAL then
        for corpse, tag in pairs(corpseESPTags) do
            if not tag or not tag.Parent then
                corpseESPTags[corpse] = nil
                continue
            end
            if not corpse.Parent then continue end
            local dl = tag:FindFirstChild("DistLabel")
            -- corpse is a Model; use the tag's Adornee (BasePart) for position
            local adornee = tag.Adornee
            if dl and root and adornee and adornee.Parent then
                local dist = (root.Position - adornee.Position).Magnitude
                dl.Text = math.floor(dist) .. " studs"
            end
        end
        lastCorpseUpdate = now
    end

    -- Bone lines (throttled)
    if SETTINGS.SHOW_BONE_ESP and (now - lastBoneUpdate) >= BONE_INTERVAL then
        -- Use pairs instead of ipairs: boneLines is a sparse array (nils from removals),
        -- and ipairs stops at the first nil hole, leaving live entries unupdated.
        for i, entry in pairs(boneLines) do
            if not entry or not entry[1] or not entry[1].Parent then
                boneLines[i] = nil
                continue
            end
            local line, part1, part2, baseColor = entry[1], entry[2], entry[3], entry[4]
            if not part1.Parent or not part2.Parent then
                pcall(function() line:Destroy() end)
                boneLines[i] = nil
                continue
            end
            local color = hasInjury(part1) and RED or baseColor
            line.Color3 = color
            -- FIX: use local-space coords relative to the Adornee (part1)
            line.From = Vector3.zero
            line.To = part1.CFrame:PointToObjectSpace(part2.Position)
        end
        lastBoneUpdate = now
    end
end)

-- ==========================================
-- LOOT ESP
-- ==========================================
local function createESP(anchor, text, color)
    if not anchor or not anchor.Parent then return nil end
    pcall(function()
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

        trackConnection(anchor.AncestryChanged:Connect(function()
            if not anchor:IsDescendantOf(game) then
                pcall(function() bgui:Destroy() end)
                espTags[anchor] = nil
                refreshCallbacks[anchor] = nil
            end
        end))
    end)
    return espTags[anchor]
end

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

local function setupGenericContainer(model)
    if not model:IsA("Model") then return end
    task.spawn(function()
        local anchor = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if not anchor then return end

        local espTag = nil
        local lootFolder = model:WaitForChild("Loot", 5)
        if not lootFolder then return end  -- no Loot folder, nothing to display

        local function refresh()
            if not SETTINGS.SHOW_EXTRACTION and model.Name == "ExtractionZone" then return end
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
        refresh()

        trackConnection(lootFolder.ChildAdded:Connect(refresh))
        trackConnection(lootFolder.ChildRemoved:Connect(refresh))
        for _, item in ipairs(lootFolder:GetChildren()) do
            local moneyVal = item:FindFirstChild("MoneyValue")
            if moneyVal then trackConnection(moneyVal.Changed:Connect(refresh)) end
        end
        trackConnection(lootFolder.ChildAdded:Connect(function(item)
            local moneyVal = item:FindFirstChild("MoneyValue")
            if moneyVal then trackConnection(moneyVal.Changed:Connect(refresh)) end
        end))

        -- Clean up when the container is removed
        trackConnection(anchor.AncestryChanged:Connect(function()
            if not anchor:IsDescendantOf(game) then
                refreshCallbacks[anchor] = nil
                lastDistUpdate[anchor] = nil
            end
        end))
    end)
end

local function setupExtraction(zone)
    if not zone:IsA("BasePart") then return end
    if not SETTINGS.SHOW_EXTRACTION then return end
    task.spawn(function()
        local n = zone:WaitForChild("extractname", 5)
        local t = zone:WaitForChild("ExtractTime", 5)
        if not n or not t then return end
        
        local function buildText()
            return string.format("[%s]\n%s",
                (n and n.Value or "EXTRACT"),
                (t and tostring(t.Value) or "")
            )
        end
        createESP(zone, buildText(), SETTINGS.ExtractionColor)
        trackConnection(t.Changed:Connect(function()
            local tag = espTags[zone]
            if tag and tag.Parent then
                local tl = tag:FindFirstChild("TextLabel")
                if tl then tl.Text = buildText() end
            end
        end))
    end)
end

-- ==========================================
-- AMMO ESP
-- ==========================================
local function removeAmmoTag(player)
    if not ammoTags[player] then return end
    if ammoTags[player].Parent then
        pcall(function() ammoTags[player]:Destroy() end)
    end
    ammoTags[player] = nil
end

local function updateEnemyAmmo(player, tool)
    local tag = ammoTags[player]
    if not tag or not tag.Parent then return end

    local label = tag:FindFirstChild("AmmoLabel")
    if not label then return end

    if not tool then
        label.Text = "0 | 0  [0]"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        return
    end

    local repValues = tool:FindFirstChild("RepValues")
    local magAmmo     = repValues and repValues:FindFirstChild("Mag")
    local reserveAmmo = repValues and repValues:FindFirstChild("StoredAmmo")
    local chambered   = repValues and repValues:FindFirstChild("Chambered")

    local current = magAmmo and magAmmo.Value or "?"
    local reserve  = reserveAmmo and reserveAmmo.Value or "?"
    local chamber  = chambered and (chambered.Value and "+1" or "") or ""

    local maxMag = enemyMaxMag[player] or (type(current) == "number" and current or 0)
    label.Text = string.format("%s  %s%s / %s", tool.Name, tostring(current), chamber, tostring(reserve))
    label.TextColor3 = getAmmoColor(type(current) == "number" and current or 0, maxMag)
end

local function createEnemyAmmoTag(player, character)
    if not SETTINGS.SHOW_ENEMY_AMMO then return end
    removeAmmoTag(player)

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "AmmoTag"
        bgui.Adornee = rootPart
        bgui.Size = UDim2.new(0, 250, 0, 40)
        bgui.StudsOffset = Vector3.new(0, -2, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_ENEMY_AMMO
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Name = "AmmoLabel"
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "0 | 0  [0]"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0.5
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        ammoTags[player] = bgui

        local tool = character:FindFirstChildOfClass("Tool")
        if tool then updateEnemyAmmo(player, tool) end
    end)
end

local function hookEnemyAmmoValues(player, tool)
    -- FIX: clear old connections first to avoid accumulating listeners on tool swap
    if enemyAmmoConnections[player] then
        cleanupConnections(enemyAmmoConnections[player])
    end
    enemyAmmoConnections[player] = {}

    local repValues = tool:FindFirstChild("RepValues")
    if not repValues then return end

    local conns = enemyAmmoConnections[player]
    local ammo    = repValues:FindFirstChild("Mag")
    local reserve = repValues:FindFirstChild("StoredAmmo")
    local chamber = repValues:FindFirstChild("Chambered")

    -- Also cache the max mag now that we have the tool
    local detectedMax = getMaxMag(tool)
    if detectedMax > 0 then enemyMaxMag[player] = detectedMax end

    if ammo    then table.insert(conns, trackConnection(ammo.Changed:Connect(function() updateEnemyAmmo(player, tool) end))) end
    if reserve then table.insert(conns, trackConnection(reserve.Changed:Connect(function() updateEnemyAmmo(player, tool) end))) end
    if chamber then table.insert(conns, trackConnection(chamber.Changed:Connect(function() updateEnemyAmmo(player, tool) end))) end
end

-- ==========================================
-- PLAYER ESP (NAME + HEALTH)
-- ==========================================
local function removePlayerESPTag(player)
    local data = playerESPTags[player]
    if not data then return end
    -- Always clear the table entry, even if the gui is already gone
    if data.gui and data.gui.Parent then
        pcall(function() data.gui:Destroy() end)
    end
    playerESPTags[player] = nil
end

local function createPlayerESPTag(player, character)
    if not SETTINGS.SHOW_PLAYER_ESP then return end
    removePlayerESPTag(player)

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "PlayerESPTag"
        bgui.Adornee = rootPart
        bgui.Size = UDim2.new(0, 200, 0, 60)
        bgui.StudsOffset = Vector3.new(0, 3, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_PLAYER_ESP
        bgui.Parent = TargetContainer

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Parent = bgui
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = SETTINGS.PlayerColor
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center

        local healthLabel = Instance.new("TextLabel")
        healthLabel.Name = "HealthLabel"
        healthLabel.Parent = bgui
        healthLabel.BackgroundTransparency = 1
        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
        healthLabel.Text = "? HP"
        healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        healthLabel.TextStrokeTransparency = 0.5
        healthLabel.TextSize = 12
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextYAlignment = Enum.TextYAlignment.Center

        playerESPTags[player] = { gui = bgui, healthLabel = healthLabel, character = character }
    end)
end

-- ==========================================
-- BONE ESP
-- ==========================================
local function createBoneLine(part1, part2, color)
    local line = Instance.new("LineHandleAdornment")
    -- FIX: LineHandleAdornment requires an Adornee (Part) to anchor to; without it lines appear at origin
    line.Adornee = part1
    line.From = Vector3.zero
    line.To = part1.CFrame:PointToObjectSpace(part2.Position)
    line.Color3 = color
    line.Thickness = 2
    line.AlwaysOnTop = true
    line.Parent = TargetContainer
    return line
end

local function setupBoneESP(player, character, boneColor)
    if not SETTINGS.SHOW_BONE_ESP then return end
    boneColor = boneColor or SETTINGS.PlayerColor

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    local bones = {
        {character:FindFirstChild("Head"), character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")},
        {character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"), character:FindFirstChild("HumanoidRootPart")},
        {character:FindFirstChild("LeftUpperArm"), character:FindFirstChild("LeftLowerArm")},
        {character:FindFirstChild("LeftLowerArm"), character:FindFirstChild("LeftHand")},
        {character:FindFirstChild("RightUpperArm"), character:FindFirstChild("RightLowerArm")},
        {character:FindFirstChild("RightLowerArm"), character:FindFirstChild("RightHand")},
        {character:FindFirstChild("LeftUpperLeg"), character:FindFirstChild("LeftLowerLeg")},
        {character:FindFirstChild("LeftLowerLeg"), character:FindFirstChild("LeftFoot")},
        {character:FindFirstChild("RightUpperLeg"), character:FindFirstChild("RightLowerLeg")},
        {character:FindFirstChild("RightLowerLeg"), character:FindFirstChild("RightFoot")},
    }

    for _, bonePair in ipairs(bones) do
        local part1, part2 = bonePair[1], bonePair[2]
        if part1 and part2 then
            local line = createBoneLine(part1, part2, boneColor)
            boneLineCount += 1
            boneLines[boneLineCount] = { line, part1, part2, boneColor }
            if not boneOwners[player] then boneOwners[player] = {} end
            table.insert(boneOwners[player], boneLineCount)
        end
    end
end

local function removeBoneLines(player)
    if not boneOwners[player] then return end
    for _, idx in ipairs(boneOwners[player]) do
        if boneLines[idx] then
            pcall(function() boneLines[idx][1]:Destroy() end)
            boneLines[idx] = nil
        end
    end
    boneOwners[player] = nil
end

-- ==========================================
-- CORPSE ESP
-- ==========================================
local function removeCorpseESPTag(corpse)
    if corpseESPTags[corpse] and corpseESPTags[corpse].Parent then
        pcall(function() corpseESPTags[corpse]:Destroy() end)
        corpseESPTags[corpse] = nil
    end
end

local function createCorpseESPTag(corpse)
    if not SETTINGS.SHOW_CORPSE_ESP then return end
    removeCorpseESPTag(corpse)

    pcall(function()
        -- BillboardGui requires a BasePart Adornee, not a Model
        local anchorPart = corpse.PrimaryPart or corpse:FindFirstChildWhichIsA("BasePart")
        if not anchorPart then return end

        local bgui = Instance.new("BillboardGui")
        bgui.Name = "CorpseESPTag"
        bgui.Adornee = anchorPart
        bgui.Size = UDim2.new(0, 150, 0, 40)
        bgui.StudsOffset = Vector3.new(0, 2, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_CORPSE_ESP
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "💀 CORPSE"
        label.TextColor3 = SETTINGS.CorpseColor
        label.TextStrokeTransparency = 0.5
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Parent = bgui
        distLabel.BackgroundTransparency = 1
        distLabel.Size = UDim2.new(1, 0, 0.4, 0)
        distLabel.Position = UDim2.new(0, 0, 0.6, 0)
        distLabel.Text = "? studs"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 10
        distLabel.TextYAlignment = Enum.TextYAlignment.Center

        corpseESPTags[corpse] = bgui
    end)
end

-- ==========================================
-- BOT ESP
-- ==========================================
local function removeBotESPTag(bot)
    if botESPTags[bot] and botESPTags[bot].Parent then
        pcall(function() botESPTags[bot]:Destroy() end)
        botESPTags[bot] = nil
    end
    removeBoneLines(bot)
end

local function createBotESPTag(bot)
    if not SETTINGS.SHOW_BOT_ESP then return end
    removeBotESPTag(bot)

    local rootPart = bot:FindFirstChildWhichIsA("BasePart", true)
    if not rootPart then return end

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "BotESPTag"
        bgui.Adornee = rootPart
        bgui.Size = UDim2.new(0, 150, 0, 40)
        bgui.StudsOffset = Vector3.new(0, 3, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_BOT_ESP
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "🤖 BOT"
        label.TextColor3 = SETTINGS.BotColor
        label.TextStrokeTransparency = 0.5
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        botESPTags[bot] = bgui

        -- FIX: setupBoneESP checks for Humanoid; bots may use a different hierarchy.
        -- Only attempt if bot has a Humanoid (otherwise it silently no-ops anyway).
        if SETTINGS.SHOW_BONE_ESP and bot:FindFirstChild("Humanoid") then
            setupBoneESP(bot, bot, SETTINGS.BotColor)
        end
    end)
end

-- ==========================================
-- ARMOR ESP
-- ==========================================
local function removeArmorESPTag(player)
    if armorESPTags[player] then
        for _, tag in pairs(armorESPTags[player]) do
            pcall(function() tag:Destroy() end)
        end
        armorESPTags[player] = nil
    end
end

local function createArmorESPTag(player, character)
    if not SETTINGS.SHOW_ARMOR_ESP then return end
    removeArmorESPTag(player)

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    armorESPTags[player] = {}

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "ArmorESPTag_" .. player.Name
        bgui.Adornee = rootPart
        bgui.Size = UDim2.new(0, 150, 0, 40)
        bgui.StudsOffset = Vector3.new(0, -3, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_ARMOR_ESP
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "🛡️ ARMOR"
        label.TextColor3 = SETTINGS.ArmorColor
        label.TextStrokeTransparency = 0.5
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        armorESPTags[player][bgui.Name] = bgui
    end)
end

-- ==========================================
-- THERMAL ESP
-- ==========================================
local function removeThermalESPTag(player)
    if thermalESPTags[player] and thermalESPTags[player].Parent then
        pcall(function() thermalESPTags[player]:Destroy() end)
        thermalESPTags[player] = nil
    end
end

local function createThermalESPTag(player, character)
    if not SETTINGS.SHOW_THERMAL_ESP then return end
    removeThermalESPTag(player)

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "ThermalESPTag"
        bgui.Adornee = rootPart
        bgui.Size = UDim2.new(0, 150, 0, 40)
        bgui.StudsOffset = Vector3.new(0, -5, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_THERMAL_ESP
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "🔥 THERMAL"
        label.TextColor3 = SETTINGS.ThermalColor
        label.TextStrokeTransparency = 0.5
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        thermalESPTags[player] = bgui
    end)
end

-- ==========================================
-- WEAPON ESP
-- ==========================================
local function removeWeaponESPTag(player)
    if weaponESPTags[player] and weaponESPTags[player].Parent then
        pcall(function() weaponESPTags[player]:Destroy() end)
        weaponESPTags[player] = nil
    end
end

local function createWeaponESPTag(player, character, toolName)
    if not SETTINGS.SHOW_WEAPON_ESP then return end
    removeWeaponESPTag(player)

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "WeaponESPTag"
        bgui.Adornee = rootPart
        bgui.Size = UDim2.new(0, 180, 0, 40)
        bgui.StudsOffset = Vector3.new(2.5, 0, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_WEAPON_ESP
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "🔫 " .. toolName
        label.TextColor3 = SETTINGS.WeaponColor
        label.TextStrokeTransparency = 0.5
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        weaponESPTags[player] = bgui
    end)
end

-- ==========================================
-- AMMO ESP (FOR PROJECTILES)
-- ==========================================
local function createAmmoESPTag(ammo)
    if not SETTINGS.SHOW_AMMO_ESP then return end
    if ammoESPTags[ammo] then return end

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "AmmoESPTag"
        bgui.Adornee = ammo
        bgui.Size = UDim2.new(0, 100, 0, 40)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_AMMO_ESP
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "💥 AMMO"
        label.TextColor3 = SETTINGS.AmmoColor
        label.TextStrokeTransparency = 0.5
        label.TextSize = 11
        label.Font = Enum.Font.Gotham
        label.TextYAlignment = Enum.TextYAlignment.Center

        ammoESPTags[ammo] = bgui

        trackConnection(ammo.AncestryChanged:Connect(function()
            if not ammo:IsDescendantOf(game) then
                pcall(function() bgui:Destroy() end)
                ammoESPTags[ammo] = nil
            end
        end))
    end)
end

-- ==========================================
-- TOOL TAGS
-- ==========================================
local function removeToolTag(player)
    if toolTags[player] and toolTags[player].Parent then
        pcall(function() toolTags[player]:Destroy() end)
        toolTags[player] = nil
    end
end

local function setupPlayerTools(player)
    if player == LocalPlayer then return end

    local function hookCharacter(character)
        removeToolTag(player)
        removePlayerESPTag(player)
        removeArmorESPTag(player)
        removeThermalESPTag(player)
        removeWeaponESPTag(player)
        removeBoneLines(player)  -- FIX: was missing; old bone lines leaked on respawn
        createEnemyAmmoTag(player, character)
        createPlayerESPTag(player, character)
        createArmorESPTag(player, character)
        createThermalESPTag(player, character)
        setupBoneESP(player, character)

        trackConnection(character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                if enemyAmmoConnections[player] then
                    cleanupConnections(enemyAmmoConnections[player])
                    enemyAmmoConnections[player] = {}
                end
                createWeaponESPTag(player, character, child.Name)
                updateEnemyAmmo(player, child)
                hookEnemyAmmoValues(player, child)
            end
        end))

        trackConnection(character.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                removeWeaponESPTag(player)
                updateEnemyAmmo(player, nil)
            end
        end))

        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            createWeaponESPTag(player, character, tool.Name)
            updateEnemyAmmo(player, tool)
            hookEnemyAmmoValues(player, tool)
        end
    end

    if player.Character then hookCharacter(player.Character) end
    trackConnection(player.CharacterAdded:Connect(function(character)
        task.wait(0)
        hookCharacter(character)
    end))
    trackConnection(player.CharacterRemoving:Connect(function()
        removeToolTag(player)
        removePlayerESPTag(player)
        removeAmmoTag(player)
        removeArmorESPTag(player)
        removeThermalESPTag(player)
        removeWeaponESPTag(player)
        removeBoneLines(player)
    end))
end

-- ==========================================
-- PLAYER HEALTH UPDATE (in heartbeat)
-- ==========================================
RunService.Heartbeat:Connect(function()
    if not espEnabled or not SETTINGS.SHOW_PLAYER_ESP then return end
    for player, data in pairs(playerESPTags) do
        if data and data.gui and data.gui.Parent and data.character and data.healthLabel then
            local humanoid = data.character:FindFirstChild("Humanoid")
            if humanoid then
                data.healthLabel.Text = math.floor(humanoid.Health) .. " HP"
                if humanoid.Health <= 0 then
                    data.healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif humanoid.Health < humanoid.MaxHealth * 0.5 then
                    data.healthLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                else
                    data.healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                end
            end
        end
    end
end)

-- ==========================================
-- LOCAL AMMO HUD
-- ==========================================
local function removeLocalAmmoHUD()
    if localAmmoHUD and localAmmoHUD.Parent then
        pcall(function() localAmmoHUD:Destroy() end)
        localAmmoHUD = nil
    end
end

local function createLocalAmmoHUD()
    removeLocalAmmoHUD()

    pcall(function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AmmoHUD"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = TargetContainer

        local frame = Instance.new("Frame")
        frame.Name = "AmmoFrame"
        frame.Size = UDim2.new(0, 220, 0, 50)
        frame.Position = UDim2.new(1, -230, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame

        local gunName = Instance.new("TextLabel")
        gunName.Name = "GunName"
        gunName.Size = UDim2.new(1, -10, 0.45, 0)
        gunName.Position = UDim2.new(0, 10, 0, 4)
        gunName.BackgroundTransparency = 1
        gunName.Text = "No Weapon"
        gunName.TextColor3 = Color3.fromRGB(200, 200, 200)
        gunName.TextSize = 12
        gunName.Font = Enum.Font.Gotham
        gunName.TextXAlignment = Enum.TextXAlignment.Left
        gunName.Parent = frame

        local ammoCount = Instance.new("TextLabel")
        ammoCount.Name = "AmmoCount"
        ammoCount.Size = UDim2.new(1, -10, 0.45, 0)
        ammoCount.Position = UDim2.new(0, 10, 0.5, 0)
        ammoCount.BackgroundTransparency = 1
        ammoCount.Text = "0 | 0  [0]"
        ammoCount.TextColor3 = Color3.fromRGB(255, 255, 255)
        ammoCount.TextSize = 15
        ammoCount.Font = Enum.Font.GothamBold
        ammoCount.TextXAlignment = Enum.TextXAlignment.Left
        ammoCount.Parent = frame

        localAmmoHUD = screenGui
    end)
end

local function getHUDLabels()
    if not localAmmoHUD or not localAmmoHUD.Parent then return nil, nil end
    local frame = localAmmoHUD:FindFirstChild("AmmoFrame")
    if not frame then return nil, nil end
    return frame:FindFirstChild("GunName"), frame:FindFirstChild("AmmoCount")
end

local function updateLocalAmmoDisplay(tool)
    local gunLabel, ammoLabel = getHUDLabels()
    if not gunLabel or not ammoLabel then return end

    if not tool then
        gunLabel.Text = "No Weapon"
        gunLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ammoLabel.Text = "0 | 0  [0]"
        ammoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        return
    end

    local repValues   = tool:FindFirstChild("RepValues")
    local magAmmo     = repValues and repValues:FindFirstChild("Mag")
    local reserveAmmo = repValues and repValues:FindFirstChild("StoredAmmo")
    local chambered   = repValues and repValues:FindFirstChild("Chambered")

    local current = magAmmo and magAmmo.Value or "?"
    local reserve  = reserveAmmo and reserveAmmo.Value or "?"
    local chamber  = chambered and (chambered.Value and "+1" or "") or ""

    gunLabel.Text = tool.Name
    gunLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ammoLabel.Text = string.format("%s%s / %s", tostring(current), chamber, tostring(reserve))
    -- FIX: was passing magAmmo.Value twice (same bug as enemy ammo); use getMaxMag for the cap
    local localMaxMag = getMaxMag(tool)
    ammoLabel.TextColor3 = getAmmoColor(
        type(current) == "number" and current or 0,
        localMaxMag > 0 and localMaxMag or (type(current) == "number" and current or 1)
    )
end

local function hookLocalAmmoValues(tool)
    local repValues = tool:FindFirstChild("RepValues")
    if not repValues then return end

    cleanupConnections(localAmmoConnections)
    localAmmoConnections = {}

    local ammo    = repValues:FindFirstChild("Mag")
    local reserve = repValues:FindFirstChild("StoredAmmo")
    local chamber = repValues:FindFirstChild("Chambered")

    if ammo    then table.insert(localAmmoConnections, trackConnection(ammo.Changed:Connect(function() updateLocalAmmoDisplay(tool) end))) end
    if reserve then table.insert(localAmmoConnections, trackConnection(reserve.Changed:Connect(function() updateLocalAmmoDisplay(tool) end))) end
    if chamber then table.insert(localAmmoConnections, trackConnection(chamber.Changed:Connect(function() updateLocalAmmoDisplay(tool) end))) end
end

local function onToolEquipped(tool)
    currentTool = tool
    if not localAmmoHUD then createLocalAmmoHUD() end
    updateLocalAmmoDisplay(tool)
    hookLocalAmmoValues(tool)
end

local function onToolUnequipped()
    currentTool = nil
    cleanupConnections(localAmmoConnections)
    localAmmoConnections = {}
    updateLocalAmmoDisplay(nil)
end

local function setupLocalCharacter(character)
    character:WaitForChild("HumanoidRootPart", 5)
    createLocalAmmoHUD()
    updateLocalAmmoDisplay(nil)

    trackConnection(character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0)
            onToolEquipped(child)
        end
    end))

    trackConnection(character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            onToolUnequipped()
        end
    end))

    local tool = character:FindFirstChildOfClass("Tool")
    if tool then onToolEquipped(tool) end
end

-- ==========================================
-- FUNCTIONS
-- ==========================================
local function toggleESP()
    espEnabled = not espEnabled
    for _, tag in pairs(espTags) do
        if tag and tag.Parent then tag.Enabled = espEnabled end
    end
    for _, tag in pairs(ammoTags) do
        if tag and tag.Parent then tag.Enabled = espEnabled and SETTINGS.SHOW_ENEMY_AMMO end
    end
    for _, tag in pairs(playerESPTags) do
        if tag and tag.gui and tag.gui.Parent then tag.gui.Enabled = espEnabled and SETTINGS.SHOW_PLAYER_ESP end
    end
    for _, tag in pairs(corpseESPTags) do
        if tag and tag.Parent then tag.Enabled = espEnabled and SETTINGS.SHOW_CORPSE_ESP end
    end
    for _, tag in pairs(botESPTags) do
        if tag and tag.Parent then tag.Enabled = espEnabled and SETTINGS.SHOW_BOT_ESP end
    end
    for _, tags in pairs(armorESPTags) do
        for _, tag in pairs(tags) do
            if tag and tag.Parent then tag.Enabled = espEnabled and SETTINGS.SHOW_ARMOR_ESP end
        end
    end
    for _, tag in pairs(thermalESPTags) do
        if tag and tag.Parent then tag.Enabled = espEnabled and SETTINGS.SHOW_THERMAL_ESP end
    end
    for _, tag in pairs(weaponESPTags) do
        if tag and tag.Parent then tag.Enabled = espEnabled and SETTINGS.SHOW_WEAPON_ESP end
    end
    if localAmmoHUD and localAmmoHUD.Parent then
        -- FIX: ScreenGui has no .Enabled; toggle the inner frame's Visible instead
        local frame = localAmmoHUD:FindFirstChild("AmmoFrame")
        if frame then frame.Visible = espEnabled and SETTINGS.SHOW_AMMO end
    end
    return espEnabled
end

local function cyclePreset()
    currentPreset = (currentPreset % #PRESETS) + 1
    SETTINGS.MIN_VALUE = PRESETS[currentPreset].MIN_VALUE
    return PRESETS[currentPreset].name
end

local function dumpLoot()
    local root = getCachedRoot()
    if not root then return end

    local lootables = workspace:FindFirstChild("Lootables")
    if not lootables then return end

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
    print("\n[ESP Loot Dump]")
    for _, r in ipairs(results) do
        print(string.format("[%s] %s — $%s | %s studs", r.container, r.name, tostring(r.price), tostring(r.dist)))
    end
    print("")
end

-- ==========================================
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
}

for _, toggle in ipairs(playerToggles) do
    PlayerTab:CreateToggle({
        Name = toggle.name, CurrentValue = _raw[toggle.key],
        Flag = "Toggle_" .. toggle.key,
        Callback = function(val) SETTINGS[toggle.key] = val end,
    })
end

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
    { name = "Loot",       key = "LootColor"       },
    { name = "High Value", key = "HighValueColor"   },
    { name = "Extraction", key = "ExtractionColor"  },
    { name = "Player",     key = "PlayerColor"      },
    { name = "Corpse",     key = "CorpseColor"      },
    { name = "Bot",        key = "BotColor"         },
    { name = "Armor",      key = "ArmorColor"       },
    { name = "Thermal",    key = "ThermalColor"     },
    { name = "Weapon",     key = "WeaponColor"      },
    { name = "Ammo",       key = "AmmoColor"        },
}

for _, def in ipairs(colorDefs) do
    ColTab:CreateColorPicker({
        Name = def.name .. " Color", Color = _raw[def.key],
        Flag = "Color_" .. def.key,
        Callback = function(val) SETTINGS[def.key] = val end,
    })
end

-- TAB 6: Tools
local ToolTab = Window:CreateTab("Tools", "hammer")
ToolTab:CreateSection("Quick Actions")

ToolTab:CreateButton({
    Name = "Toggle ESP (Alt)",
    Callback = function()
        local on = toggleESP()
        Rayfield:Notify({
            Title = "ESP",
            Content = on and "✓ Enabled" or "✗ Disabled",
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
            Content = "→ " .. preset,
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

-- TAB 7: Info
local InfoTab = Window:CreateTab("Info", "info")
InfoTab:CreateSection("m995 panel")
InfoTab:CreateLabel("Version: v4 Complete")
InfoTab:CreateLabel("A full-featured ESP suite built for ACS-based games.")
InfoTab:CreateSection("Credits")
InfoTab:CreateLabel("Script by: millionlikes_9677")
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
InfoTab:CreateSection("Keybinds")
InfoTab:CreateLabel("ALT — Toggle ESP on/off")
InfoTab:CreateLabel("ALT+R — Cycle loot preset")

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

    local acsWS = workspace:FindFirstChild("ACS_WorkSpace")
    if acsWS then
        local ai = acsWS:FindFirstChild("AI")
        if ai then
            for _, bot in ipairs(ai:GetChildren()) do
                createBotESPTag(bot)
            end
            trackConnection(ai.ChildAdded:Connect(createBotESPTag))
            trackConnection(ai.ChildRemoving:Connect(removeBotESPTag))
        end

        -- Wire ammo pickup ESP to the ammo folder inside ACS_WorkSpace
        local ammoFolder = acsWS:FindFirstChild("Ammo")
        if ammoFolder then
            for _, ammo in ipairs(ammoFolder:GetChildren()) do
                createAmmoESPTag(ammo)
            end
            trackConnection(ammoFolder.ChildAdded:Connect(createAmmoESPTag))
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        setupPlayerTools(player)
    end
    
    trackConnection(Players.PlayerAdded:Connect(setupPlayerTools))
    trackConnection(Players.PlayerRemoving:Connect(function(player)
        removeAmmoTag(player)
        removePlayerESPTag(player)
        removeArmorESPTag(player)
        removeThermalESPTag(player)
        removeWeaponESPTag(player)
        removeBoneLines(player)
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

Rayfield:Notify({
    Title = "m995 panel",
    Content = "All systems online",
    Duration = 5,
})

print("[m995 panel v4] All features enabled!")
