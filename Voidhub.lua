-- VOID SCRIPTS HUB – FINAL EDITION

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local lp = Players.LocalPlayer

-- Remove old UI if exists
for _, name in pairs({"VoidHub", "VoidJump", "VoidStats", "VoidESP"}) do
	local existing = CoreGui:FindFirstChild(name)
	if existing then existing:Destroy() end
end

-- GUI setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "VoidHub"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- Toggle Button
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 150)
toggleBtn.Image = "rbxassetid://121584081125594"
toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn)

-- Main Panel
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0, 230, 0, 320)
hub.Position = toggleBtn.Position + UDim2.new(0, 60, 0, 0)
hub.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
hub.BorderSizePixel = 0
hub.Visible = false
Instance.new("UICorner", hub)

local layout = Instance.new("UIListLayout", hub)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Drag system
local dragging = false
local dragStart, startPos

toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = toggleBtn.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

toggleBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		UIS.InputChanged:Connect(function(move)
			if move.UserInputType == Enum.UserInputType.MouseMovement and dragging then
				local delta = move.Position - dragStart
				local newPos = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
				toggleBtn.Position = newPos
				hub.Position = newPos + UDim2.new(0, 60, 0, 0)
				jumpBtn.Position = newPos + UDim2.new(0, 0, 0, 60)
				statsFrame.Position = newPos + UDim2.new(0, 0, 0, 115)
			end
		end)
	end
end)

toggleBtn.MouseButton1Click:Connect(function()
	hub.Visible = not hub.Visible
end)

-- Button maker
local function makeButton(text, emoji, callback)
	local btn = Instance.new("TextButton", hub)
	btn.Size = UDim2.new(1, -12, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = emoji .. " " .. text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
end

-- Camlock
makeButton("Prensado Camlock", "🎯", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Aepione/Prensado/refs/heads/main/Prensado%20camlock"))()
end)

-- Redz
makeButton("Redz Hub", "💀", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
end)

-- Speed Hack (Editable)
local walkSpeed = 100
local speedOn = false
local speedBtn

local function updateSpeed()
	speedBtn.Text = "🏃 Speed: " .. walkSpeed .. (speedOn and " (ON)" or " (OFF)")
end

speedBtn = Instance.new("TextButton", hub)
speedBtn.Size = UDim2.new(1, -12, 0, 34)
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 13
Instance.new("UICorner", speedBtn)
updateSpeed()

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	updateSpeed()
end)

makeButton("Set Speed (Max 700)", "⚙️", function()
	local val = tonumber(string.match(lp.Name, "%d+")) or 100
	walkSpeed = math.clamp(val, 1, 700)
	updateSpeed()
end)

RunService.Stepped:Connect(function()
	if lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = speedOn and walkSpeed or 16
	end
end)

-- Hitbox Expander (Editable & Effective)
local hitboxSize = 20

makeButton("Set Hitbox Size", "⚙️", function()
	local val = tonumber(string.match(lp.Name, "%d+")) or 20
	hitboxSize = math.clamp(val, 5, 400)
end)

makeButton("Apply Hitbox", "🎯", function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character then
			for _, partName in pairs({"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
				local part = plr.Character:FindFirstChild(partName)
				if part and part:IsA("BasePart") then
					part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
					part.Material = Enum.Material.Neon
					part.Transparency = 0.5
					part.CanCollide = false
				end
			end
		end
	end
end)

-- Built-in ESP
local espEnabled = false
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "VoidESP"

makeButton("Toggle ESP", "👁", function()
	espEnabled = not espEnabled
	if not espEnabled then espFolder:ClearAllChildren() end
end)

RunService.RenderStepped:Connect(function()
	if not espEnabled then return end
	espFolder:ClearAllChildren()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Team ~= lp.Team then
			local esp = Instance.new("BillboardGui", espFolder)
			esp.AlwaysOnTop = true
			esp.Size = UDim2.new(0, 100, 0, 40)
			esp.Adornee = plr.Character.HumanoidRootPart
			esp.StudsOffset = Vector3.new(0, 3, 0)

			local label = Instance.new("TextLabel", esp)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = "👁 " .. plr.Name
			label.TextColor3 = Color3.fromRGB(255, 0, 0)
			label.TextStrokeTransparency = 0.5
			label.Font = Enum.Font.GothamBold
			label.TextSize = 14
		end
	end
end)

-- Jump Boost
local jumpGui = Instance.new("ScreenGui", CoreGui)
jumpGui.Name = "VoidJump"

jumpBtn = Instance.new("TextButton", jumpGui)
jumpBtn.Size = UDim2.new(0, 150, 0, 30)
jumpBtn.Position = toggleBtn.Position + UDim2.new(0, 0, 0, 60)
jumpBtn.Text = "🪂 Jump Boost: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
jumpBtn.TextColor3 = Color3.new(1,1,1)
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.TextSize = 13
Instance.new("UICorner", jumpBtn)

local jumpOn = false
jumpBtn.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	jumpBtn.Text = jumpOn and "🪂 Jump Boost: ON" or "🪂 Jump Boost: OFF"
end)

UIS.JumpRequest:Connect(function()
	if jumpOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		lp.Character.Humanoid.JumpPower = 120
	end
end)

-- FPS + Ping
local statsGui = Instance.new("ScreenGui", CoreGui)
statsGui.Name = "VoidStats"

statsFrame = Instance.new("Frame", statsGui)
statsFrame.Size = UDim2.new(0, 150, 0, 40)
statsFrame.Position = toggleBtn.Position + UDim2.new(0, 0, 0, 115)
statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", statsFrame)

local fpsLabel = Instance.new("TextLabel", statsFrame)
fpsLabel.Size = UDim2.new(1, 0, 0.5, 0)
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 12
fpsLabel.BackgroundTransparency = 1

local pingLabel = Instance.new("TextLabel", statsFrame)
pingLabel.Position = UDim2.new(0, 0, 0.5, 0)
pingLabel.Size = UDim2.new(1, 0, 0.5, 0)
pingLabel.Text = "Ping: --"
pingLabel.TextColor3 = Color3.new(1,1,1)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 12
pingLabel.BackgroundTransparency = 1

local last = tick()
RunService.RenderStepped:Connect(function()
	local now = tick()
	local fps = math.floor(1 / (now - last))
	last = now
	local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
	fpsLabel.Text = "FPS: " .. fps
	pingLabel.Text = "Ping: " .. ping
end)
