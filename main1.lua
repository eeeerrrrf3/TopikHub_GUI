local Kavo = {}

-- Подключение необходимых сервисов Roblox
local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}

-- Функция для перетаскивания GUI-окна
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Функция анимации изменений свойств объекта
function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, TweenInfo.new(duration, ...), properties):Play()
end

-- Темы оформления GUI
local themes = {
    Dark = {
        Background = Color3.fromRGB(18, 18, 18),
        Header = Color3.fromRGB(28, 28, 28),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(38, 38, 38),
        Accent = Color3.fromRGB(0, 132, 255)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Header = Color3.fromRGB(225, 225, 225),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(0, 132, 255)
    }
}

function Kavo:ChangeColor(prope, color)
    if themes.Dark[prope] then
        themes.Dark[prope] = color
    end
end

-- Функция создания вкладок в GUI
function Kavo:NewTab(tabName)
    local tab = {}
    tab.Name = tabName
    tab.Button = Instance.new("TextButton")
    tab.Page = Instance.new("ScrollingFrame")
    
    tab.Button.Text = tabName
    tab.Button.BackgroundColor3 = themes.Dark.Accent
    tab.Button.TextColor3 = themes.Dark.TextColor
    tab.Button.Parent = script.Parent
    
    tab.Page.Size = UDim2.new(1, 0, 1, 0)
    tab.Page.BackgroundTransparency = 1
    tab.Page.Parent = script.Parent
    
    function tab:NewButton(text, callback)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = themes.Dark.ElementColor
        button.TextColor3 = themes.Dark.TextColor
        button.Parent = tab.Page
        button.MouseButton1Click:Connect(callback)
    end
    
    function tab:NewToggle(text, default, callback)
        local toggle = Instance.new("TextButton")
        toggle.Text = text
        toggle.Size = UDim2.new(1, 0, 0, 30)
        toggle.BackgroundColor3 = themes.Dark.ElementColor
        toggle.TextColor3 = themes.Dark.TextColor
        toggle.Parent = tab.Page
        local state = default
        toggle.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
        end)
    end
    
    function tab:NewSlider(text, min, max, callback)
        local slider = Instance.new("TextLabel")
        slider.Text = text .. " [" .. min .. " - " .. max .. "]"
        slider.Size = UDim2.new(1, 0, 0, 30)
        slider.BackgroundColor3 = themes.Dark.ElementColor
        slider.TextColor3 = themes.Dark.TextColor
        slider.Parent = tab.Page
        -- Здесь можно добавить механизм изменения значения
    end
    
    function tab:NewTextBox(text, callback)
        local textBox = Instance.new("TextBox")
        textBox.PlaceholderText = text
        textBox.Size = UDim2.new(1, 0, 0, 30)
        textBox.BackgroundColor3 = themes.Dark.ElementColor
        textBox.TextColor3 = themes.Dark.TextColor
        textBox.Parent = tab.Page
        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
    end
    
    return tab
end

local function CreateUI(theme)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    screenGui.Name = "KavoUI"
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 520, 0, 320)
    mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.Parent = screenGui
    
    return screenGui
end

local ui = CreateUI(themes.Dark)
return Kavo
