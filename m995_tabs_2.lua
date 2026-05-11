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
        print("=== m995 panel - Player Info ===")
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

-- -- Helpers -----------------------------------------------------------------
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
        nowPlayingLabel:Set(string.format("📝 %s", track.name))
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
    index = ((index — 1) % #playlist) + 1  -- wrap around
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

-- -- UI -----------------------------------------------------------------------
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
            local marker = (i == currentIndex) and " < NOW PLAYING" or ""
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

