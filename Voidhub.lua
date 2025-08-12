-- FULL VOID SCRIPTS WITH MODERN KEY SYSTEM
-- Keys: Sub2Centu, Sub2VoidScripts
-- Get keys: https://voidcam.vercel.app

-- ========== CONFIG ==========
local PANEL_WIDTH  = 200 -- change panel width
local PANEL_HEIGHT = 200 -- change panel height
local VALID_KEYS = { "Sub2Centu", "Sub2VoidScripts" }
local KEY_SITE = "https://voidcam.vercel.app"
local KEY_RESET_TIME = 86400 -- 24h in seconds

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

local function notify(title, text, dur)
    StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = dur or 3 })
end

-- ========== MAIN VOID SCRIPTS ==========
local function loadVoidScripts()
    local camlockOn, speedOn, hitboxOn, infJumpOn, jumpBoostOn = false, false, false, false, false
    local camTarget, speedValue, hitboxSize, jumpBoostValue = nil, 16, 5, 50
    local prediction = 0.13
    local originalSizes = {}
    local sessionStart = tick()

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "VoidScriptsGUI"
    gui.ResetOnSpawn = false

    -- toggle button
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

    -- main panel
    local panel = Instance.new("Frame", gui)
    panel.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
    panel.Position = UDim2.new(0, 70, 0.5, -PANEL_HEIGHT / 2)
    panel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    panel.Visible = false
    panel.Active = true
    panel.Draggable = true
    Instance.new("UICorner", panel)
    createRainbowStroke(panel, 2)

    -- footer
    local footer = Instance.new("TextLabel", panel)
    footer.Size = UDim2.new(1, 0, 0, 18)
    footer.Position = UDim2.new(0, 0, 1, -18)
    footer.BackgroundTransparency = 1
    footer.Font = Enum.Font.Gotham
    footer.TextScaled = true
    footer.Text = "Made by VoidScripts (rip_trollz98/vonplayz_real)"
    footer.TextColor3 = Color3.new(1, 1, 1)

    local layout = Instance.new("UIListLayout", panel)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local padding = Instance.new("UIPadding", panel)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)

    toggle.MouseButton1Click:Connect(function()
        panel.Visible = not panel.Visible
        toggle.Text = panel.Visible and "-" or "+"
    end)

    local function createControl(name, default, min, max, toggleCallback, valueCallback)
        local row = Instance.new("Frame", panel)
        row.Size = UDim2.new(1, 0, 0, 28)
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
    createControl("🎯 Hitbox", 5, 1, 50, function(v) hitboxOn = v end, function(v) hitboxSize = v end)
    createControl("🪂 Inf Jump", 0, 0, 0, function(v) infJumpOn = v end)
    createControl("🚀 Jump Boost", 50, 25, 300, function(v) jumpBoostOn = v end, function(v) jumpBoostValue = v end)

    -- Infinite Jump
    UserInputService.JumpRequest:Connect(function()
        if infJumpOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- VoidCam Button
    local camBtn = Instance.new("TextButton", gui)
    camBtn.Size = UDim2.new(0, 160, 0, 40)
    camBtn.Position = UDim2.new(0, 20, 1, -60)
    camBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    camBtn.Text = "VoidCam: OFF"
    camBtn.TextScaled = true
    camBtn.Font = Enum.Font.GothamBold
    camBtn.TextColor3 = Color3.new(0, 0, 0)
    camBtn.Active = true
    camBtn.Draggable = true
    Instance.new("UICorner", camBtn)
    createRainbowStroke(camBtn, 3)

    camBtn.MouseButton1Click:Connect(function()
        camlockOn = not camlockOn
        camBtn.Text = camlockOn and "VoidCam: ON" or "VoidCam: OFF"
        if camlockOn then
            local closest, shortest = nil, math.huge
            local cam = workspace.CurrentCamera
            local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
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
                notify("🎯 VOIDCAM LOCKED", "Target: " .. camTarget.DisplayName, 3)
            else
                notify("❌ VOIDCAM", "No players found!", 3)
                camlockOn = false
                camBtn.Text = "VoidCam: OFF"
            end
        end
    end)

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
                    if not originalSizes[p] then originalSizes[p] = hrp.Size end
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Material = Enum.Material.Neon
                    hrp.Transparency = 0.5
                    hrp.CanCollide = false
                end
            end
        else
            for p, sz in pairs(originalSizes) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = sz
                end
            end
            originalSizes = {}
        end
    end)

    notify("✅ Void Scripts Ready", "Welcome. Everything's loaded.", 5)
end

-- ========== MODERN 24H KEY SYSTEM ==========
if getgenv().VoidKey and getgenv().VoidKeyTime and (tick() - getgenv().VoidKeyTime < KEY_RESET_TIME) then
    loadVoidScripts()
else
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

    getBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(KEY_SITE)
            notify("Copied!", KEY_SITE, 3)
        else
            notify("Clipboard not supported", "Open: " .. KEY_SITE, 4)
        end
    end)

    local function checkKey()
        local entered = keyBox.Text
        for _, k in ipairs(VALID_KEYS) do
            if entered == k then
                getgenv().VoidKey = entered
                getgenv().VoidKeyTime = tick()
                TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                for _, c in pairs(frame:GetChildren()) do
                    if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then
                        TweenService:Create(c, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                    end
                end
                task.wait(0.45)
                keyGui:Destroy()
                loadVoidScripts()
                return
            end
        end
        keyBox.Text = ""
        keyBox.PlaceholderText = "❌ Wrong Key!"
    end

    submitBtn.MouseButton1Click:Connect(checkKey)
    keyBox.FocusLost:Connect(function(enter) if enter then checkKey() end end)
end
