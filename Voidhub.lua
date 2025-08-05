-- [[ VOID SCRIPTS – MODULAR UI SYSTEM ]] --

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local speedEnabled, hitboxEnabled, camlockEnabled = false, false, false
local speedValue, hitboxSize = 16, 5
local camlockTarget = nil

-- Destroy previous UIs
for _, name in ipairs({"Void_UI_Speed", "Void_UI_Hitbox", "Void_UI_Camlock", "Void_UI_Redz"}) do
	local ui = CoreGui:FindFirstChild(name)
	if ui then ui:Destroy() end
end

-- Sound setup
local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 0.5
clickSound.Name = "VoidClick"

local function playClick()
	clickSound:Play()
end

local function createToggleUI(name, labelText, pos)
	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = name

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 180, 0, 60)
	frame.Position = pos
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	frame.Active = true
	frame.Draggable = true

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 6)

	local button = Instance.new("TextButton", frame)
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, 10)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
	button.Text = labelText
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 14

	Instance.new("UICorner", button)

	return button, gui
end

-- SPEED UI
local speedBtn, speedGui = createToggleUI("Void_UI_Speed", "Speed: OFF", UDim2.new(0, 20, 0, 100))
local speedBox = Instance.new("TextBox", speedGui)
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 20, 0, 70)
speedBox.Text = "16"
speedBox.PlaceholderText = "Speed (max 500)"
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.ClearTextOnFocus = true
Instance.new("UICorner", speedBox)

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	playClick()
	speedBtn.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
end)

speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val >= 16 and val <= 500 then
		speedValue = val
	else
		speedBox.Text = tostring(speedValue)
	end
end)

-- HITBOX UI
local hitboxBtn, hitboxGui = createToggleUI("Void_UI_Hitbox", "Hitbox: OFF", UDim2.new(0, 220, 0, 100))
local hitboxBox = Instance.new("TextBox", hitboxGui)
hitboxBox.Size = UDim2.new(0, 100, 0, 30)
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
