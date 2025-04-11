local Kavo = {}

-- Сервисы
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Утилиты
local Utility = {}
local Objects = {}

-- Функция для перетаскивания окна
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

-- Цветовые темы
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

-- Создание библиотеки
function Kavo.CreateLib(title, themeName)
    -- Настройки по умолчанию
    local theme = themes[themeName] or themes.Dark
    
    -- Создание основного окна
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI_" .. math.random(1, 10000)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Главный контейнер
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.ClipsDescendants = true
    
    -- Скругление углов
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Заголовок окна
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = theme.Header
    Header.Size = UDim2.new(1, 0, 0, 40)
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    -- Название окна
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
    
    -- Кнопка закрытия
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
    
    -- Вкладки
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = theme.Header
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer
    
    -- Контейнер для страниц
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.BackgroundTransparency = 1
    PageContainer.Size = UDim2.new(1, -150, 1, -40)
    PageContainer.Position = UDim2.new(0, 150, 0, 40)
    
    -- Добавление элементов в иерархию
    Header.Parent = MainFrame
    Title.Parent = Header
    CloseButton.Parent = Header
    TabContainer.Parent = MainFrame
    PageContainer.Parent = MainFrame
    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = game.CoreGui
    
    -- Включение перетаскивания
    Kavo:DraggingEnabled(Header, MainFrame)
    
    -- Функция для создания вкладки
    local function CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 14
        TabButton.TextColor3 = theme.TextColor
        TabButton.BackgroundColor3 = theme.ElementColor
        TabButton.AutoButtonColor = false
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- Страница вкладки
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "Page"
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 5
        TabPage.ScrollBarImageColor3 = theme.AccentColor
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = TabPage
        
        -- Функция для обновления размера страницы
        local function UpdatePageSize()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdatePageSize)
        
        -- Добавление элементов
        TabButton.Parent = TabContainer
        TabPage.Parent = PageContainer
        
        -- Обработчик клика по вкладке
        TabButton.MouseButton1Click:Connect(function()
            -- Скрыть все страницы
            for _, page in ipairs(PageContainer:GetChildren()) do
                if page:IsA("ScrollingFrame") then
                    page.Visible = false
                end
            end
            
            -- Сбросить стиль всех кнопок
            for _, button in ipairs(TabContainer:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = theme.ElementColor
                end
            end
            
            -- Показать выбранную страницу
            TabPage.Visible = true
            TabButton.BackgroundColor3 = theme.AccentColor
        end)
        
        -- Функции для создания элементов интерфейса
        local Elements = {}
        
        -- Секция
        function Elements:NewSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = sectionName .. "Section"
            Section.BackgroundColor3 = theme.ElementColor
            Section.Size = UDim2.new(1, -20, 0, 0)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.Parent = Section
            
            -- Заголовок секции
            local SectionHeader = Instance.new("TextLabel")
            SectionHeader.Name = "Header"
            SectionHeader.Text = "  " .. sectionName
            SectionHeader.Font = Enum.Font.GothamSemibold
            SectionHeader.TextSize = 16
            SectionHeader.TextColor3 = theme.TextColor
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Size = UDim2.new(1, 0, 0, 30)
            SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionHeader.Parent = Section
            Section.Parent = TabPage
            
            -- Функция для обновления размера секции
            local function UpdateSectionSize()
                Section.Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 10)
            end
            
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionSize)
            
            -- Элементы секции
            local SectionElements = {}
            
            -- Кнопка
            function SectionElements:NewButton(buttonName, callback)
                local Button = Instance.new("TextButton")
                Button.Name = buttonName .. "Button"
                Button.Text = buttonName
                Button.Font = Enum.Font.GothamMedium
                Button.TextSize = 14
                Button.TextColor3 = theme.TextColor
                Button.BackgroundColor3 = theme.Background
                Button.AutoButtonColor = false
                Button.Size = UDim2.new(1, -10, 0, 35)
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                -- Эффект при наведении
                Button.MouseEnter:Connect(function()
                    Utility:TweenObject(Button, {BackgroundColor3 = Color3.fromRGB(
                        theme.Background.r * 255 + 20,
                        theme.Background.g * 255 + 20,
                        theme.Background.b * 255 + 20
                    )}, 0.1)
                end)
                
                Button.MouseLeave:Connect(function()
                    Utility:TweenObject(Button, {BackgroundColor3 = theme.Background}, 0.1)
                end)
                
                -- Эффект при клике
                Button.MouseButton1Click:Connect(function()
                    Utility:TweenObject(Button, {BackgroundColor3 = theme.AccentColor}, 0.1)
                    Utility:TweenObject(Button, {BackgroundColor3 = theme.Background}, 0.1, function()
                        if callback then callback() end
                    end)
                end)
                
                Button.Parent = Section
                
                local ButtonFunctions = {}
                
                -- Обновление текста кнопки
                function ButtonFunctions:UpdateText(newText)
                    Button.Text = newText
                end
                
                return ButtonFunctions
            end
            
            -- Текстовое поле
            function SectionElements:NewTextBox(textBoxName, placeholder, callback)
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
                TextBox.TextColor3 = theme.TextColor
                TextBox.BackgroundColor3 = theme.Background
                TextBox.Size = UDim2.new(1, 0, 1, 0)
                
                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 4)
                TextBoxCorner.Parent = TextBox
                
                -- Обработчик ввода
                TextBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then
                        callback(TextBox.Text)
                    end
                end)
                
                TextBox.Parent = TextBoxContainer
                TextBoxContainer.Parent = Section
                
                local TextBoxFunctions = {}
                
                -- Обновление текста
                function TextBoxFunctions:UpdateText(newText)
                    TextBox.Text = newText
                end
                
                return TextBoxFunctions
            end
            
            -- Переключатель
            function SectionElements:NewToggle(toggleName, defaultValue, callback)
                local Toggle = Instance.new("TextButton")
                Toggle.Name = toggleName .. "Toggle"
                Toggle.Text = ""
                Toggle.BackgroundColor3 = theme.Background
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
                ToggleLabel.TextColor3 = theme.TextColor
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.BackgroundColor3 = defaultValue and theme.AccentColor or Color3.fromRGB(100, 100, 100)
                ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
                ToggleIndicator.Position = UDim2.new(1, -35, 0.5, -10)
                
                local ToggleIndicatorCorner = Instance.new("UICorner")
                ToggleIndicatorCorner.CornerRadius = UDim.new(0.5, 0)
                ToggleIndicatorCorner.Parent = ToggleIndicator
                
                local isToggled = defaultValue or false
                
                -- Обработчик клика
                Toggle.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    Utility:TweenObject(ToggleIndicator, {
                        BackgroundColor3 = isToggled and theme.AccentColor or Color3.fromRGB(100, 100, 100)
                    }, 0.1)
                    
                    if callback then callback(isToggled) end
                end)
                
                ToggleLabel.Parent = Toggle
                ToggleIndicator.Parent = Toggle
                Toggle.Parent = Section
                
                local ToggleFunctions = {}
                
                -- Обновление состояния
                function ToggleFunctions:SetState(state)
                    isToggled = state
                    Utility:TweenObject(ToggleIndicator, {
                        BackgroundColor3 = isToggled and theme.AccentColor or Color3.fromRGB(100, 100, 100)
                    }, 0.1)
                end
                
                return ToggleFunctions
            end
            
            return SectionElements
        end
        
        return Elements
    end
    
    -- Функции библиотеки
    local LibraryFunctions = {}
    
    -- Создание новой вкладки
    function LibraryFunctions:NewTab(tabName)
        return CreateTab(tabName)
    end
    
    -- Переключение видимости интерфейса
    function LibraryFunctions:ToggleUI()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
    
    -- Изменение темы
    function LibraryFunctions:SetTheme(newTheme)
        theme = themes[newTheme] or theme
        -- Обновляем все цвета интерфейса
        MainFrame.BackgroundColor3 = theme.Background
        Header.BackgroundColor3 = theme.Header
        Title.TextColor3 = theme.TextColor
        TabContainer.BackgroundColor3 = theme.Header
        
        -- Обновляем цвета всех элементов
        for _, tab in ipairs(TabContainer:GetChildren()) do
            if tab:IsA("TextButton") then
                tab.TextColor3 = theme.TextColor
                tab.BackgroundColor3 = theme.ElementColor
            end
        end
        
        for _, page in ipairs(PageContainer:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                page.ScrollBarImageColor3 = theme.AccentColor
                
                for _, section in ipairs(page:GetChildren()) do
                    if section:IsA("Frame") then
                        section.BackgroundColor3 = theme.ElementColor
                        
                        for _, element in ipairs(section:GetChildren()) do
                            if element:IsA("TextButton") then
                                element.BackgroundColor3 = theme.Background
                                element.TextColor3 = theme.TextColor
                            elseif element:IsA("TextBox") then
                                element.BackgroundColor3 = theme.Background
                                element.TextColor3 = theme.TextColor
                            end
                        end
                    end
                end
            end
        end
    end
    
    return LibraryFunctions
end

return Kavo
