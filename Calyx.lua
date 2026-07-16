local Library = {}
Library.__index = Library

local Theme = {
    Background = Color3.fromRGB(28, 28, 34),
    TabBar = Color3.fromRGB(20, 20, 25),
    TabActive = Color3.fromRGB(42, 42, 52),
    TabInactive = Color3.fromRGB(28, 28, 34),
    TabHover = Color3.fromRGB(35, 35, 43),
    Text = Color3.fromRGB(225, 225, 230),
    TextDim = Color3.fromRGB(130, 130, 140),
    Accent = Color3.fromRGB(72, 145, 255),
    SwitchOn = Color3.fromRGB(72, 210, 120),
    SwitchOff = Color3.fromRGB(55, 55, 62),
    SliderTrack = Color3.fromRGB(45, 45, 52),
    Dropdown = Color3.fromRGB(38, 38, 46),
    DropdownHover = Color3.fromRGB(50, 50, 60),
    Button = Color3.fromRGB(45, 45, 55),
    ButtonHover = Color3.fromRGB(60, 60, 72),
    SectionBg = Color3.fromRGB(33, 33, 40),
    AnyTabBg = Color3.fromRGB(18, 18, 22),
    Border = Color3.fromRGB(50, 50, 58),
}

local Font = Enum.Font.Gotham
local TitleSize = 14
local TextSize = 12
local SmallSize = 11
local CornerRad = 6

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    return TweenService:Create(obj, info, props)
end

local function AddCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or CornerRad)
    c.Parent = parent
    return c
end

local function AddStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function MakeLabel(props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Font = Font
    l.TextSize = TextSize
    l.TextColor3 = Theme.Text
    for k, v in pairs(props or {}) do l[k] = v end
    return l
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:Create(name, size, position)
    local Gui = Instance.new("ScreenGui")
    Gui.Name = name or "Calyx"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.IgnoreGuiInset = true
    pcall(function() Gui.Parent = game:GetService("CoreGui") end)
    if not Gui.Parent then
        Gui.Parent = PlayerGui
    end

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = size or UDim2.new(0, 520, 0, 420)
    Main.Position = position or UDim2.new(0.5, -260, 0.5, -210)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = Gui
    AddCorner(Main, 10)
    AddStroke(Main, Theme.Border, 1)
    MakeDraggable(Main)

    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    AccentLine.BackgroundColor3 = Theme.Accent
    AccentLine.BorderSizePixel = 0
    AccentLine.ZIndex = 5
    AccentLine.Parent = Main

    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(0, 135, 1, 0)
    TabBar.BackgroundColor3 = Theme.TabBar
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Main
    AddCorner(TabBar, 10)

    local TabBarClip = Instance.new("Frame")
    TabBarClip.Name = "Clip"
    TabBarClip.Size = UDim2.new(1, 0, 1, 0)
    TabBarClip.BackgroundTransparency = 1
    TabBarClip.ClipsDescendants = true
    TabBarClip.Parent = TabBar

    local Title = MakeLabel({
        Name = "Title",
        Size = UDim2.new(1, -16, 0, 40),
        Position = UDim2.new(0, 12, 0, 6),
        Text = name or "Calyx",
        TextSize = TitleSize,
        Font = Font,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Title.Parent = TabBarClip

    local Sep = Instance.new("Frame")
    Sep.Size = UDim2.new(1, -20, 0, 1)
    Sep.Position = UDim2.new(0, 10, 0, 42)
    Sep.BackgroundColor3 = Theme.Border
    Sep.BorderSizePixel = 0
    Sep.BackgroundTransparency = 0.5
    Sep.Parent = TabBarClip

    local TabList = Instance.new("Frame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, -52)
    TabList.Position = UDim2.new(0, 0, 0, 52)
    TabList.BackgroundTransparency = 1
    TabList.Parent = TabBarClip

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 3)
    TabListLayout.Parent = TabList

    local TabListPadding = Instance.new("UIPadding")
    TabListPadding.PaddingLeft = UDim.new(0, 6)
    TabListPadding.PaddingRight = UDim.new(0, 6)
    TabListPadding.PaddingTop = UDim.new(0, 4)
    TabListPadding.PaddingBottom = UDim.new(0, 6)
    TabListPadding.Parent = TabList

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -135, 1, 0)
    ContentArea.Position = UDim2.new(0, 135, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = Main

    local self = setmetatable({
        Gui = Gui,
        Main = Main,
        TabBar = TabBar,
        TabList = TabList,
        TabListLayout = TabListLayout,
        ContentArea = ContentArea,
        Tabs = {},
        TabOrder = 0,
        CurrentTab = nil,
    }, Library)

    return self
end

function Library:Tab(name, anytab)
    if anytab == nil then anytab = false end
    self.TabOrder = self.TabOrder + 1
    local order = self.TabOrder

    local tabData = {
        Name = name,
        IsAnyTab = anytab,
        ContentFrame = nil,
        Button = nil,
        Scroll = nil,
        Layout = nil,
        ElementOrder = 0,
    }

    local Btn = Instance.new("TextButton")
    Btn.Name = "Tab_" .. name
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Theme.TabInactive
    Btn.BorderSizePixel = 0
    Btn.Text = "  " .. name
    Btn.TextColor3 = Theme.TextDim
    Btn.Font = Font
    Btn.TextSize = SmallSize
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Btn.LayoutOrder = order
    Btn.Parent = self.TabList
    AddCorner(Btn, 6)

    Btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            Tween(Btn, {BackgroundColor3 = Theme.TabHover}, 0.15):Play()
        end
    end)
    Btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            Tween(Btn, {BackgroundColor3 = Theme.TabInactive}, 0.15):Play()
        end
    end)

    local Content = Instance.new("Frame")
    Content.Name = name .. "_Content"
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.BackgroundTransparency = 1
    Content.Visible = false
    Content.ClipsDescendants = true
    Content.Parent = self.ContentArea

    tabData.ContentFrame = Content
    tabData.Button = Btn

    if anytab then
        Content.BackgroundTransparency = 0
        Content.BackgroundColor3 = Theme.AnyTabBg
    else
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Name = "Scroll"
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.BackgroundTransparency = 1
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = Theme.Border
        Scroll.BorderSizePixel = 0
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Scroll.ScrollBarImageTransparency = 0.4
        Scroll.Parent = Content

        local Layout = Instance.new("UIListLayout")
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 6)
        Layout.Parent = Scroll

        local Pad = Instance.new("UIPadding")
        Pad.PaddingTop = UDim.new(0, 12)
        Pad.PaddingLeft = UDim.new(0, 12)
        Pad.PaddingRight = UDim.new(0, 12)
        Pad.PaddingBottom = UDim.new(0, 12)
        Pad.Parent = Scroll

        tabData.Scroll = Scroll
        tabData.Layout = Layout
    end

    Btn.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)

    table.insert(self.Tabs, tabData)

    if #self.Tabs == 1 then
        self:SelectTab(name)
    end

    local tabObj = {}
    tabObj._data = tabData
    tabObj._lib = self

    function tabObj:Button(text, callback)
        return self._lib:AddButton(self._data, text, callback)
    end

    function tabObj:Toggle(text, default, callback)
        return self._lib:AddToggle(self._data, text, default, callback)
    end

    function tabObj:Slider(text, min, max, default, callback)
        return self._lib:AddSlider(self._data, text, min, max, default, callback)
    end

    function tabObj:Dropdown(text, options, default, callback)
        return self._lib:AddDropdown(self._data, text, options, default, callback)
    end

    function tabObj:Section(text)
        return self._lib:AddSection(self._data, text)
    end

    function tabObj:Label(text)
        return self._lib:AddLabel(self._data, text)
    end

    function tabObj:GetFrame()
        return self._data.ContentFrame
    end

    return tabObj
end

function Library:SelectTab(name)
    for _, tab in pairs(self.Tabs) do
        local active = (tab.Name == name)
        tab.ContentFrame.Visible = active
        if active then
            Tween(tab.Button, {BackgroundColor3 = Theme.TabActive}, 0.2):Play()
            tab.Button.TextColor3 = Theme.Text
        else
            Tween(tab.Button, {BackgroundColor3 = Theme.TabInactive}, 0.2):Play()
            tab.Button.TextColor3 = Theme.TextDim
        end
    end
    self.CurrentTab = name
end

function Library:AddButton(tabData, text, callback)
    local parent = tabData.Scroll or tabData.ContentFrame
    tabData.ElementOrder = tabData.ElementOrder + 1

    local Btn = Instance.new("TextButton")
    Btn.Name = "Button_" .. text
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = Theme.Button
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Font
    Btn.TextSize = TextSize
    Btn.AutoButtonColor = false
    Btn.LayoutOrder = tabData.ElementOrder
    Btn.Parent = parent
    AddCorner(Btn)

    Btn.MouseEnter:Connect(function()
        Tween(Btn, {BackgroundColor3 = Theme.ButtonHover}, 0.15):Play()
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn, {BackgroundColor3 = Theme.Button}, 0.15):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.08):Play()
        task.delay(0.08, function()
            Tween(Btn, {BackgroundColor3 = Theme.ButtonHover}, 0.15):Play()
        end)
        if callback then callback() end
    end)

    return {Instance = Btn}
end

function Library:AddToggle(tabData, text, default, callback)
    local parent = tabData.Scroll or tabData.ContentFrame
    tabData.ElementOrder = tabData.ElementOrder + 1
    local toggled = default or false

    local Container = Instance.new("Frame")
    Container.Name = "Toggle_" .. text
    Container.Size = UDim2.new(1, 0, 0, 34)
    Container.BackgroundTransparency = 1
    Container.LayoutOrder = tabData.ElementOrder
    Container.Parent = parent

    local Label = MakeLabel({
        Size = UDim2.new(1, -52, 1, 0),
        Text = text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Label.Parent = Container

    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(0, 42, 0, 22)
    Track.Position = UDim2.new(1, -42, 0.5, -11)
    Track.BackgroundColor3 = toggled and Theme.SwitchOn or Theme.SwitchOff
    Track.BorderSizePixel = 0
    Track.Parent = Container
    AddCorner(Track, 11)

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track
    AddCorner(Knob, 9)

    local Click = Instance.new("TextButton")
    Click.Size = UDim2.new(1, 0, 1, 0)
    Click.BackgroundTransparency = 1
    Click.Text = ""
    Click.Parent = Container

    Click.MouseButton1Click:Connect(function()
        toggled = not toggled
        Tween(Track, {BackgroundColor3 = toggled and Theme.SwitchOn or Theme.SwitchOff}, 0.25):Play()
        Tween(Knob, {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.25):Play()
        if callback then callback(toggled) end
    end)

    return {
        Instance = Container,
        Get = function() return toggled end,
        Set = function(v)
            toggled = v
            Track.BackgroundColor3 = v and Theme.SwitchOn or Theme.SwitchOff
            Knob.Position = v and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        end,
    }
end

function Library:AddSlider(tabData, text, min, max, default, callback)
    local parent = tabData.Scroll or tabData.ContentFrame
    tabData.ElementOrder = tabData.ElementOrder + 1
    local value = default or min
    local dragging = false

    local Container = Instance.new("Frame")
    Container.Name = "Slider_" .. text
    Container.Size = UDim2.new(1, 0, 0, 52)
    Container.BackgroundTransparency = 1
    Container.LayoutOrder = tabData.ElementOrder
    Container.Parent = parent

    local Label = MakeLabel({
        Size = UDim2.new(0.65, 0, 0, 20),
        Text = text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Label.Parent = Container

    local ValLabel = MakeLabel({
        Size = UDim2.new(0.35, 0, 0, 20),
        Position = UDim2.new(0.65, 0, 0, 0),
        Text = tostring(value),
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextSize = SmallSize,
    })
    ValLabel.Parent = Container

    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(1, 0, 0, 8)
    Track.Position = UDim2.new(0, 0, 0, 30)
    Track.BackgroundColor3 = Theme.SliderTrack
    Track.BorderSizePixel = 0
    Track.Parent = Container
    AddCorner(Track, 4)

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    local pct = (value - min) / (max - min)
    Fill.Size = UDim2.new(pct, 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    AddCorner(Fill, 4)

    local Handle = Instance.new("Frame")
    Handle.Name = "Handle"
    Handle.Size = UDim2.new(0, 16, 0, 16)
    Handle.Position = UDim2.new(pct, -8, 0.5, -8)
    Handle.BackgroundColor3 = Theme.Accent
    Handle.BorderSizePixel = 0
    Handle.Parent = Track
    AddCorner(Handle, 8)

    local Ring = Instance.new("UIStroke")
    Ring.Color = Color3.fromRGB(255, 255, 255)
    Ring.Thickness = 1.5
    Ring.Transparency = 0.6
    Ring.Parent = Handle

    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 0, 26)
    ClickArea.Position = UDim2.new(0, 0, 0, 22)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = Container

    local function update(input)
        local relX = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * relX
        value = math.floor(value * 100 + 0.5) / 100
        Fill.Size = UDim2.new(relX, 0, 1, 0)
        Handle.Position = UDim2.new(relX, -8, 0.5, -8)
        ValLabel.Text = tostring(value)
        if callback then callback(value) end
    end

    ClickArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    ClickArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local conn
    conn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    Container.AncestryChanged:Connect(function(_, parent)
        if not parent then conn:Disconnect() end
    end)

    return {
        Instance = Container,
        Get = function() return value end,
        Set = function(v)
            value = math.clamp(v, min, max)
            local r = (value - min) / (max - min)
            Fill.Size = UDim2.new(r, 0, 1, 0)
            Handle.Position = UDim2.new(r, -8, 0.5, -8)
            ValLabel.Text = tostring(value)
        end,
    }
end

function Library:AddDropdown(tabData, text, options, default, callback)
    local parent = tabData.Scroll or tabData.ContentFrame
    tabData.ElementOrder = tabData.ElementOrder + 1
    local selected = default or (options and options[1]) or ""
    local isOpen = false

    local Container = Instance.new("Frame")
    Container.Name = "Dropdown_" .. text
    Container.Size = UDim2.new(1, 0, 0, 34)
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = false
    Container.LayoutOrder = tabData.ElementOrder
    Container.Parent = parent

    local Main = Instance.new("TextButton")
    Main.Name = "Main"
    Main.Size = UDim2.new(1, 0, 0, 34)
    Main.BackgroundColor3 = Theme.Dropdown
    Main.BorderSizePixel = 0
    Main.Text = ""
    Main.AutoButtonColor = false
    Main.ZIndex = 10
    Main.Parent = Container
    AddCorner(Main)

    local Label = MakeLabel({
        Size = UDim2.new(1, -32, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Text = text .. ":  " .. selected,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = SmallSize,
    })
    Label.ZIndex = 11
    Label.Parent = Main

    local Arrow = MakeLabel({
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -24, 0.5, -10),
        Text = "\226\136\189",
        TextColor3 = Theme.TextDim,
        TextSize = TextSize,
    })
    Arrow.ZIndex = 11
    Arrow.Parent = Main

    local Options = Instance.new("Frame")
    Options.Name = "Options"
    Options.Size = UDim2.new(1, 0, 0, 0)
    Options.Position = UDim2.new(0, 0, 1, 4)
    Options.BackgroundColor3 = Theme.Dropdown
    Options.BorderSizePixel = 0
    Options.ClipsDescendants = true
    Options.Visible = false
    Options.ZIndex = 20
    Options.Parent = Container
    AddCorner(Options)
    AddStroke(Options, Theme.Border, 1)

    local OptLayout = Instance.new("UIListLayout")
    OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptLayout.Padding = UDim.new(0, 2)
    OptLayout.Parent = Options

    local OptPad = Instance.new("UIPadding")
    OptPad.PaddingTop = UDim.new(0, 4)
    OptPad.PaddingBottom = UDim.new(0, 4)
    OptPad.Parent = Options

    local optionButtons = {}

    local function buildOptions(optList)
        for _, btn in pairs(optionButtons) do
            if btn.Parent then btn:Destroy() end
        end
        optionButtons = {}
        for i, opt in ipairs(optList or {}) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Name = "Opt_" .. opt
            OptBtn.Size = UDim2.new(1, -12, 0, 28)
            OptBtn.Position = UDim2.new(0, 6, 0, 0)
            OptBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            OptBtn.BackgroundTransparency = (opt == selected) and 0.85 or 1
            OptBtn.BorderSizePixel = 0
            OptBtn.Text = opt
            OptBtn.TextColor3 = (opt == selected) and Theme.Accent or Theme.Text
            OptBtn.Font = Font
            OptBtn.TextSize = SmallSize
            OptBtn.AutoButtonColor = false
            OptBtn.LayoutOrder = i
            OptBtn.ZIndex = 21
            OptBtn.Parent = Options
            optionButtons[opt] = OptBtn

            OptBtn.MouseEnter:Connect(function()
                if opt ~= selected then
                    Tween(OptBtn, {BackgroundTransparency = 0.88, BackgroundColor3 = Theme.DropdownHover}, 0.12):Play()
                end
            end)
            OptBtn.MouseLeave:Connect(function()
                if opt ~= selected then
                    Tween(OptBtn, {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.12):Play()
                end
            end)

            OptBtn.MouseButton1Click:Connect(function()
                selected = opt
                Label.Text = text .. ":  " .. selected
                for name, btn in pairs(optionButtons) do
                    local isSel = (name == selected)
                    btn.TextColor3 = isSel and Theme.Accent or Theme.Text
                    Tween(btn, {BackgroundTransparency = isSel and 0.85 or 1, BackgroundColor3 = isSel and Theme.Accent or Color3.fromRGB(255, 255, 255)}, 0.12):Play()
                end
                isOpen = false
                Options.Visible = false
                Arrow.Text = "\226\136\189"
                Tween(Container, {Size = UDim2.new(1, 0, 0, 34)}, 0.2):Play()
                if callback then callback(selected) end
            end)
        end
    end

    buildOptions(options)
    Options.AutomaticSize = Enum.AutomaticSize.Y

    Main.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            Options.Visible = true
            Arrow.Text = "\226\136\161"
            task.defer(function()
                local targetH = 34 + Options.AbsoluteSize.Y + 6
                Tween(Container, {Size = UDim2.new(1, 0, 0, targetH)}, 0.2):Play()
            end)
        else
            Arrow.Text = "\226\136\189"
            Tween(Container, {Size = UDim2.new(1, 0, 0, 34)}, 0.2):Play()
            task.delay(0.2, function()
                Options.Visible = false
            end)
        end
    end)

    local closeConn
    closeConn = UserInputService.InputBegan:Connect(function(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = input.Position
            local abs = Container.AbsolutePosition
            local siz = Container.AbsoluteSize
            if pos.X < abs.X or pos.X > abs.X + siz.X or pos.Y < abs.Y or pos.Y > abs.Y + siz.Y + 200 then
                isOpen = false
                Arrow.Text = "\226\136\189"
                Tween(Container, {Size = UDim2.new(1, 0, 0, 34)}, 0.2):Play()
                task.delay(0.2, function()
                    Options.Visible = false
                end)
            end
        end
    end)

    Container.AncestryChanged:Connect(function(_, p)
        if not p then closeConn:Disconnect() end
    end)

    return {
        Instance = Container,
        Get = function() return selected end,
        Set = function(v)
            selected = v
            Label.Text = text .. ":  " .. selected
            for name, btn in pairs(optionButtons) do
                local isSel = (name == selected)
                btn.TextColor3 = isSel and Theme.Accent or Theme.Text
                btn.BackgroundTransparency = isSel and 0.85 or 1
            end
        end,
        Refresh = function(newOptions)
            buildOptions(newOptions)
        end,
    }
end

function Library:AddSection(tabData, text)
    local parent = tabData.Scroll or tabData.ContentFrame
    tabData.ElementOrder = tabData.ElementOrder + 1

    local Container = Instance.new("Frame")
    Container.Name = "Section_" .. text
    Container.Size = UDim2.new(1, 0, 0, 26)
    Container.BackgroundColor3 = Theme.SectionBg
    Container.BorderSizePixel = 0
    Container.LayoutOrder = tabData.ElementOrder
    Container.Parent = parent
    AddCorner(Container, 4)

    local Label = MakeLabel({
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = text:upper(),
        TextSize = 10,
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Label.Parent = Container

    return {Instance = Container}
end

function Library:AddLabel(tabData, text)
    local parent = tabData.Scroll or tabData.ContentFrame
    tabData.ElementOrder = tabData.ElementOrder + 1

    local Label = MakeLabel({
        Name = "Label_" .. text,
        Size = UDim2.new(1, 0, 0, 18),
        Text = text,
        TextSize = SmallSize,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = tabData.ElementOrder,
    })
    Label.Parent = parent

    return {
        Instance = Label,
        Set = function(newText) Label.Text = newText end,
    }
end

function Library:SetTheme(newTheme)
    for k, v in pairs(newTheme) do
        if Theme[k] then Theme[k] = v end
    end
end

function Library:Destroy()
    if self.Gui then self.Gui:Destroy() end
end

return Library
