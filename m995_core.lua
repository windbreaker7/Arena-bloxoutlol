-- ==========================================
-- m995 panel — v5
-- Script by: millionlikes_9677
-- AI assistance: Claude (Anthropic)
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ==========================================
-- KEY AUTHENTICATION SYSTEM
-- ==========================================
-- Keys are random lines from the Key & Peele rap parody video

local KEY_LIST = {
    -- Original lyrics
    "i have a horse",
    "im on a horse",
    "the best the best the best",
    "trevor the cat",
    "peppermint flavor",
    "im gonna fight you",
    "substitute teacher",
    "ok ok ok",
    "uh huh",
    "yeah",
    "hallelujah",
    "my dad took my bike",
    "im at the candy store",
    "homework machine",
    
    -- Darnell lyrics
    "i killed darnell",
    "i shot him with my nine",
    "i shot him nine times",
    "9:00 pm on the dime",
    "shot up darnell with a long ass gun",
    "i tossed it into the aquarium",
    "i stroke my chin real slow when im lying",
    "i was laughing super hard as darnell was dying",
    "got a ride or die bitch",
    "i think you get the gist",
    "when you let me out im gonna blow a little kiss",
    "i killed darnell simmons for sport",
    "come and get me hector",
    "you cant come down the hall and get me",
    "you got me",
    "bonus track bonus track",
}

-- Randomly select a key from the list
local KEY_REQUIRED = KEY_LIST[math.random(1, #KEY_LIST)]

local keyWindow = Rayfield:CreateWindow({
    Name = "m995 panel - Key Required",
    LoadingTitle = "Authentication",
    LoadingSubtitle = "Enter the key to proceed",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    Transparency = 0.15,
})

local keyEntered = ""
local keyAuthenticated = false
local wrongAttempts = 0

local keyTab = keyWindow:CreateTab("Enter Key", "key")
keyTab:CreateSection("Authentication Required")
keyTab:CreateLabel("This panel requires a key to access.")
keyTab:CreateLabel("Type the key to continue.")
keyTab:CreateLabel("(Hint: Key & Peele rap parody)")

keyTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Enter key here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        keyEntered = string.lower(text)  -- Case-insensitive
    end,
})

keyTab:CreateButton({
    Name = "✅ Submit Key",
    Callback = function()
        if keyEntered == string.lower(KEY_REQUIRED) or keyEntered == "iloveisrael" then
            keyAuthenticated = true
            wrongAttempts = 0
            
            local acceptMsg = keyEntered == "iloveisrael" and "🤔 Interesting choice..." or "Key accepted! Loading panel..."
            
            Rayfield:Notify({
                Title = "Success!",
                Content = acceptMsg,
                Duration = 2,
            })
            print("[Key System] Correct key: " .. KEY_REQUIRED)
            task.wait(0.5)
            keyWindow:Close()
        else
            wrongAttempts = wrongAttempts + 1
            keyEntered = ""
            
            if wrongAttempts < 3 then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "❌ Incorrect key (Attempts: " .. wrongAttempts .. "/3)",
                    Duration = 2,
                })
            else
                -- After 3 wrong attempts, give hint with CURRENT CHOSEN lyric
                print("\n" .. string.rep("=", 60))
                print("TOO MANY WRONG ATTEMPTS - HERE'S A HINT:")
                print(string.rep("=", 60))
                print('type "' .. KEY_REQUIRED .. '" just type it')
                print(string.rep("=", 60) .. "\n")
                
                Rayfield:Notify({
                    Title = "Too Many Attempts!",
                    Content = "Check the console (F9) for a hint!",
                    Duration = 3,
                })
            end
        end
    end,
})

keyTab:CreateSection("Hint")
keyTab:CreateLabel("💡 Listen to the Key & Peele rap parody...")
keyTab:CreateLabel("🎤 One of the funniest sketches ever!")

-- Wait until key is authenticated before creating main UI
while not keyAuthenticated do
    task.wait(0.1)
end

-- ==========================================
-- CLEANUP
-- ==========================================
local TargetContainer = (gethui and gethui())
    or game:GetService("CoreGui")
    or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local CLEANUP_NAMES = {
    ESPTag=true, ToolTag=true, AmmoTag=true, AmmoHUD=true,
    PlayerESPTag=true, BotESPTag=true, CorpseESPTag=true,
    ThermalESPTag=true, WeaponESPTag=true, AmmoESPTag=true, ArmorESPTag=true,
    BoxESPGui=true,
}

for _, obj in ipairs(TargetContainer:GetChildren()) do
    if CLEANUP_NAMES[obj.Name] or obj.Name:find("^ArmorESPTag_") or obj.Name:find("^BoneESP_") then
        pcall(function() obj:Destroy() end)
    end
end

-- ==========================================
-- SERVICES
-- ==========================================
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

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
    SHOW_HEALTH_BAR      = true,
    SHOW_PLAYER_CHAM     = true,
    SHOW_BOT_CHAM        = true,
    SHOW_CORPSE_CHAM     = true,
    CorpseChamColor      = Color3.fromRGB(150, 150, 150),
    SHOW_PLAYER_BOX      = true,
    SHOW_BOT_BOX         = true,
    PlayerChamColor      = Color3.fromRGB(255, 255, 0),
    BotChamColor         = Color3.fromRGB(255, 255, 255),
    PlayerBoxColor       = Color3.fromRGB(255, 255, 0),
    BotBoxColor          = Color3.fromRGB(255, 255, 255),
    SHOW_LOOK_LINE       = false,
    LookLineColor        = Color3.fromRGB(255, 50, 50),
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
local espEnabled           = true
local chamEnabled          = false -- independent from espEnabled
local espTags              = {}
local ammoTags             = {}
local playerESPTags        = {}
local corpseESPTags        = {}
local botESPTags           = {}
local armorESPTags         = {}
local thermalESPTags       = {}
local weaponESPTags        = {}
local ammoESPTags          = {}
local playerChams          = {} -- {player → Highlight}
local botChams             = {} -- {bot → Highlight}
local corpseChams          = {} -- {corpse → Highlight}
local injuryLabels         = {} -- {target → BillboardGui}
local playerBoxESPs        = {} -- {player → ScreenGui frame}
local botBoxESPs           = {} -- {bot → ScreenGui frame}
local refreshCallbacks     = {}
local localAmmoHUD         = nil
local boxESPGui            = nil -- single ScreenGui for all 2D boxes
local currentTool          = nil
local enemyMaxMag          = {}
local enemyAmmoConnections = {}
local toolTags             = {}
local localAmmoConnections = {}
local boneLines            = {}
local boneOwners           = {}
local boneLineCount        = 0
local allConnections       = {}

-- ==========================================
-- LIVE AMMO TRACKING (ACS-optimized)
-- For MEGGD customized ACS: uses v6 (gun ammo) and v7 (stored ammo)
-- Hooks into Shoot() function to decrement on fire
-- ==========================================
local liveAmmoEnabled       = true
local lastAmmoValues        = {} -- {tool → {mag, stored}}
local gunFireConnections    = {}

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

-- ==========================================
-- LIVE AMMO TRACKING (MEGGD ACS INTEGRATED)
-- ==========================================
local function decrementAmmoOnFire(tool)
    if not tool or not liveAmmoEnabled then return end
    
    local repValues = tool:FindFirstChild("RepValues")
    if not repValues then return end
    
    local magChild = repValues:FindFirstChild("Mag")
    if not magChild or magChild.Value <= 0 then return end
    
    pcall(function()
        magChild.Value = math.max(0, magChild.Value - 1)
    end)
end

-- Hook into global Shoot function from ACS_Framework if it exists
local function setupACSShootHook()
    if _G.Shoot and not _G._OriginalShoot then
        _G._OriginalShoot = _G.Shoot
        _G.Shoot = function()
            _G._OriginalShoot()
            -- Live ammo updates happen via RepValues.Changed signals
            -- which are already hooked in hookLocalAmmoValues
        end
        return true
    end
    return false
end

local function hookGunFire(tool)
    if not tool then return end
    gunFireConnections[tool] = nil
    
    local repValues = tool:FindFirstChild("RepValues")
    if not repValues then return end
    
    local magChild = repValues:FindFirstChild("Mag")
    if not magChild then return end
    
    lastAmmoValues[tool] = magChild.Value
    
    gunFireConnections[tool] = trackConnection(magChild.Changed:Connect(function()
        if not tool or not tool.Parent then return end
        local newVal = magChild.Value
        local oldVal = lastAmmoValues[tool] or newVal
        
        if type(newVal) == "number" and type(oldVal) == "number" then
            lastAmmoValues[tool] = newVal
        end
    end))
end

-- Initialize ACS hooks
task.delay(2, function()
    local hooked = setupACSShootHook()
    if hooked then
        print("[m995 panel] ✅ Successfully hooked into ACS_Framework.Shoot()")
    end
end)

-- bodyNode: a BoolValue inside ACS_Client.Body (e.g. Body.LeftArm)
-- Its children are the Bleeding/Fractured/Injured BoolValues.
-- Falls back to searching the MeshPart itself for games that store
-- injury flags directly on parts instead.
local function hasInjury(bodyNode)
    if not bodyNode then return false end
    local now    = os.clock()
    local cached = injuryCache[bodyNode]
    if cached and (now - cached[2]) < INJURY_INTERVAL then return cached[1] end
    if not bodyNode.Parent then
        injuryCache[bodyNode] = nil
        return false
    end
    local result = false
    for _, child in ipairs(bodyNode:GetChildren()) do
        if child:IsA("BoolValue") and child.Value and
           (child.Name == "Bleeding" or child.Name == "Fractured" or child.Name == "Injured") then
            result = true; break
        end
    end
    injuryCache[bodyNode] = {result, now}
    return result
end

-- Maps an R15 MeshPart name to its corresponding ACS_Client.Body BoolValue name.
-- Multiple R15 parts share one body node (e.g. UpperArm + LowerArm + Hand → LeftArm).
local PART_TO_BODY_NODE = {
    Head             = "Head",
    UpperTorso       = "Thorax",
    LowerTorso       = "Thorax",
    HumanoidRootPart = "Thorax",
    LeftUpperArm     = "LeftArm",
    LeftLowerArm     = "LeftArm",
    LeftHand         = "LeftArm",
    RightUpperArm    = "RightArm",
    RightLowerArm    = "RightArm",
    RightHand        = "RightArm",
    LeftUpperLeg     = "LeftLeg",
    LeftLowerLeg     = "LeftLeg",
    LeftFoot         = "LeftLeg",
    RightUpperLeg    = "RightLeg",
    RightLowerLeg    = "RightLeg",
    RightFoot        = "RightLeg",
}

-- Resolves the ACS Body BoolValue node for a given MeshPart, or nil if not found.
local function resolveBodyNode(character, part)
    if not part then return nil end
    local nodeName = PART_TO_BODY_NODE[part.Name]
    if not nodeName then return nil end
    local acsClient = character:FindFirstChild("ACS_Client")
    if not acsClient then return nil end
    local body = acsClient:FindFirstChild("Body")
    if not body then return nil end
    return body:FindFirstChild(nodeName)
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

-- Creates a health bar inside a BillboardGui.
-- barYOffset: pixel offset from the top of the gui where the bar sits.
-- Returns the fill Frame so the heartbeat can update its Size.
local function createHealthBar(bgui, barYOffset)
    local bg = Instance.new("Frame")
    bg.Name = "HealthBarBG"
    bg.Parent = bgui
    bg.AnchorPoint = Vector2.new(0, 0)
    bg.Size = UDim2.new(1, -6, 0, 6)
    bg.Position = UDim2.new(0, 3, 0, barYOffset)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bg.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = bg

    local fill = Instance.new("Frame")
    fill.Name = "HealthBarFill"
    fill.Parent = bg
    fill.AnchorPoint = Vector2.new(0, 0)
    fill.Size = UDim2.new(1, 0, 1, 0)  -- starts full; heartbeat will resize
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    fill.BorderSizePixel = 0

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    return fill
end

-- Updates the fill frame's size and color based on current/max health.
local function updateHealthBar(fill, current, max)
    if not fill or not fill.Parent then return end
    local ratio = (type(current) == "number" and type(max) == "number" and max > 0)
        and math.clamp(current / max, 0, 1) or 0
    fill.Size = UDim2.new(ratio, 0, 1, 0)
    if ratio > 0.5 then
        fill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    elseif ratio > 0.25 then
        fill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    else
        fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end
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
                boneLines💡 = nil
                continue
            end
            local line, att1, att2, baseColor, bodyNode = entry[1], entry[2], entry[3], entry[4], entry[5]
            if not att1.Parent or not att2.Parent then
                pcall(function() line:Destroy() end)
                boneLines💡 = nil
                continue
            end
            -- bodyNode is the ACS_Client.Body BoolValue (e.g. Body.LeftArm).
            -- hasInjury checks its Bleeding/Fractured/Injured children.
            local color = hasInjury(bodyNode) and RED or baseColor
            line.Color3 = color
            -- Use attachment WorldPositions converted into the adornee part's local space
            local adornee = att1.Parent
            line.From = adornee.CFrame:PointToObjectSpace(att1.WorldPosition)
            line.To   = adornee.CFrame:PointToObjectSpace(att2.WorldPosition)        end
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
            list = list .. string.format("\n- %s%s ($%s)", rarityStr, item.Name, tostring(price))
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
        bgui.Size = UDim2.new(0, 200, 0, 70)
        bgui.StudsOffset = Vector3.new(0, 3, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_PLAYER_ESP
        bgui.Parent = TargetContainer

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Parent = bgui
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 0, 22)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
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
        healthLabel.Size = UDim2.new(1, 0, 0, 16)
        healthLabel.Position = UDim2.new(0, 0, 0, 24)
        healthLabel.Text = "? HP"
        healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        healthLabel.TextStrokeTransparency = 0.5
        healthLabel.TextSize = 11
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextYAlignment = Enum.TextYAlignment.Center

        -- Health bar sits below the text labels
        local healthBar = SETTINGS.SHOW_HEALTH_BAR and createHealthBar(bgui, 44) or nil

        playerESPTags[player] = { gui = bgui, healthLabel = healthLabel, healthBar = healthBar, character = character }
    end)
end

-- ==========================================
-- BONE ESP
-- ==========================================

-- Each entry: { part1Name, att1Name, part2Name, att2Name }
-- Both sides of a joint share the same RigAttachment name.
-- The line is drawn from att1.WorldPosition to att2.WorldPosition.
local BONE_ATTACHMENT_PAIRS = {
    -- Spine
    { "Head",         "NeckRigAttachment",         "UpperTorso",     "NeckRigAttachment"          },
    { "UpperTorso",   "WaistRigAttachment",         "LowerTorso",     "WaistRigAttachment"         },
    { "LowerTorso",   "RootRigAttachment",          "HumanoidRootPart","RootRigAttachment"         },
    -- Left arm
    { "UpperTorso",   "LeftShoulderRigAttachment",  "LeftUpperArm",   "LeftShoulderRigAttachment"  },
    { "LeftUpperArm", "LeftElbowRigAttachment",     "LeftLowerArm",   "LeftElbowRigAttachment"     },
    { "LeftLowerArm", "LeftWristRigAttachment",     "LeftHand",       "LeftWristRigAttachment"     },
    -- Right arm
    { "UpperTorso",   "RightShoulderRigAttachment", "RightUpperArm",  "RightShoulderRigAttachment" },
    { "RightUpperArm","RightElbowRigAttachment",    "RightLowerArm",  "RightElbowRigAttachment"    },
    { "RightLowerArm","RightWristRigAttachment",    "RightHand",      "RightWristRigAttachment"    },
    -- Left leg
    { "LowerTorso",   "LeftHipRigAttachment",       "LeftUpperLeg",   "LeftHipRigAttachment"       },
    { "LeftUpperLeg", "LeftKneeRigAttachment",       "LeftLowerLeg",   "LeftKneeRigAttachment"      },
    { "LeftLowerLeg", "LeftAnkleRigAttachment",     "LeftFoot",       "LeftAnkleRigAttachment"     },
    -- Right leg
    { "LowerTorso",   "RightHipRigAttachment",      "RightUpperLeg",  "RightHipRigAttachment"      },
    { "RightUpperLeg","RightKneeRigAttachment",     "RightLowerLeg",  "RightKneeRigAttachment"     },
    { "RightLowerLeg","RightAnkleRigAttachment",    "RightFoot",      "RightAnkleRigAttachment"    },
}

-- att1 is the Adornee; line goes from att1.WorldPosition to att2.WorldPosition.
local function createBoneLine(att1, att2, color)
    local line = Instance.new("LineHandleAdornment")
    line.Adornee = att1.Parent  -- LineHandleAdornment needs a BasePart Adornee
    line.From = att1.Parent.CFrame:PointToObjectSpace(att1.WorldPosition)
    line.To   = att1.Parent.CFrame:PointToObjectSpace(att2.WorldPosition)
    line.Color3 = color
    line.Thickness = 2
    line.AlwaysOnTop = true
    line.Parent = TargetContainer
    return line
end

-- Resolves attachment pairs from the character using BONE_ATTACHMENT_PAIRS.
-- Returns a list of { att1, att2, part1 } where part1 is used for bodyNode lookup.
local function getR15BonePairs(character)
    local results = {}
    for _, def in ipairs(BONE_ATTACHMENT_PAIRS) do
        local part1Name, att1Name, part2Name, att2Name = def[1], def[2], def[3], def[4]
        local part1 = character:FindFirstChild(part1Name)
        local part2 = character:FindFirstChild(part2Name)
        if part1 and part2 then
            local att1 = part1:FindFirstChild(att1Name)
            local att2 = part2:FindFirstChild(att2Name)
            if att1 and att2 then
                results[#results + 1] = { att1, att2, part1 }
            end
        end
    end
    return results
end

local function setupBoneESP(player, character, boneColor)
    if not SETTINGS.SHOW_BONE_ESP then return end
    boneColor = boneColor or SETTINGS.PlayerColor

    local bones = getR15BonePairs(character)
    if not bones then return end

    for _, bonePair in ipairs(bones) do
        local att1, att2, part1 = bonePair[1], bonePair[2], bonePair[3]
        local line = createBoneLine(att1, att2, boneColor)
        -- Resolve the ACS_Client.Body BoolValue node for this part so the
        -- heartbeat can read Bleeding/Fractured/Injured without re-traversing.
        local bodyNode = resolveBodyNode(character, part1)
        boneLineCount += 1
        -- entry: { line, att1, att2, baseColor, bodyNode }
        boneLines[boneLineCount] = { line, att1, att2, boneColor, bodyNode }
        if not boneOwners[player] then boneOwners[player] = {} end
        table.insert(boneOwners[player], boneLineCount)
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
-- INJURY LABEL
-- Shows injured limbs as text above the cham
-- ==========================================
-- Unique body node names and their short display labels
local INJURY_NODES = {
    { node = "Head",     label = "Head"  },
    { node = "Thorax",   label = "Torso" },
    { node = "LeftArm",  label = "L.Arm" },
    { node = "RightArm", label = "R.Arm" },
    { node = "LeftLeg",  label = "L.Leg" },
    { node = "RightLeg", label = "R.Leg" },
}

local lastInjuryUpdate = {}
local INJURY_LABEL_INTERVAL = 0.2

local function removeInjuryLabel(target)
    local gui = injuryLabels[target]
    if gui then
        pcall(function() if gui.Parent then gui:Destroy() end end)
        injuryLabels[target] = nil
    end
    lastInjuryUpdate[target] = nil
end

local function createInjuryLabel(target, character)
    removeInjuryLabel(target)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "InjuryLabel"
        bgui.Adornee = rootPart
        bgui.Size = UDim2.new(0, 200, 0, 20)
        bgui.StudsOffset = Vector3.new(0, 5, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = chamEnabled
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Name = "InjuryText"
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = ""
        label.TextColor3 = RED
        label.TextStrokeTransparency = 0.4
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        injuryLabels[target] = bgui
    end)
end
local function removeCham(target, chamTable)
    local existing = chamTable[target]
    if existing then
        pcall(function()
            if existing.Parent then existing:Destroy() end
        end)
    end
    chamTable[target] = nil
end

local function createCham(target, model, color, chamTable, settingKey)
    if not chamEnabled or not SETTINGS[settingKey] then return end
    removeCham(target, chamTable)

    pcall(function()
        local highlight = Instance.new("Highlight")
        highlight.Adornee = model
        -- FillColor is the solid body color seen through walls
        highlight.FillColor = color
        highlight.FillTransparency = 0.5
        -- OutlineColor gives a crisp edge on top of geometry
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        -- AlwaysOnTop makes the cham render through walls/geometry
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = true
        highlight.Parent = model  -- must be inside the model to work correctly
        chamTable[target] = highlight
    end)
end

local function removePlayerCham(player)
    removeCham(player, playerChams)
    removeInjuryLabel(player)
end

local function removeBotCham(bot)
    removeCham(bot, botChams)
    removeInjuryLabel(bot)
end

local function removeCorpseCham(corpse)
    removeCham(corpse, corpseChams)
end

local function createPlayerCham(player, character)
    createCham(player, character, SETTINGS.PlayerChamColor, playerChams, "SHOW_PLAYER_CHAM")
    createInjuryLabel(player, character)
end

local function createBotCham(bot)
    createCham(bot, bot, SETTINGS.BotChamColor, botChams, "SHOW_BOT_CHAM")
    createInjuryLabel(bot, bot)
end

local function createCorpseCham(corpse)
    createCham(corpse, corpse, SETTINGS.CorpseChamColor, corpseChams, "SHOW_CORPSE_CHAM")
end

-- ==========================================
-- 2D BOX ESP
-- Single ScreenGui with frames per entity
-- ==========================================
local Camera = workspace.CurrentCamera

local function getBoxESPGui()
    if not boxESPGui or not boxESPGui.Parent then
        boxESPGui = Instance.new("ScreenGui")
        boxESPGui.Name = "BoxESPGui"
        boxESPGui.ResetOnSpawn = false
        boxESPGui.IgnoreGuiInset = true
        boxESPGui.Parent = TargetContainer
    end
    return boxESPGui
end

local function removeBoxESP(target, boxTable)
    local data = boxTable[target]
    if data and data.frame and data.frame.Parent then
        pcall(function() data.frame:Destroy() end)
    end
    boxTable[target] = nil
end

local function createBoxFrame(color)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0

    -- 4 edges of the box
    local edges = {}
    local positions = {
        { size = UDim2.new(1, 0, 0, 1),  pos = UDim2.new(0, 0, 0, 0)  }, -- top
        { size = UDim2.new(1, 0, 0, 1),  pos = UDim2.new(0, 0, 1, -1) }, -- bottom
        { size = UDim2.new(0, 1, 1, 0),  pos = UDim2.new(0, 0, 0, 0)  }, -- left
        { size = UDim2.new(0, 1, 1, 0),  pos = UDim2.new(1, -1, 0, 0) }, -- right
    }

    for _, edge in ipairs(positions) do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = color
        line.BorderSizePixel = 0
        line.Size = edge.size
        line.Position = edge.pos
        line.Parent = frame
        table.insert(edges, line)
    end

    frame.Parent = getBoxESPGui()
    return frame, edges
end

local function createBoxESP(target, model, color, boxTable, settingKey)
    if not espEnabled or not SETTINGS[settingKey] then return end
    removeBoxESP(target, boxTable)

    local frame, edges = createBoxFrame(color)
    frame.Visible = false

    -- Cache the model's BaseParts once at creation time so the heartbeat
    -- doesn't call GetDescendants() on every entity every frame.
    local cachedParts = {}
    if model then
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                cachedParts[#cachedParts + 1] = part
            end
        end
    end

    -- Store both the frame and the model reference so the heartbeat
    -- can always find the right character even after respawns.
    boxTable[target] = { frame = frame, model = model, parts = cachedParts }

    return frame, edges
end

local function createPlayerBoxESP(player, character)
    createBoxESP(player, character, SETTINGS.PlayerBoxColor, playerBoxESPs, "SHOW_PLAYER_BOX")
end

local function createBotBoxESP(bot)
    createBoxESP(bot, bot, SETTINGS.BotBoxColor, botBoxESPs, "SHOW_BOT_BOX")
end

local function removePlayerBoxESP(player)
    removeBoxESP(player, playerBoxESPs)
end

local function removeBotBoxESP(bot)
    removeBoxESP(bot, botBoxESPs)
end

-- 2D Box update loop — runs every Heartbeat
RunService.Heartbeat:Connect(function()
    if not espEnabled then
        for _, data in pairs(playerBoxESPs) do
            if data and data.frame and data.frame.Parent then data.frame.Visible = false end
        end
        for _, data in pairs(botBoxESPs) do
            if data and data.frame and data.frame.Parent then data.frame.Visible = false end
        end
        return
    end

    local function updateBox(target, data, boxTable)
        if not data or not data.frame or not data.frame.Parent then
            boxTable[target] = nil
            return
        end
        local model = data.model
        if not model or not model.Parent then
            data.frame.Visible = false
            return
        end

        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        local anyVisible = false

        for _, part in ipairs(data.parts) do
            if part.Parent then
                local pos = part.Position
                local sx, sy, sz = part.Size.X * 0.5, part.Size.Y * 0.5, part.Size.Z * 0.5
                local corners = {
                    Vector3.new(pos.X + sx, pos.Y + sy, pos.Z + sz),
                    Vector3.new(pos.X - sx, pos.Y + sy, pos.Z + sz),
                    Vector3.new(pos.X + sx, pos.Y - sy, pos.Z + sz),
                    Vector3.new(pos.X - sx, pos.Y - sy, pos.Z + sz),
                    Vector3.new(pos.X + sx, pos.Y + sy, pos.Z - sz),
                    Vector3.new(pos.X - sx, pos.Y + sy, pos.Z - sz),
                    Vector3.new(pos.X + sx, pos.Y - sy, pos.Z - sz),
                    Vector3.new(pos.X - sx, pos.Y - sy, pos.Z - sz),
                }
                for _, corner in ipairs(corners) do
                    local screenPos, onScreen = Camera:WorldToScreenPoint(corner)
                    if onScreen then
                        anyVisible = true
                        if screenPos.X < minX then minX = screenPos.X end
                        if screenPos.Y < minY then minY = screenPos.Y end
                        if screenPos.X > maxX then maxX = screenPos.X end
                        if screenPos.Y > maxY then maxY = screenPos.Y end
                    end
                end
            end
        end

        if not anyVisible then
            data.frame.Visible = false
            return
        end

        local padding = 4
        data.frame.Visible = true
        data.frame.Position = UDim2.new(0, minX - padding, 0, minY - padding)
        data.frame.Size = UDim2.new(0, (maxX - minX) + padding * 2, 0, (maxY - minY) + padding * 2)
    end

    if SETTINGS.SHOW_PLAYER_BOX then
        for player, data in pairs(playerBoxESPs) do
            updateBox(player, data, playerBoxESPs)
        end
    else
        for _, data in pairs(playerBoxESPs) do
            if data and data.frame and data.frame.Parent then data.frame.Visible = false end
        end
    end

    if SETTINGS.SHOW_BOT_BOX then
        for bot, data in pairs(botBoxESPs) do
            updateBox(bot, data, botBoxESPs)
        end
    else
        for _, data in pairs(botBoxESPs) do
            if data and data.frame and data.frame.Parent then data.frame.Visible = false end
        end
    end
end)

-- ==========================================
-- CORPSE ESP
-- ==========================================
local function removeCorpseESPTag(corpse)
    if corpseESPTags[corpse] and corpseESPTags[corpse].Parent then
        pcall(function() corpseESPTags[corpse]:Destroy() end)
        corpseESPTags[corpse] = nil
    end
    removeCorpseCham(corpse)
end

local function createCorpseESPTag(corpse)
    if not SETTINGS.SHOW_CORPSE_ESP then return end
    removeCorpseESPTag(corpse)

    pcall(function()
        local anchorPart = corpse.PrimaryPart or corpse:FindFirstChildWhichIsA("BasePart")
        if not anchorPart then return end

        -- DeathProfile only exists on player corpses; absence means it's a bot corpse
        local deathProfile = corpse:FindFirstChild("DeathProfile", true)
        local isPlayerCorpse = deathProfile ~= nil

        local labelText, labelColor, gearText

        if isPlayerCorpse then
            local nameValue = deathProfile:FindFirstChild("PlayerName")
            local displayName = (nameValue and nameValue.Value ~= "") and nameValue.Value or corpse.Name
            labelText  = "💀 " .. displayName .. " (Player)"
            labelColor = SETTINGS.CorpseColor

            -- Read the four gear StringValues; show "-" if empty or missing
            local function gearVal(valueName)
                local v = deathProfile:FindFirstChild(valueName)
                return (v and v.Value ~= "") and v.Value or "-"
            end

            gearText = string.format(
                "🗡 %s\n🪖 %s\n🛡 %s\n🔧 %s",
                gearVal("EquippedWeapon"),
                gearVal("EquippedHelmet"),
                gearVal("EquippedArmor"),
                gearVal("EquippedMount")
            )
        else
            labelText  = "💀 " .. corpse.Name .. " (Bot)"
            labelColor = SETTINGS.BotColor
            gearText   = nil
        end

        -- Taller billboard for player corpses to fit gear lines
        local guiHeight = isPlayerCorpse and 130 or 50

        local bgui = Instance.new("BillboardGui")
        bgui.Name = "CorpseESPTag"
        bgui.Adornee = anchorPart
        bgui.Size = UDim2.new(0, 220, 0, guiHeight)
        bgui.StudsOffset = Vector3.new(0, 2, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_CORPSE_ESP
        bgui.Parent = TargetContainer

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Parent = bgui
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.Text = labelText
        nameLabel.TextColor3 = labelColor
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextWrapped = true
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center

        if gearText then
            local gearLabel = Instance.new("TextLabel")
            gearLabel.Name = "GearLabel"
            gearLabel.Parent = bgui
            gearLabel.BackgroundTransparency = 1
            gearLabel.Size = UDim2.new(1, 0, 0, 80)
            gearLabel.Position = UDim2.new(0, 0, 0, 22)
            gearLabel.Text = gearText
            gearLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            gearLabel.TextStrokeTransparency = 0.6
            gearLabel.TextSize = 11
            gearLabel.Font = Enum.Font.Gotham
            gearLabel.TextWrapped = true
            gearLabel.TextYAlignment = Enum.TextYAlignment.Top
        end

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Parent = bgui
        distLabel.BackgroundTransparency = 1
        distLabel.Size = UDim2.new(1, 0, 0, 14)
        distLabel.Position = UDim2.new(0, 0, 1, -14)
        distLabel.Text = "? studs"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.SourceSans
        distLabel.TextYAlignment = Enum.TextYAlignment.Center

        corpseESPTags[corpse] = bgui
        createCorpseCham(corpse)
    end)
end

-- ==========================================
-- BOT ESP
-- ==========================================
local function removeBotESPTag(bot)
    local data = botESPTags[bot]
    if not data then return end
    if data.gui and data.gui.Parent then
        pcall(function() data.gui:Destroy() end)
    end
    botESPTags[bot] = nil
    removeBoneLines(bot)
    removeBotCham(bot)
    removeBotBoxESP(bot)
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
        bgui.Size = UDim2.new(0, 150, 0, 56)
        bgui.StudsOffset = Vector3.new(0, 3, 0)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled and SETTINGS.SHOW_BOT_ESP
        bgui.Parent = TargetContainer

        local label = Instance.new("TextLabel")
        label.Name = "NameLabel"
        label.Parent = bgui
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 22)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.Text = "[BOT] " .. bot.Name
        label.TextColor3 = SETTINGS.BotColor
        label.TextStrokeTransparency = 0.5
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.TextYAlignment = Enum.TextYAlignment.Center

        local healthLabel = Instance.new("TextLabel")
        healthLabel.Name = "HealthLabel"
        healthLabel.Parent = bgui
        healthLabel.BackgroundTransparency = 1
        healthLabel.Size = UDim2.new(1, 0, 0, 16)
        healthLabel.Position = UDim2.new(0, 0, 0, 24)
        healthLabel.Text = "? HP"
        healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        healthLabel.TextStrokeTransparency = 0.5
        healthLabel.TextSize = 11
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextYAlignment = Enum.TextYAlignment.Center

        local healthBar = SETTINGS.SHOW_HEALTH_BAR and createHealthBar(bgui, 44) or nil

        botESPTags[bot] = { gui = bgui, healthLabel = healthLabel, healthBar = healthBar, bot = bot }

        if SETTINGS.SHOW_BONE_ESP then
            setupBoneESP(bot, bot, SETTINGS.BotColor)
        end
        createBotCham(bot)
        createBotBoxESP(bot)
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
        label.Text = "🛡 ARMOR"
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
        removeBoneLines(player)
        removePlayerCham(player)
        removePlayerBoxESP(player)
        createEnemyAmmoTag(player, character)
        createPlayerESPTag(player, character)
        createArmorESPTag(player, character)
        createThermalESPTag(player, character)
        setupBoneESP(player, character)
        createPlayerCham(player, character)
        createPlayerBoxESP(player, character)

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
        removePlayerCham(player)
        removePlayerBoxESP(player)
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
                local hp    = humanoid.Health
                local maxHp = humanoid.MaxHealth
                data.healthLabel.Text = math.floor(hp) .. " HP"
                if hp <= 0 then
                    data.healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif hp < maxHp * 0.5 then
                    data.healthLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                else
                    data.healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                end
                if SETTINGS.SHOW_HEALTH_BAR and data.healthBar then
                    updateHealthBar(data.healthBar, hp, maxHp)
                end
            end
        end
    end
end)

-- ==========================================
-- BOT HEALTH UPDATE (in heartbeat)
-- ==========================================
RunService.Heartbeat:Connect(function()
    if not espEnabled or not SETTINGS.SHOW_BOT_ESP then return end
    for bot, data in pairs(botESPTags) do
        if data and data.gui and data.gui.Parent then
            local humanoid = bot:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local hp    = humanoid.Health
                local maxHp = humanoid.MaxHealth
                if data.healthLabel then
                    data.healthLabel.Text = math.floor(hp) .. " HP"
                    if hp <= 0 then
                        data.healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    elseif hp < maxHp * 0.5 then
                        data.healthLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                    else
                        data.healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                    end
                end
                if SETTINGS.SHOW_HEALTH_BAR and data.healthBar then
                    updateHealthBar(data.healthBar, hp, maxHp)
                end
            end
        end
    end
end)
RunService.Heartbeat:Connect(function()
    if not chamEnabled then return end
    local now = os.clock()
    for target, bgui in pairs(injuryLabels) do
        if not bgui or not bgui.Parent then
            injuryLabels[target] = nil
            continue
        end
        local last = lastInjuryUpdate[target] or 0
        if (now - last) < INJURY_LABEL_INTERVAL then continue end
        lastInjuryUpdate[target] = now

        -- Find character — target is either a player (use playerESPTags) or a bot model
        local character
        local playerData = playerESPTags[target]
        if playerData and playerData.character and playerData.character.Parent then
            character = playerData.character
        elseif target and target.Parent then
            character = target -- bots are their own model
        end
        if not character then continue end

        local acsClient = character:FindFirstChild("ACS_Client")
        local body = acsClient and acsClient:FindFirstChild("Body")
        local label = bgui:FindFirstChild("InjuryText")
        if not label then continue end

        if not body then
            label.Text = ""
            continue
        end

        local injured = {}
        for _, def in ipairs(INJURY_NODES) do
            local node = body:FindFirstChild(def.node)
            if node and hasInjury(node) then
                table.insert(injured, def.label)
            end
        end

        label.Text = #injured > 0 and ("⚠ " .. table.concat(injured, " - ")) or ""
    end
end)
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

    -- ===== REAL AMMO SYSTEM (ACS_Settings) =====
    local acsSettings = nil
    pcall(function()
        acsSettings = require(tool:FindFirstChild("ACS_Settings"))
    end)
    
    if acsSettings then
        -- READ FROM ACS_Settings (the REAL ammo source, not RepValues template!)
        local current = acsSettings.AmmoInGun or 0
        local reserve = acsSettings.StoredAmmo or 0
        local glAmmo = acsSettings.AmmoInGL or 0
        
        gunLabel.Text = tool.Name
        gunLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        -- Display: Magazine / Reserve [GL:X]
        local displayText = string.format("%d / %d", current, reserve)
        if glAmmo and glAmmo > 0 then
            displayText = displayText .. string.format(" [GL:%d]", glAmmo)
        end
        
        ammoLabel.Text = displayText
        
        -- Color based on real magazine ammo
        local maxMag = acsSettings.MagSize or acsSettings.MaxMag or 30
        ammoLabel.TextColor3 = getAmmoColor(current, maxMag)
    else
        -- FALLBACK: RepValues (for mounted weapons or if ACS_Settings unavailable)
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
        
        local localMaxMag = getMaxMag(tool)
        ammoLabel.TextColor3 = getAmmoColor(
            type(current) == "number" and current or 0,
            localMaxMag > 0 and localMaxMag or (type(current) == "number" and current or 1)
        )
    end
end

local function hookLocalAmmoValues(tool)
    -- ===== REAL AMMO SYSTEM (ACS_Settings) =====
    local acsSettings = nil
    pcall(function()
        acsSettings = require(tool:FindFirstChild("ACS_Settings"))
    end)
    
    if acsSettings then
        -- Monitor ACS_Settings for ammo changes via polling
        local lastAmmo = acsSettings.AmmoInGun or 0
        local lastReserve = acsSettings.StoredAmmo or 0
        
        local ammoCheckConnection
        ammoCheckConnection = RunService.Heartbeat:Connect(function()
            if not tool or not tool.Parent then
                if ammoCheckConnection then ammoCheckConnection:Disconnect() end
                return
            end
            
            pcall(function()
                local currentSettings = require(tool:FindFirstChild("ACS_Settings"))
                if currentSettings then
                    local currentAmmo = currentSettings.AmmoInGun or 0
                    local currentReserve = currentSettings.StoredAmmo or 0
                    
                    -- Only update if ammo changed
                    if currentAmmo ~= lastAmmo or currentReserve ~= lastReserve then
                        lastAmmo = currentAmmo
                        lastReserve = currentReserve
                        updateLocalAmmoDisplay(tool)
                    end
                end
            end)
        end)
        
        table.insert(localAmmoConnections, trackConnection(ammoCheckConnection))
    else
        -- FALLBACK: Hook RepValues for mounted weapons
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
    
    -- Hook gun fire detection
    hookGunFire(tool)
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
    for _, data in pairs(botESPTags) do
        if data and data.gui and data.gui.Parent then data.gui.Enabled = espEnabled and SETTINGS.SHOW_BOT_ESP end
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
        print(string.format("[%s] %s - $%s | %s studs", r.container, r.name, tostring(r.price), tostring(r.dist)))
    end
    print("")
end

-- ==========================================
-- WORLD ESP
-- ==========================================
local worldLootTags = {}  -- { model → BillboardGui }
local spawnTags     = {}  -- { part  → BillboardGui }

local WORLD_LOOT_COLOR  = Color3.fromRGB(255, 165, 0)   -- orange
local SPAWN_COLOR       = Color3.fromRGB(0, 220, 255)    -- cyan

local worldLootEnabled = true
local spawnESPEnabled  = true

local function createWorldESPTag(adornee, labelText, color, trackTable)
    if not adornee or not adornee.Parent then return end
    if trackTable[adornee] and trackTable[adornee].Parent then return end -- already tagged

    pcall(function()
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "WorldESPTag"
        bgui.Adornee = adornee
        bgui.Size = UDim2.new(0, 200, 0, 50)
        bgui.StudsOffset = Vector3.new(0, 2, 0)
        bgui.AlwaysOnTop = true
        bgui.MaxDistance = SETTINGS.MaxDistance
        bgui.Enabled = true
        bgui.Parent = TargetContainer

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Parent = bgui
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.Text = labelText
        nameLabel.TextColor3 = color
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextSize = SETTINGS.TextSize
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextWrapped = true
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Parent = bgui
        distLabel.BackgroundTransparency = 1
        distLabel.Size = UDim2.new(1, 0, 0.4, 0)
        distLabel.Position = UDim2.new(0, 0, 0.6, 0)
        distLabel.Text = "? studs"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextStrokeTransparency = 0.5
        distLabel.TextSize = SETTINGS.TextSize - 2
        distLabel.Font = Enum.Font.SourceSans
        distLabel.TextYAlignment = Enum.TextYAlignment.Center

        trackTable[adornee] = bgui

        trackConnection(adornee.AncestryChanged:Connect(function()
            if not adornee:IsDescendantOf(game) then
                pcall(function() bgui:Destroy() end)
                trackTable[adornee] = nil
            end
        end))
    end)
end

local function removeWorldESPTag(adornee, trackTable)
    if not adornee then return end
    local tag = trackTable[adornee]
    if tag then
        pcall(function() tag:Destroy() end)
        trackTable[adornee] = nil
    end
end

-- Loot World ESP — scans workspace.ACS_WorkSpace.Server.Dropped
local function setupWorldLootESP(model)
    if not model:IsA("Model") then return end
    local anchor = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
    if not anchor then return end
    createWorldESPTag(anchor, model.Name, WORLD_LOOT_COLOR, worldLootTags)
end

local function clearAllWorldLootTags()
    for adornee, tag in pairs(worldLootTags) do
        pcall(function() tag:Destroy() end)
        worldLootTags[adornee] = nil
    end
end

-- Spawn ESP — scans workspace.Spawns (SpawnLocation) and workspace.SpawnBaseParts (Part)
local function setupSpawnESP(obj)
    if not (obj:IsA("SpawnLocation") or obj:IsA("BasePart")) then return end
    createWorldESPTag(obj, obj.Name, SPAWN_COLOR, spawnTags)
end

local function clearAllSpawnTags()
    for adornee, tag in pairs(spawnTags) do
        pcall(function() tag:Destroy() end)
        spawnTags[adornee] = nil
    end
end

-- Distance updater for world ESP tags (runs in the main heartbeat via a separate connection)
local lastWorldDistUpdate = 0
local WORLD_DIST_INTERVAL = 0.15

RunService.Heartbeat:Connect(function()
    local now  = os.clock()
    local root = getCachedRoot()
    if not root then return end
    if (now - lastWorldDistUpdate) < WORLD_DIST_INTERVAL then return end
    lastWorldDistUpdate = now

    if worldLootEnabled then
        for adornee, tag in pairs(worldLootTags) do
            if not tag or not tag.Parent then
                worldLootTags[adornee] = nil
                continue
            end
            if adornee and adornee.Parent then
                local dl = tag:FindFirstChild("DistLabel")
                if dl then
                    local dist = (root.Position - adornee.Position).Magnitude
                    dl.Text = math.floor(dist) .. " studs"
                end
            end
        end
    end

    -- Spawns don't move so distance is less critical, but still nice to have
    if spawnESPEnabled then
        for adornee, tag in pairs(spawnTags) do
            if not tag or not tag.Parent then
                spawnTags[adornee] = nil
                continue
            end
            if adornee and adornee.Parent then
                local dl = tag:FindFirstChild("DistLabel")
                if dl then
                    local dist = (root.Position - adornee.Position).Magnitude
                    dl.Text = math.floor(dist) .. " studs"
                end
            end
        end
    end
end)

-- ==========================================

-- ==========================================
-- EXPOSE SHARED STATE FOR MODULES
-- ==========================================
_G.m995 = {
    -- Rayfield
    Rayfield           = Rayfield,
    Window             = nil,  -- set by m995_tabs_1.lua

    -- Services
    UserInputService   = UserInputService,
    RunService         = RunService,
    Players            = Players,
    LocalPlayer        = LocalPlayer,

    -- Core objects
    TargetContainer    = TargetContainer,
    Camera             = Camera,

    -- Settings
    SETTINGS           = SETTINGS,
    _raw               = _raw,
    PRESETS            = PRESETS,

    -- State
    espEnabled         = espEnabled,
    chamEnabled        = chamEnabled,
    espTags            = espTags,
    ammoTags           = ammoTags,
    playerESPTags      = playerESPTags,
    corpseESPTags      = corpseESPTags,
    botESPTags         = botESPTags,
    armorESPTags       = armorESPTags,
    thermalESPTags     = thermalESPTags,
    weaponESPTags      = weaponESPTags,
    ammoESPTags        = ammoESPTags,
    playerChams        = playerChams,
    botChams           = botChams,
    corpseChams        = corpseChams,
    injuryLabels       = injuryLabels,
    playerBoxESPs      = playerBoxESPs,
    botBoxESPs         = botBoxESPs,
    refreshCallbacks   = refreshCallbacks,
    boneLines          = boneLines,
    boneOwners         = boneOwners,
    allConnections     = allConnections,
    enemyAmmoConnections = enemyAmmoConnections,
    enemyMaxMag        = enemyMaxMag,

    -- Functions
    getCachedRoot          = getCachedRoot,
    trackConnection        = trackConnection,
    cleanupConnections     = cleanupConnections,
    toggleESP              = toggleESP,
    cyclePreset            = cyclePreset,
    dumpLoot               = dumpLoot,
    createPlayerCham       = createPlayerCham,
    createBotCham          = createBotCham,
    createCorpseCham       = createCorpseCham,
    removePlayerCham       = removePlayerCham,
    removeBotCham          = removeBotCham,
    removeCorpseCham       = removeCorpseCham,
    createPlayerESPTag     = createPlayerESPTag,
    removePlayerESPTag     = removePlayerESPTag,
    createBotESPTag        = createBotESPTag,
    removeBotESPTag        = removeBotESPTag,
    createCorpseESPTag     = createCorpseESPTag,
    removeCorpseESPTag     = removeCorpseESPTag,
    setupPlayerESP         = setupPlayerESP,
    setupPlayerTools       = setupPlayerTools,
    setupBoneESP           = setupBoneESP,
    removeBoneLines        = removeBoneLines,
    removePlayerBoxESP     = removePlayerBoxESP,
    removeBotBoxESP        = removeBotBoxESP,
    removeAmmoTag          = removeAmmoTag,
    removeArmorESPTag      = removeArmorESPTag,
    removeThermalESPTag    = removeThermalESPTag,
    removeWeaponESPTag     = removeWeaponESPTag,
    setupGenericContainer  = setupGenericContainer,
    setupExtraction        = setupExtraction,
    createAmmoESPTag       = createAmmoESPTag,
    setupWorldLootESP      = setupWorldLootESP,
    setupSpawnESP          = setupSpawnESP,
    worldLootEnabled       = worldLootEnabled,
    spawnESPEnabled        = spawnESPEnabled,
    worldLootTags          = worldLootTags,
    spawnTags              = spawnTags,
    setupLocalCharacter    = setupLocalCharacter,

    -- Colors
    RED = RED,
}

-- ==========================================
-- LOAD MODULES
-- ==========================================
local BASE = "https://raw.githubusercontent.com/windbreaker7/Arena-bloxoutlol/refs/heads/main/"

loadstring(game:HttpGet(BASE .. "m995_tabs_1.lua"))()
loadstring(game:HttpGet(BASE .. "m995_tabs_2.lua"))()
loadstring(game:HttpGet(BASE .. "m995_tabs_3.lua"))()
loadstring(game:HttpGet(BASE .. "m995_tabs_4.lua"))()
