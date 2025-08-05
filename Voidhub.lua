-- VOID UI SYSTEM (LEGIT TOOLKIT VERSION) 🔧

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local lp = Players.LocalPlayer

--// CLEANUP
for _, uiName in ipairs({"VoidUI_Main", "VoidUI_Stats"}) do
    if CoreGui:FindFirstChild(uiName) then
        CoreGui[uiName]:Destroy()
    end
end

--// SOUND
local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 0.5
clickSound.Name = "UIButtonClick"

--// UI BASE
local gui = Instance.new("ScreenGui")
gui.Name = "VoidUI_Main"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

--// TOGGLE BUTTON
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.Image = "rbxassetid://121584081125594" -- your custom toggle icon
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true
Instance.new("UICorner", toggleBtn)

--// MAIN HUB
local hub = Instance.new("Frame", gui)
hub.Name = "MainHub"
hub.Size = UDim2.new(0, 360, 0, 400)
hub.Position = UDim2.new(0, 90, 0, 100)
hub.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
hub.Visible = false
hub.Active = true
hub.Draggable = true
Instance.new("UICorner", hub)

--// TOP BAR
local topBar = Instance.new("Frame", hub)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar)

--// TABS
local tabs = {"Combat", "Visual", "Utility"}
local tabFrames = {}
local tabButtons = {}

local tabBar = Instance.new("Frame", hub)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", tabBar)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- PAGE HOLDER
local pageHolder = Instance.new("Frame", hub)
pageHolder.Position = UDim2.new(0, 0, 0, 70)
pageHolder.Size = UDim2.new(1, 0, 1, -70)
pageHolder.BackgroundTransparency = 1

local pageLayout = Instance.new("UIPageLayout", pageHolder)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
pageLayout.EasingDirection = Enum.EasingDirection.Out
pageLayout.EasingStyle = Enum.EasingStyle.Quad
pageLayout.TweenTime = 0.25

-- CREATE TABS
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
