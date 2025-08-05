local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local camlockOn, speedOn, hitboxOn = false, false, false
local speedValue, hitboxSize = 16, 5
local target = nil
local prediction = 0.13
local originalSizes = {}

local killLines = {
	"You fucking clapped that clown 💀",
	"Void Scripts certified wipe 😈",
	"Another idiot down. Good shit.",
	"You’re built different as fuck 🔥",
	"That bitch didn’t stand a chance 🤡",
	"Void Scripts on top. One more deleted 💥",
	"Fuck around, find out. They found out.",
	"Made that dummy uninstall 🔪",
	"Headshot from Void Scripts with love 💀",
}

-- UI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "VoidHubUI"

local buttonColor = Color3.fromRGB(40, 40, 40)
local textColor = Color3.new(1, 1, 1)
local fontType = Enum.Font.Gotham

-- Click Sound
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12222005"
clickSound.Volume = 1

-- Toggle Button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 30, 0, 30)
toggle.Position = UDim2.new(0, 10, 0.5, -80)
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.Text = "+"
toggle.Font = fontType
toggle.TextColor3 = textColor
toggle.TextScaled = true
toggle.Draggable = true
toggle.Active = true

-- Menu
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 160, 0, 280)
menu.Position = UDim2.new(0, 50, 0.5, -100)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Active = true
menu.Draggable = true
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)

toggle.MouseButton1Click:Connect(function()
	clickSound:Play()
	menu.Visible = not menu.Visible
	toggle.Text = menu.Visible and "-" or "+"
end)

-- Speed Button
local speedBtn = Instance.new("TextButton", menu)
speedBtn.Size = UDim2.new(1, -20, 0, 30)
speedBtn.Position = UDim2.new(0, 10, 0, 10)
speedBtn.Text = "Speed: OFF"
speedBtn.BackgroundColor3 = buttonColor
speedBtn.TextColor3 = textColor
speedBtn.TextScaled = true
speedBtn.Font = fontType

local speedBox = Instance.new("TextBox", menu)
speedBox.Size = UDim2.new(1, -20, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 50)
speedBox.Text = tostring(speedValue)
speedBox.PlaceholderText = "Walkspeed (15 - 500)"
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = textColor
speedBox.TextScaled = true
speedBox.ClearTextOnFocus = false
speedBox.Font = fontType

-- Redz Hub Button
local execBtn = Instance.new("TextButton", menu)
execBtn.Size = UDim2.new(1, -20, 0, 30)
execBtn.Position = UDim2.new(0, 10, 0, 90)
execBtn.Text = "Launch Redz Hub"
execBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
execBtn.TextColor3 = textColor
execBtn.TextScaled = true
execBtn.Font = fontType

-- Hitbox Button
local hitboxBtn = Instance.new("TextButton", menu)
hitboxBtn.Size = UDim2.new(1, -20, 0, 30)
hitboxBtn.Position = UDim2.new(0, 10, 0, 130)
hitboxBtn.Text = "Hitbox: OFF"
hitboxBtn.BackgroundColor3 = buttonColor
hitboxBtn.TextColor3 = textColor
hitboxBtn.TextScaled = true
hitboxBtn.Font = fontType

local hitboxBox = Instance.new("TextBox", menu)
hitboxBox.Size = UDim2.new(1, -20, 0, 30)
hitboxBox.Position = UDim2.new(0, 10, 0, 170)
hitboxBox.Text = tostring(hitboxSize)
hitboxBox.PlaceholderText = "Size (1 - 400)"
hitboxBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxBox.TextColor3 = textColor
hitboxBox.TextScaled = true
hitboxBox.ClearTextOnFocus = false
hitboxBox.Font = fontType

-- VoidCam Button
local camBtn = Instance.new("TextButton", gui)
camBtn.Size = UDim2.new(0, 140, 0, 40)
camBtn.Position = UDim2.new(0, 10, 0.5, 40)
camBtn.Text = "VoidCam: OFF"
camBtn.BackgroundColor3 = buttonColor
camBtn.TextColor3 = textColor
camBtn.TextScaled = true
camBtn.Font = fontType
camBtn.Draggable = true
camBtn.Active = true
Instance.new("UICorner", camBtn)

-- Functions
speedBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
	if not speedOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = 16
	end
end)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val >= 15 and val <= 500 then
		speedValue = val
	else
		speedBox.Text = tostring(speedValue)
	end
end)

execBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
	end)
end)

local function restoreHitboxes()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = p.Character.HumanoidRootPart
			if originalSizes[p] then
				hrp.Size = originalSizes[p]
				hrp.Transparency = 1
				hrp.Material = Enum.Material.Plastic
				hrp.CanCollide = true
				originalSizes[p] = nil
			end
		end
	end
end

hitboxBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	hitboxOn = not hitboxOn
	hitboxBtn.Text = hitboxOn and "Hitbox: ON" or "Hitbox: OFF"
	if not hitboxOn then
		restoreHitboxes()
	end
end)

hitboxBox.FocusLost:Connect(function()
	local val = tonumber(hitboxBox.Text)
	if val and val >= 1 and val <= 400 then
		hitboxSize = val
	else
		hitboxBox.Text = tostring(hitboxSize)
	end
end)

camBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	camlockOn = not camlockOn
	camBtn.Text = camlockOn and "VoidCam: ON" or "VoidCam: OFF"
	if camlockOn then
		local closest = nil
		local shortest = math.huge
		local center = Vector2.new(GuiService:GetScreenResolution().X / 2, GuiService:GetScreenResolution().Y / 2)
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
				local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
				if onScreen then
					local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
					if dist < shortest then
						shortest = dist
						closest = p
					end
				end
			end
		end
		target = closest
		if target then
			StarterGui:SetCore("SendNotification", {
				Title = "VOIDCAM LOCKED 🎯",
				Text = "Target: " .. target.DisplayName,
				Duration = 3
			})
		end
	end
end)

-- KILL Achievements
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild("Humanoid").Died:Connect(function()
			if plr ~= lp then return end
			local msg = killLines[math.random(1, #killLines)]
			StarterGui:SetCore("SendNotification", {
				Title = "VOID SCRIPTS 🧱",
				Text = msg,
				Duration = 5
			})
		end)
	end)
end)

-- Clipboard Promo
task.spawn(function()
	while true do
		task.wait(600)
		pcall(function()
			setclipboard("https://youtube.com/@voidscripts-r3u?si=NcLm_SCf6ogHNzVI")
			StarterGui:SetCore("SendNotification", {
				Title = "VOID SCRIPTS 🔗",
				Text = "Subscribe to Void Scripts 💀\n(link copied 📋)",
				Duration = 5
			})
		end)
	end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
	if camlockOn and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = target.Character.HumanoidRootPart
		workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, hrp.Position + hrp.Velocity * prediction)
	end

	if speedOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = speedValue
	end

	if hitboxOn then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = p.Character.HumanoidRootPart
				if not originalSizes[p] then
					originalSizes[p] = hrp.Size
				end
				hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
				hrp.Transparency = 0.6
				hrp.Material = Enum.Material.ForceField
				hrp.CanCollide = false
			end
		end
	end
end)

-- Final Welcome Notif
StarterGui:SetCore("SendNotification", {
	Title = "Void Scripts 🧱",
	Text = "Loaded successfully, you sick fuck 💀",
	Duration = 5
})makeButton("Speed Hack", "🏃", function()
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
