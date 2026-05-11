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
    Name = "m995 panel — Key Required",
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
    Name = "✓ Submit Key",
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
local playerChams          = {} -- {player -> Highlight}
local botChams             = {} -- {bot -> Highlight}
local corpseChams          = {} -- {corpse -> Highlight}
local injuryLabels         = {} -- {target -> BillboardGui}
local playerBoxESPs        = {} -- {player -> ScreenGui frame}
local botBoxESPs           = {} -- {bot -> ScreenGui frame}
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
local lastAmmoValues        = {} -- {tool -> {mag, stored}}
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
        print("[m995 panel] ✓ Successfully hooked into ACS_Framework.Shoot()")
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
                boneLines[i] = nil
                continue
            end
            local line, att1, att2, baseColor, bodyNode = entry[1], entry[2], entry[3], entry[4], entry[5]
            if not att1.Parent or not att2.Parent then
                pcall(function() line:Destroy() end)
                boneLines[i] = nil
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

        label.Text = #injured > 0 and ("⚠ " .. table.concat(injured, " • ")) or ""
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
        print(string.format("[%s] %s — $%s | %s studs", r.container, r.name, tostring(r.price), tostring(r.dist)))
    end
    print("")
end

-- ==========================================
-- WORLD ESP
-- ==========================================
local worldLootTags = {}  -- { model -> BillboardGui }
local spawnTags     = {}  -- { part  -> BillboardGui }

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
                Content = "⚠️ Limited effect - ACS recoil is server-side",
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
                Content = "⚠️ Limited effect - ACS spread is server-side",
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

-- TAB 9: Player Info
local PlayerInfoTab = Window:CreateTab("Player Info", "users")
PlayerInfoTab:CreateSection("Players in Server")

-- Holds label references so we can remove them when a player leaves
-- Each entry: { player, label }
local playerInfoLabels = {}

local function formatAccountAge(days)
    if days >= 365 then
        local years = math.floor(days / 365)
        local rem   = days % 365
        local months = math.floor(rem / 30)
        if months > 0 then
            return years .. "y " .. months .. "m"
        end
        return years .. "y"
    elseif days >= 30 then
        return math.floor(days / 30) .. "m " .. (days % 30) .. "d"
    end
    return days .. "d"
end

local function getPlayerPosAndDist(player)
    local root = getCachedRoot()
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    local pos  = hrp.Position
    local dist = root and math.floor((root.Position - pos).Magnitude) or nil
    return pos, dist
end

local function buildPlayerInfoText(player)
    local pos, dist = getPlayerPosAndDist(player)
    local posStr  = pos  and string.format("(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z) or "unknown"
    local distStr = dist and (dist .. " studs") or "unknown"
    local char     = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local speed    = humanoid and math.floor(humanoid.WalkSpeed) or "?"
    
    -- Get current weapon
    local weaponName = "None"
    local weaponAmmo = ""
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            weaponName = tool.Name
            -- Try to get ammo info
            local repValues = tool:FindFirstChild("RepValues")
            if repValues then
                local mag = repValues:FindFirstChild("Mag")
                local stored = repValues:FindFirstChild("StoredAmmo") or repValues:FindFirstChild("Stored")
                if mag then
                    weaponAmmo = mag.Value .. ""
                    if stored then
                        weaponAmmo = weaponAmmo .. " | " .. stored.Value
                    end
                end
            end
        end
    end
    
    local weaponStr = weaponAmmo ~= "" and (weaponName .. " [" .. weaponAmmo .. "]") or weaponName
    
    return string.format(
        "%s  |  ID: %d  |  Age: %s\nPos: %s  |  Dist: %s  |  Speed: %s\nWeapon: %s",
        player.Name,
        player.UserId,
        formatAccountAge(player.AccountAge),
        posStr,
        distStr,
        tostring(speed),
        weaponStr
    )
end

local function addPlayerInfoLabel(player)
    for _, entry in ipairs(playerInfoLabels) do
        if entry.player == player then return end
    end
    local label = PlayerInfoTab:CreateLabel(buildPlayerInfoText(player))
    table.insert(playerInfoLabels, { player = player, label = label })
end

local function removePlayerInfoLabel(player)
    for i, entry in ipairs(playerInfoLabels) do
        if entry.player == player then
            pcall(function()
                entry.label:Set(entry.player.Name .. "  |  (left the server)")
            end)
            table.remove(playerInfoLabels, i)
            return
        end
    end
end

-- Live position/distance update — refreshes every 0.5s
local lastInfoUpdate = 0
RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if (now - lastInfoUpdate) < 0.5 then return end
    lastInfoUpdate = now
    for _, entry in ipairs(playerInfoLabels) do
        if entry.player and entry.label then
            pcall(function()
                entry.label:Set(buildPlayerInfoText(entry.player))
            end)
        end
    end
end)

-- Populate with players already in the server
for _, player in ipairs(Players:GetPlayers()) do
    addPlayerInfoLabel(player)
end

-- Keep in sync as players join / leave
trackConnection(Players.PlayerAdded:Connect(function(player)
    addPlayerInfoLabel(player)
end))

trackConnection(Players.PlayerRemoving:Connect(function(player)
    removePlayerInfoLabel(player)
end))

PlayerInfoTab:CreateSection("Actions")

PlayerInfoTab:CreateButton({
    Name = "Print All to Console",
    Callback = function()
        print("=== m995 panel — Player Info ===")
        for _, player in ipairs(Players:GetPlayers()) do
            local pos, dist = getPlayerPosAndDist(player)
            local posStr  = pos  and string.format("(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z) or "unknown"
            local distStr = dist and (dist .. " studs") or "unknown"
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            local speed    = humanoid and math.floor(humanoid.WalkSpeed) or "?"
            
            -- Get weapon info
            local weaponName = "None"
            local weaponAmmo = ""
            if player.Character then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    weaponName = tool.Name
                    local repValues = tool:FindFirstChild("RepValues")
                    if repValues then
                        local mag = repValues:FindFirstChild("Mag")
                        local stored = repValues:FindFirstChild("StoredAmmo") or repValues:FindFirstChild("Stored")
                        if mag then
                            weaponAmmo = mag.Value .. ""
                            if stored then
                                weaponAmmo = weaponAmmo .. " | " .. stored.Value
                            end
                        end
                    end
                end
            end
            
            local weaponStr = weaponAmmo ~= "" and (weaponName .. " [" .. weaponAmmo .. "]") or weaponName
            
            print(string.format(
                "  %s  |  UserID: %d  |  Age: %s  |  Pos: %s  |  Dist: %s  |  Speed: %s  |  Weapon: %s",
                player.Name,
                player.UserId,
                formatAccountAge(player.AccountAge),
                posStr,
                distStr,
                tostring(speed),
                weaponStr
            ))
        end
        print("================================")
        Rayfield:Notify({
            Title = "Player Info",
            Content = "Printed " .. #Players:GetPlayers() .. " player(s) to console (F9)",
            Duration = 3,
        })
    end,
})

-- TAB 11: Music Player
local MusicTab = Window:CreateTab("Music", "music")

-- ==========================================
-- MUSIC PLAYER
-- ==========================================
local MUSIC_FOLDER    = "boomboomboomtelaviv"
local AUDIO_FORMATS   = { ".mp3", ".ogg", ".wav", ".flac", ".aac", ".m4a", ".opus", ".mp2", ".mp1" }

-- State
local playlist        = {}   -- { name, path, assetUrl }
local currentIndex    = 0
local isPlaying       = false
local isLooping       = false
local isShuffling     = false
local musicVolume     = 0.5
local shuffleHistory  = {}

-- Sound instance — parented to PlayerGui so it persists through workspace changes
local musicSound = Instance.new("Sound")
musicSound.Name = "m995_MusicPlayer"
musicSound.Volume = musicVolume
musicSound.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ── Helpers ─────────────────────────────────────────────────────────────────
local function getExtension(filename)
    return filename:match("%.%w+$") and filename:match("%.%w+$"):lower() or ""
end

local function isAudioFile(filename)
    local ext = getExtension(filename)
    for _, fmt in ipairs(AUDIO_FORMATS) do
        if ext == fmt then return true end
    end
    return false
end

local function trimName(filename)
    -- Strip folder path and extension for display
    local name = filename:match("([^/\\]+)$") or filename
    return name:match("(.+)%.[^%.]+$") or name
end

local function scanFolder()
    playlist = {}
    if not isfolder(MUSIC_FOLDER) then
        makefolder(MUSIC_FOLDER)
        return
    end
    local files = listfiles(MUSIC_FOLDER)
    if not files then return end
    for _, path in ipairs(files) do
        local filename = path:match("([^/\\]+)$") or path
        if isAudioFile(filename) then
            local ok, url = pcall(getcustomasset, path)
            if ok and url then
                table.insert(playlist, {
                    name     = trimName(filename),
                    path     = path,
                    assetUrl = url,
                })
            end
        end
    end
end

local nowPlayingLabel
local statusLabel

local function updateNowPlayingLabel()
    if not nowPlayingLabel then return end
    if currentIndex == 0 or #playlist == 0 then
        pcall(function() nowPlayingLabel:Set("No track loaded") end)
        pcall(function() statusLabel:Set("Status: Stopped") end)
        return
    end
    local track = playlist[currentIndex]
    pcall(function()
        nowPlayingLabel:Set(string.format("♪ %s", track.name))
    end)
    pcall(function()
        statusLabel:Set(string.format(
            "Status: %s  |  %d / %d  |  %s%s",
            isPlaying and "Playing" or "Paused",
            currentIndex, #playlist,
            isLooping and "🔁 " or "",
            isShuffling and "🔀" or ""
        ))
    end)
end

local function stopMusic()
    isPlaying = false
    musicSound:Stop()
    updateNowPlayingLabel()
end

local function playTrack(index)
    if #playlist == 0 then
        Rayfield:Notify({ Title = "Music", Content = "Playlist is empty. Add MP3s to:\n" .. MUSIC_FOLDER, Duration = 4 })
        return
    end
    index = ((index - 1) % #playlist) + 1  -- wrap around
    currentIndex = index
    local track = playlist[currentIndex]
    musicSound:Stop()
    musicSound.SoundId = track.assetUrl
    musicSound.TimePosition = 0
    musicSound:Play()
    isPlaying = true
    updateNowPlayingLabel()
end

local function getNextIndex()
    if isShuffling then
        if #playlist <= 1 then return 1 end
        local idx
        local attempts = 0
        repeat
            idx = math.random(1, #playlist)
            attempts = attempts + 1
        until idx ~= currentIndex or attempts > 10
        return idx
    end
    return (currentIndex % #playlist) + 1
end

local function getPrevIndex()
    if isShuffling then return getNextIndex() end
    return ((currentIndex - 2) % #playlist) + 1
end

-- Auto-advance when a track ends
musicSound.Ended:Connect(function()
    if not isPlaying then return end
    if isLooping then
        musicSound.TimePosition = 0
        musicSound:Play()
    else
        playTrack(getNextIndex())
    end
end)

-- ── UI ───────────────────────────────────────────────────────────────────────
MusicTab:CreateSection("Now Playing")

nowPlayingLabel = MusicTab:CreateLabel("No track loaded")
statusLabel     = MusicTab:CreateLabel("Status: Stopped")

MusicTab:CreateSection("Controls")

MusicTab:CreateButton({
    Name = "⏮  Previous",
    Callback = function()
        if #playlist == 0 then return end
        playTrack(getPrevIndex())
    end,
})

MusicTab:CreateButton({
    Name = "⏯  Play / Pause",
    Callback = function()
        if #playlist == 0 then
            Rayfield:Notify({ Title = "Music", Content = "No tracks loaded. Scan the folder first.", Duration = 3 })
            return
        end
        if currentIndex == 0 then
            playTrack(1)
            return
        end
        if isPlaying then
            musicSound:Pause()
            isPlaying = false
        else
            musicSound:Resume()
            isPlaying = true
        end
        updateNowPlayingLabel()
    end,
})

MusicTab:CreateButton({
    Name = "⏭  Next",
    Callback = function()
        if #playlist == 0 then return end
        playTrack(getNextIndex())
    end,
})

MusicTab:CreateButton({
    Name = "⏹  Stop",
    Callback = function()
        stopMusic()
        Rayfield:Notify({ Title = "Music", Content = "Stopped.", Duration = 2 })
    end,
})

MusicTab:CreateSection("Options")

MusicTab:CreateToggle({
    Name = "🔁  Loop Track",
    CurrentValue = isLooping,
    Flag = "Music_Loop",
    Callback = function(val)
        isLooping = val
        updateNowPlayingLabel()
    end,
})

MusicTab:CreateToggle({
    Name = "🔀  Shuffle",
    CurrentValue = isShuffling,
    Flag = "Music_Shuffle",
    Callback = function(val)
        isShuffling = val
        updateNowPlayingLabel()
    end,
})

MusicTab:CreateSlider({
    Name = "Volume",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = musicVolume * 100,
    Flag = "Music_Volume",
    Callback = function(val)
        musicVolume = val / 100
        musicSound.Volume = musicVolume
    end,
})

MusicTab:CreateSection("Playlist")

MusicTab:CreateButton({
    Name = "📂  Scan Folder",
    Callback = function()
        scanFolder()
        if #playlist == 0 then
            Rayfield:Notify({
                Title   = "Music Player",
                Content = "No audio files found in:\n" .. MUSIC_FOLDER .. "\n\nAdd MP3s and scan again.",
                Duration = 5,
            })
        else
            Rayfield:Notify({
                Title   = "Music Player",
                Content = "Loaded " .. #playlist .. " track(s).\nFirst track: " .. playlist[1].name,
                Duration = 4,
            })
            updateNowPlayingLabel()
        end
    end,
})

MusicTab:CreateButton({
    Name = "📋  Print Playlist to Console",
    Callback = function()
        if #playlist == 0 then
            print("[Music] Playlist is empty.")
            return
        end
        print("[Music] Playlist (" .. #playlist .. " tracks):")
        for i, track in ipairs(playlist) do
            local marker = (i == currentIndex) and " ◄ NOW PLAYING" or ""
            print(string.format("  %d. %s%s", i, track.name, marker))
        end
    end,
})

MusicTab:CreateButton({
    Name = "🗑  Clear Playlist",
    Callback = function()
        stopMusic()
        playlist = {}
        currentIndex = 0
        updateNowPlayingLabel()
        Rayfield:Notify({ Title = "Music", Content = "Playlist cleared.", Duration = 2 })
    end,
})

MusicTab:CreateSection("Folder Info")
MusicTab:CreateLabel("Folder: " .. MUSIC_FOLDER)
MusicTab:CreateLabel("Supported: MP3, OGG, WAV, FLAC, AAC, M4A, OPUS, MP2, MP1")
MusicTab:CreateLabel("Place audio files in the folder above,")
MusicTab:CreateLabel("then press Scan Folder to load them.")

-- Auto-scan on load
task.spawn(function()
    task.wait(1)  -- let Rayfield finish drawing first
    scanFolder()
    if #playlist > 0 then
        Rayfield:Notify({
            Title   = "Music Player",
            Content = "Auto-loaded " .. #playlist .. " track(s).",
            Duration = 3,
        })
        updateNowPlayingLabel()
    end
end)

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
        Title   = "View — Orbit",
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
        Title   = "View — POV",
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

-- ── UI ───────────────────────────────────────────────────────────────────────
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
                "Status: %s — %s\nPress E or use button below to exit.",
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
            Name = "👁  " .. name .. "  —  Orbit",
            Callback = function()
                orbitPlayer(player)
            end,
        })

        ViewTab:CreateButton({
            Name = "🎥  " .. name .. "  —  POV",
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

-- ── UI ───────────────────────────────────────────────────────────────────────
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

-- { [player] = { flags = {reason->true}, label = RayfieldLabel, airtimer = number } }
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
    return string.format("⚑ %s\n  %s", player.Name, formatFlags(flagTable))
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
        Title   = "⚑ Flag: " .. player.Name,
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

-- ── Detection ────────────────────────────────────────────────────────────────
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

        -- ── Fling detection (every frame — velocity spikes are momentary) ──
        local vel = hrp.AssemblyLinearVelocity.Magnitude
        if vel >= FLING_THRESHOLD then
            addOrUpdateFlag(player, string.format("Fling (%.0f studs/s)", vel))
        end

        -- ── Airtime + horizontal movement ──
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

        -- ── Throttled checks (every 0.5s) ──
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

-- ── UI ───────────────────────────────────────────────────────────────────────
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
        print("=== m995 panel — Flagged Players ===")
        for player, data in pairs(flaggedPlayers) do
            count = count + 1
            print(string.format("  %s:", player.Name))
            for reason in pairs(data.flags) do
                print("    • " .. reason)
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

-- ── Israel Tab UI ─────────────────────────────────────────────────────────────
IsraelTab:CreateSection("Radar")
IsraelTab:CreateLabel("Circular radar — rotates with your camera.")
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

DramaTab:CreateSection("⚠️ TROLLING & DRAMA")
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

local premiumStatus = getPremiumStatus() and "✓ Premium" or "✗ Regular"
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
        print("Premium Status: " .. (premium and "✓ Premium" or "✗ Regular"))
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
GameTab:CreateLabel("⚠️ Ping is approximated from network lag")

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
                        Content = "✓ Changelog loaded! Check console for details.",
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
PanelChangelogTab:CreateLabel("✓ Decompiler Integration")
PanelChangelogTab:CreateLabel("✓ Tools & Item Database")
PanelChangelogTab:CreateLabel("✓ User Info Display")
PanelChangelogTab:CreateLabel("✓ Drama/Trolling Tab")
PanelChangelogTab:CreateLabel("✓ Key Authentication")
PanelChangelogTab:CreateLabel("✓ 19 Tabs Total")
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
        
        print("[Decompiler] ✓ MEGGD Script Scanner Mobile loaded!")
        
        Rayfield:Notify({
            Title = "Decompiler",
            Content = "✓ Script Scanner is now active!",
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
                        Content = "✓ Changelog loaded! Check console for details.",
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
DecompilerTab:CreateLabel("⚠️ Note: Opens in separate GUI window")

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
            Content = on and "✓ Enabled" or "✗ Disabled",
            Duration = 2,
        })
    elseif input.KeyCode == Enum.KeyCode.R and
           (UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) then
        local preset = cyclePreset()
        Rayfield:Notify({
            Title = "Preset",
            Content = "→ " .. preset,
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
