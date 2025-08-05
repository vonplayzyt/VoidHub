-- VOIDHUB V4 - Fully Modernized by Void Scripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local prediction = 0.13
local target = nil
local camlockOn, speedOn, hitboxOn = false, false, false
local speedValue, hitboxSize = 16, 5
local originalSizes = {}

-- Clean old
for _, name in ipairs({"VoidHubUI", "VoidCamBtn", "VoidToggle"}) do
	if CoreGui:FindFirstChild(name) then
		CoreGui[name]:Destroy()
	end
end

-- MAIN GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "VoidHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Notification Function
local function notify(title, msg)
	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 260, 0, 60)
	frame.Position = UDim2.new(1, 10, 1, -80)
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -10, 1, -10)
	label.Position = UDim2.new(0, 5, 0, 5)
	label.Text = title .. "\n" .. msg
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextWrapped = true
	label.BackgroundTransparency = 1

	TweenService:Create(frame, TweenInfo.new(0.4), {
		Position = UDim2.new(1, -20, 1, -20)
	}):Play()

	task.delay(4, function()
		TweenService:Create(frame, TweenInfo.new(0.4), {
			BackgroundTransparency = 1
		}):Play()
		label.TextTransparency = 1
		task.wait(0.4)
		frame:Destroy()
	end)
end

-- Toggle Button
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Name = "VoidToggle"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -100)
toggleBtn.Image = "rbxassetid://121584081125594"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = true
Instance.new("UICorner", toggleBtn)

toggleBtn.Draggable = true
toggleBtn.Active = true

-- Hub Frame
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 190, 0, 280)
menu.Position = UDim2.new(0, 70, 0.5, -120)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.Visible = false
menu.Active = true
menu.Draggable = true
Instance.new("UICorner", menu)

-- Toggle logic
toggleBtn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Helper: create button
local function makeButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -20, 0, 32)
	btn.Position = UDim2.new(0, 10, 0, 10 + (#parent:GetChildren()-1)*38)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Speed Section
local speedBtn = makeButton(menu, "Speed: OFF", function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
	if not speedOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = 16
	end
end)

local speedBox = Instance.new("TextBox", menu)
speedBox.Size = UDim2.new(1, -20, 0, 28)
speedBox.Position = speedBtn.Position + UDim2.new(0, 0, 0, 38)
speedBox.Text = tostring(speedValue)
speedBox.PlaceholderText = "Max: 500"
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.ClearTextOnFocus = false
Instance.new("UICorner", speedBox)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val <= 500 then
		speedValue = val
	else
		speedBox.Text = tostring(speedValue)
	end
end)

-- RedzHub
makeButton(menu, "Load RedzHub", function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
	end)
end)

-- Hitbox Expander
local hitboxBtn = makeButton(menu, "Hitbox: OFF", function()
	hitboxOn = not hitboxOn
	hitboxBtn.Text = hitboxOn and "Hitbox: ON" or "Hitbox: OFF"
	if not hitboxOn then
		for plr, size in pairs(originalSizes) do
			if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = plr.Character.HumanoidRootPart
				hrp.Size = size
				hrp.Transparency = 1
				hrp.Material = Enum.Material.Plastic
				hrp.CanCollide = true
			end
		end
		originalSizes = {}
	end
end)

-- Hitbox Size
local hitboxBox = Instance.new("TextBox", menu)
hitboxBox.Size = UDim2.new(1, -20, 0, 28)
hitboxBox.Position = hitboxBtn.Position + UDim2.new(0, 0, 0, 38)
hitboxBox.Text = tostring(hitboxSize)
hitboxBox.PlaceholderText = "Size: 5–50"
hitboxBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
hitboxBox.TextColor3 = Color3.new(1,1,1)
hitboxBox.Font = Enum.Font.Gotham
hitboxBox.TextSize = 14
hitboxBox.ClearTextOnFocus = false
Instance.new("UICorner", hitboxBox)

hitboxBox.FocusLost:Connect(function()
	local val = tonumber(hitboxBox.Text)
	if val and val >= 5 and val <= 50 then
		hitboxSize = val
	else
		hitboxBox.Text = tostring(hitboxSize)
	end
end)

-- VoidCam Floating Button
local camBtn = Instance.new("TextButton", gui)
camBtn.Name = "VoidCamBtn"
camBtn.Size = UDim2.new(0, 150, 0, 40)
camBtn.Position = UDim2.new(0, 10, 1, -60)
camBtn.Text = "VoidCam: OFF"
camBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
camBtn.TextColor3 = Color3.new(1,1,1)
camBtn.Font = Enum.Font.GothamBold
camBtn.TextSize = 14
camBtn.Draggable = true
camBtn.Active = true
Instance.new("UICorner", camBtn)

camBtn.MouseButton1Click:Connect(function()
	camlockOn = not camlockOn
	camBtn.Text = camlockOn and "VoidCam: ON" or "VoidCam: OFF"

	if camlockOn then
		local closest, shortest = nil, math.huge
		local center = Vector2.new(GuiService:GetScreenResolution().X / 2, GuiService:GetScreenResolution().Y / 2)
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
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
			notify("🎯 VoidCam", "Target Locked: " .. target.DisplayName)
		end
	end
end)

-- Auto Clipboard & Kill Achievements
task.spawn(function()
	while true do
		pcall(function()
			setclipboard("https://youtube.com/@voidscripts-r3u")
		end)
		task.wait(600)
	end
end)

lp.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").Died:Connect(function()
		local phrases = {
			"Another one down 😤",
			"Void Scripts strikes again ⚡",
			"Owned. Simple. 💀",
			"Stay mad 🤫"
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
		notify("🏆 Achievement", phrases[math.random(1, #phrases)])
	end)
end)

-- Runtime
RunService.RenderStepped:Connect(function()
	if camlockOn and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = target.Character.HumanoidRootPart
		workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, hrp.Position + hrp.Velocity * prediction)
	end

	if speedOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = speedValue
	end

	if hitboxOn then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = p.Character.HumanoidRootPart
				if not originalSizes[p] then
					originalSizes[p] = hrp.Size
				end
				hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
				hrp.Transparency = 0.7
				hrp.Material = Enum.Material.ForceField
				hrp.CanCollide = false
			end
		end
	end
end)

notify("✅ VoidHub Loaded", "Made by Void Scripts – You’re ready.")speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = textColor
speedBox.Font = fontType
speedBox.TextScaled = true
Instance.new("UICorner", speedBox)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val >= 0 and val <= 500 then
		speedValue = val
	else
		speedBox.Text = tostring(speedValue)
	end
end)

-- Redz Hub
makeButton("Launch Redz Hub 🚀", 90, main, function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
	end)
end)

-- Hitbox
makeButton("Hitbox: OFF", 130, main, function()
	hitboxOn = not hitboxOn
	main:GetChildren()[4].Text = "Hitbox: " .. (hitboxOn and "ON" or "OFF")
	if not hitboxOn then
		for p, size in pairs(originalSizes) do
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = p.Character.HumanoidRootPart
				hrp.Size = size
				hrp.Transparency = 1
				hrp.Material = Enum.Material.Plastic
				hrp.CanCollide = true
			end
		end
	end
end)

local hitboxBox = Instance.new("TextBox", main)
hitboxBox.Size = UDim2.new(1, -20, 0, 30)
hitboxBox.Position = UDim2.new(0, 10, 0, 170)
hitboxBox.Text = tostring(hitboxSize)
hitboxBox.PlaceholderText = "Size (max 100)"
hitboxBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxBox.TextColor3 = textColor
hitboxBox.Font = fontType
hitboxBox.TextScaled = true
Instance.new("UICorner", hitboxBox)

hitboxBox.FocusLost:Connect(function()
	local val = tonumber(hitboxBox.Text)
	if val and val >= 1 and val <= 100 then
		hitboxSize = val
	else
		hitboxBox.Text = tostring(hitboxSize)
	end
end)

-- VoidCam (Camlock)
local camBtn = Instance.new("TextButton", gui)
camBtn.Size = UDim2.new(0, 150, 0, 40)
camBtn.Position = UDim2.new(0, 10, 0.5, 120)
camBtn.Text = "VoidCam: OFF"
camBtn.BackgroundColor3 = buttonColor
camBtn.TextColor3 = textColor
camBtn.Font = fontType
camBtn.TextScaled = true
camBtn.Draggable = true
camBtn.Active = true
Instance.new("UICorner", camBtn)

camBtn.MouseButton1Click:Connect(function()
	camlockOn = not camlockOn
	camBtn.Text = "VoidCam: " .. (camlockOn and "ON" or "OFF")
	if camlockOn then
		local closest, shortest = nil, math.huge
		local center = Vector2.new(GuiService:GetScreenResolution().X / 2, GuiService:GetScreenResolution().Y / 2)
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
				local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
				local dist = (center - Vector2.new(pos.X, pos.Y)).Magnitude
				if onScreen and dist < shortest then
					shortest = dist
					closest = p
				end
			end
		end
		target = closest
		if target then
			notiSound:Play()
			StarterGui:SetCore("SendNotification", {
				Title = "🎯 VOIDCAM LOCKED",
				Text = "Target: " .. target.DisplayName,
				Duration = 3
			})
		end
	end
end)

-- Kill Message System
local killMsgs = {
	"You fucking clapped that clown 💀",
	"Void Scripts certified wipe 😈",
	"Another idiot down. Good shit.",
	"You’re built different as fuck 🔥",
	"That bitch didn’t stand a chance 🤡",
	"Void Scripts on top. One more deleted 💥",
	"Fuck around, find out. They found out.",
	"Made that dummy uninstall 🔪",
	"Headshot from Void Scripts with love 💀",
	"Fuck that bitch frfr🥶",
}

lp.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	hum.Died:Connect(function()
		local msg = killMsgs[math.random(1, #killMsgs)]
		StarterGui:SetCore("SendNotification", {
			Title = "☠️ Kill Achieved",
			Text = msg,
			Duration = 3
		})
	end)
end)

-- Clipboard auto-copy
task.spawn(function()
	while true do
		task.wait(600)
		pcall(function()
			setclipboard("https://youtube.com/@voidscripts-r3u")
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
				hrp.Transparency = 0.5
				hrp.Material = Enum.Material.ForceField
				hrp.CanCollide = false
			end
		end
	end
end)execBtn.Size = UDim2.new(1, -20, 0, 30)
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
