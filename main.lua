-- ============================================
-- RAKEREMASTERED QOL SCRIPT v15
-- Compatible with game version 3.0.0
-- All features: Stamina, Auto-Run w/ distance slider,
-- ESP (Rake/Players/Flares/Traps) with Blood Hour override,
-- Fast Airdrop, Remove Wheelchair Barrier, Bright Mode,
-- Performance Mode, Third Person, Blood Hour detection,
-- Customizable rounded menu (black/white themes)
-- ============================================

-- Anti-detection: randomize GUI names
local guiName = "RakeQOL_" .. math.random(1000, 9999)
local buttonName = "MenuButton_" .. math.random(1000, 9999)

-- Wait for player
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- ============================================
-- RAKE FINDER (v3.0.0)
-- ============================================
local function findRake()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("rake") then
            -- Check for primary part or any base part
            if obj.PrimaryPart then return obj end
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then return obj end
            end
        end
    end
    return nil
end

local function getRakePart(rake)
    if rake.PrimaryPart then return rake.PrimaryPart end
    for _, part in pairs(rake:GetDescendants()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end

-- ============================================
-- THEME SYSTEM
-- ============================================
local themes = {
    Black = {
        bg = Color3.fromRGB(20, 20, 20),
        bg2 = Color3.fromRGB(40, 40, 40),
        text = Color3.fromRGB(220, 220, 220),
        title = Color3.fromRGB(255, 100, 100),
        button = Color3.fromRGB(50, 50, 50),
        slider = Color3.fromRGB(100, 200, 255)
    },
    White = {
        bg = Color3.fromRGB(240, 240, 240),
        bg2 = Color3.fromRGB(220, 220, 220),
        text = Color3.fromRGB(20, 20, 20),
        title = Color3.fromRGB(200, 50, 50),
        button = Color3.fromRGB(200, 200, 200),
        slider = Color3.fromRGB(0, 120, 255)
    }
}
local currentTheme = "Black"

-- ============================================
-- GUI CONSTRUCTION (Mobile & PC)
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 750)
frame.Position = UDim2.new(0.5, -200, 0.5, -375)
frame.BackgroundColor3 = themes.Black.bg
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = themes.Black.bg2
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar
titleBar.ClipsDescendants = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 40, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Rake QOL v15 ⚡"
title.TextColor3 = themes.Black.title
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

-- Lock button
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 30, 1, 0)
lockBtn.Position = UDim2.new(0, 0, 0, 0)
lockBtn.BackgroundTransparency = 0.5
lockBtn.Text = "🔓"
lockBtn.TextColor3 = themes.Black.text
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 16
lockBtn.Parent = titleBar
local locked = false
lockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    frame.Draggable = not locked
    lockBtn.Text = locked and "🔒" or "🔓"
end)

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(0, 30, 0, 0)
minimizeBtn.BackgroundTransparency = 0.5
minimizeBtn.Text = "🗕"
minimizeBtn.TextColor3 = themes.Black.text
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = titleBar
minimizeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = themes.Black.text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

-- ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -35)
scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = scrollingFrame

-- Helper functions for UI
local function createCategory(titleText)
    local catFrame = Instance.new("Frame")
    catFrame.Size = UDim2.new(1, -10, 0, 25)
    catFrame.BackgroundColor3 = themes.Black.bg2
    catFrame.BorderSizePixel = 0
    catFrame.Parent = scrollingFrame
    local catCorner = Instance.new("UICorner")
    catCorner.CornerRadius = UDim.new(0, 8)
    catCorner.Parent = catFrame
    local catLabel = Instance.new("TextLabel")
    catLabel.Size = UDim2.new(1, -5, 1, 0)
    catLabel.Position = UDim2.new(0, 5, 0, 0)
    catLabel.BackgroundTransparency = 1
    catLabel.Text = titleText
    catLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    catLabel.Font = Enum.Font.GothamBold
    catLabel.TextSize = 14
    catLabel.TextXAlignment = Enum.TextXAlignment.Left
    catLabel.Parent = catFrame
end

local function createToggle(name, displayText, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = themes.Black.button
    btn.Text = "⬜ " .. displayText
    btn.TextColor3 = themes.Black.text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = scrollingFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = "✅ " .. displayText
            btn.BackgroundColor3 = color
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            btn.Text = "⬜ " .. displayText
            btn.BackgroundColor3 = themes.Black.button
            btn.TextColor3 = themes.Black.text
        end
        callback(enabled)
    end)
end

local function createSlider(name, displayText, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 50)
    container.BackgroundColor3 = themes.Black.bg2
    container.BorderSizePixel = 0
    container.Parent = scrollingFrame
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = displayText .. ": " .. defaultVal
    label.TextColor3 = themes.Black.text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 10)
    slider.Position = UDim2.new(0, 10, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    slider.BorderSizePixel = 0
    slider.Parent = container
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = themes.Black.slider
    fill.BorderSizePixel = 0
    fill.Parent = slider
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local drag = Instance.new("TextButton")
    drag.Size = UDim2.new(0, 20, 0, 20)
    drag.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -10, 0.5, -10)
    drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    drag.Text = ""
    drag.Parent = container
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(1, 0)
    dragCorner.Parent = drag

    local dragging = false
    drag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    drag.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position.X - slider.AbsolutePosition.X
            local perc = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
            local val = minVal + (maxVal - minVal) * perc
            val = math.floor(val * 10) / 10
            fill.Size = UDim2.new(perc, 0, 1, 0)
            drag.Position = UDim2.new(perc, -10, 0.5, -10)
            label.Text = displayText .. ": " .. val
            callback(val)
        end
    end)
end

-- ============================================
-- FEATURE TOGGLES & SETTINGS
-- ============================================
local features = {}
local settings = {
    autoRunDistance = 60,
    bloodHourBrightness = 5,
    theme = "Black"
}

-- Theme selection
createCategory("🎨 THEME")
local function setTheme(themeName)
    currentTheme = themeName
    local t = themes[themeName]
    frame.BackgroundColor3 = t.bg
    titleBar.BackgroundColor3 = t.bg2
    title.TextColor3 = t.title
    lockBtn.TextColor3 = t.text
    minimizeBtn.TextColor3 = t.text
    closeBtn.TextColor3 = t.text
    -- Update all toggles/sliders? For simplicity we'll just update the global colors; toggles will be recreated on theme change? 
    -- We'll not implement full dynamic update to keep it simple; user can re-open menu.
end
createToggle("ThemeBlack", " Black Theme", Color3.fromRGB(20,20,20), function(e) if e then setTheme("Black") end end)
createToggle("ThemeWhite", " White Theme", Color3.fromRGB(240,240,240), function(e) if e then setTheme("White") end end)

-- Player
createCategory("👤 PLAYER")
createToggle("InfStamina", "∞ Infinite Stamina", Color3.fromRGB(100, 255, 100), function(e) features.InfStamina = e end)
createToggle("StunAura", "⚡ Stun Stick Aura", Color3.fromRGB(0, 200, 255), function(e) features.StunAura = e end)

-- Auto Run
createCategory("🏃 AUTO RUN")
createToggle("AutoRun", "Smart Auto-Run", Color3.fromRGB(255, 180, 100), function(e) features.AutoRun = e end)
createSlider("AutoRunDist", "Auto-Run Distance", 10, 100, 60, function(val) settings.autoRunDistance = val end)

-- ESP
createCategory("👁️ ESP")
createToggle("ESPRake", "👹 Rake (red outline)", Color3.fromRGB(255, 80, 80), function(e) features.ESPRake = e; updateESP() end)
createToggle("ESPPlayers", "👤 Players (blue outline)", Color3.fromRGB(100, 200, 255), function(e) features.ESPPlayers = e; updateESP() end)
createToggle("ESPFlares", "✨ Flares/Scraps (yellow)", Color3.fromRGB(255, 255, 100), function(e) features.ESPFlares = e; updateESP() end)
createToggle("ESPTraps", "⚠️ Traps (red outline)", Color3.fromRGB(255, 100, 100), function(e) features.ESPTraps = e; updateESP() end)

-- World
createCategory("🌍 WORLD")
createToggle("FastAirdrop", "📦 Fast Airdrop", Color3.fromRGB(200, 100, 255), function(e) features.FastAirdrop = e end)
createToggle("RemoveBarrier", "♿ Remove Wheelchair Barrier", Color3.fromRGB(255, 150, 200), function(e) features.RemoveBarrier = e end)
createToggle("BrightMode", "☀️ Full Bright (always)", Color3.fromRGB(255, 255, 0), function(e) features.BrightMode = e; toggleBrightMode(e) end)
createToggle("PerformanceMode", "⚡ Performance Mode", Color3.fromRGB(150, 150, 255), function(e) features.PerformanceMode = e; togglePerformanceMode(e) end)
createToggle("ThirdPerson", "🎥 Third Person", Color3.fromRGB(180, 130, 255), function(e) features.ThirdPerson = e; toggleThirdPerson(e) end)

-- Blood Hour
createCategory("🩸 BLOOD HOUR")
createToggle("BloodHourVision", "🩸 Blood Hour Vision", Color3.fromRGB(255, 50, 50), function(e) features.BloodHourVision = e; initBloodHourDetection() end)
createSlider("BloodHourBright", "Blood Hour Brightness", 1, 10, 5, function(val) settings.bloodHourBrightness = val end)
createToggle("BloodHourSpeed", "⚡ Blood Hour Speed Boost", Color3.fromRGB(255, 100, 100), function(e) features.BloodHourSpeed = e end)

scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

-- Floating menu button
local menuButton = Instance.new("TextButton")
menuButton.Name = buttonName
menuButton.Size = UDim2.new(0, 60, 0, 60)
menuButton.Position = UDim2.new(0, 20, 0.8, -30)
menuButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
menuButton.BackgroundTransparency = 0.2
menuButton.Text = "⚡"
menuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
menuButton.Font = Enum.Font.GothamBold
menuButton.TextSize = 30
menuButton.Draggable = true
menuButton.Parent = screenGui
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = menuButton

menuButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)

-- ============================================
-- FEATURE IMPLEMENTATIONS
-- ============================================

-- Blood Hour Detection
local bloodHourActive = false
local bloodHourConnection
local originalLighting = {}

function initBloodHourDetection()
    if bloodHourConnection then bloodHourConnection:Disconnect() end
    bloodHourConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not features.BloodHourVision then return end
        -- Detect based on ambient color and brightness
        local ambient = game:GetService("Lighting").Ambient
        local brightness = game:GetService("Lighting").Brightness
        local isBloodHour = (ambient.r > 0.5 and ambient.g < 0.3 and ambient.b < 0.3) or brightness < 0.5
        -- Check chat
        if not isBloodHour then
            for _, msg in pairs(workspace:FindFirstChild("Chat") or {}) do
                if msg:IsA("Message") and msg.Text:lower():find("blood hour") then
                    isBloodHour = true
                    break
                end
            end
        end
        
        if isBloodHour and not bloodHourActive then
            bloodHourActive = true
            onBloodHourStart()
        elseif not isBloodHour and bloodHourActive then
            bloodHourActive = false
            onBloodHourEnd()
        end
    end)
end

function onBloodHourStart()
    originalLighting = {
        Brightness = game.Lighting.Brightness,
        Ambient = game.Lighting.Ambient,
        ClockTime = game.Lighting.ClockTime,
        FogEnd = game.Lighting.FogEnd,
        GlobalShadows = game.Lighting.GlobalShadows
    }
    game.Lighting.Brightness = settings.bloodHourBrightness
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.ClockTime = 12
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
    if features.BloodHourSpeed and humanoid then
        humanoid.WalkSpeed = 24
    end
    updateESP(true)  -- white override
end

function onBloodHourEnd()
    if not features.BrightMode then
        game.Lighting.Brightness = originalLighting.Brightness or 1
        game.Lighting.Ambient = originalLighting.Ambient or Color3.new(0,0,0)
        game.Lighting.ClockTime = originalLighting.ClockTime or -1
        game.Lighting.FogEnd = originalLighting.FogEnd or 100000
        game.Lighting.GlobalShadows = originalLighting.GlobalShadows
    end
    if features.BloodHourSpeed and humanoid then
        humanoid.WalkSpeed = 16
    end
    updateESP()
end

-- Infinite Stamina
function toggleInfStamina(enabled) features.InfStamina = enabled end

-- Stun Aura
function toggleStunAura(enabled) features.StunAura = enabled end

-- Auto Run (smart)
function toggleAutoRun(enabled) features.AutoRun = enabled end

-- Fast Airdrop
function toggleFastAirdrop(enabled) features.FastAirdrop = enabled end

-- Remove Barrier
function toggleRemoveBarrier(enabled) features.RemoveBarrier = enabled end

-- Bright Mode
function toggleBrightMode(enabled)
    if enabled then
        game.Lighting.Brightness = 3
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
        camera.FieldOfView = 90
    else
        game.Lighting.Brightness = 1
        game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        game.Lighting.ClockTime = -1
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = true
        camera.FieldOfView = 70
    end
end

-- Performance Mode
function togglePerformanceMode(enabled)
    if enabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
        game.Lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = 1
    else
        game.Lighting.GlobalShadows = true
        settings().Rendering.QualityLevel = 5
    end
end

-- Third Person
local thirdPersonConnection
function toggleThirdPerson(enabled)
    if thirdPersonConnection then thirdPersonConnection:Disconnect() end
    if enabled then
        camera.CameraType = Enum.CameraType.Custom
        thirdPersonConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not features.ThirdPerson or not character or not character.PrimaryPart then return end
            local charPos = character.PrimaryPart.Position
            local offset = character.PrimaryPart.CFrame.LookVector * -8 + Vector3.new(0, 3, 0)
            camera.CFrame = CFrame.new(charPos + offset, charPos)
        end)
    else
        camera.CameraType = Enum.CameraType.Custom
    end
end

-- ESP System
local espObjects = {}
local function createESP(part, color, text, isBloodHourOverride)
    if not part or not part.Parent th
