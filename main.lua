-- VX9X Script Fixed
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Простое GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleAimbot = Instance.new("TextButton")
local ToggleESP = Instance.new("TextButton")
local ToggleSpeed = Instance.new("TextButton")
local SliderSpeed = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "VX9X_HUB"

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

ToggleAimbot.Parent = Frame
ToggleAimbot.Size = UDim2.new(0.9, 0, 0, 30)
ToggleAimbot.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleAimbot.Text = "Aimbot: OFF"
ToggleAimbot.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

ToggleESP.Parent = Frame
ToggleESP.Size = UDim2.new(0.9, 0, 0, 30)
ToggleESP.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleESP.Text = "ESP: OFF"
ToggleESP.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

ToggleSpeed.Parent = Frame
ToggleSpeed.Size = UDim2.new(0.9, 0, 0, 30)
ToggleSpeed.Position = UDim2.new(0.05, 0, 0.45, 0)
ToggleSpeed.Text = "Speed: OFF (16)"
ToggleSpeed.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

SliderSpeed.Parent = Frame
SliderSpeed.Size = UDim2.new(0.9, 0, 0, 30)
SliderSpeed.Position = UDim2.new(0.05, 0, 0.65, 0)
SliderSpeed.Text = "Speed Value: 50"
SliderSpeed.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Variables
_G.AimbotEnabled = false
_G.ESPEnabled = false
_G.SpeedEnabled = false
_G.SpeedValue = 50
_G.AimbotKey = Enum.KeyCode.E
_G.AimbotFOV = 100

-- Functions
function GetClosestPlayer()
    if not _G.AimbotEnabled then return nil end
    local closestPlayer = nil
    local shortestDistance = _G.AimbotFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if distance < shortestDistance and onScreen then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

-- Toggle Actions
ToggleAimbot.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    ToggleAimbot.Text = "Aimbot: " .. (_G.AimbotEnabled and "ON (E)" or "OFF")
    ToggleAimbot.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
end)

ToggleESP.MouseButton1Click:Connect(function()
    _G.ESPEnabled = not _G.ESPEnabled
    ToggleESP.Text = "ESP: " .. (_G.ESPEnabled and "ON" or "OFF")
    ToggleESP.BackgroundColor3 = _G.ESPEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 60, 60)
    if not _G.ESPEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local highlight = v.Character:FindFirstChildOfClass("Highlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

ToggleSpeed.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    ToggleSpeed.Text = "Speed: " .. (_G.SpeedEnabled and "ON (".. _G.SpeedValue ..")" or "OFF (16)")
    ToggleSpeed.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
end)

SliderSpeed.MouseButton1Click:Connect(function()
    _G.SpeedValue = _G.SpeedValue + 10
    if _G.SpeedValue > 200 then _G.SpeedValue = 16 end
    SliderSpeed.Text = "Speed Value: " .. _G.SpeedValue
    if _G.SpeedEnabled then
        ToggleSpeed.Text = "Speed: ON (".. _G.SpeedValue ..")"
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if _G.AimbotEnabled and UserInputService:IsKeyDown(_G.AimbotKey) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character.HumanoidRootPart then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end

    -- ESP
    if _G.ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = player.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end

    -- Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.SpeedEnabled and _G.SpeedValue or 16
    end
end)

print("Скрипт VX9X загружен. Выживаем.")
