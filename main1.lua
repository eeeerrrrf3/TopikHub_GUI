local Kavo = {}

-- Подключение необходимых сервисов Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Utility = {}
local Objects = {}

-- Функция для перетаскивания GUI-окна
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput
    local mousePos
    local framePos

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

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Функция анимации изменений свойств объекта
function Utility:TweenObject(obj, properties, duration, ...)
    local tweenInfo = TweenInfo.new(duration, ...)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
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

function Kavo:ChangeColor(property, color)
    if themes.Dark[property] then
        themes.Dark[property] = color
    end
    if themes.Light[property] then
        themes.Light[property] = color
    end
end

-- Функция создания вкладок в GUI
function Kavo:CreateTab(tabName, parentFrame)
    local tab = {}
    tab.Name = tabName
    
    -- Создание кнопки вкладки
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = tabName .. "TabButton"
    tab.Button.Text = tabName
    tab.Button.Size = UDim2.new(0, 100, 0, 30)
    tab.Button.BackgroundColor3 = themes.Dark.Accent
    tab.Button.TextColor3 = themes.Dark.TextColor
    tab.Button.Parent = parentFrame
    
    -- Создание страницы вкладки
    tab.Page = Instance.new("ScrollingFrame")
    tab.Page.Name = tabName .. "Page"
    tab.Page.Size = UDim2.new(1, 0, 1, -40)
    tab.Page.Position = UDim2.new(0, 0, 0, 40)
    tab.Page.BackgroundTransparency = 1
    tab.Page.ScrollingDirection = Enum.ScrollingDirection.Y
    tab.Page.ScrollBarThickness = 8
    tab.Page.Parent = parentFrame
    
    -- Контейнер для элементов
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = tab.Page
    
    function tab:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Name = text .. "Button"
        button.Text = text
        button.Size = UDim2.new(1, -10, 0, 30)
        button.Position = UDim2.new(0, 5, 0, 0)
        button.BackgroundColor3 = themes.Dark.ElementColor
        button.TextColor3 = themes.Dark.TextColor
        button.Parent = tab.Page
        
        button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        return button
    end
    
    function tab:AddToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = text .. "Toggle"
        toggleFrame.Size = UDim2.new(1, -10, 0, 30)
        toggleFrame.Position = UDim2.new(0, 5, 0, 0)
        toggleFrame.BackgroundColor3 = themes.Dark.ElementColor
        toggleFrame.Parent = tab.Page
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = text
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = themes.Dark.TextColor
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local stateIndicator = Instance.new("Frame")
        stateIndicator.Name = "State"
        stateIndicator.Size = UDim2.new(0.2, 0, 0.6, 0)
        stateIndicator.Position = UDim2.new(0.75, 0, 0.2, 0)
        stateIndicator.BackgroundColor3 = default and themes.Dark.Accent or Color3.fromRGB(80, 80, 80)
        stateIndicator.Parent = toggleFrame
        
        local state = default
        
        toggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                stateIndicator.BackgroundColor3 = state and themes.Dark.Accent or Color3.fromRGB(80, 80, 80)
                callback(state)
            end
        end)
        
        return {
            Set = function(value)
                state = value
                stateIndicator.BackgroundColor3 = state and themes.Dark.Accent or Color3.fromRGB(80, 80, 80)
                callback(state)
            end,
            Get = function()
                return state
            end
        }
    end
    
    function tab:AddSlider(text, min, max, defaultValue, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = text .. "Slider"
        sliderFrame.Size = UDim2.new(1, -10, 0, 50)
        sliderFrame.Position = UDim2.new(0, 5, 0, 0)
        sliderFrame.BackgroundColor3 = themes.Dark.ElementColor
        sliderFrame.Parent = tab.Page
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = text .. ": " .. defaultValue
        label.Size = UDim2.new(1, -10, 0.4, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = themes.Dark.TextColor
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame
        
        local slider = Instance.new("Frame")
        slider.Name = "Slider"
        slider.Size = UDim2.new(1, -10, 0.3, 0)
        slider.Position = UDim2.new(0, 5, 0.5, 0)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        slider.Parent = sliderFrame
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = themes.Dark.Accent
        fill.Parent = slider
        
        local dragging = false
        
        local function updateValue(input)
            local xOffset = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
            local value = min + (max - min) * (xOffset / slider.AbsoluteSize.X)
            value = math.floor(value * 100) / 100 -- Округление до 2 знаков
            
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            label.Text = text .. ": " .. value
            callback(value)
        end
        
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateValue(input)
            end
        end)
        
        slider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateValue(input)
            end
        end)
        
        return {
            Set = function(value)
                value = math.clamp(value, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                label.Text = text .. ": " .. value
                callback(value)
            end
        }
    end
    
    function tab:AddTextBox(text, placeholder, callback)
        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Name = text .. "TextBox"
        textBoxFrame.Size = UDim2.new(1, -10, 0, 50)
        textBoxFrame.Position = UDim2.new(0, 5, 0, 0)
        textBoxFrame.BackgroundColor3 = themes.Dark.ElementColor
        textBoxFrame.Parent = tab.Page
        
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = text
        label.Size = UDim2.new(1, -10, 0.4, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = themes.Dark.TextColor
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = textBoxFrame
        
        local textBox = Instance.new("TextBox")
        textBox.Name = "Input"
        textBox.Size = UDim2.new(1, -10, 0.5, 0)
        textBox.Position = UDim2.new(0, 5, 0.45, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        textBox.TextColor3 = themes.Dark.TextColor
        textBox.PlaceholderText = placeholder
        textBox.ClearTextOnFocus = false
        textBox.Parent = textBoxFrame
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(textBox.Text)
            end
        end)
        
        return {
            Set = function(text)
                textBox.Text = text
            end,
            Get = function()
                return textBox.Text
            end
        }
    end
    
    return tab
end

function Kavo:CreateUI(themeName)
    local theme = themes[themeName] or themes.Dark
    
    -- Создание основного GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KavoUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Основной фрейм
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.Parent = screenGui
    
    -- Заголовок
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = theme.Header
    header.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "Kavo UI"
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = theme.TextColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = header
    
    -- Включение перетаскивания для заголовка
    self:DraggingEnabled(header, mainFrame)
    
    -- Контейнер для вкладок
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(1, 0, 0, 30)
    tabButtons.Position = UDim2.new(0, 0, 0, 40)
    tabButtons.BackgroundTransparency = 1
    tabButtons.Parent = mainFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabButtons
    
    -- Контейнер для страниц вкладок
    local tabPages = Instance.new("Frame")
    tabPages.Name = "TabPages"
    tabPages.Size = UDim2.new(1, 0, 1, -70)
    tabPages.Position = UDim2.new(0, 0, 0, 70)
    tabPages.BackgroundTransparency = 1
    tabPages.Parent = mainFrame
    
    local tabs = {}
    
    function tabs:AddTab(name)
        return Kavo:CreateTab(name, mainFrame)
    end
    
    return {
        GUI = screenGui,
        Tabs = tabs,
        Theme = theme
    }
end

return Kavo
