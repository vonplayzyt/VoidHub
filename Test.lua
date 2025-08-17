-- FULL VOID SCRIPTS — with rainbow outline + notifications + Jump Boost
-- Panel size can be changed at the top:
local PANEL_WIDTH = 200 -- width in pixels
local PANEL_HEIGHT = 212 -- height in pixels

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Helpers
local function rainbowColor(t)
return Color3.fromHSV((t * 0.5) % 1, 0.8, 1)
end

local function createRainbowStroke(parent, thickness)
thickness = thickness or 2
local stroke = Instance.new("UIStroke")
stroke.Thickness = thickness
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = parent
task.spawn(function()
local t = 0
while parent and parent.Parent do
t += task.wait()
stroke.Color = rainbowColor(t)
end
end)
return stroke
end

local function safeNotify(title, text, dur)
pcall(function()
StarterGui:SetCore("SendNotification", {Title = title or "Notice", Text = text or "", Duration = dur or 3})
end)
end

local function createSound(id, parent)
local s = Instance.new("Sound")
s.SoundId = "rbxassetid://" .. tostring(id)
s.Volume = 1
s.Parent = parent or CoreGui
return s
end

-- Main UI and features
local function loadVoidScripts()
-- State variables
local camlockOn, speedOn, hitboxOn, infJumpOn, jumpBoostOn = false, false, false, false, false
local camTarget, speedValue, hitboxSize, jumpBoostValue = nil, 16, 5, 50
local prediction = 0.13
local originalProps = {}
local sessionStart = tick()
local defaultJumpPower = lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.JumpPower or 50

-- GUI root
local gui = Instance.new("ScreenGui")
gui.Name = "VoidScriptsGUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- Sounds
local clickSound = createSound(1837635154, gui)
local voidCamOnSound = createSound(103240623182313, gui)
local voidCamOffSound = createSound(117614974260388, gui)
createSound(115780308685053, gui):Play()

-- Toggle button (left side)
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,35,0,35)
toggle.Position = UDim2.new(0,20,0.5,-20)
toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggle.Text = "+"
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Active = true
toggle.Draggable = true
Instance.new("UICorner", toggle)

-- Main panel
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
panel.Position = UDim2.new(0,70,0.5,-PANEL_HEIGHT/2)
panel.BackgroundColor3 = Color3.fromRGB(25,25,30)
panel.Visible = false
panel.Active = true
panel.Draggable = true
Instance.new("UICorner", panel)
createRainbowStroke(panel, 2)

-- Layout + padding
local layout = Instance.new("UIListLayout", panel)
layout.Padding = UDim.new(0,8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
local padding = Instance.new("UIPadding", panel)
padding.PaddingTop = UDim.new(0,8)
padding.PaddingLeft = UDim.new(0,8)
padding.PaddingRight = UDim.new(0,8)

-- Toggle show/hide
toggle.MouseButton1Click:Connect(function()
pcall(function() clickSound:Play() end)
panel.Visible = not panel.Visible
toggle.Text = panel.Visible and "-" or "+"
end)

-- Generic control creator
local function createControl(name, default, min, max, toggleCallback, valueCallback)
local row = Instance.new("Frame", panel)
row.Size = UDim2.new(1,0,0,30)
row.BackgroundColor3 = Color3.fromRGB(40,40,45)
Instance.new("UICorner", row)

local label = Instance.new("TextLabel", row)
label.Size = UDim2.new(0.45,0,1,0)
label.Text = name
label.Font = Enum.Font.Gotham
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.BackgroundTransparency = 1

local input = Instance.new("TextBox", row)
input.Size = UDim2.new(0.3,0,1,0)
input.Position = UDim2.new(0.45,0,0,0)
input.Text = tostring(default)
input.Font = Enum.Font.Gotham
input.TextColor3 = Color3.new(1,1,1)
input.TextScaled = true
input.BackgroundColor3 = Color3.fromRGB(50,50,60)
input.ClearTextOnFocus = false
Instance.new("UICorner", input)

local btn = Instance.new("TextButton", row)
btn.Size = UDim2.new(0.25,0,1,0)
btn.Position = UDim2.new(0.75,0,0,0)
btn.Text = "OFF"
btn.Font = Enum.Font.GothamBold
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", btn)

local active = false
btn.MouseButton1Click:Connect(function()
pcall(function() clickSound:Play() end)
active = not active
btn.Text = active and "ON" or "OFF"
if toggleCallback then toggleCallback(active) end
safeNotify(name, active and "Enabled" or "Disabled", 2)
end)

input.FocusLost:Connect(function()
local v = tonumber(input.Text)
if v and v >= min and v <= max then
if valueCallback then valueCallback(v) end
else
input.Text = tostring(default)
end
end)
end

-- Controls
createControl("⚡ Speed", 16, 15, 500,
function(v) speedOn = v
if not v and lp.Character and lp.Character:FindFirstChild("Humanoid") then
lp.Character.Humanoid.WalkSpeed = 16
end
end,
function(v) speedValue = v end)

createControl("🎯 Hitbox", 5, 1, 50,
function(v)
hitboxOn = v
if not v then
for p, props in pairs(originalProps) do
if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local hrp = p.Character.HumanoidRootPart
hrp.Size = props.Size
hrp.Material = props.Material
hrp.Transparency = props.Transparency
hrp.CanCollide = props.CanCollide
end
end
originalProps = {}
end
end,
function(v) hitboxSize = v end)

createControl("🪂 Inf Jump", 0, 0, 0,
function(v) infJumpOn = v end)

createControl("🦘 Jump Boost", 50, 50, 300,
function(v)
jumpBoostOn = v
if not v and lp.Character and lp.Character:FindFirstChild("Humanoid") then
lp.Character.Humanoid.JumpPower = defaultJumpPower
end
end,
function(v) jumpBoostValue = v end)

-- Redz loader
local redzBtn = Instance.new("TextButton", panel)
redzBtn.Size = UDim2.new(1,0,0,30)
redzBtn.BackgroundColor3 = Color3.fromRGB(60,20,20)
redzBtn.Text = "🚀 Load RedzHub"
redzBtn.Font = Enum.Font.GothamBold
redzBtn.TextScaled = true
redzBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", redzBtn)
redzBtn.MouseButton1Click:Connect(function()
pcall(function() clickSound:Play() end)
local ok, err = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
end)
if ok then
safeNotify("RedzHub", "Loaded", 3)
else
safeNotify("RedzHub", "Failed: "..tostring(err), 4)
end
end)

-- Footer
local footer = Instance.new("TextLabel", panel)
footer.Size = UDim2.new(1,0,0,18)
footer.Position = UDim2.new(0,0,1,-18)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextScaled = true
footer.Text = "Made by VoidScripts (rip_trollz98/vonplayz_real)"
footer.TextColor3 = Color3.new(1,1,1)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
if infJumpOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end)

-- VoidCam button
local camBtn = Instance.new("TextButton", gui)
camBtn.Size = UDim2.new(0,160,0,40)
camBtn.Position = UDim2.new(0,20,1,-60)
camBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
camBtn.Text = "VoidCam: OFF"
camBtn.TextScaled = true
camBtn.Font = Enum.Font.GothamBold
camBtn.TextColor3 = Color3.new(0,0,0)
camBtn.Active = true
camBtn.Draggable = true
Instance.new("UICorner", camBtn)
local camStroke = Instance.new("UIStroke", camBtn)
camStroke.Thickness = 3
camStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
task.spawn(function()
local t = 0
while camBtn and camBtn.Parent do
t += task.wait()
camStroke.Color = rainbowColor(t)
end
end)

camBtn.MouseButton1Click:Connect(function()
pcall(function() clickSound:Play() end)
camlockOn = not camlockOn
camBtn.Text = camlockOn and "VoidCam: ON" or "VoidCam: OFF"
(camlockOn and voidCamOnSound or voidCamOffSound):Play()
if camlockOn then
local cam = workspace.CurrentCamera
local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
local closest, shortest = nil, math.huge
for _, p in pairs(Players:GetPlayers()) do
if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local pos, visible = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
if visible then
local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
if dist < shortest then
shortest = dist
closest = p
end
end
end
end
camTarget = closest
if camTarget then
safeNotify("🎯 VOIDCAM LOCKED", "Target: "..tostring(camTarget.DisplayName or camTarget.Name), 3)
else
camlockOn = false
camBtn.Text = "VoidCam: OFF"
safeNotify("❌ VOIDCAM", "No players found to lock onto!", 3)
end
else
camTarget = nil
safeNotify("VOIDCAM", "Disabled", 2)
end
end)

-- Loops
RunService.RenderStepped:Connect(function()
if camlockOn and camTarget and camTarget.Character and camTarget.Character:FindFirstChild("HumanoidRootPart") then
local hrp = camTarget.Character.HumanoidRootPart
workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, hrp.Position + hrp.Velocity * prediction)
end
if speedOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
lp.Character.Humanoid.WalkSpeed = speedValue
end
if jumpBoostOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
lp.Character.Humanoid.JumpPower = jumpBoostValue
end
if hitboxOn then
for _, p in pairs(Players:GetPlayers()) do
if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local hrp = p.Character.HumanoidRootPart
if not originalProps[p] then
originalProps[p] = {
Size = hrp.Size,
Material = hrp.Material,
Transparency = hrp.Transparency,
CanCollide = hrp.CanCollide
}
end
hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
hrp.Material = Enum.Material.Neon
hrp.Transparency = 0.5
hrp.CanCollide = false
end
end
end
end)

safeNotify("✅ Void Scripts Ready", "Welcome. Everything's loaded.", 4)
end

-- Launch
loadVoidScripts()
