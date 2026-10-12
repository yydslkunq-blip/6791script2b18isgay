-- V0id Hub | Combat Initiation
-- made by v0idPlaysGD
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- detect mobile so we can scale things up
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- grab the tool from backpack or character, whichever has it
local function getTool(name)
    return player.Backpack:FindFirstChild(name)
        or (player.Character and player.Character:FindFirstChild(name))
end

-- set attrs on a tool, returns true if found
local function modifyToolAttributes(toolName, attrs)
    local tool = getTool(toolName)
    if tool then
        for k, v in pairs(attrs) do tool:SetAttribute(k, v) end
        return true
    end
    return false
end

-- store original attribute values so toggles can revert
local origCache = {}
local function cacheAndSet(toolName, attrs)
    local tool = getTool(toolName)
    if not tool then return false end
    if not origCache[toolName] then
        origCache[toolName] = {}
        for k in pairs(attrs) do
            origCache[toolName][k] = tool:GetAttribute(k)
        end
    end
    for k, v in pairs(attrs) do tool:SetAttribute(k, v) end
    return true
end
local function revertTool(toolName, attrs)
    local tool = getTool(toolName)
    if not tool then return end
    local saved = origCache[toolName]
    if saved then
        for k in pairs(attrs) do
            tool:SetAttribute(k, saved[k])
        end
        origCache[toolName] = nil
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "V0idHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- scale factor: bigger on mobile so fingers can actually hit stuff
local S = isMobile and 1.35 or 1
local function sc(n) return math.floor(n * S) end

-- ── loading screen ───────────────────────────────────────────
local loadGui = Instance.new("Frame")
loadGui.Size = UDim2.new(1,0,1,0)
loadGui.BackgroundColor3 = Color3.fromRGB(6,0,14)
loadGui.ZIndex = 200
loadGui.Parent = gui

local loadLogo = Instance.new("TextLabel")
loadLogo.Size = UDim2.new(0,300,0,60)
loadLogo.Position = UDim2.new(0.5,-150,0.35,0)
loadLogo.BackgroundTransparency = 1
loadLogo.Text = "V0id Hub"
loadLogo.Font = Enum.Font.GothamBold
loadLogo.TextSize = 42
loadLogo.TextColor3 = Color3.fromRGB(168,85,247)
loadLogo.TextTransparency = 1
loadLogo.ZIndex = 201
loadLogo.Parent = loadGui

local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(0,300,0,24)
loadSub.Position = UDim2.new(0.5,-150,0.35,62)
loadSub.BackgroundTransparency = 1
loadSub.Text = "Combat Initiation  •  v2.1.3.2"
loadSub.Font = Enum.Font.Gotham
loadSub.TextSize = 13
loadSub.TextColor3 = Color3.fromRGB(157,142,192)
loadSub.TextTransparency = 1
loadSub.ZIndex = 201
loadSub.Parent = loadGui

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0,260,0,4)
barBg.Position = UDim2.new(0.5,-130,0.62,0)
barBg.BackgroundColor3 = Color3.fromRGB(35,15,60)
barBg.ZIndex = 201
barBg.Parent = loadGui
local barBgC = Instance.new("UICorner"); barBgC.CornerRadius = UDim.new(0,2); barBgC.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(124,58,237)
barFill.ZIndex = 202
barFill.Parent = barBg
local barFillC = Instance.new("UICorner"); barFillC.CornerRadius = UDim.new(0,2); barFillC.Parent = barFill

local loadStatus = Instance.new("TextLabel")
loadStatus.Size = UDim2.new(0,260,0,20)
loadStatus.Position = UDim2.new(0.5,-130,0.62,10)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "loading..."
loadStatus.Font = Enum.Font.Gotham
loadStatus.TextSize = 11
loadStatus.TextColor3 = Color3.fromRGB(100,80,140)
loadStatus.TextTransparency = 1
loadStatus.ZIndex = 201
loadStatus.Parent = loadGui

-- fade in logo
TweenService:Create(loadLogo, TweenInfo.new(.5), {TextTransparency=0}):Play()
TweenService:Create(loadSub,  TweenInfo.new(.6,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,.2), {TextTransparency=0}):Play()
TweenService:Create(loadStatus,TweenInfo.new(.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,.4),{TextTransparency=0}):Play()

local steps = {
    {t=0.4, txt="initialising gui..."},
    {t=0.7, txt="loading weapons..."},
    {t=0.85,txt="loading character mods..."},
    {t=1.0, txt="done!"},
}
for _, s in ipairs(steps) do
    task.spawn(function()
        task.wait(s.t)
        loadStatus.Text = s.txt
        TweenService:Create(barFill, TweenInfo.new(.25), {Size=UDim2.new(s.t,0,1,0)}):Play()
    end)
end
task.spawn(function()
    task.wait(1.5)
    TweenService:Create(loadGui, TweenInfo.new(.4), {BackgroundTransparency=1}):Play()
    TweenService:Create(loadLogo,  TweenInfo.new(.3), {TextTransparency=1}):Play()
    TweenService:Create(loadSub,   TweenInfo.new(.3), {TextTransparency=1}):Play()
    TweenService:Create(loadStatus,TweenInfo.new(.3), {TextTransparency=1}):Play()
    TweenService:Create(barBg,     TweenInfo.new(.3), {BackgroundTransparency=1}):Play()
    TweenService:Create(barFill,   TweenInfo.new(.3), {BackgroundTransparency=1}):Play()
    task.wait(.45)
    loadGui:Destroy()
end)

local C = {
    bg      = Color3.fromRGB(10,0,20),
    card    = Color3.fromRGB(18,8,38),
    border  = Color3.fromRGB(45,20,80),
    accent  = Color3.fromRGB(124,58,237),
    accent2 = Color3.fromRGB(168,85,247),
    text    = Color3.fromRGB(226,217,243),
    sub     = Color3.fromRGB(157,142,192),
    white   = Color3.fromRGB(255,255,255),
    red     = Color3.fromRGB(220,60,60),
}

-- small helpers
local function applyCorner(r, parent)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,r); c.Parent = parent
end
local function applyStroke(t, c, parent)
    local s = Instance.new("UIStroke"); s.Thickness = t; s.Color = c; s.Parent = parent
end
local function label(txt, size, color, parent, bold)
    local l = Instance.new("TextLabel")
    l.Text = txt; l.TextSize = size; l.TextColor3 = color
    l.BackgroundTransparency = 1; l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = parent
    return l
end

-- toast notification
local toastW = sc(260)
local toastFrame = Instance.new("Frame")
toastFrame.Size = UDim2.new(0, toastW, 0, sc(36))
toastFrame.Position = UDim2.new(0.5, -toastW/2, 1, 60)
toastFrame.BackgroundColor3 = C.accent
toastFrame.ZIndex = 99
toastFrame.Parent = gui
local _tc = Instance.new("UICorner"); _tc.CornerRadius = UDim.new(0,8); _tc.Parent = toastFrame
local toastLabel = Instance.new("TextLabel")
toastLabel.Size = UDim2.new(1,-16,1,0); toastLabel.Position = UDim2.new(0,8,0,0)
toastLabel.BackgroundTransparency = 1; toastLabel.TextXAlignment = Enum.TextXAlignment.Center
toastLabel.Font = Enum.Font.Gotham; toastLabel.TextSize = sc(12); toastLabel.TextColor3 = C.white
toastLabel.TextWrapped = true; toastLabel.Parent = toastFrame

local toastActive = false
local function showToast(msg)
    toastLabel.Text = msg
    if toastActive then toastActive = false end
    toastActive = true
    TweenService:Create(toastFrame, TweenInfo.new(.25), {
        Position = UDim2.new(0.5, -toastW/2, 1, -sc(54))
    }):Play()
    task.delay(2.4, function()
        TweenService:Create(toastFrame, TweenInfo.new(.25), {
            Position = UDim2.new(0.5, -toastW/2, 1, 60)
        }):Play()
        task.wait(.28)
        toastActive = false
    end)
end

-- main window — wider/taller on mobile
local winW = sc(340)
local winH = sc(500)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, winW, 0, winH)
mainFrame.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
mainFrame.BackgroundColor3 = C.bg
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
applyCorner(12, mainFrame)
applyStroke(1, C.border, mainFrame)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,sc(38))
titleBar.BackgroundColor3 = C.card
titleBar.Parent = mainFrame
applyCorner(12, titleBar)
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1,0,0,12); titleFix.Position = UDim2.new(0,0,1,-12)
titleFix.BackgroundColor3 = C.card; titleFix.BorderSizePixel = 0; titleFix.Parent = titleBar

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0,8,0,8); dot.Position = UDim2.new(0,12,0.5,-4)
dot.BackgroundColor3 = C.accent2; dot.Parent = titleBar; applyCorner(4, dot)

local titleL = label("V0id Hub  —  Combat Initiation", sc(13), C.accent2, titleBar, true)
titleL.Size = UDim2.new(1,-100,1,0); titleL.Position = UDim2.new(0,28,0,0)

local verL = label("v2.1.3.2", sc(11), C.sub, titleBar, false)
verL.Size = UDim2.new(0,70,1,0); verL.Position = UDim2.new(1,-80,0,0)
verL.TextXAlignment = Enum.TextXAlignment.Right

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,sc(28),0,sc(28)); closeBtn.Position = UDim2.new(1,-sc(34),0.5,-sc(14))
closeBtn.Text = "×"; closeBtn.TextSize = sc(18); closeBtn.TextColor3 = C.sub
closeBtn.BackgroundTransparency = 1; closeBtn.Font = Enum.Font.GothamBold; closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- drag the window by the title bar (mouse + touch)
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; startPos = mainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        TweenService:Create(mainFrame, TweenInfo.new(0.1), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                 startPos.Y.Scale, startPos.Y.Offset + d.Y)
        }):Play()
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- tab bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,sc(32)); tabBar.Position = UDim2.new(0,0,0,sc(38))
tabBar.BackgroundColor3 = Color3.fromRGB(14,5,26); tabBar.BorderSizePixel = 0; tabBar.Parent = mainFrame
local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabBar

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1,0,1,-sc(70))
scrollFrame.Position = UDim2.new(0,0,0,sc(70))
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = C.accent
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame
local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0,sc(6)); scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scrollFrame
local scrollPad = Instance.new("UIPadding")
scrollPad.PaddingLeft = UDim.new(0,sc(10)); scrollPad.PaddingRight = UDim.new(0,sc(10))
scrollPad.PaddingTop = UDim.new(0,sc(8)); scrollPad.PaddingBottom = UDim.new(0,sc(10))
scrollPad.Parent = scrollFrame

-- tab + pane system
local TABS = {"Main","Hats","Character","Auto Farm","Info"}
local tabBtns = {}
local panes   = {}
local activeTab = 1

local function createPane()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,0); f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundTransparency = 1; f.Visible = false; f.LayoutOrder = 1; f.Parent = scrollFrame
    local l = Instance.new("UIListLayout"); l.Padding = UDim.new(0,6); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = f
    return f
end

local function switchTab(idx)
    activeTab = idx
    for i,p in ipairs(panes) do p.Visible = (i==idx) end
    for i,b in ipairs(tabBtns) do
        b.TextColor3 = (i==idx) and C.accent2 or C.sub
        b.BorderSizePixel = 0
    end
    -- underline indicator
    for i,b in ipairs(tabBtns) do
        if b:FindFirstChildWhichIsA("Frame") then b:FindFirstChildWhichIsA("Frame"):Destroy() end
        if i == idx then
            local ul = Instance.new("Frame"); ul.Size = UDim2.new(1,0,0,2)
            ul.Position = UDim2.new(0,0,1,-2); ul.BackgroundColor3 = C.accent; ul.BorderSizePixel = 0; ul.Parent = b
        end
    end
end

for i,name in ipairs(TABS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sc(62), 1, 0); btn.Text = name; btn.TextSize = sc(11)
    btn.Font = Enum.Font.Gotham; btn.TextColor3 = C.sub
    btn.BackgroundTransparency = 1; btn.LayoutOrder = i; btn.Parent = tabBar
    btn.MouseButton1Click:Connect(function() switchTab(i) end)
    table.insert(tabBtns, btn)
    table.insert(panes, createPane())
end

-- ── component builders ───────────────────────────────────────

local function createSection(pane, title)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,sc(22))
    f.BackgroundTransparency = 1; f.Parent = pane
    local l = label(title:upper(), sc(10), C.accent2, f, true)
    l.Size = UDim2.new(1,0,1,0); l.TextXAlignment = Enum.TextXAlignment.Left
    local line = Instance.new("Frame"); line.Size = UDim2.new(1,0,0,1); line.Position = UDim2.new(0,0,1,-1)
    line.BackgroundColor3 = C.border; line.BorderSizePixel = 0; line.Parent = f
    return f
end

local function createParagraph(pane, title, content)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,0); f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = C.card; f.Parent = pane; applyCorner(8, f); applyStroke(1, C.border, f)
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0,sc(10)); pad.PaddingRight = UDim.new(0,sc(10))
    pad.PaddingTop = UDim.new(0,sc(7)); pad.PaddingBottom = UDim.new(0,sc(7)); pad.Parent = f
    local tl = label(title, sc(11), C.accent2, f, true); tl.Size = UDim2.new(1,0,0,sc(16)); tl.LayoutOrder = 1
    local cl = Instance.new("TextLabel"); cl.Text = content; cl.TextSize = sc(11); cl.TextColor3 = C.sub
    cl.BackgroundTransparency = 1; cl.Font = Enum.Font.Gotham; cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextWrapped = true; cl.Size = UDim2.new(1,0,0,0); cl.AutomaticSize = Enum.AutomaticSize.Y
    cl.LayoutOrder = 2; cl.Parent = f
    local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0,2); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = f
end

local function createButton(pane, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,sc(38)); btn.Text = "  "..name; btn.TextSize = sc(12)
    btn.Font = Enum.Font.Gotham; btn.TextColor3 = C.text; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = C.card; btn.Parent = pane; applyCorner(8, btn); applyStroke(1, C.border, btn)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(.15),{BackgroundColor3=Color3.fromRGB(38,20,70)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(.15),{BackgroundColor3=C.card}):Play() end)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn,TweenInfo.new(.08),{BackgroundColor3=C.accent}):Play()
        task.delay(.12, function() TweenService:Create(btn,TweenInfo.new(.15),{BackgroundColor3=C.card}):Play() end)
        callback()
    end)
    return btn
end

local function createToggle(pane, name, default, callback)
    local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,sc(38))
    row.BackgroundColor3 = C.card; row.Parent = pane; applyCorner(8, row); applyStroke(1, C.border, row)
    local nl = label(name, sc(12), C.text, row, false); nl.Size = UDim2.new(1,-sc(54),1,0); nl.Position = UDim2.new(0,sc(10),0,0)

    local track = Instance.new("Frame"); track.Size = UDim2.new(0,sc(36),0,sc(20)); track.Position = UDim2.new(1,-sc(46),0.5,-sc(10))
    track.BackgroundColor3 = default and C.accent or C.border; track.Parent = row; applyCorner(sc(10), track)
    local thumb = Instance.new("Frame"); thumb.Size = UDim2.new(0,sc(16),0,sc(16)); thumb.Position = UDim2.new(0, default and sc(18) or sc(2), 0.5,-sc(8))
    thumb.BackgroundColor3 = C.white; thumb.Parent = track; applyCorner(sc(8), thumb)

    local state = default or false
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = row
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TweenInfo.new(.2), {BackgroundColor3 = state and C.accent or C.border}):Play()
        TweenService:Create(thumb, TweenInfo.new(.2), {Position = UDim2.new(0, state and sc(18) or sc(2), 0.5,-sc(8))}):Play()
        callback(state)
    end)
    return row
end

-- weapon toggle: applies modded attrs when ON, reverts originals when OFF
local function createWeaponToggle(pane, name, toolName, attrs)
    createToggle(pane, name, false, function(on)
        if on then
            local ok = cacheAndSet(toolName, attrs)
            showToast(ok and (toolName.." modded!") or (toolName.." not found!"))
        else
            revertTool(toolName, attrs)
            showToast(toolName.." reverted")
        end
    end)
end

local function createSlider(pane, name, min_, max_, default_, suffix, callback)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,sc(54))
    f.BackgroundColor3 = C.card; f.Parent = pane; applyCorner(8, f); applyStroke(1, C.border, f)
    local head = Instance.new("Frame"); head.Size = UDim2.new(1,-sc(20),0,sc(20)); head.Position = UDim2.new(0,sc(10),0,sc(8))
    head.BackgroundTransparency = 1; head.Parent = f
    local nl = label(name, sc(12), C.text, head, false); nl.Size = UDim2.new(0.7,0,1,0)
    local vl = label(tostring(default_).." "..suffix, sc(11), C.accent2, head, false)
    vl.Size = UDim2.new(0.3,0,1,0); vl.Position = UDim2.new(0.7,0,0,0); vl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame"); track.Size = UDim2.new(1,-sc(20),0,sc(5)); track.Position = UDim2.new(0,sc(10),0,sc(36))
    track.BackgroundColor3 = C.border; track.Parent = f; applyCorner(3, track)
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((default_-min_)/(max_-min_),0,1,0)
    fill.BackgroundColor3 = C.accent; fill.Parent = track; applyCorner(3, fill)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,sc(14),0,sc(14)); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default_-min_)/(max_-min_),0,0.5,0)
    knob.BackgroundColor3 = C.accent2; knob.Parent = track; applyCorner(sc(7), knob)

    local val = default_
    local draggingSlider = false
    -- larger hit area on mobile
    local hitH = isMobile and sc(32) or sc(20)
    local clickArea = Instance.new("TextButton"); clickArea.Size = UDim2.new(1,0,0,hitH)
    clickArea.Position = UDim2.new(0,0,0.5,-hitH/2); clickArea.BackgroundTransparency = 1; clickArea.Text = ""; clickArea.Parent = track
    local function updateSlider(absX)
        local tw = track.AbsoluteSize.X; local tx = track.AbsolutePosition.X
        local t = math.clamp((absX-tx)/tw, 0, 1)
        val = math.floor(min_ + t*(max_-min_))
        fill.Size = UDim2.new(t,0,1,0); knob.Position = UDim2.new(t,0,0.5,0)
        vl.Text = tostring(val).." "..suffix
        callback(val)
    end
    clickArea.MouseButton1Down:Connect(function() draggingSlider = true end)
    clickArea.TouchLongPress:Connect(function() draggingSlider = true end)
    UIS.InputChanged:Connect(function(inp)
        if draggingSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(inp.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end
    end)
    clickArea.MouseButton1Click:Connect(function()
        updateSlider(UIS:GetMouseLocation().X)
    end)
    return f, function() return val end
end

local function createInput(pane, name, default_, callback)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,sc(54))
    f.BackgroundColor3 = C.card; f.Parent = pane; applyCorner(8, f); applyStroke(1, C.border, f)
    local nl = label(name, sc(11), C.sub, f, false); nl.Size = UDim2.new(1,-sc(20),0,sc(18)); nl.Position = UDim2.new(0,sc(10),0,sc(7))
    local box = Instance.new("TextBox"); box.Size = UDim2.new(1,-sc(20),0,sc(24)); box.Position = UDim2.new(0,sc(10),0,sc(27))
    box.BackgroundColor3 = Color3.fromRGB(10,4,22); box.Text = tostring(default_)
    box.TextSize = sc(12); box.Font = Enum.Font.Gotham; box.TextColor3 = C.text; box.TextXAlignment = Enum.TextXAlignment.Left
    box.PlaceholderText = "type here..."; box.PlaceholderColor3 = C.sub; box.ClearTextOnFocus = false
    box.Parent = f; applyCorner(6, box); applyStroke(1, C.border, box)
    box.FocusLost:Connect(function() callback(box.Text) end)
    return f, box
end

-- ── tab 1: weapons ───────────────────────────────────────────
local P1 = panes[1]

createSection(P1, "Sword")
createParagraph(P1, "Sword", "Parry PARRYYYYYYYYYYYY")
createWeaponToggle(P1, "Modded Sword",     "Sword",    {LungeRate=0, Swingrate=0, OffhandSwingRate=0})
createWeaponToggle(P1, "Modded Firebrand", "Firebrand",{LungeRate=0, Swingrate=0, OffhandSwingRate=0, Windup=0})
createWeaponToggle(P1, "Modded Katana",    "Katana",   {LungeRate=0, Swingrate=0, OffhandSwingRate=0})

createSection(P1, "Slingshot")
createParagraph(P1, "Slingshot", "Spammy!")
createWeaponToggle(P1, "Modded Slingshot",    "Slingshot",    {Capacity=10000, ChargeRate=0, Firerate=0, Spread=0, ProjectileSpeed=2250})
createWeaponToggle(P1, "Modded Flamethrower", "Flamethrower", {Cooldown=0})
createWeaponToggle(P1, "Modded Scatterblaster","Scatterblaster",{Capacity=10000, ChargeRate=0, Firerate=0, Spread=0, ProjectileSpeed=3000})

createSection(P1, "Paintball Gun")
createParagraph(P1, "Paintball Gun", "Ah, yes! The good ol' ranged guns!")
createWeaponToggle(P1, "Modded Paintball Gun",              "Paintball Gun", {Firerate=0, ProjectileSpeed=2250})
createWeaponToggle(P1, "Modded BB Gun",                     "BB Gun",        {Firerate=0, MinShots=2, MaxShots=math.huge})
createWeaponToggle(P1, "Modded Freeze Ray (Always Charged)","Freeze Ray",    {Firerate=0, ProjectileSpeed=2250, ChargeTime=0})
createWeaponToggle(P1, "Modded Freeze Ray (Hold to Charge)","Freeze Ray",    {Firerate=0, ProjectileSpeed=2250})

createSection(P1, "Superball & Rockets")
createParagraph(P1, "Superball & Rocket", "Bounce and BOOOMM!")
createWeaponToggle(P1, "Modded Superball",   "Superball",   {ThrowRate=0, ChargeRate=0})
createWeaponToggle(P1, "Modded Ninja Stars", "Ninja Stars", {ThrowRate=0, Capacity=10000000, ChargeRate=0})
createWeaponToggle(P1, "Modded Bazooka",     "Bazooka",     {ReloadTick=0, Capacity=100, PassiveReloadTick=0})

createSection(P1, "Timebomb")
createParagraph(P1, "Timebomb", "Chat is this real?")
createWeaponToggle(P1, "Modded Subspace Tripmine", "Subspace Tripmine", {Cooldown=0})
createWeaponToggle(P1, "Modded Explosive Pinata",  "Explosive Pinata",  {Cooldown=0})

createSection(P1, "Trowel")
createParagraph(P1, "Trowel", "Hey look guys! I'm a Builder Man!")
createToggle(P1, "Frozen Wrench", false, function(v)
    local tool = getTool("Wrench")
    if tool then
        tool:SetAttribute("TimeScale", v and 0 or 1)
        showToast("Wrench TimeScale: "..(v and "frozen" or "normal"))
    else
        showToast("Wrench not found!")
    end
end)

-- ── tab 2: hats ──────────────────────────────────────────────
local P2 = panes[2]
createSection(P2, "Hat Modifiers")
createButton(P2, "Electric Punk (Lightning Chance 100%)", function()
    local ae = player.Backpack.Parent:FindFirstChild("AccessoryEffects")
    if ae then ae:SetAttribute("Lightning_Chance", 100); showToast("Lightning Chance set to 100!")
    else showToast("AccessoryEffects not found!") end
end)

local _, meleeBox = createInput(P2, "Melee Range  (5 = +500%)", "5", function() end)
local _, pogoBox  = createInput(P2, "Pogo Range   (5 = +500%)", "5", function() end)

createButton(P2, "Apply Bandit / Stage Prop Ranges", function()
    local ae = player.Backpack.Parent:FindFirstChild("AccessoryEffects")
    if ae then
        ae:SetAttribute("Melee_Range", tonumber(meleeBox.Text))
        ae:SetAttribute("Pogo_Range",  tonumber(pogoBox.Text))
        showToast("Melee " .. meleeBox.Text .. " | Pogo " .. pogoBox.Text)
    else
        showToast("AccessoryEffects not found!")
    end
end)

-- ── tab 3: character ─────────────────────────────────────────
local P3 = panes[3]

-- character refs, updated on respawn
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid  = Character:WaitForChild("Humanoid")
local HRP       = Character:WaitForChild("HumanoidRootPart")
local Camera    = workspace.CurrentCamera

local DefaultWalkSpeed = 16
local DefaultJumpPower = 50
local SpeedhackEnabled = false
local JumppowerEnabled = false
local FlyEnabled       = false
local SpeedValue       = DefaultWalkSpeed
local JumpValue        = DefaultJumpPower
local FlySpeedValue    = 50

-- fly stuff
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
bodyVelocity.Velocity = Vector3.zero
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
bodyGyro.CFrame    = HRP.CFrame

local inputFlags = {forward=false,back=false,left=false,right=false,up=false,down=false}
UIS.InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.W          then inputFlags.forward = true end
    if inp.KeyCode == Enum.KeyCode.S          then inputFlags.back    = true end
    if inp.KeyCode == Enum.KeyCode.A          then inputFlags.left    = true end
    if inp.KeyCode == Enum.KeyCode.D          then inputFlags.right   = true end
    if inp.KeyCode == Enum.KeyCode.Space      then inputFlags.up      = true end
    if inp.KeyCode == Enum.KeyCode.LeftControl then inputFlags.down   = true end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.W          then inputFlags.forward = false end
    if inp.KeyCode == Enum.KeyCode.S          then inputFlags.back    = false end
    if inp.KeyCode == Enum.KeyCode.A          then inputFlags.left    = false end
    if inp.KeyCode == Enum.KeyCode.D          then inputFlags.right   = false end
    if inp.KeyCode == Enum.KeyCode.Space      then inputFlags.up      = false end
    if inp.KeyCode == Enum.KeyCode.LeftControl then inputFlags.down   = false end
end)

local function startFlying()
    FlyEnabled = true
    bodyVelocity.Parent = HRP; bodyGyro.Parent = HRP
    Humanoid.PlatformStand = true
end
local function stopFlying()
    FlyEnabled = false
    bodyVelocity.Parent = nil; bodyGyro.Parent = nil
    Humanoid.PlatformStand = false
end

RunService.RenderStepped:Connect(function()
    if FlyEnabled and HRP and Camera then
        local dir = Vector3.new()
        local cf  = Camera.CFrame
        if inputFlags.forward then dir += cf.LookVector  end
        if inputFlags.back    then dir -= cf.LookVector  end
        if inputFlags.left    then dir -= cf.RightVector end
        if inputFlags.right   then dir += cf.RightVector end
        if inputFlags.up      then dir += Vector3.new(0,1,0) end
        if inputFlags.down    then dir -= Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        bodyVelocity.Velocity = dir * FlySpeedValue
        bodyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + cf.LookVector)
    end
end)

player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid  = newChar:WaitForChild("Humanoid")
    HRP       = newChar:WaitForChild("HumanoidRootPart")
    bodyGyro.CFrame = HRP.CFrame
    if FlyEnabled then startFlying() end
end)

createSection(P3, "Movement")
createButton(P3, "Infinite Dashes", function()
    if player.Character then
        player.Character:SetAttribute("DashRegenTime",  0.05)
        player.Character:SetAttribute("DashRegenFury",  0.05)
        showToast("Dash regen → 0.05!")
    end
end)

createToggle(P3, "Enable Speed", false, function(v)
    SpeedhackEnabled = v
    if Humanoid then Humanoid.WalkSpeed = v and SpeedValue or DefaultWalkSpeed end
    showToast(v and "Speed hack ON!" or "Speed reset to " .. DefaultWalkSpeed)
end)
createSlider(P3, "Speed Value", 5, 200, DefaultWalkSpeed, "WalkSpeed", function(v)
    SpeedValue = v
    if SpeedhackEnabled and Humanoid then Humanoid.WalkSpeed = v end
end)

createToggle(P3, "Enable Jump", false, function(v)
    JumppowerEnabled = v
    if Humanoid then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = v and JumpValue or DefaultJumpPower
    end
    showToast(v and "Jump hack ON!" or "Jump reset to " .. DefaultJumpPower)
end)
createSlider(P3, "Jump Value", 10, 500, DefaultJumpPower, "JumpPower", function(v)
    JumpValue = v
    if JumppowerEnabled and Humanoid then Humanoid.UseJumpPower = true; Humanoid.JumpPower = v end
end)

createToggle(P3, "Fly", false, function(v)
    if v then startFlying() else stopFlying() end
    showToast(v and "Fly ON! WASD + Space/Ctrl" or "Fly OFF")
end)
createSlider(P3, "Fly Speed", 10, 200, 50, "Studs/s", function(v)
    FlySpeedValue = v
end)

createSection(P3, "Utility")
local _, utilBox = createInput(P3, "Utility Boost Value  (2 = default)", "2", function() end)
createButton(P3, "Apply Utility Boost", function()
    if player.Character then
        player.Character:SetAttribute("UtilityBoost", tonumber(utilBox.Text))
        showToast("UtilityBoost → " .. utilBox.Text)
    end
end)

-- ── tab 4: auto farm ─────────────────────────────────────────
local P4 = panes[4]
local FarmEnabled = false
local FarmDistance = 10

createSection(P4, "Auto Farm")
createParagraph(P4, "Kill All", "Teleports all living enemies in game.Workspace.Enemies to in front of you every 0.1s.")

local function BringNPCs()
    local path = workspace:WaitForChild("Enemies")
    while FarmEnabled do
        local char     = player.Character
        local pHRP     = char and char:FindFirstChild("HumanoidRootPart")
        if pHRP then
            for _, npc in ipairs(path:GetChildren()) do
                local nHRP = npc:FindFirstChild("HumanoidRootPart")
                local nHum = npc:FindFirstChild("Humanoid")
                if nHRP and nHum and nHum.Health > 0 then
                    nHRP.CFrame = pHRP.CFrame + pHRP.CFrame.LookVector * FarmDistance
                end
            end
        end
        task.wait(0.1)
    end
end

createToggle(P4, "Kill All (Bring NPCs)", false, function(v)
    FarmEnabled = v
    if v then task.spawn(BringNPCs) end
    showToast(v and "Kill All enabled!" or "Kill All disabled.")
end)

local _, distBox = createInput(P4, "Distance (studs in front of player)", "10", function(v)
    local n = tonumber(v); if n then FarmDistance = n end
end)

createButton(P4, "Set Distance", function()
    local n = tonumber(distBox.Text)
    if n then FarmDistance = n; showToast("Distance → " .. n .. " studs") end
end)

-- ── tab 5: info ──────────────────────────────────────────────
local P5 = panes[5]
createSection(P5, "About")
createParagraph(P5, "Version",      "BETA")
createParagraph(P5, "Status",       "BETA")
createParagraph(P5, "Original",     "V0idPlaysGD")
-- mobile toggle button (draggable, always visible)
local tbSize = sc(58)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, tbSize, 0, tbSize)
toggleBtn.Position = UDim2.new(1, -tbSize - sc(14), 0.5, -tbSize/2)
toggleBtn.Text = "V0id"
toggleBtn.TextSize = sc(12)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = C.white
toggleBtn.BackgroundColor3 = C.accent
toggleBtn.Parent = gui
applyCorner(tbSize/2, toggleBtn)
applyStroke(1, C.accent2, toggleBtn)
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- drag the toggle button around
local tbDrag, tbStart, tbPos
toggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        tbDrag = true; tbStart = inp.Position; tbPos = toggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if tbDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - tbStart
        TweenService:Create(toggleBtn, TweenInfo.new(.1), {
            Position = UDim2.new(tbPos.X.Scale, tbPos.X.Offset+d.X,
                                 tbPos.Y.Scale, tbPos.Y.Offset+d.Y)
        }):Play()
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then tbDrag = false end
end)

-- kick off
switchTab(1)
showToast("V0id Hub loaded lmao")
