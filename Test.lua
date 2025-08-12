--// CONFIG
local VALID_KEYS = { "Sub2Centu", "Sub2VoidScripts" }
local GET_KEY_URL = "https://voidcam.vercel.app"

--// SERVICES
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

--// Rainbow function
local function rainbowColor(t)
    return Color3.fromHSV((t * 0.5) % 1, 1, 1)
end

--// ===== MAIN VOID SCRIPTS FUNCTION =====
local function loadVoidScripts()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local lp = Players.LocalPlayer

    local camlockOn, speedOn, hitboxOn, infJumpOn = false, false, false, false
    local camTarget, speedValue, hitboxSize = nil, 16, 5
    local prediction = 0.13
    local originalSizes = {}
    local sessionStart = tick()

    local function rainbowColor(t)
        return Color3.fromHSV((t * 0.5) % 1, 1, 1)
    end

    local function createSound(id, parent)
        local s = Instance.new("Sound", parent or CoreGui)
        s.SoundId = "rbxassetid://" .. id
        s.Volume = 1
        return s
    end

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "VoidScriptsGUI"

    local clickSound = createSound("1837635154")
    createSound("115780308685053"):Play()

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

    local panel = Instance.new("Frame", gui)
    panel.Size = UDim2.new(0, 200, 0, 150)
    panel.Position = UDim2.new(0, 70, 0.5, -75)
    panel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    panel.Visible = false
    panel.Active = true
    panel.Draggable = true
    Instance.new("UICorner", panel)

    local outline = Instance.new("UIStroke", panel)
    outline.Thickness = 3
    outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    task.spawn(function()
        local t = 0
        while panel.Parent do
            t += task.wait()
            outline.Color = rainbowColor(t)
        end
    end)

    local layout = Instance.new("UIListLayout", panel)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local padding = Instance.new("UIPadding", panel)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)

    toggle.MouseButton1Click:Connect(function()
        clickSound:Play()
        panel.Visible = not panel.Visible
        toggle.Text = panel.Visible and "-" or "+"
    end)

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
            clickSound:Play()
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

    local footer = Instance.new("TextLabel", panel)
    footer.Size = UDim2.new(1, 0, 0, 20)
    footer.Text = "Made by VoidScripts (rip_trollz98/vonplayz_real)"
    footer.TextScaled = true
    footer.Font = Enum.Font.Gotham
    footer.TextColor3 = Color3.new(1, 1, 1)
    footer.BackgroundTransparency = 1
end

--// ===== KEY SYSTEM =====
local keyGui = Instance.new("ScreenGui", CoreGui)
keyGui.Name = "VoidKeySystem"

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", frame)

local outline = Instance.new("UIStroke", frame)
outline.Thickness = 3
outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
task.spawn(function()
    local t = 0
    while frame.Parent do
        t += task.wait()
        outline.Color = rainbowColor(t)
    end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔑 Enter Key"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local keyBox = Instance.new("TextBox", frame)
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
keyBox.PlaceholderText = "Enter your key..."
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", keyBox)

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Size = UDim2.new(0.35, 0, 0, 35)
submitBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
submitBtn.Text = "✅ Submit"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextScaled = true
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
Instance.new("UICorner", submitBtn)

local getKeyBtn = Instance.new("TextButton", frame)
getKeyBtn.Size = UDim2.new(0.35, 0, 0, 35)
getKeyBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
getKeyBtn.Text = "🔗 Get Key"
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.TextScaled = true
getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 150)
Instance.new("UICorner", getKeyBtn)

getKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(GET_KEY_URL)
        StarterGui:SetCore("SendNotification", {
            Title = "✅ Key Link Copied!",
            Text = GET_KEY_URL,
            Duration = 3
        })
    end
end)

submitBtn.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    for _, validKey in ipairs(VALID_KEYS) do
        if enteredKey == validKey then
            frame:Destroy()
            keyGui:Destroy()
            loadVoidScripts()
            return
        end
    end
    keyBox.Text = ""
    keyBox.PlaceholderText = "❌ Wrong Key!"
end)
