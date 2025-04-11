local Kavo = {}

--[[
===============
СЕРВИСЫ
===============
]]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

--[[
============
УТИЛИТЫ
============
]]
local Utility = {}
local Objects = {}

-- Функция перетаскивания окон
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    
    local dragging = false
    local dragInput, mousePos, framePos

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

-- Анимация объектов
function Utility:TweenObject(obj, properties, duration, ...)
    TweenService:Create(obj, TweenInfo.new(duration, ...), properties):Play()
end

--[[
============
ТЕМЫ
============
]]
local themes = {
    Dark = {
        SchemeColor = Color3.fromRGB(74, 99, 135),
        Background = Color3.fromRGB(36, 37, 43),
        Header = Color3.fromRGB(28, 29, 34),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(32, 32, 38),
        AccentColor = Color3.fromRGB(100, 150, 255)
    },
    Light = {
        SchemeColor = Color3.fromRGB(220, 220, 220),
        Background = Color3.fromRGB(240, 240, 240),
        Header = Color3.fromRGB(230, 230, 230),
        TextColor = Color3.fromRGB(50, 50, 50),
        ElementColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(80, 120, 200)
    }
}

--[[
============
ОСНОВНЫЕ КОМПОНЕНТЫ UI
============
]]
local function CreateBaseUI(title, theme)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI_" .. math.random(1, 10000)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = theme.Header
    Header.Size = UDim2.new(1, 0, 0, 40)
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = title
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 18
    Title.TextColor3 = theme.TextColor
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Image = "rbxassetid://3926305904"
    CloseButton.ImageRectOffset = Vector2.new(284, 4)
    CloseButton.ImageRectSize = Vector2.new(24, 24)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -30, 0.5, -12)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = theme.Header
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer
    
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.BackgroundTransparency = 1
    PageContainer.Size = UDim2.new(1, -150, 1, -40)
    PageContainer.Position = UDim2.new(0, 150, 0, 40)
    
    -- Сборка иерархии
    Header.Parent = MainFrame
    Title.Parent = Header
    CloseButton.Parent = Header
    TabContainer.Parent = MainFrame
    PageContainer.Parent = MainFrame
    MainFrame.Parent = ScreenGui
    
    Kavo:DraggingEnabled(Header, MainFrame)
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabContainer = TabContainer,
        PageContainer = PageContainer,
        Theme = theme
    }
end

--[[
============
СИСТЕМА ВКЛАДОК
============
]]
local function CreateTab(uiComponents, tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Text = tabName
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 14
    TabButton.TextColor3 = uiComponents.Theme.TextColor
    TabButton.BackgroundColor3 = uiComponents.Theme.ElementColor
    TabButton.AutoButtonColor = false
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = tabName .. "Page"
    TabPage.BackgroundTransparency = 1
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 5
    TabPage.ScrollBarImageColor3 = uiComponents.Theme.AccentColor
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.Parent = TabPage
    
    local function UpdatePageSize()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdatePageSize)
    
    TabButton.Parent = uiComponents.TabContainer
    TabPage.Parent = uiComponents.PageContainer
    
    TabButton.MouseButton1Click:Connect(function()
        for _, page in ipairs(uiComponents.PageContainer:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                page.Visible = false
            end
        end
        
        for _, button in ipairs(uiComponents.TabContainer:GetChildren()) do
            if button:IsA("TextButton") then
                button.BackgroundColor3 = uiComponents.Theme.ElementColor
            end
        end
        
        TabPage.Visible = true
        TabButton.BackgroundColor3 = uiComponents.Theme.AccentColor
    end)
    
    --[[
    ============
    СИСТЕМА СЕКЦИЙ
    ============
    ]]
local function CreateSection(sectionName)
    -- Проверяем, что sectionName - строка
    if type(sectionName) ~= "string" then
        sectionName = tostring(sectionName) or "Section"
    end
    
    local Section = Instance.new("Frame")
    Section.Name = sectionName .. "Section"  -- Здесь была возможная ошибка, если sectionName - таблица
    Section.BackgroundColor3 = uiComponents.Theme.ElementColor
    Section.Size = UDim2.new(1, -20, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = Section
    
    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.Padding = UDim.new(0, 5)
    SectionLayout.Parent = Section
    
    local SectionHeader = Instance.new("TextLabel")
    SectionHeader.Name = "Header"
    SectionHeader.Text = "  " .. tostring(sectionName)  -- Дополнительная проверка на строку
    SectionHeader.Font = Enum.Font.GothamSemibold
    SectionHeader.TextSize = 16
    SectionHeader.TextColor3 = uiComponents.Theme.TextColor
    SectionHeader.BackgroundTransparency = 1
    SectionHeader.Size = UDim2.new(1, 0, 0, 30)
    SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
    
    SectionHeader.Parent = Section
    Section.Parent = TabPage
    
    local function UpdateSectionSize()
        Section.Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 10)
    end
    
    SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionSize)
        
        --[[
        ============
        ЭЛЕМЕНТЫ УПРАВЛЕНИЯ
        ============
        ]]
        local Elements = {}
        
        --[[
        БАЗОВЫЕ ЭЛЕМЕНТЫ
        ]]
        -- Кнопка
        function Elements:NewButton(buttonName, callback)
            local Button = Instance.new("TextButton")
            Button.Name = buttonName .. "Button"
            Button.Text = buttonName
            Button.Font = Enum.Font.GothamMedium
            Button.TextSize = 14
            Button.TextColor3 = uiComponents.Theme.TextColor
            Button.BackgroundColor3 = uiComponents.Theme.Background
            Button.AutoButtonColor = false
            Button.Size = UDim2.new(1, -10, 0, 35)
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                Utility:TweenObject(Button, {BackgroundColor3 = Color3.fromRGB(
                    uiComponents.Theme.Background.r * 255 + 20,
                    uiComponents.Theme.Background.g * 255 + 20,
                    uiComponents.Theme.Background.b * 255 + 20
                )}, 0.1)
            end)
            
            Button.MouseLeave:Connect(function()
                Utility:TweenObject(Button, {BackgroundColor3 = uiComponents.Theme.Background}, 0.1)
            end)
            
            Button.MouseButton1Click:Connect(function()
                Utility:TweenObject(Button, {BackgroundColor3 = uiComponents.Theme.AccentColor}, 0.1)
                Utility:TweenObject(Button, {BackgroundColor3 = uiComponents.Theme.Background}, 0.1, function()
                    if callback then callback() end
                end)
            end)
            
            Button.Parent = Section
            
            local ButtonFunctions = {}
            
            function ButtonFunctions:UpdateText(newText)
                Button.Text = newText
            end
            
            return ButtonFunctions
        end
        
        --[[
        ЭЛЕМЕНТЫ ВВОДА
        ]]
        -- Текстовое поле
        function Elements:NewTextBox(textBoxName, placeholder, callback)
            local TextBoxContainer = Instance.new("Frame")
            TextBoxContainer.Name = textBoxName .. "Container"
            TextBoxContainer.BackgroundTransparency = 1
            TextBoxContainer.Size = UDim2.new(1, -10, 0, 35)
            
            local TextBox = Instance.new("TextBox")
            TextBox.Name = textBoxName .. "TextBox"
            TextBox.PlaceholderText = placeholder
            TextBox.Text = ""
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 14
            TextBox.TextColor3 = uiComponents.Theme.TextColor
            TextBox.BackgroundColor3 = uiComponents.Theme.Background
            TextBox.Size = UDim2.new(1, 0, 1, 0)
            
            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 4)
            TextBoxCorner.Parent = TextBox
            
            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    callback(TextBox.Text)
                end
            end)
            
            TextBox.Parent = TextBoxContainer
            TextBoxContainer.Parent = Section
            
            local TextBoxFunctions = {}
            
            function TextBoxFunctions:UpdateText(newText)
                TextBox.Text = newText
            end
            
            return TextBoxFunctions
        end
        
        --[[
        ПЕРЕКЛЮЧАТЕЛИ
        ]]
        function Elements:NewToggle(toggleName, defaultValue, callback)
            local Toggle = Instance.new("TextButton")
            Toggle.Name = toggleName .. "Toggle"
            Toggle.Text = ""
            Toggle.BackgroundColor3 = uiComponents.Theme.Background
            Toggle.AutoButtonColor = false
            Toggle.Size = UDim2.new(1, -10, 0, 35)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = Toggle
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.Text = toggleName
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.TextSize = 14
            ToggleLabel.TextColor3 = uiComponents.Theme.TextColor
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.BackgroundColor3 = defaultValue and uiComponents.Theme.AccentColor or Color3.fromRGB(100, 100, 100)
            ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
            ToggleIndicator.Position = UDim2.new(1, -35, 0.5, -10)
            
            local ToggleIndicatorCorner = Instance.new("UICorner")
            ToggleIndicatorCorner.CornerRadius = UDim.new(0.5, 0)
            ToggleIndicatorCorner.Parent = ToggleIndicator
            
            local isToggled = defaultValue or false
            
            Toggle.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                Utility:TweenObject(ToggleIndicator, {
                    BackgroundColor3 = isToggled and uiComponents.Theme.AccentColor or Color3.fromRGB(100, 100, 100)
                }, 0.1)
                
                if callback then callback(isToggled) end
            end)
            
            ToggleLabel.Parent = Toggle
            ToggleIndicator.Parent = Toggle
            Toggle.Parent = Section
            
            local ToggleFunctions = {}
            
            function ToggleFunctions:SetState(state)
                isToggled = state
                Utility:TweenObject(ToggleIndicator, {
                    BackgroundColor3 = isToggled and uiComponents.Theme.AccentColor or Color3.fromRGB(100, 100, 100)
                }, 0.1)
            end
            
            return ToggleFunctions
        end
        
        --[[
        ЭЛЕМЕНТЫ ВЫБОРА ЗНАЧЕНИЙ
        ]]
        -- Слайдер
        function Elements:NewSlider(sliderName, minValue, maxValue, defaultValue, callback)
            -- Реализация слайдера
        end
        
        -- Выпадающий список
        function Elements:NewDropdown(dropdownName, options, defaultOption, callback)
            -- Реализация выпадающего списка
        end
        
        --[[
        СПЕЦИАЛЬНЫЕ ЭЛЕМЕНТЫ
        ]]
        -- Выбор цвета
        function Elements:NewColorPicker(colorPickerName, defaultColor, callback)
            -- Реализация выбора цвета
        end
        
        -- Горячая клавиша
        function Elements:NewKeybind(keybindName, defaultKey, callback)
            -- Реализация горячей клавиши
        end
        
        --[[
        ИНФОРМАЦИОННЫЕ ЭЛЕМЕНТЫ
        ]]
        -- Метка
        function Elements:NewLabel(labelText)
            -- Реализация текстовой метки
        end
        
        return Elements
    end
    
    return {
        NewSection = CreateSection
    }
end

--[[
============
ОСНОВНАЯ ФУНКЦИЯ БИБЛИОТЕКИ
============
]]
function Kavo.CreateLib(title, themeName)
    local theme = themes[themeName] or themes.Dark
    local uiComponents = CreateBaseUI(title, theme)
    
    -- Помещаем интерфейс в CoreGui
    uiComponents.ScreenGui.Parent = game.CoreGui
    
    local LibraryFunctions = {}
    
    function LibraryFunctions:NewTab(tabName)
        return CreateTab(uiComponents, tabName)
    end
    
    function LibraryFunctions:ToggleUI()
        uiComponents.ScreenGui.Enabled = not uiComponents.ScreenGui.Enabled
    end
    
    function LibraryFunctions:SetTheme(newTheme)
        theme = themes[newTheme] or theme
        -- Логика обновления темы
    end
    
    return LibraryFunctions
end

return Kavo
