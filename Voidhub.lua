local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local camlockOn, speedOn, hitboxOn = false, false, false
local speedValue, hitboxSize = 16, 5
local target = nil
local prediction = 0.13
local originalSizes = {}

local killLines = {
	"You clapped that clown 💀",
	"Void Scripts certified wipe 😈",
	"Another idiot down. Good shit.",
	"You’re built different 🔥",
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

-- VoidCam Toggle Sounds
local voidCamOnSound = Instance.new("Sound", gui)
voidCamOnSound.SoundId = "rbxassetid://103240623182313"
voidCamOnSound.Volume = 1

local voidCamOffSound = Instance.new("Sound", gui)
voidCamOffSound.SoundId = "rbxassetid://115780308685053"
voidCamOffSound.Volume = 1

-- Script Executed Sound
local startupSound = Instance.new("Sound", gui)
startupSound.SoundId = "rbxassetid://117614974260388"
startupSound.Volume = 1
startupSound:Play()

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

-- VoidCam Button (Image-based toggle)
local camBtn = Instance.new("ImageButton", gui)
camBtn.Size = UDim2.new(0, 140, 0, 40)
camBtn.Position = UDim2.new(0, 10, 0.5, 40)
camBtn.Image = "rbxassetid://115780308685053" -- OFF by default
camBtn.BackgroundColor3 = buttonColor
camBtn.Draggable = true
camBtn.Active = true
Instance.new("UICorner", camBtn)

-- Label on Cam Button
local camLabel = Instance.new("TextLabel", camBtn)
camLabel.Size = UDim2.new(1, 0, 1, 0)
camLabel.BackgroundTransparency = 1
camLabel.Text = "VoidCam: OFF"
camLabel.TextColor3 = textColor
camLabel.TextScaled = true
camLabel.Font = fontType

-- Feature Buttons Logic
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

-- VOIDCAM LOGIC (Image Toggle)
camBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	camlockOn = not camlockOn
	camLabel.Text = camlockOn and "VoidCam: ON" or "VoidCam: OFF"
	camBtn.Image = camlockOn and "rbxassetid://103240623182313" or "rbxassetid://115780308685053"

	if camlockOn then
		voidCamOnSound:Play()
	else
		voidCamOffSound:Play()
	end

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
})-- CREATE TABS
for _, name in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton", tabBar)
	tabBtn.Size = UDim2.new(0, 100, 1, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	tabBtn.TextColor3 = Color3.new(1, 1, 1)
	tabBtn.Font = Enum.Font.Gotham
	tabBtn.Text = name
	tabBtn.TextSize = 14
	tabBtn.AutoButtonColor = false
	Instance.new("UICorner", tabBtn)

	local page = Instance.new("Frame", pageHolder)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	local list = Instance.new("UIListLayout", page)
	list.Padding = UDim.new(0, 8)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	local pad = Instance.new("UIPadding", page)
	pad.PaddingTop = UDim.new(0, 10)
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)

	tabBtn.MouseButton1Click:Connect(function()
		clickSound:Play()
		pageLayout:JumpTo(page)
	end)

	tabButtons[name] = tabBtn
	tabFrames[name] = page
end

-- MODERN BUTTON FUNCTION
local function createButton(tabName, text, emoji, callback)
	local btn = Instance.new("TextButton", tabFrames[tabName])
	btn.Size = UDim2.new(1, -10, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	btn.Text = emoji .. "  " .. text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// COMBAT EXAMPLE
createButton("Combat", "VoidCam (Demo)", "🎯", function()
	warn("VoidCam activated.")
end)

--// VISUAL EXAMPLE
createButton("Visual", "Toggle Light Theme", "💡", function()
	hub.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
end)

--// UTILITY EXAMPLE
createButton("Utility", "Print Hello", "🔧", function()
	print("Hello from Void Utility!")
end)

--// FPS + PING STATS
local statsUI = Instance.new("ScreenGui", CoreGui)
statsUI.Name = "VoidUI_Stats"

local statsFrame = Instance.new("Frame", statsUI)
statsFrame.Size = UDim2.new(0, 160, 0, 45)
statsFrame.Position = UDim2.new(1, -170, 1, -60)
statsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
statsFrame.BorderSizePixel = 0
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

--// STATS UPDATE LOOP
local last = tick()
RunService.RenderStepped:Connect(function()
	local now = tick()
	local fps = math.floor(1 / (now - last))
	last = now
	local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
	fpsLabel.Text = "FPS: " .. tostring(fps)
	pingLabel.Text = "Ping: " .. ping
end)

--// TOGGLE HUB
toggleBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	hub.Visible = not hub.Visible
end)

-- FINAL WELCOME
pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Void UI Loaded 🧱",
		Text = "UI Toolkit Ready",
		Duration = 4
	})
end)hitboxBox.Size = UDim2.new(0, 100, 0, 30)
hitboxBox.Position = UDim2.new(0, 20, 0, 70)
hitboxBox.Text = "5"
hitboxBox.PlaceholderText = "Size (1-100)"
hitboxBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
hitboxBox.TextColor3 = Color3.new(1, 1, 1)
hitboxBox.Font = Enum.Font.Gotham
hitboxBox.TextSize = 14
hitboxBox.ClearTextOnFocus = true
Instance.new("UICorner", hitboxBox)

hitboxBtn.MouseButton1Click:Connect(function()
	hitboxEnabled = not hitboxEnabled
	playClick()
	hitboxBtn.Text = hitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
end)

hitboxBox.FocusLost:Connect(function()
	local val = tonumber(hitboxBox.Text)
	if val and val >= 1 and val <= 100 then
		hitboxSize = val
	else
		hitboxBox.Text = tostring(hitboxSize)
	end
end)

-- CAMLOCK UI
local camBtn, camGui = createToggleUI("Void_UI_Camlock", "VoidCam: OFF", UDim2.new(0, 420, 0, 100))
camBtn.MouseButton1Click:Connect(function()
	camlockEnabled = not camlockEnabled
	playClick()
	camBtn.Text = camlockEnabled and "VoidCam: ON" or "VoidCam: OFF"

	if camlockEnabled then
		local closest, shortest = nil, math.huge
		local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)

		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
				if onScreen then
					local dist = (screenCenter - Vector2.new(pos.X, pos.Y)).Magnitude
					if dist < shortest then
						shortest = dist
						closest = p
					end
				end
			end
		end

		camlockTarget = closest
	end
end)

-- REDZ LOADER
local redzBtn, redzGui = createToggleUI("Void_UI_Redz", "Load Redz Hub", UDim2.new(0, 620, 0, 100))
redzBtn.MouseButton1Click:Connect(function()
	playClick()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
	end)
end)

-- ACHIEVEMENT POPUP
local achievementPhrases = {
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

local function showAchievement()
	local msg = achievementPhrases[math.random(1, #achievementPhrases)]
	StarterGui:SetCore("SendNotification", {
		Title = "🏆 Achievement",
		Text = msg,
		Duration = 3
	})

	-- Auto copy YouTube link
	pcall(function()
		setclipboard("https://youtube.com/@voidscripts-r3u")
	end)
end

-- Enemy death detection
for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= lp then
		plr.CharacterAdded:Connect(function(char)
			local hum = char:WaitForChild("Humanoid")
			hum.Died:Connect(function()
				if hum:FindFirstChild("creator") and hum.creator.Value == lp then
					showAchievement()
				end
			end)
		end)
	end
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
	if speedEnabled and lp.Character and lp.Character:FindFirstChild("Humanoid") then
		lp.Character.Humanoid.WalkSpeed = speedValue
	end

	if hitboxEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local part = p.Character.HumanoidRootPart
				part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
				part.Material = Enum.Material.Neon
				part.Transparency = 0.6
				part.CanCollide = false
			end
		end
	end

	if camlockEnabled and camlockTarget and camlockTarget.Character then
		local hrp = camlockTarget.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local pred = hrp.Position + hrp.Velocity * 0.13
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, pred)
		end
	end
end)
