local library = {}
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local core = game:GetService("CoreGui")
local players = game:GetService("Players")

library.theme = {
    bg = Color3.fromRGB(10, 10, 12),
    accent = Color3.fromRGB(110, 80, 255),
    text = Color3.fromRGB(255, 255, 255),
    subtext = Color3.fromRGB(140, 140, 150),
    module_on = Color3.fromRGB(110, 80, 255),
    module_off = Color3.fromRGB(255, 255, 255),
    setting_bg = Color3.fromRGB(16, 16, 20),
    font = Enum.Font.Ubuntu,
    blur_size = 16,
    transparency = 0.15,
    lowercase = true,
    rainbow = false
}

local elements = {glows = {}, toggles = {}, fills = {}, panels = {}, lists = {}}

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function format_text(str) 
    return library.theme.lowercase and string.lower(tostring(str)) or tostring(str) 
end

function library:update_theme()
    if self.blur then self.blur.Size = self.theme.blur_size end
    for _, g in pairs(elements.glows) do g.BackgroundColor3 = self.theme.accent end
    for _, f in pairs(elements.fills) do f.BackgroundColor3 = self.theme.accent end
    for _, p in pairs(elements.panels) do p.BackgroundTransparency = self.theme.transparency end
    for _, l in pairs(elements.lists) do l.BackgroundTransparency = self.theme.transparency + 0.1 end
    for mod, btn in pairs(elements.toggles) do
        if mod.active then btn.TextColor3 = self.theme.accent end
    end
end

run.RenderStepped:Connect(function()
    if library.theme.rainbow then
        local hue = tick() % 5 / 5
        library.theme.accent = Color3.fromHSV(hue, 0.7, 1)
        library:update_theme()
    end
end)

local function makedrag(frame, handle)
    handle = handle or frame
    local dragging, input, start, pos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true start = i.Position pos = frame.Position
        end
    end)
    uis.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - start
            ts:Create(frame, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)}):Play()
        end
    end)
    uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

function library:init(name)
    self.name = name or "shadowui"
    self.sg = create("ScreenGui", {Name = "shadow_ui", Parent = core, ResetOnSpawn = false})
    self.container = create("Frame", {Name = "container", Parent = self.sg, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = true})
    self.blur = create("BlurEffect", {Parent = game:GetService("Lighting"), Size = self.theme.blur_size, Name = "shadow_blur"})
    local visible = true

    uis.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightShift then
            visible = not visible
            self.container.Visible = visible
            ts:Create(self.blur, TweenInfo.new(0.4), {Size = visible and self.theme.blur_size or 0}):Play()
        end
    end)

    function library:create_watermark()
        local wm_frame = create("Frame", {Name = "watermark", Parent = self.sg, BackgroundColor3 = Color3.fromRGB(10, 10, 12), BackgroundTransparency = 0.2, Position = UDim2.new(0, 15, 0, 15), Size = UDim2.new(0, 0, 0, 30), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X})
        create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = wm_frame})
        local line = create("Frame", {Parent = wm_frame, Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 255))}), Parent = line})
        local content = create("Frame", {Parent = wm_frame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X})
        create("UIListLayout", {Parent = content, FillDirection = "Horizontal", VerticalAlignment = "Center"})
        create("UIPadding", {Parent = content, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
        local title_label = create("TextLabel", {Parent = content, BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), Font = self.theme.font, Text = format_text(self.name), TextColor3 = Color3.new(1,1,1), TextSize = 14, AutomaticSize = "X"})
        create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 255))}), Parent = title_label})
        local info_label = create("TextLabel", {Parent = content, BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), Font = self.theme.font, Text = "", TextColor3 = Color3.new(1,1,1), TextSize = 14, AutomaticSize = "X"})
        local fps = 0
        run.RenderStepped:Connect(function(dt)
            fps = math.floor(1/dt)
            info_label.Text = format_text(" | " .. players.LocalPlayer.Name .. " | " .. fps .. " fps")
        end)
    end

    function library:create_category(cat_name, pos)
        local cat = {}
        local panel = create("Frame", {Name = format_text(cat_name) .. "_panel", Parent = self.container, BackgroundColor3 = self.theme.bg, BackgroundTransparency = self.theme.transparency, Position = pos or UDim2.new(0, 100, 0, 100), Size = UDim2.new(0, 220, 0, 42), BorderSizePixel = 0})
        table.insert(elements.panels, panel)
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = panel})
        local glow = create("Frame", {Parent = panel, BackgroundColor3 = self.theme.accent, BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2)})
        table.insert(elements.glows, glow)
        local title = create("TextLabel", {Parent = panel, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = self.theme.font, Text = format_text(cat_name), TextColor3 = self.theme.text, TextSize = 18})
        local list = create("Frame", {Parent = panel, BackgroundColor3 = self.theme.bg, BackgroundTransparency = self.theme.transparency + 0.1, Position = UDim2.new(0, 0, 1, 3), Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y})
        table.insert(elements.lists, list)
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = list})
        create("UIListLayout", {Parent = list, Padding = UDim.new(0, 2)})
        makedrag(panel)
        function cat:add_module(m_name, cb)
            local mod = {active = false, open = false}
            local btn = create("TextButton", {Parent = list, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), Font = self.theme.font, Text = "   " .. format_text(m_name), TextColor3 = self.theme.module_off, TextSize = 16, TextXAlignment = "Left", AutoButtonColor = false})
            elements.toggles[mod] = btn
            local settings = create("Frame", {Parent = list, BackgroundColor3 = self.theme.setting_bg, BackgroundTransparency = 0.4, Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0, ClipsDescendants = true, Visible = false, AutomaticSize = Enum.AutomaticSize.Y})
            create("UIListLayout", {Parent = settings})
            btn.MouseButton1Click:Connect(function()
                mod.active = not mod.active
                ts:Create(btn, TweenInfo.new(0.35), {TextColor3 = mod.active and lib.theme.accent or self.theme.module_off}):Play()
                cb(mod.active)
            end)
            btn.MouseButton2Click:Connect(function()
                mod.open = not mod.open
                settings.Visible = mod.open
                ts:Create(settings, TweenInfo.new(0.4), {BackgroundTransparency = mod.open and 0.4 or 1}):Play()
            end)
            function mod:add_toggle(s_name, def, scb)
                local s = def
                local t_btn = create("TextButton", {Parent = settings, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Font = self.theme.font, Text = "     " .. format_text(s_name) .. ": " .. (s and "on" or "off"), TextColor3 = s and lib.theme.accent or self.theme.subtext, TextSize = 13, TextXAlignment = "Left"})
                t_btn.MouseButton1Click:Connect(function()
                    s = not s
                    t_btn.Text = "     " .. format_text(s_name) .. ": " .. (s and "on" or "off")
                    ts:Create(t_btn, TweenInfo.new(0.2), {TextColor3 = s and lib.theme.accent or self.theme.subtext}):Play()
                    scb(s)
                end)
            end
            function mod:add_slider(s_name, min, max, def, scb)
                local f = create("Frame", {Parent = settings, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44)})
                local l = create("TextLabel", {Parent = f, BackgroundTransparency = 1, Position = UDim2.new(0, 22, 0, 6), Size = UDim2.new(1, -30, 0, 16), Font = self.theme.font, Text = format_text(s_name) .. ": " .. def, TextColor3 = self.theme.subtext, TextSize = 12, TextXAlignment = "Left"})
                local b = create("Frame", {Parent = f, BackgroundColor3 = Color3.fromRGB(35, 35, 40), Position = UDim2.new(0, 22, 0, 28), Size = UDim2.new(1, -44, 0, 5), BorderSizePixel = 0})
                local fill = create("Frame", {Parent = b, BackgroundColor3 = lib.theme.accent, Size = UDim2.new((def-min)/(max-min), 0, 1, 0), BorderSizePixel = 0})
                table.insert(elements.fills, fill)
                local c = create("TextButton", {Parent = b, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""})
                local d = false
                local function u()
                    local p = math.clamp((uis:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
                    ts:Create(fill, TweenInfo.new(0.15), {Size = UDim2.new(p, 0, 1, 0)}):Play()
                    local v = math.floor(min + (max-min)*p)
                    l.Text = format_text(s_name) .. ": " .. v
                    scb(v)
                end
                c.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true u() end end)
                uis.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then u() end end)
                uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
            end
            return mod
        end
        return cat
    end
    return self
end

return library
