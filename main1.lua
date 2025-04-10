-- Полный код с обновленным дизайном GUI и кнопок

local Kavo = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}

-- Улучшенный современный дизайн
local themes = {
    SchemeColor = Color3.fromRGB(100, 180, 255), -- Голубой цвет акцентов
    Background = Color3.fromRGB(30, 30, 40), -- Темный фон
    Header = Color3.fromRGB(45, 45, 60), -- Цвет заголовков
    TextColor = Color3.fromRGB(255, 255, 255), -- Белый текст
    ElementColor = Color3.fromRGB(55, 55, 70) -- Цвет элементов
}

-- Функция обновления цветовой схемы элементов
function Kavo:ChangeColor(property, color)
    if themes[property] then
        themes[property] = color
    end
end

-- Функция создания основного GUI с современным дизайном
function Kavo.CreateLib(kavName, themeList)
    themeList = themeList or themes
    kavName = kavName or "Library"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "KavoGUI"
    ScreenGui.ResetOnSpawn = false
    
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.3, 0, 0.3, 0)
    Main.BackgroundColor3 = themeList.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15) -- Более закругленные углы
    MainCorner.Parent = Main
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = themeList.Header
    Header.Parent = Main
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Text = kavName
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = themeList.TextColor
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 50, 1, 0)
    CloseButton.Position = UDim2.new(1, -50, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "✖"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 24
    CloseButton.TextColor3 = themeList.TextColor
    CloseButton.Parent = Header
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    return Kavo
end

-- Улучшенные кнопки
function Kavo:NewButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = themes.ElementColor
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.TextColor3 = themes.TextColor
    button.Text = text
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        callback()
    end)
    return button
end

-- Улучшенные слайдеры
function Kavo:NewSlider(parent, min, max, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundColor3 = themes.ElementColor
    sliderFrame.Parent = parent
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
    sliderBar.BackgroundColor3 = themes.SchemeColor
    sliderBar.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local function move(input)
                local size = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                sliderBar.Size = UDim2.new(size, 0, 1, 0)
                callback(math.floor(min + (max - min) * size))
            end
            move(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    return
                end
                move(input)
            end)
        end
    end)
    return sliderFrame
end

return Kavo
