--[[ 
	VOID HUB V3 – Custom GUI
	Made by LUA Programming GOD 😤
	YouTube: @voidscripts-r3u
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

-- 🧼 CLEANUP
for _, v in ipairs({"VoidHub", "VoidStats", "VoidJump"}) do
	if CoreGui:FindFirstChild(v) then CoreGui[v]:Destroy() end
end

-- 🧱 BASIC UI SETUP
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "VoidHub"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- 🟥 TOGGLE BUTTON
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.Image = "rbxassetid://121584081125594"
toggleBtn.BackgroundTransparency = 1
local dragging, dragInput, dragStart, startPos

-- ✅ Make it draggable
local function makeDraggable(btn)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = btn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	btn.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			btn.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X, 0, gui.AbsoluteSize.X - btn.AbsoluteSize.X), 0, math.clamp(startPos.Y.Offset + delta.Y, 0, gui.AbsoluteSize.Y - btn.AbsoluteSize.Y))
		end
	end)
end
makeDraggable(toggleBtn)

-- 🟫 HUB FRAME
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0, 280, 0, 300)
hub.Position = UDim2.new(0, toggleBtn.Position.X.Offset + 70, 0, toggleBtn.Position.Y.Offset)
hub.BackgroundColor3 = Color3.fromRGB(30,30,35)
hub.Visible = false
hub.Active = true
hub.Draggable = true
Instance.new("UICorner", hub)

local layout = Instance.new("UIListLayout", hub)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- 🔘 Button Maker
local function makeButton(text, emoji, callback)
	local btn = Instance.new("TextButton", hub)
	btn.Size = UDim2.new(1, -20, 0, 36)
	btn.Text = emoji.." "..text
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
end

-- 🏃 Speed Hack
local speedEnabled = false
local currentSpeed = 16
makeButton("Speed Hack", "🏃", function()
	speedEnabled = not speedEnabled
end)
local speedInput = Instance.new("TextBox", hub)
speedInput.Size = UDim2.new(1, -20, 0, 30)
speedInput.PlaceholderText = "Set Speed (Max 700)"
speedInput.Text = ""
speedInput.BackgroundColor3 = Color3.fromRGB(20,20,20)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
Instance.new("UICorner", speedInput)
speedInput.FocusLost:Connect(function()
	local val = tonumber(speedInput.Text)
	if val and val <= 700 and val >= 16 then
		currentSpeed = val
	end
end)

RunService.Stepped:Connect(function()
	if lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = speedEnabled and currentSpeed or 16
	end
end)

-- 🎯 Hitbox Expander
makeButton("Hitbox Expander", "🎯", function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local part = plr.Character.HumanoidRootPart
			part.Size = Vector3.new(currentHitbox, currentHitbox, currentHitbox)
			part.Transparency = 0.6
			part.Material = Enum.Material.Neon
			part.CanCollide = false
		end
	end
end)
local currentHitbox = 20
local hitboxInput = Instance.new("TextBox", hub)
hitboxInput.Size = UDim2.new(1, -20, 0, 30)
hitboxInput.PlaceholderText = "Set Hitbox Size (Max 400)"
hitboxInput.Text = ""
hitboxInput.BackgroundColor3 = Color3.fromRGB(20,20,20)
hitboxInput.TextColor3 = Color3.new(1,1,1)
hitboxInput.Font = Enum.Font.Gotham
hitboxInput.TextSize = 14
Instance.new("UICorner", hitboxInput)
hitboxInput.FocusLost:Connect(function()
	local val = tonumber(hitboxInput.Text)
	if val and val <= 400 and val >= 10 then
		currentHitbox = val
	end
end)

-- 👁 ESP (Box + Name + TeamColor)
makeButton("ESP (Players)", "👁", function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local tag = Instance.new("BillboardGui", plr.Character.HumanoidRootPart)
			tag.Size = UDim2.new(0, 100, 0, 40)
			tag.Adornee = plr.Character.HumanoidRootPart
			tag.AlwaysOnTop = true
			local nameLabel = Instance.new("TextLabel", tag)
			nameLabel.Size = UDim2.new(1, 0, 1, 0)
			nameLabel.Text = plr.Name
			nameLabel.BackgroundTransparency = 1
			nameLabel.TextColor3 = plr.TeamColor.Color
			nameLabel.Font = Enum.Font.GothamBold
			nameLabel.TextSize = 14
		end
	end
end)

-- 🪂 Jump Boost
local jumpGui = Instance.new("ScreenGui", CoreGui)
jumpGui.Name = "VoidJump"
local jumpBtn = Instance.new("TextButton", jumpGui)
jumpBtn.Size = UDim2.new(0, 140, 0, 40)
jumpBtn.Position = UDim2.new(0, 20, 1, -120)
jumpBtn.Text = "🪂 Jump Boost: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
jumpBtn.TextColor3 = Color3.new(1,1,1)
jumpBtn.Font = Enum.Font.Gotham
jumpBtn.TextSize = 14
Instance.new("UICorner", jumpBtn)

local jumpOn = false
jumpBtn.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	jumpBtn.Text = jumpOn and "🪂 Jump Boost: ON" or "🪂 Jump Boost: OFF"
end)
makeDraggable(jumpBtn)

UserInputService.JumpRequest:Connect(function()
	if jumpOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		lp.Character.Humanoid.JumpPower = 120
	end
end)

-- 📊 FPS / Ping Tracker
local statsGui = Instance.new("ScreenGui", CoreGui)
statsGui.Name = "VoidStats"
local statsFrame = Instance.new("Frame", statsGui)
statsFrame.Size = UDim2.new(0, 160, 0, 50)
statsFrame.Position = UDim2.new(0, 20, 1, -170)
statsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", statsFrame)

local fpsLabel = Instance.new("TextLabel", statsFrame)
fpsLabel.Size = UDim2.new(1, 0, 0.5, 0)
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 14
fpsLabel.BackgroundTransparency = 1

local pingLabel = Instance.new("TextLabel", statsFrame)
pingLabel.Position = UDim2.new(0, 0, 0.5, 0)
pingLabel.Size = UDim2.new(1, 0, 0.5, 0)
pingLabel.Text = "Ping: --"
pingLabel.TextColor3 = Color3.new(1,1,1)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 14
pingLabel.BackgroundTransparency = 1
makeDraggable(statsFrame)

local last = tick()
RunService.RenderStepped:Connect(function()
	local now = tick()
	local fps = math.floor(1 / (now - last))
	last = now
	local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
	fpsLabel.Text = "FPS: " .. tostring(fps)
	pingLabel.Text = "Ping: " .. ping
end)

-- 🧲 Toggle hub
toggleBtn.MouseButton1Click:Connect(function()
	hub.Visible = not hub.Visible
end)
