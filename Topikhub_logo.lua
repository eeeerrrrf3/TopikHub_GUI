local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LogoScreen"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Основной фрейм
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1
frame.Parent = gui

-- Логотип (изначально прозрачный)
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Image = "http://www.roblox.com/asset/?id=88824350044835"
logo.Size = UDim2.new(0, 400, 0, 350)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.Position = UDim2.new(0.5, 0, 0.5, 0)
logo.BackgroundTransparency = 1
logo.ImageTransparency = 1
logo.Parent = frame

-- Кнопка Play (изначально скрыта)
local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Size = UDim2.new(0, 200, 0, 50)
playButton.AnchorPoint = Vector2.new(0.5, 0)
playButton.Position = UDim2.new(0.5, 0, 0.65, 0)
playButton.Text = "PLAY"
playButton.Font = Enum.Font.SourceSansBold
playButton.TextSize = 24
playButton.TextColor3 = Color3.new(1, 1, 1)
playButton.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
playButton.BorderSizePixel = 0
playButton.BackgroundTransparency = 1
playButton.TextTransparency = 1
playButton.Visible = false
playButton.Parent = frame

-- Эффекты кнопки
playButton.MouseEnter:Connect(function()
    playButton.BackgroundColor3 = Color3.new(0.3, 0.7, 1)
end)

playButton.MouseLeave:Connect(function()
    playButton.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
end)

playButton.MouseButton1Down:Connect(function()
    playButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.9)
end)

playButton.MouseButton1Up:Connect(function()
    playButton.BackgroundColor3 = Color3.new(0.3, 0.7, 1)
end)

-- Анимация появления
local TweenService = game:GetService("TweenService")

-- Анимация логотипа
local logoFadeIn = TweenService:Create(
    logo,
    TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    {ImageTransparency = 0}
)

local logoScaleUp = TweenService:Create(
    logo,
    TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 420, 0, 367.5)}
)

-- Анимация кнопки
local buttonFadeIn = TweenService:Create(
    playButton,
    TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {BackgroundTransparency = 0, TextTransparency = 0}
)

-- Запуск анимации
task.wait(0.5)
logoFadeIn:Play()
logoScaleUp:Play()

task.wait(1.5)
local logoScaleBack = TweenService:Create(
    logo,
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 400, 0, 350)}
)
logoScaleBack:Play()

playButton.Visible = true
buttonFadeIn:Play()

-- Удаление интерфейса при нажатии Play
playButton.Activated:Connect(function()
    -- Анимация исчезновения для всех элементов
    local fadeElements = {}
    
    -- Собираем все элементы, которые нужно анимировать
    for _, element in ipairs(gui:GetDescendants()) do
        if element:IsA("ImageLabel") then
            table.insert(fadeElements, {
                obj = element,
                prop = "ImageTransparency",
                start = element.ImageTransparency,
                target = 1
            })
        elseif element:IsA("TextButton") or element:IsA("TextLabel") then
            table.insert(fadeElements, {
                obj = element,
                prop = "TextTransparency",
                start = element.TextTransparency,
                target = 1
            })
            table.insert(fadeElements, {
                obj = element,
                prop = "BackgroundTransparency",
                start = element.BackgroundTransparency,
                target = 1
            })
        elseif element:IsA("Frame") then
            table.insert(fadeElements, {
                obj = element,
                prop = "BackgroundTransparency",
                start = element.BackgroundTransparency,
                target = 1
            })
        end
    end

    -- Создаем и запускаем все анимации
    local tweens = {}
    for _, elementData in ipairs(fadeElements) do
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(
            elementData.obj,
            tweenInfo,
            {[elementData.prop] = elementData.target}
        )
        table.insert(tweens, tween)
        tween:Play()
    end

    -- Ждем завершения самой длинной анимации
    task.wait(0.5)
    
    -- Полное удаление интерфейса
    gui:Destroy()
    
    print("Интерфейс удален, игра начинается!")
    -- Здесь можно добавить код начала игры
end)
