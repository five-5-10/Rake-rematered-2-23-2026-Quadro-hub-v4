-- ============================================
-- RAKEREMASTERED QOL SCRIPT v16
-- Sidebar Categories | All Features | Mobile Ready
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
-- RAKE FINDER
-- ============================================
local function findRake()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("rake") then
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
-- GUI CONSTRUCTION
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 400)
frame.Position = UDim2.new(0.5, -250, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar
titleBar.ClipsDescendants = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 40, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Rake QOL v16 ⚡"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

-- Lock button
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 30, 1, 0)
lockBtn.Position = UDim2.new(0, 0, 0, 0)
lockBtn.BackgroundTransparency = 0.5
lockBtn.Text = "🔓"
lockBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
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
minimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
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
closeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

-- Sidebar (categories)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame
local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = sidebar

-- Category buttons list
local categoryList = Instance.new("ScrollingFrame")
categoryList.Size = UDim2.new(1, 0, 1, 0)
categoryList.BackgroundTransparency = 1
categoryList.BorderSizePixel = 0
categoryList.ScrollBarThickness = 4
categoryList.CanvasSize = UDim2.new(0, 0, 0, 0)
categoryList.Parent = sidebar

local categoryLayout = Instance.new("UIListLayout")
categoryLayout.Padding = UDim.new(0, 5)
categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
categoryLayout.Parent = categoryList

-- Content area (features)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -105, 1, -30)
content.Position = UDim2.new(0, 105, 0, 30)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
content.BorderSizePixel = 0
content.Parent = frame
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = content

local contentList = Instance.new("ScrollingFrame")
contentList.Size = UDim2.new(1, -10, 1, -10)
contentList.Position = UDim2.new(0, 5, 0, 5)
contentList.BackgroundTransparency = 1
contentList.BorderSizePixel = 0
contentList.ScrollBarThickness = 6
contentList.CanvasSize = UDim2.new(0, 0, 0, 0)
contentList.Parent = content

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 5)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentList

-- ============================================
-- FEATURE DATA
-- ============================================
local features = {}
local settings = {
    autoRunDistance = 60,
    bloodHourBrightness = 5
}

-- Define categories and their features
local categories = {
    {
        name = "👤 Player",
        features = {
            {type="toggle", name="InfStamina", text="∞ Infinite Stamina", color=Color3.fromRGB(100,255,100), callback=function(e) features.InfStamina=e end},
            {type="toggle", name="StunAura", text="⚡ Stun Stick Aura", color=Color3.fromRGB(0,200,255), callback=function(e) features.StunAura=e end}
        }
    },
    {
        name = "🏃 Auto Run",
        features = {
            {type="toggle", name="AutoRun", text="Smart Auto-Run", color=Color3.fromRGB(255,180,100), callback=function(e) features.AutoRun=e end},
            {type="slider", name="AutoRunDist", text="Auto-Run Distance", min=10, max=100, default=60, callback=function(v) settings.autoRunDistance=v end}
        }
    },
    {
        name = "👁️ ESP",
        features = {
            {type="toggle", name="ESPRake", text="👹 Rake (red)", color=Color3.fromRGB(255,80,80), callback=function(e) features.ESPRake=e; updateESP() end},
            {type="toggle", name="ESPPlayers", text="👤 Players (blue)", color=Color3.fromRGB(100,200,255), callback=function(e) features.ESPPlayers=e; updateESP() end},
            {type="toggle", name="ESPFlares", text="✨ Flares (yellow)", color=Color3.fromRGB(255,255,100), callback=function(e) features.ESPFlares=e; updateESP() end},
            {type="toggle", name="ESPTraps", text="⚠️ Traps (red)", color=Color3.fromRGB(255,100,100), callback=function(e) features.ESPTraps=e; updateESP() end}
        }
    },
    {
        name = "🌍 World",
        features = {
            {type="toggle", name="FastAirdrop", text="📦 Fast Airdrop", color=Color3.fromRGB(200,100,255), callback=function(e) features.FastAirdrop=e end},
            {type="toggle", name="RemoveBarrier", text="♿ Remove Barrier", color=Color3.fromRGB(255,150,200), callback=function(e) features.RemoveBarrier=e end},
            {type="toggle", name="BrightMode", text="☀️ Full Bright", color=Color3.fromRGB(255,255,0), callback=function(e) features.BrightMode=e; toggleBrightMode(e) end},
            {type="toggle", name="PerformanceMode", text="⚡ Performance", color=Color3.fromRGB(150,150,255), callback=function(e) features.PerformanceMode=e; togglePerformanceMode(e) end},
            {type="toggle", name="ThirdPerson", text="🎥 Third Person", color=Color3.fromRGB(180,130,255), callback=function(e) features.ThirdPerson=e; toggleThirdPerson(e) end}
        }
    },
    {
        name = "🩸 Blood Hour",
        features = {
            {type="toggle", name="BloodHourVision", text="🩸 Blood Hour Vision", color=Color3.fromRGB(255,50,50), callback=function(e) features.BloodHourVision=e; initBloodHourDetection() end},
            {type="slider", name="BloodHourBright", text="Brightness", min=1, max=10, default=5, callback=function(v) settings.bloodHourBrightness=v end},
            {type="toggle", name="BloodHourSpeed", text="⚡ Speed Boost", color=Color3.fromRGB(255,100,100), callback=function(e) features.BloodHourSpeed=e end}
        }
    }
}

-- Helper to create toggle buttons in content area
local function createToggleButton(data)
    local btn = Instance.new("TextButton")
    btn.Name = data.name
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = "⬜ " .. data.text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = contentList
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = "✅ " .. data.text
            btn.BackgroundColor3 = data.color
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            btn.Text = "⬜ " .. data.text
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        end
        data.callback(enabled)
    end)
end

-- Helper to create slider
local function createSlider(data)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    container.BorderSizePixel = 0
    container.Parent = contentList
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = data.text .. ": " .. data.default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
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
    fill.Size = UDim2.new((data.default - data.min) / (data.max - data.min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local drag = Instance.new("TextButton")
    drag.Size = UDim2.new(0, 20, 0, 20)
    drag.Position = UDim2.new((data.default - data.min) / (data.max - data.min), -10, 0.5, -10)
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
            local val = data.min + (data.max - data.min) * perc
            val = math.floor(val * 10) / 10
            fill.Size = UDim2.new(perc, 0, 1, 0)
            drag.Position = UDim2.new(perc, -10, 0.5, -10)
            label.Text = data.text .. ": " .. val
            data.callback(val)
        end
    end)
end

-- Populate category buttons
for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = cat.name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = categoryList
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        -- Clear content
        for _, child in ipairs(contentList:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then
                child:Destroy()
            end
        end
        -- Populate with features
        for _, feat in ipairs(cat.features) do
            if feat.type == "toggle" then
                createToggleButton(feat)
            elseif feat.type == "slider" then
                createSlider(feat)
            end
        end
        -- Update canvas size
        contentList.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
end

categoryList.CanvasSize = UDim2.new(0, 0, 0, categoryLayout.AbsoluteContentSize.Y + 10)

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
-- FEATURE IMPLEMENTATIONS (abbreviated for space)
-- (All functions from v15 are included here)
-- ============================================
-- Blood Hour Detection
local bloodHourActive = false
local bloodHourConnection
local originalLighting = {}

function initBloodHourDetection()
    if bloodHourConnection then bloodHourConnection:Disconnect() end
    bloodHourConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not features.BloodHourVision then return end
        local ambient = game:GetService("Lighting").Ambient
        local brightness = game:GetService("Lighting").Brightness
        local isBloodHour = (ambient.r > 0.5 and ambient.g < 0.3 and ambient.b < 0.3) or brightness < 0.5
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
    updateESP(true)
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

-- Bright Mode
function toggleBrightMode(enabled)
    if enabled then
        game.Lighting.Brightness = 3
        game.Lighting.Ambient = Color3.fromRGB(255,255,255)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
        camera.FieldOfView = 90
    else
        game.Lighting.Brightness = 1
        game.Lighting.Ambient = Color3.fromRGB(0,0,0)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
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
            local offset = character.PrimaryPart.CFrame.LookVector * -8 + Vector3.new(0,3,0)
            camera.CFrame = CFrame.new(charPos + offset, charPos)
        end)
    else
        camera.CameraType = Enum.CameraType.Custom
    end
end

-- ESP System
local espObjects = {}
local function createESP(part, color, text, isBloodHourOv
