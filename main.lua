-- ============================================
-- RAKEREMASTERED ULTIMATE QOL SCRIPT v4
-- Fully Toggleable | Mobile Ready | Anti-Detection Basics
-- Features:
-- • Infinite Stamina (toggle)
-- • Smart Auto-Run (avoids all requested obstacles: shop, tower, safe house, broken house, bus, Rake cave, traps)
-- • ESP: Rake, Players, Flares (toggle individually)
-- • Fast Airdrop (toggle)
-- • Bright Mode (toggle)
-- • Stun Stick Aura (auto-hit Rake when close) (toggle)
-- • Remove Wheelchair Barrier (toggle)
-- • Floating menu button (draggable, works on mobile)
-- • Every feature can be turned OFF without rejoining
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
-- CREATE GUI (Mobile & PC)
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main menu frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 500)
frame.Position = UDim2.new(0.5, -140, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ QOL MENU v4 ⚡"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

-- Toggle data
local toggles = {
    InfStamina = {text = "∞ Infinite Stamina", color = Color3.fromRGB(100, 255, 100), enabled = false},
    AutoRun = {text = "🏃 Smart Auto-Run", color = Color3.fromRGB(255, 180, 100), enabled = false},
    ESPHostile = {text = "👹 ESP: Rake", color = Color3.fromRGB(255, 80, 80), enabled = false},
    ESPPlayers = {text = "👤 ESP: Players", color = Color3.fromRGB(100, 200, 255), enabled = false},
    ESPFlare = {text = "✨ ESP: Flares", color = Color3.fromRGB(255, 255, 100), enabled = false},
    FastAirdrop = {text = "📦 Fast Airdrop", color = Color3.fromRGB(200, 100, 255), enabled = false},
    BrightMode = {text = "☀️ Bright Mode", color = Color3.fromRGB(255, 255, 0), enabled = false},
    StunAura = {text = "⚡ Stun Stick Aura", color = Color3.fromRGB(0, 200, 255), enabled = false},
    RemoveBarrier = {text = "♿ Remove Wheelchair Barrier", color = Color3.fromRGB(255, 150, 200), enabled = false}
}

-- Connections and loop flags for cleanup
local connections = {}
local loopFlags = {}

-- Create toggle buttons
local yPos = 35
for name, data in pairs(toggles) do
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = "⬜ " .. data.text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = frame
    
    btn.MouseButton1Click:Connect(function()
        data.enabled = not data.enabled
        if data.enabled then
            btn.Text = "✅ " .. data.text
            btn.BackgroundColor3 = data.color
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            btn.Text = "⬜ " .. data.text
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        end
        
        -- Trigger feature (toggle on/off)
        if name == "InfStamina" then
            toggleInfStamina(data.enabled)
        elseif name == "AutoRun" then
            toggleAutoRun(data.enabled)
        elseif name == "ESPHostile" or name == "ESPPlayers" or name == "ESPFlare" then
            updateESP()
        elseif name == "FastAirdrop" then
            toggleFastAirdrop(data.enabled)
        elseif name == "BrightMode" then
            toggleBrightMode(data.enabled)
        elseif name == "StunAura" then
            toggleStunAura(data.enabled)
        elseif name == "RemoveBarrier" then
            toggleRemoveBarrier(data.enabled)
        end
    end)
    
    yPos = yPos + 38
end

-- Floating menu button (for mobile)
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

menuButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Also allow RightCtrl on PC
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)

-- ============================================
-- FEATURE 1: INFINITE STAMINA
-- ============================================
local staminaLoop
function toggleInfStamina(enabled)
    if staminaLoop then staminaLoop:Disconnect() end
    if enabled then
        staminaLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if not toggles.InfStamina.enabled then return end
            pcall(function()
                humanoid:SetAttribute("Stamina", 100)
                humanoid:SetAttribute("stamina", 100)
                humanoid:SetAttribute("StaminaValue", 100)
            end)
        end)
    end
end

-- ============================================
-- FEATURE 2: SMART AUTO-RUN WITH COMPLETE OBSTACLE AVOIDANCE
-- ============================================
local DANGEROUS_OBJECTS = {
    "shop", "wall", "tower", "safe house", "safehouse", "broken house", "bus", "broken bus",
    "rake cave", "cave", "middle cave",
    "trap", "bear trap", "spike", "pit", "hole",
    "basement", "power station", "well", "shack"
}

local runConnection
function toggleAutoRun(enabled)
    if runConnection then runConnection:Disconnect() end
    if enabled then
        runConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not toggles.AutoRun.enabled then return end
            
            local rake = nil
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("rake") and obj:IsA("Model") and obj.PrimaryPart then
                    rake = obj
                    break
                end
            end
            
            if rake and rake.PrimaryPart and character and character.PrimaryPart then
                local myPos = character.PrimaryPart.Position
                local rakePos = rake.PrimaryPart.Position
                local distance = (myPos - rakePos).Magnitude
                
                if distance < 60 then
                    local awayDir = (myPos - rakePos).Unit
                    local safeDir = findSafestDirection(myPos, awayDir)
                    humanoid:Move(safeDir, true)
                    humanoid.WalkSpeed = 24
                else
                    humanoid.WalkSpeed = 16
                end
            end
        end)
    else
        humanoid.WalkSpeed = 16
    end
end

function findSafestDirection(startPos, preferredDir)
    local checkDist = 20
    local results = {}
    
    local prefDanger = checkDirectionForDanger(startPos, preferredDir, checkDist)
    if not prefDanger then
        return preferredDir
    end
    
    local angles = {0, 45, 90, 135, 180, 225, 270, 315}
    for _, angle in ipairs(angles) do
        local rad = math.rad(angle)
        local dir = Vector3.new(math.cos(rad), 0, math.sin(rad))
        local isDanger = checkDirectionForDanger(startPos, dir, checkDist)
        local distance = isDanger and 0 or checkDist
        table.insert(results, {dir = dir, isDanger = isDanger, distance = distance})
    end
    
    table.sort(results, function(a, b)
        if a.isDanger ~= b.isDanger then
            return not a.isDanger
        end
        return a.distance > b.distance
    end)
    
    return results[1].dir
end

function checkDirectionForDanger(start, dir, distance)
    local ray = Ray.new(start + Vector3.new(0, 2, 0), dir * distance)
    local part, pos = workspace:FindPartOnRay(ray, character)
    if part then
        local name = part.Name:lower()
        local parentName = part.Parent and part.Parent.Name:lower() or ""
        local fullName = name .. " " .. parentName
        for _, danger in ipairs(DANGEROUS_OBJECTS) do
            if fullName:find(danger) then
                return true
            end
        end
    end
    return part ~= nil
end

-- ============================================
-- FEATURE 3,4,5: ESP SYSTEM
-- ============================================
local espObjects = {}
local espUpdateLoop

function createESP(part, color, text)
    if not part or not part.Parent then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..tostring(math.random(1, 999999))
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = part
    billboard.Parent = part
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.3
    frame.BackgroundColor3 = color
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 0, 0.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.Parent = frame
    
    table.insert(espObjects, billboard)
end

function updateESP()
    -- Clean up old ESP
    for _, esp in ipairs(espObjects) do
        pcall(function() esp:Destroy() end)
    end
    espObjects = {}
    
    if toggles.ESPHostile.enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("rake") and obj:IsA("Model") and obj.PrimaryPart then
                createESP(obj.PrimaryPart, Color3.fromRGB(255, 0, 0), "👹 RAKE")
            end
        end
    end
    
    if toggles.ESPPlayers.enabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character.PrimaryPart then
                local teamColor = plr.TeamColor.Color or Color3.fromRGB(0, 255, 0)
                createESP(plr.Character.PrimaryPart, teamColor, "👤 "..plr.Name)
            end
        end
    end
    
    if toggles.ESPFlare.enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("flare") and obj:IsA("BasePart") then
                createESP(obj, Color3.fromRGB(255, 255, 0), "✨ FLARE")
            end
        end
    end
end

-- Periodic ESP update
if espUpdateLoop then espUpdateLoop:Disconnect() end
espUpdateLoop = game:GetService("RunService").Heartbeat:Connect(function()
    -- Only update occasionally to save performance
    if not espUpdateTimer or tick() - espUpdateTimer > 1 then
        espUpdateTimer = tick()
        updateESP()
    end
end)

workspace.DescendantAdded:Connect(function()
    task.wait(0.2)
    updateESP()
end)

-- ============================================
-- FEATURE 6: FAST AIRDROP
-- ============================================
local airdropLoop
function toggleFastAirdrop(enabled)
    if airdropLoop then airdropLoop:Disconnect() end
    if enabled then
        airdropLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if not toggles.FastAirdrop.enabled then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("airdrop") or obj.Name:lower():find("crate") then
                    pcall(function()
                        if obj:FindFirstChild("ClickDetector") then
                            obj.ClickDetector.MaxActivationDistance = 50
                        end
                        if obj:FindFirstChild("Timer") then
                            obj.Timer.Value = 0.1
                        end
                    end)
                end
            end
        end)
    end
end

-- ============================================
-- FEATURE 7: BRIGHT MODE
-- ============================================
function toggleBrightMode(enabled)
    if enabled then
        game.Lighting.Brightness = 3
        game.Lighting.Ambient = Color3.fromRGB(150, 150, 150)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
        game.Lighting.ClockTime = 12
        camera.FieldOfView = 90
    else
        game.Lighting.Brightness = 1
        game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        game.Lighting.ClockTime = -1 -- reset to default
        camera.FieldOfView = 70
    end
end

-- ============================================
-- FEATURE 8: STUN STICK AURA
-- ============================================
local stunConnection
function toggleStunAura(enabled)
    if stunConnection then stunConnection:Disconnect() end
    if enabled then
        stunConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not toggles.StunAura.enabled then return end
            
            local rake = nil
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("rake") and obj:IsA("Model") and obj.PrimaryPart then
                    rake = obj
                    break
                end
            end
            
            if rake and rake.PrimaryPart and character and character.PrimaryPart then
                local distance = (rake.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
                if distance < 8 then
                    -- Find stun stick
                    local stunStick = nil
                    for _, tool in pairs(player.Backpack:GetChildren()) do
                        if tool.Name:lower():find("stun") or tool.Name:lower():find("stick") then
                            stunStick = tool
                            break
                        end
                    end
                    if not stunStick and character:FindFirstChildOfClass("Tool") then
                        local equipped = character:FindFirstChildOfClass("Tool")
                        if equipped.Name:lower():find("stun") or equipped.Name:lower():find("stick") then
                            stunStick = equipped
                        end
                    end
                    if stunStick then
                        stunStick:Activate()
                        -- Visual effect
                        if not character:FindFirstChild("StunAuraEffect") then
                            local effect = Instance.new("SelectionBox")
                            effect.Name = "StunAuraEffect"
                            effect.Adornee = character.PrimaryPart
                            effect.Color3 = Color3.fromRGB(0, 200, 255)
                            effect.LineThickness = 0.1
                            effect.Parent = character
                            game:GetService("Debris"):AddItem(effect, 0.3)
                        end
                    end
                end
            end
        end)
    end
end

-- ============================================
-- FEATURE 9: REMOVE WHEELCHAIR BARRIER
-- ============================================
local barrierLoop
function toggleRemoveBarrier(enabled)
    if barrierLoop then barrierLoop:Disconnect() end
    if enabled then
        -- Immediate cleanup
        for _, obj in pairs(workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if (name:find("wheelchair") or name:find("barrier") or name:find("ramp")) and obj:IsA("BasePart") then
                pcall(function()
                    obj.CanCollide = false
                    obj.Transparency = 1
                end)
            end
        end
        
        -- Continuous cleanup
        barrierLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if not toggles.RemoveBarrier.enabled then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if (name:find("wheelchair") or name:find("barrier") or name:find("ramp")) and obj:IsA("BasePart") then
                    pcall(function()
                        obj.CanCollide = false
                        obj.Transparency = 1
                    end)
                end
            end
        end)
    end
end

-- ============================================
-- CHARACTER RESPAWN HANDLING
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    updateESP()
    -- Re-enable features that need reinitialization
    if toggles.InfStamina.enabled then
        toggleInfStamina(true)
    end
    if toggles.AutoRun.enabled then
        toggleAutoRun(true)
    end
    if toggles.StunAura.enabled then
        toggleStunAura(true)
    end
    if toggles.RemoveBarrier.enabled then
        toggleRemoveBarrier(true)
    end
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ QOL v4 Loaded",
    Text = "Tap red button or press RightCtrl",
    Duration = 4
})
