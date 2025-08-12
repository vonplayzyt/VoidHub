-- FULL VOID SCRIPTS WITH KEY SYSTEM
-- Keys: Sub2Centu, Sub2VoidScripts
-- Get keys: https://voidcam.vercel.app

-- ========== CONFIG ==========
local PANEL_WIDTH  = 200 -- change this for panel width
local PANEL_HEIGHT = 190 -- change this for panel height

local VALID_KEYS = { "Sub2Centu", "Sub2VoidScripts" }
local KEY_SITE = "https://voidcam.vercel.app"

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer

-- ========== HELPERS ==========
local function rainbowColor(t)
    return Color3.fromHSV((t * 0.5) % 1, 0.8, 1)
end

local function createSound(id, parent)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. id
    s.Volume = 1
    s.Parent = parent or CoreGui
    return s
end

local function createRainbowStroke(parent, thickness)
    thickness = thickness or 2
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    -- animate
    task.spawn(function()
        local t = 0
        while parent and parent.Parent do
            t += task.wait()
            stroke.Color = rainbowColor(t)
        end
    end)
    return stroke
end

-- ========== MAIN UI (original features) ==========
local function loadVoidScripts()
    -- local services inside to avoid accidental early access
    local Players_local = Players
    local RunService_local = RunService
    local UserInputService_local = UserInputService

    -- script vars
    local camlockOn, speedOn, hitboxOn, infJumpOn = false, false, false, false
    local camTarget, speedValue, hitboxSize = nil, 16, 5
    local prediction = 0.13
    local originalSizes = {}
    local sessionStart = tick()

    -- small helper (local)
    local function rainbowColorLocal(t)
        return Color3.fromHSV((t * 0.5) % 1, 0.8, 1)
    end

    local function createSoundLocal(id, parent)
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = 1
        s.Parent = parent or CoreGui
        return s
    end

    -- create GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "VoidScriptsGUI"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false

    -- sounds
    local clickSound = createSoundLocal("1837635154", gui)
    local voidCamOnSound = createSoundLocal("103240623182313", gui)
    local voidCamOffSound = createSoundLocal("117614974260388", gui)
    createSoundLocal("115780308685053", gui):Play()

    -- toggle button (open/close panel)
    local toggle = Instance.new("TextButton", gui)
    toggle.Size = UDim2.new(0, 35, 0, 35)
    toggle.Position = UDim2.new(0, 20, 0.5, -20)
    toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggle.Text = "+"
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Active = true
    toggle.Draggable = true
    Instance.new("UICorner", toggle)

    -- panel (main)
    local panel = Instance.new("Frame", gui)
    panel.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
    panel.Position = UDim2.new(0, 70, 0.5, -PANEL_HEIGHT/2)
    panel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    panel.Visible = false
    panel.Active = true
    panel.Draggable = true
    Instance.new("UICorner", panel)

    -- rainbow outline on panel
    createRainbowStroke(panel, 2)

    -- layout & padding
    local layout = Instance.new("UIListLayout", panel)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local padding = Instance.new("UIPadding", panel)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)

    -- toggle behavior
    toggle.MouseButton1Click:Connect(function()
        pcall(function() clickSound:Play() end)
        panel.Visible = not panel.Visible
        toggle.Text = panel.Visible and "-" or "+"
    end)

    -- controls creator
    local function createControl(name, default, min, max, toggleCallback, valueCallback)
        local row = Instance.new("Frame", panel)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Instance.new("UICorner", row)

        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0.45, 0, 1, 0)
        label.Text = name
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.Gotham
        label.TextScaled = true
        label.BackgroundTransparency = 1

        local input = Instance.new("TextBox", row)
        input.Size = UDim2.new(0.3, 0, 1, 0)
        input.Position = UDim2.new(0.45, 0, 0, 0)
        input.Text = tostring(default)
        input.Font = Enum.Font.Gotham
        input.TextScaled = true
        input.TextColor3 = Color3.new(1, 1, 1)
        input.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        input.ClearTextOnFocus = false
        Instance.new("UICorner", input)

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new(0.75, 0, 0, 0)
        btn.Text = "OFF"
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        Instance.new("UICorner", btn)

        local active = false
        btn.MouseButton1Click:Connect(function()
            pcall(function() clickSound:Play() end)
            active = not active
            btn.Text = active and "ON" or "OFF"
            if toggleCallback then toggleCallback(active) end
        end)

        input.FocusLost:Connect(function()
            local val = tonumber(input.Text)
            if val and val >= min and val <= max then
                if valueCallback then valueCallback(val) end
            else
                input.Text = tostring(default)
            end
        end)
    end

    createControl("⚡ Speed", 16, 15, 500, function(v) speedOn = v end, function(v) speedValue = v end)
    createControl("🎯 Hitbox", 5, 1, 400, function(v) hitboxOn = v end, function(v) hitboxSize = v end)
    createControl("🪂 Inf Jump", 0, 0, 0, function(v) infJumpOn = v end)

    -- Redz button (keeps original loadstring behavior)
    local redzBtn = Instance.new("TextButton", panel)
    redzBtn.Size = UDim2.new(1, 0, 0, 30)
    redzBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    redzBtn.Text = "🚀 Load RedzHub"
    redzBtn.Font = Enum.Font.GothamBold
    redzBtn.TextScaled = true
    redzBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", redzBtn)
    redzBtn.MouseButton1Click:Connect(function()
        pcall(function() clickSound:Play() end)
        -- original remote loader
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
        end)
        if not ok then
            StarterGui:SetCore("SendNotification", {
                Title = "RedzHub load failed",
                Text = tostring(err),
                Duration = 4
            })
        end
    end)

    -- Infinite Jump
    UserInputService_local.JumpRequest:Connect(function()
        if infJumpOn and lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- VoidCam button (flashy)
    local camBtn = Instance.new("TextButton", gui)
    camBtn.Size = UDim2.new(0, 160, 0, 40)
    camBtn.Position = UDim2.new(0, 20, 1, -60)
    camBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    camBtn.Text = "VoidCam: OFF"
    camBtn.TextColor3 = Color3.new(0, 0, 0)
    camBtn.Font = Enum.Font.GothamBold
    camBtn.TextScaled = true
    camBtn.Active = true
    camBtn.Draggable = true
    Instance.new("UICorner", camBtn)

    local camOutline = Instance.new("UIStroke", camBtn)
    camOutline.Thickness = 3
    camOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- rainbow for cam button, and text color when active
    task.spawn(function()
        local t = 0
        while camBtn and camBtn.Parent do
            t += task.wait()
            camOutline.Color = rainbowColorLocal(t)
            if camlockOn then
                camBtn.TextColor3 = rainbowColorLocal(t)
            else
                camBtn.TextColor3 = Color3.new(0,0,0)
            end
        end
    end)

    camBtn.MouseButton1Click:Connect(function()
        pcall(function() clickSound:Play() end)
        camlockOn = not camlockOn
        camBtn.Text = camlockOn and "VoidCam: ON" or "VoidCam: OFF"
        (camlockOn and voidCamOnSound or voidCamOffSound):Play()

        if camlockOn then
            local closest, shortest = nil, math.huge
            local cam = workspace.CurrentCamera
            local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            for _, p in pairs(Players_local:GetPlayers()) do
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
                StarterGui:SetCore("SendNotification", {
                    Title = "🎯 VOIDCAM LOCKED",
                    Text = "Target: " .. tostring(camTarget.DisplayName or camTarget.Name),
                    Duration = 3
                })
            else
                camlockOn = false
                camBtn.Text = "VoidCam: OFF"
                StarterGui:SetCore("SendNotification", {
                    Title = "❌ VOIDCAM",
                    Text = "No players found to lock onto!",
                    Duration = 3
                })
            end
        end
    end)

    -- loops: camera follow, speed, hitbox
    RunService_local.RenderStepped:Connect(function()
        -- cam lock follow
        if camlockOn and camTarget and camTarget.Character and camTarget.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = camTarget.Character.HumanoidRootPart
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, hrp.Position + hrp.Velocity * prediction)
        end

        -- speed override
        if speedOn and lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = speedValue
        end

        -- hitbox
        if hitboxOn then
            for _, p in pairs(Players_local:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    if not originalSizes[p] and hrp then originalSizes[p] = hrp.Size end
                    if hrp then
                        hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        hrp.Material = Enum.Material.Neon
                        hrp.Transparency = 0.5
                        hrp.CanCollide = false
                    end
                end
            end
        else
            -- restore sizes when disabled (best effort)
            for p, sz in pairs(originalSizes) do
                if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = sz
                end
            end
            -- clear table to prevent repeated restores
            originalSizes = {}
        end
    end)

    -- Stats Box (FPS, Ping, Playtime)
    local statsGui = Instance.new("ScreenGui", CoreGui)
    statsGui.Name = "VoidStats"
    local frameStats = Instance.new("Frame", statsGui)
    frameStats.Size = UDim2.new(0, 160, 0, 70)
    frameStats.Position = UDim2.new(1, -180, 1, -80)
    frameStats.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frameStats.Active = true
    frameStats.Draggable = true
    Instance.new("UICorner", frameStats)

    local fpsLabel = Instance.new("TextLabel", frameStats)
    fpsLabel.Size = UDim2.new(1, 0, 0.33, 0)
    fpsLabel.TextColor3 = Color3.new(1, 1, 1)
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextScaled = true
    fpsLabel.Text = "⚡ FPS: 0"
    fpsLabel.BackgroundTransparency = 1

    local pingLabel = Instance.new("TextLabel", frameStats)
    pingLabel.Size = UDim2.new(1, 0, 0.33, 0)
    pingLabel.Position = UDim2.new(0, 0, 0.33, 0)
    pingLabel.TextColor3 = Color3.new(1, 1, 1)
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextScaled = true
    pingLabel.Text = "📶 Ping: --"
    pingLabel.BackgroundTransparency = 1

    local timeLabel = Instance.new("TextLabel", frameStats)
    timeLabel.Size = UDim2.new(1, 0, 0.33, 0)
    timeLabel.Position = UDim2.new(0, 0, 0.66, 0)
    timeLabel.TextColor3 = Color3.new(1, 1, 1)
    timeLabel.Font = Enum.Font.GothamBold
    timeLabel.TextScaled = true
    timeLabel.Text = "⏳ Playtime: 00:00:00"
    timeLabel.BackgroundTransparency = 1

    -- update stats every frame
    local lastTick = tick()
    local colorT = 0
    RunService_local.RenderStepped:Connect(function()
        local now = tick()
        local delta = now - lastTick
        lastTick = now
        local fps = math.floor(1 / math.max(delta, 0.0001))
        fpsLabel.Text = "⚡ FPS: " .. tostring(fps)

        -- try to get ping value; use pcall to avoid errors on some environments
        local success, s = pcall(function()
            local StatsService = game:GetService("Stats")
            local serverStats = StatsService and StatsService.Network and StatsService.Network.ServerStatsItem
            if serverStats and serverStats["Data Ping"] then
                return serverStats["Data Ping"]:GetValueString()
            end
            return nil
        end)
        if success and s then
            pingLabel.Text = "📶 Ping: " .. tostring(s)
        else
            -- fallback: display placeholder
            pingLabel.Text = "📶 Ping: --"
        end

        local elapsed = math.floor(now - sessionStart)
        local hrs = string.format("%02d", math.floor(elapsed / 3600))
        local mins = string.format("%02d", math.floor((elapsed % 3600) / 60))
        local secs = string.format("%02d", (elapsed % 60))
        timeLabel.Text = "⏳ Playtime: " .. hrs .. ":" .. mins .. ":" .. secs

        colorT += delta
        local color = rainbowColorLocal(colorT)
        fpsLabel.TextColor3 = color
        pingLabel.TextColor3 = color
        timeLabel.TextColor3 = color
    end)

    StarterGui:SetCore("SendNotification", {
        Title = "✅ Void Scripts Ready",
        Text = "Welcome. Everything's loaded.",
        Duration = 5
    })
end

-- ========== KEY SYSTEM ==========
-- build key GUI, rainbow outline matches the main panel style
local keyGui = Instance.new("ScreenGui", CoreGui)
keyGui.Name = "VoidKeySystem"
keyGui.ResetOnSpawn = false

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 320, 0, 190)
frame.Position = UDim2.new(0.5, -160, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

createRainbowStroke(frame, 3)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 44)
title.Position = UDim2.new(0, 0, 0, 6)
title.Text = "🔑 VoidScripts Key"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

local keyBox = Instance.new("TextBox", frame)
keyBox.Size = UDim2.new(0.86, 0, 0, 44)
keyBox.Position = UDim2.new(0.07, 0, 0, 56)
keyBox.PlaceholderText = "Enter key..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
keyBox.ClearTextOnFocus = false
Instance.new("UICorner", keyBox)

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Size = UDim2.new(0.42, 0, 0, 40)
submitBtn.Position = UDim2.new(0.07, 0, 0, 110)
submitBtn.Text = "Submit"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextScaled = true
submitBtn.BackgroundColor3 = Color3.fromRGB(40,120,40)
submitBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", submitBtn)

local getBtn = Instance.new("TextButton", frame)
getBtn.Size = UDim2.new(0.42, 0, 0, 40)
getBtn.Position = UDim2.new(0.51, 0, 0, 110)
getBtn.Text = "Get Key 🔑"
getBtn.Font = Enum.Font.GothamBold
getBtn.TextScaled = true
getBtn.BackgroundColor3 = Color3.fromRGB(60,60,120)
getBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", getBtn)

local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1, 0, 0, 16)
footer.Position = UDim2.new(0, 0, 1, -18)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextScaled = true
footer.Text = "Made by VoidScripts (rip_trollz98/vonplayz_real)"
footer.TextColor3 = Color3.new(1,1,1)

-- copy link
getBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(KEY_SITE)
        StarterGui:SetCore("SendNotification", {
            Title = "Copied!",
            Text = KEY_SITE,
            Duration = 3
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Clipboard not supported",
            Text = "Open: " .. KEY_SITE,
            Duration = 4
        })
    end
end)

-- submit check
submitBtn.MouseButton1Click:Connect(function()
    local entered = keyBox.Text
    for _, k in ipairs(VALID_KEYS) do
        if entered == k then
            StarterGui:SetCore("SendNotification", {
                Title = "✅ Key Accepted",
                Text = "Loading VoidScripts...",
                Duration = 3
            })
            -- fade & destroy key GUI
            TweenService:Create(frame, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()
            for _, c in pairs(frame:GetChildren()) do
                if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then
                    pcall(function()
                        TweenService:Create(c, TweenInfo.new(0.45), {TextTransparency = 1}):Play()
                    end)
                end
            end
            task.wait(0.55)
            keyGui:Destroy()

            -- load full UI locally
            loadVoidScripts()
            return
        end
    end
    keyBox.Text = ""
    keyBox.PlaceholderText = "❌ Wrong Key!"
end)
