local Kavo = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Utility = {}
local Objects = {}

-- Улучшенная функция для перетаскивания окна
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
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Улучшенная функция для анимации объектов
function Utility:TweenObject(obj, properties, duration, ...)
    local tweenInfo = TweenInfo.new(duration, ...)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Современные цветовые темы
local themes = {
    SchemeColor = Color3.fromRGB(100, 120, 180),
    Background = Color3.fromRGB(30, 32, 40),
    Header = Color3.fromRGB(25, 27, 35),
    TextColor = Color3.fromRGB(240, 240, 240),
    ElementColor = Color3.fromRGB(35, 37, 45),
    AccentColor = Color3.fromRGB(80, 160, 220)
}

local themeStyles = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(80, 160, 220),
        Background = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(15, 15, 20),
        TextColor = Color3.fromRGB(240, 240, 240),
        ElementColor = Color3.fromRGB(30, 30, 40),
        AccentColor = Color3.fromRGB(80, 160, 220)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(70, 140, 200),
        Background = Color3.fromRGB(240, 240, 245),
        Header = Color3.fromRGB(220, 220, 230),
        TextColor = Color3.fromRGB(30, 30, 40),
        ElementColor = Color3.fromRGB(250, 250, 255),
        AccentColor = Color3.fromRGB(70, 140, 200)
    },
    PurpleTheme = {
        SchemeColor = Color3.fromRGB(140, 100, 180),
        Background = Color3.fromRGB(25, 20, 35),
        Header = Color3.fromRGB(20, 15, 30),
        TextColor = Color3.fromRGB(240, 240, 240),
        ElementColor = Color3.fromRGB(35, 30, 45),
        AccentColor = Color3.fromRGB(140, 100, 180)
    },
    GreenTheme = {
        SchemeColor = Color3.fromRGB(80, 180, 120),
        Background = Color3.fromRGB(20, 30, 25),
        Header = Color3.fromRGB(15, 25, 20),
        TextColor = Color3.fromRGB(240, 240, 240),
        ElementColor = Color3.fromRGB(30, 40, 35),
        AccentColor = Color3.fromRGB(80, 180, 120)
    }
}

local SettingsT = {}
local Name = "KavoConfig.JSON"

-- Улучшенная обработка сохранений
pcall(function()
    if not pcall(function() readfile(Name) end) then
        writefile(Name, HttpService:JSONEncode(SettingsT))
    end
    Settings = HttpService:JSONEncode(readfile(Name))
end)

local LibName = "KavoUI_"..tostring(math.random(1, 10000))

-- Функция для переключения видимости UI
function Kavo:ToggleUI()
    if game.CoreGui[LibName] then
        game.CoreGui[LibName].Enabled = not game.CoreGui[LibName].Enabled
    end
end

-- Основная функция создания библиотеки
function Kavo.CreateLib(kavName, themeList)
    kavName = kavName or "Kavo UI"
    themeList = themeList or themes
    
    -- Выбор темы
    if type(themeList) == "string" then
        themeList = themeStyles[themeList] or themes
    end
    
    -- Проверка наличия всех цветов в теме
    for prop, default in pairs(themes) do
        if themeList[prop] == nil then
            themeList[prop] = default
        end
    end
    
    -- Удаление старых UI с таким же именем
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then
            v:Destroy()
        end
    end
    
    -- Создание основного контейнера
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    
    -- Главный фрейм
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.BackgroundTransparency = 0.05
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.35, 0, 0.3, 0)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Скругление углов
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = Main
    
    -- Тень
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = Main
    Shadow.BackgroundTransparency = 1
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = -1
    
    -- Заголовок
    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(1, 0, 0, 35)
    
    local headerCover = Instance.new("UICorner")
    headerCover.CornerRadius = UDim.new(0, 8)
    headerCover.Name = "headerCover"
    headerCover.Parent = MainHeader
    
    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.02, 0, 0, 0)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Font = Enum.Font.GothamSemibold
    title.Text = kavName
    title.TextColor3 = themeList.TextColor
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.RichText = true
    
    -- Кнопка закрытия
    local close = Instance.new("ImageButton")
    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(0.95, -20, 0.5, -10)
    close.Size = UDim2.new(0, 20, 0, 20)
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.ImageColor3 = themeList.TextColor
    
    close.MouseEnter:Connect(function()
        Utility:TweenObject(close, {ImageColor3 = Color3.fromRGB(255, 80, 80)}, 0.1)
    end)
    
    close.MouseLeave:Connect(function()
        Utility:TweenObject(close, {ImageColor3 = themeList.TextColor}, 0.1)
    end)
    
    close.MouseButton1Click:Connect(function()
        Utility:TweenObject(close, {ImageTransparency = 1}, 0.1)
        Utility:TweenObject(Main, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, Main.AbsolutePosition.X + Main.AbsoluteSize.X/2 - Main.AbsolutePosition.X, 
                             0.5, Main.AbsolutePosition.Y + Main.AbsoluteSize.Y/2 - Main.AbsolutePosition.Y)
        }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        wait(0.2)
        ScreenGui:Destroy()
    end)
    
    -- Боковая панель
    local MainSide = Instance.new("Frame")
    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(0, 0, 0, 35)
    MainSide.Size = UDim2.new(0, 150, 0, 315)
    
    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 8)
    sideCorner.Name = "sideCorner"
    sideCorner.Parent = MainSide
    
    -- Контейнер вкладок
    local tabFrames = Instance.new("Frame")
    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0.05, 0, 0, 5)
    tabFrames.Size = UDim2.new(0.9, 0, 1, -10)
    
    local tabListing = Instance.new("UIListLayout")
    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder
    tabListing.Padding = UDim.new(0, 5)
    
    -- Основная область контента
    local pages = Instance.new("Frame")
    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1
    pages.Position = UDim2.new(0, 155, 0, 40)
    pages.Size = UDim2.new(0, 385, 0, 305)
    
    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = pages
    
    -- Информационный контейнер
    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1
    infoContainer.Position = UDim2.new(0, 155, 1, -35)
    infoContainer.Size = UDim2.new(0, 385, 0, 35)
    infoContainer.ClipsDescendants = true
    
    -- Размытие фона
    local blurFrame = Instance.new("Frame")
    blurFrame.Name = "blurFrame"
    blurFrame.Parent = pages
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 1
    blurFrame.Size = UDim2.new(1, 0, 1, 0)
    blurFrame.ZIndex = 999
    
    -- Включение перетаскивания
    Kavo:DraggingEnabled(MainHeader, Main)
    
    -- Обновление цветов при изменении темы
    coroutine.wrap(function()
        while wait() do
            Main.BackgroundColor3 = themeList.Background
            MainHeader.BackgroundColor3 = themeList.Header
            MainSide.BackgroundColor3 = themeList.Header
            title.TextColor3 = themeList.TextColor
            close.ImageColor3 = themeList.TextColor
        end
    end)()
    
    -- Функция изменения цвета
    function Kavo:ChangeColor(property, color)
        if themeList[property] then
            themeList[property] = color
        end
    end
    
    local Tabs = {}
    local firstTab = true
    
    -- Функция создания новой вкладки
    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")
        
        -- Функция обновления размера страницы
        local function UpdateSize()
            local contentSize = pageListing.AbsoluteContentSize
            Utility:TweenObject(page, {
                CanvasSize = UDim2.new(0, contentSize.X, 0, contentSize.Y)
            }, 0.15)
        end
        
        -- Создание страницы
        page.Name = "Page"
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BackgroundTransparency = 0.05
        page.BorderSizePixel = 0
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.ScrollBarImageColor3 = themeList.SchemeColor
        page.Visible = false
        
        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)
        
        -- Кнопка вкладки
        tabButton.Name = tabName.."TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        tabButton.TextSize = 14
        tabButton.BackgroundTransparency = firstTab and 0 or 1
        
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = tabButton
        
        if firstTab then
            firstTab = false
            page.Visible = true
            UpdateSize()
        end
        
        -- Обработчик клика по вкладке
        tabButton.MouseButton1Click:Connect(function()
            UpdateSize()
            for _, v in next, Pages:GetChildren() do
                v.Visible = false
            end
            page.Visible = true
            
            for _, v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then
                    Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2)
                end
            end
            
            Utility:TweenObject(tabButton, {
                BackgroundTransparency = 0,
                TextColor3 = themeList.SchemeColor == Color3.fromRGB(255,255,255) and Color3.new(0,0,0) or 
                            themeList.SchemeColor == Color3.fromRGB(0,0,0) and Color3.new(255,255,255) or 
                            themeList.TextColor
            }, 0.2)
        end)
        
        -- Обновление цветов
        coroutine.wrap(function()
            while wait() do
                page.BackgroundColor3 = themeList.Background
                page.ScrollBarImageColor3 = themeList.SchemeColor
                tabButton.TextColor3 = themeList.TextColor
                tabButton.BackgroundColor3 = themeList.SchemeColor
            end
        end)()
        
        local Sections = {}
        local focusing = false
        local viewDe = false
        
        -- Функция создания нового раздела
        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            hidden = hidden or false
            
            local sectionFrame = Instance.new("Frame")
            local sectionListLayout = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sHeadCorner = Instance.new("UICorner")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")
            
            -- Основной фрейм раздела
            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionFrame.BackgroundTransparency = 0.05
            sectionFrame.BorderSizePixel = 0
            
            sectionListLayout.Name = "sectionListLayout"
            sectionListLayout.Parent = sectionFrame
            sectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionListLayout.Padding = UDim.new(0, 5)
            
            -- Заголовок раздела
            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            sectionHead.Size = UDim2.new(1, 0, 0, 35)
            sectionHead.Visible = not hidden
            
            sHeadCorner.CornerRadius = UDim.new(0, 4)
            sHeadCorner.Name = "sHeadCorner"
            sHeadCorner.Parent = sectionHead
            
            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.02, 0, 0, 0)
            sectionName.Size = UDim2.new(0.98, 0, 1, 0)
            sectionName.Font = Enum.Font.GothamSemibold
            sectionName.Text = secName
            sectionName.TextColor3 = themeList.TextColor
            sectionName.TextSize = 14
            sectionName.TextXAlignment = Enum.TextXAlignment.Left
            sectionName.RichText = true
            
            if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                Utility:TweenObject(sectionName, {TextColor3 = Color3.new(0,0,0)}, 0.2)
            elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                Utility:TweenObject(sectionName, {TextColor3 = Color3.new(255,255,255)}, 0.2)
            end
            
            -- Внутренний контейнер для элементов
            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundTransparency = 1
            sectionInners.Position = UDim2.new(0, 0, 0, hidden and 0 or 40)
            
            sectionElListing.Name = "sectionElListing"
            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 3)
            
            -- Функция обновления размеров
            local function updateSectionFrame()
                local innerSize = sectionElListing.AbsoluteContentSize
                sectionInners.Size = UDim2.new(1, 0, 0, innerSize.Y)
                local frameSize = sectionListLayout.AbsoluteContentSize
                sectionFrame.Size = UDim2.new(1, 0, 0, frameSize.Y)
                UpdateSize()
            end
            
            updateSectionFrame()
            sectionInners.ChildAdded:Connect(updateSectionFrame)
            sectionInners.ChildRemoved:Connect(updateSectionFrame)
            
            -- Обновление цветов
            coroutine.wrap(function()
                while wait() do
                    sectionFrame.BackgroundColor3 = themeList.Background
                    sectionHead.BackgroundColor3 = themeList.SchemeColor
                    sectionName.TextColor3 = themeList.TextColor
                end
            end)()
            
            local Elements = {}
            
            -- Функция создания кнопки
            function Elements:NewButton(bname, tipInf, callback)
                bname = bname or "Button"
                tipInf = tipInf or "Click to activate"
                callback = callback or function() end
                
                local buttonElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local btnInfo = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local icon = Instance.new("ImageLabel")
                local Sample = Instance.new("ImageLabel")
                
                -- Основная кнопка
                buttonElement.Name = bname
                buttonElement.Parent = sectionInners
                buttonElement.BackgroundColor3 = themeList.ElementColor
                buttonElement.ClipsDescendants = true
                buttonElement.Size = UDim2.new(1, 0, 0, 35)
                buttonElement.AutoButtonColor = false
                buttonElement.Font = Enum.Font.SourceSans
                buttonElement.Text = ""
                buttonElement.TextColor3 = Color3.new(0, 0, 0)
                buttonElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = buttonElement
                
                -- Иконка
                icon.Name = "icon"
                icon.Parent = buttonElement
                icon.BackgroundTransparency = 1
                icon.Position = UDim2.new(0.02, 0, 0.2, 0)
                icon.Size = UDim2.new(0, 21, 0, 21)
                icon.Image = "rbxassetid://3926305904"
                icon.ImageColor3 = themeList.SchemeColor
                icon.ImageRectOffset = Vector2.new(84, 204)
                icon.ImageRectSize = Vector2.new(36, 36)
                
                -- Текст кнопки
                btnInfo.Name = "btnInfo"
                btnInfo.Parent = buttonElement
                btnInfo.BackgroundTransparency = 1
                btnInfo.Position = UDim2.new(0.1, 0, 0.2, 0)
                btnInfo.Size = UDim2.new(0.8, 0, 0, 21)
                btnInfo.Font = Enum.Font.GothamSemibold
                btnInfo.Text = bname
                btnInfo.TextColor3 = themeList.TextColor
                btnInfo.TextSize = 14
                btnInfo.TextXAlignment = Enum.TextXAlignment.Left
                btnInfo.RichText = true
                
                -- Кнопка информации
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = buttonElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.15, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                -- Эффект нажатия
                Sample.Name = "Sample"
                Sample.Parent = buttonElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                -- Подсказка
                local moreInfo = Instance.new("TextLabel")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 14,
                    themeList.SchemeColor.g * 255 - 17,
                    themeList.SchemeColor.b * 255 - 13
                )
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..tipInf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.RichText = true
                
                local UICornerTip = Instance.new("UICorner")
                UICornerTip.CornerRadius = UDim.new(0, 4)
                UICornerTip.Parent = moreInfo
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                updateSectionFrame()
                
                -- Обработчики событий
                local hovering = false
                local ms = game.Players.LocalPlayer:GetMouse()
                
                buttonElement.MouseEnter:Connect(function()
                    if not focusing then
                        Utility:TweenObject(buttonElement, {
                            BackgroundColor3 = Color3.fromRGB(
                                themeList.ElementColor.r * 255 + 8,
                                themeList.ElementColor.g * 255 + 9,
                                themeList.ElementColor.b * 255 + 10
                            )
                        }, 0.1)
                        hovering = true
                    end
                end)
                
                buttonElement.MouseLeave:Connect(function()
                    if not focusing then
                        Utility:TweenObject(buttonElement, {
                            BackgroundColor3 = themeList.ElementColor
                        }, 0.1)
                        hovering = false
                    end
                end)
                
                buttonElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        callback()
                        
                        -- Эффект волны при нажатии
                        local c = Sample:Clone()
                        c.Parent = buttonElement
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        
                        local len, size = 0.35, nil
                        if buttonElement.AbsoluteSize.X >= buttonElement.AbsoluteSize.Y then
                            size = (buttonElement.AbsoluteSize.X * 1.5)
                        else
                            size = (buttonElement.AbsoluteSize.Y * 1.5)
                        end
                        
                        c:TweenSizeAndPosition(
                            UDim2.new(0, size, 0, size),
                            UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)),
                            'Out', 'Quad', len, true, nil
                        )
                        
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    else
                        for _, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        
                        for _, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(buttonElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        
                        wait(1.5)
                        
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        
                        wait(0.1)
                        viewDe = false
                    end
                end)
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            buttonElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 14,
                            themeList.SchemeColor.g * 255 - 17,
                            themeList.SchemeColor.b * 255 - 13
                        )
                        moreInfo.TextColor3 = themeList.TextColor
                        icon.ImageColor3 = themeList.SchemeColor
                        btnInfo.TextColor3 = themeList.TextColor
                    end
                end)()
                
                local ButtonFunction = {}
                
                -- Функция обновления кнопки
                function ButtonFunction:UpdateButton(newTitle)
                    btnInfo.Text = newTitle
                end
                
                return ButtonFunction
            end
            
            -- ... (предыдущий код остается без изменений до функции Elements:NewButton)

            -- Функция создания текстового поля
            function Elements:NewTextBox(tname, tTip, callback)
                tname = tname or "Textbox"
                tTip = tTip or "Enter text here"
                callback = callback or function() end
                
                local textboxElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local viewInfo = Instance.new("ImageButton")
                local icon = Instance.new("ImageLabel")
                local TextBox = Instance.new("TextBox")
                local TextBoxCorner = Instance.new("UICorner")
                local textName = Instance.new("TextLabel")
                
                -- Основной элемент
                textboxElement.Name = "textboxElement"
                textboxElement.Parent = sectionInners
                textboxElement.BackgroundColor3 = themeList.ElementColor
                textboxElement.ClipsDescendants = true
                textboxElement.Size = UDim2.new(1, 0, 0, 35)
                textboxElement.AutoButtonColor = false
                textboxElement.Font = Enum.Font.SourceSans
                textboxElement.Text = ""
                textboxElement.TextColor3 = Color3.new(0, 0, 0)
                textboxElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = textboxElement
                
                -- Иконка
                icon.Name = "icon"
                icon.Parent = textboxElement
                icon.BackgroundTransparency = 1
                icon.Position = UDim2.new(0.02, 0, 0.2, 0)
                icon.Size = UDim2.new(0, 21, 0, 21)
                icon.Image = "rbxassetid://3926305904"
                icon.ImageColor3 = themeList.SchemeColor
                icon.ImageRectOffset = Vector2.new(324, 604)
                icon.ImageRectSize = Vector2.new(36, 36)
                
                -- Название
                textName.Name = "textName"
                textName.Parent = textboxElement
                textName.BackgroundTransparency = 1
                textName.Position = UDim2.new(0.1, 0, 0.2, 0)
                textName.Size = UDim2.new(0.4, 0, 0, 21)
                textName.Font = Enum.Font.GothamSemibold
                textName.Text = tname
                textName.TextColor3 = themeList.TextColor
                textName.TextSize = 14
                textName.TextXAlignment = Enum.TextXAlignment.Left
                textName.RichText = true
                
                -- Поле ввода
                TextBox.Parent = textboxElement
                TextBox.BackgroundColor3 = Color3.fromRGB(
                    themeList.ElementColor.r * 255 - 6,
                    themeList.ElementColor.g * 255 - 6,
                    themeList.ElementColor.b * 255 - 7
                )
                TextBox.BorderSizePixel = 0
                TextBox.ClipsDescendants = true
                TextBox.Position = UDim2.new(0.55, 0, 0.2, 0)
                TextBox.Size = UDim2.new(0.4, 0, 0, 21)
                TextBox.ClearTextOnFocus = false
                TextBox.Font = Enum.Font.Gotham
                TextBox.PlaceholderColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 19,
                    themeList.SchemeColor.g * 255 - 26,
                    themeList.SchemeColor.b * 255 - 35
                )
                TextBox.PlaceholderText = "Type here..."
                TextBox.Text = ""
                TextBox.TextColor3 = themeList.SchemeColor
                TextBox.TextSize = 12
                
                TextBoxCorner.CornerRadius = UDim.new(0, 4)
                TextBoxCorner.Parent = TextBox
                
                -- Кнопка информации
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = textboxElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.15, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                -- Подсказка
                local moreInfo = Instance.new("TextLabel")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 14,
                    themeList.SchemeColor.g * 255 - 17,
                    themeList.SchemeColor.b * 255 - 13
                )
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..tTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.RichText = true
                
                local UICornerTip = Instance.new("UICorner")
                UICornerTip.CornerRadius = UDim.new(0, 4)
                UICornerTip.Parent = moreInfo
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                updateSectionFrame()
                
                -- Обработчики событий
                local hovering = false
                
                textboxElement.MouseEnter:Connect(function()
                    if not focusing then
                        Utility:TweenObject(textboxElement, {
                            BackgroundColor3 = Color3.fromRGB(
                                themeList.ElementColor.r * 255 + 8,
                                themeList.ElementColor.g * 255 + 9,
                                themeList.ElementColor.b * 255 + 10
                            )
                        }, 0.1)
                        hovering = true
                    end
                end)
                
                textboxElement.MouseLeave:Connect(function()
                    if not focusing then
                        Utility:TweenObject(textboxElement, {
                            BackgroundColor3 = themeList.ElementColor
                        }, 0.1)
                        hovering = false
                    end
                end)
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    if not enterPressed then return end
                    callback(TextBox.Text)
                    Utility:TweenObject(TextBox, {TextColor3 = themeList.SchemeColor}, 0.2)
                    wait(0.18)
                    TextBox.Text = ""
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        
                        for _, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(textboxElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        
                        wait(1.5)
                        
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        
                        wait(0.1)
                        viewDe = false
                    end
                end)
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            textboxElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 14,
                            themeList.SchemeColor.g * 255 - 17,
                            themeList.SchemeColor.b * 255 - 13
                        )
                        moreInfo.TextColor3 = themeList.TextColor
                        icon.ImageColor3 = themeList.SchemeColor
                        textName.TextColor3 = themeList.TextColor
                        TextBox.BackgroundColor3 = Color3.fromRGB(
                            themeList.ElementColor.r * 255 - 6,
                            themeList.ElementColor.g * 255 - 6,
                            themeList.ElementColor.b * 255 - 7
                        )
                        TextBox.PlaceholderColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 19,
                            themeList.SchemeColor.g * 255 - 26,
                            themeList.SchemeColor.b * 255 - 35
                        )
                        TextBox.TextColor3 = themeList.SchemeColor
                    end
                end)()
                
                local TextBoxFunction = {}
                
                -- Функция обновления текстового поля
                function TextBoxFunction:UpdateTextBox(newTitle, newPlaceholder)
                    if newTitle then textName.Text = newTitle end
                    if newPlaceholder then TextBox.PlaceholderText = newPlaceholder end
                end
                
                return TextBoxFunction
            end

            -- Функция создания переключателя
            function Elements:NewToggle(tname, nTip, callback)
                tname = tname or "Toggle"
                nTip = nTip or "Toggle state"
                callback = callback or function() end
                local toggled = false
                
                local toggleElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled = Instance.new("ImageLabel")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local Sample = Instance.new("ImageLabel")
                
                -- Основной элемент
                toggleElement.Name = "toggleElement"
                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.ClipsDescendants = true
                toggleElement.Size = UDim2.new(1, 0, 0, 35)
                toggleElement.AutoButtonColor = false
                toggleElement.Font = Enum.Font.SourceSans
                toggleElement.Text = ""
                toggleElement.TextColor3 = Color3.new(0, 0, 0)
                toggleElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = toggleElement
                
                -- Иконка выключенного состояния
                toggleDisabled.Name = "toggleDisabled"
                toggleDisabled.Parent = toggleElement
                toggleDisabled.BackgroundTransparency = 1
                toggleDisabled.Position = UDim2.new(0.02, 0, 0.2, 0)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://3926309567"
                toggleDisabled.ImageColor3 = themeList.SchemeColor
                toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
                toggleDisabled.ImageRectSize = Vector2.new(48, 48)
                
                -- Иконка включенного состояния
                toggleEnabled.Name = "toggleEnabled"
                toggleEnabled.Parent = toggleElement
                toggleEnabled.BackgroundTransparency = 1
                toggleEnabled.Position = UDim2.new(0.02, 0, 0.2, 0)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://3926309567"
                toggleEnabled.ImageColor3 = themeList.SchemeColor
                toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
                toggleEnabled.ImageRectSize = Vector2.new(48, 48)
                toggleEnabled.ImageTransparency = 1
                
                -- Название
                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.1, 0, 0.2, 0)
                togName.Size = UDim2.new(0.7, 0, 0, 21)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = tname
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left
                togName.RichText = true
                
                -- Кнопка информации
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = toggleElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.15, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                -- Эффект нажатия
                Sample.Name = "Sample"
                Sample.Parent = toggleElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                -- Подсказка
                local moreInfo = Instance.new("TextLabel")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 14,
                    themeList.SchemeColor.g * 255 - 17,
                    themeList.SchemeColor.b * 255 - 13
                )
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..nTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.RichText = true
                
                local UICornerTip = Instance.new("UICorner")
                UICornerTip.CornerRadius = UDim.new(0, 4)
                UICornerTip.Parent = moreInfo
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                updateSectionFrame()
                
                -- Обработчики событий
                local hovering = false
                local ms = game.Players.LocalPlayer:GetMouse()
                
                toggleElement.MouseEnter:Connect(function()
                    if not focusing then
                        Utility:TweenObject(toggleElement, {
                            BackgroundColor3 = Color3.fromRGB(
                                themeList.ElementColor.r * 255 + 8,
                                themeList.ElementColor.g * 255 + 9,
                                themeList.ElementColor.b * 255 + 10
                            )
                        }, 0.1)
                        hovering = true
                    end
                end)
                
                toggleElement.MouseLeave:Connect(function()
                    if not focusing then
                        Utility:TweenObject(toggleElement, {
                            BackgroundColor3 = themeList.ElementColor
                        }, 0.1)
                        hovering = false
                    end
                end)
                
                toggleElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        toggled = not toggled
                        
                        if toggled then
                            Utility:TweenObject(toggleEnabled, {ImageTransparency = 0}, 0.1)
                        else
                            Utility:TweenObject(toggleEnabled, {ImageTransparency = 1}, 0.1)
                        end
                        
                        -- Эффект волны
                        local c = Sample:Clone()
                        c.Parent = toggleElement
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        
                        local len, size = 0.35, nil
                        if toggleElement.AbsoluteSize.X >= toggleElement.AbsoluteSize.Y then
                            size = (toggleElement.AbsoluteSize.X * 1.5)
                        else
                            size = (toggleElement.AbsoluteSize.Y * 1.5)
                        end
                        
                        c:TweenSizeAndPosition(
                            UDim2.new(0, size, 0, size),
                            UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)),
                            'Out', 'Quad', len, true, nil
                        )
                        
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                        
                        pcall(callback, toggled)
                    else
                        for _, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        
                        for _, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(toggleElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        
                        wait(1.5)
                        
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        
                        wait(0.1)
                        viewDe = false
                    end
                end)
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            toggleElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 14,
                            themeList.SchemeColor.g * 255 - 17,
                            themeList.SchemeColor.b * 255 - 13
                        )
                        moreInfo.TextColor3 = themeList.TextColor
                        toggleDisabled.ImageColor3 = themeList.SchemeColor
                        toggleEnabled.ImageColor3 = themeList.SchemeColor
                        togName.TextColor3 = themeList.TextColor
                    end
                end)()
                
                local ToggleFunction = {}
                
                -- Функция обновления переключателя
                function ToggleFunction:UpdateToggle(newText, isTogOn)
                    if newText then togName.Text = newText end
                    if isTogOn ~= nil then
                        toggled = isTogOn
                        Utility:TweenObject(toggleEnabled, {
                            ImageTransparency = toggled and 0 or 1
                        }, 0.1)
                        pcall(callback, toggled)
                    end
                end
                
                return ToggleFunction
            end

            -- Функция создания слайдера
            function Elements:NewSlider(slidInf, slidTip, minvalue, maxvalue, startvalue, callback)
                slidInf = slidInf or "Slider"
                slidTip = slidTip or "Adjust value"
                minvalue = minvalue or 0
                maxvalue = maxvalue or 100
                startvalue = startvalue or minvalue
                callback = callback or function() end
                
                local sliderElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local sliderName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local sliderTrack = Instance.new("Frame")
                local sliderTrackCorner = Instance.new("UICorner")
                local sliderThumb = Instance.new("Frame")
                local sliderThumbCorner = Instance.new("UICorner")
                local sliderValue = Instance.new("TextLabel")
                local icon = Instance.new("ImageLabel")
                
                -- Основной элемент
                sliderElement.Name = "sliderElement"
                sliderElement.Parent = sectionInners
                sliderElement.BackgroundColor3 = themeList.ElementColor
                sliderElement.ClipsDescendants = true
                sliderElement.Size = UDim2.new(1, 0, 0, 50)
                sliderElement.AutoButtonColor = false
                sliderElement.Font = Enum.Font.SourceSans
                sliderElement.Text = ""
                sliderElement.TextColor3 = Color3.new(0, 0, 0)
                sliderElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = sliderElement
                
                -- Иконка
                icon.Name = "icon"
                icon.Parent = sliderElement
                icon.BackgroundTransparency = 1
                icon.Position = UDim2.new(0.02, 0, 0.1, 0)
                icon.Size = UDim2.new(0, 21, 0, 21)
                icon.Image = "rbxassetid://3926307971"
                icon.ImageColor3 = themeList.SchemeColor
                icon.ImageRectOffset = Vector2.new(404, 164)
                icon.ImageRectSize = Vector2.new(36, 36)
                
                -- Название
                sliderName.Name = "sliderName"
                sliderName.Parent = sliderElement
                sliderName.BackgroundTransparency = 1
                sliderName.Position = UDim2.new(0.1, 0, 0.1, 0)
                sliderName.Size = UDim2.new(0.5, 0, 0, 21)
                sliderName.Font = Enum.Font.GothamSemibold
                sliderName.Text = slidInf
                sliderName.TextColor3 = themeList.TextColor
                sliderName.TextSize = 14
                sliderName.TextXAlignment = Enum.TextXAlignment.Left
                sliderName.RichText = true
                
                -- Значение
                sliderValue.Name = "sliderValue"
                sliderValue.Parent = sliderElement
                sliderValue.BackgroundTransparency = 1
                sliderValue.Position = UDim2.new(0.8, 0, 0.1, 0)
                sliderValue.Size = UDim2.new(0.15, 0, 0, 21)
                sliderValue.Font = Enum.Font.GothamSemibold
                sliderValue.Text = tostring(startvalue)
                sliderValue.TextColor3 = themeList.SchemeColor
                sliderValue.TextSize = 14
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                -- Кнопка информации
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = sliderElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.1, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                -- Дорожка слайдера
                sliderTrack.Name = "sliderTrack"
                sliderTrack.Parent = sliderElement
                sliderTrack.BackgroundColor3 = Color3.fromRGB(
                    themeList.ElementColor.r * 255 + 5,
                    themeList.ElementColor.g * 255 + 5,
                    themeList.ElementColor.b * 255 + 5
                )
                sliderTrack.BorderSizePixel = 0
                sliderTrack.Position = UDim2.new(0.05, 0, 0.7, 0)
                sliderTrack.Size = UDim2.new(0.9, 0, 0, 5)
                
                sliderTrackCorner.CornerRadius = UDim.new(1, 0)
                sliderTrackCorner.Parent = sliderTrack
                
                -- Ползунок
                sliderThumb.Name = "sliderThumb"
                sliderThumb.Parent = sliderTrack
                sliderThumb.BackgroundColor3 = themeList.SchemeColor
                sliderThumb.Size = UDim2.new(0, 10, 1, 0)
                
                sliderThumbCorner.CornerRadius = UDim.new(1, 0)
                sliderThumbCorner.Parent = sliderThumb
                
                -- Подсказка
                local moreInfo = Instance.new("TextLabel")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 14,
                    themeList.SchemeColor.g * 255 - 17,
                    themeList.SchemeColor.b * 255 - 13
                )
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..slidTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.RichText = true
                
                local UICornerTip = Instance.new("UICorner")
                UICornerTip.CornerRadius = UDim.new(0, 4)
                UICornerTip.Parent = moreInfo
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                updateSectionFrame()
                
                -- Обработчики событий
                local mouse = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                local sliding = false
                local hovering = false
                
                -- Установка начального значения
                local function setValue(value)
                    value = math.clamp(value, minvalue, maxvalue)
                    local percent = (value - minvalue) / (maxvalue - minvalue)
                    sliderThumb.Position = UDim2.new(percent, -5, 0, 0)
                    sliderValue.Text = tostring(math.floor(value))
                    callback(value)
                end
                
                setValue(startvalue)
                
                sliderElement.MouseEnter:Connect(function()
                    if not focusing then
                        Utility:TweenObject(sliderElement, {
                            BackgroundColor3 = Color3.fromRGB(
                                themeList.ElementColor.r * 255 + 8,
                                themeList.ElementColor.g * 255 + 9,
                                themeList.ElementColor.b * 255 + 10
                            )
                        }, 0.1)
                        hovering = true
                    end
                end)
                
                sliderElement.MouseLeave:Connect(function()
                    if not focusing and not sliding then
                        Utility:TweenObject(sliderElement, {
                            BackgroundColor3 = themeList.ElementColor
                        }, 0.1)
                        hovering = false
                    end
                end)
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        local percent = (mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                        local value = minvalue + (maxvalue - minvalue) * math.clamp(percent, 0, 1)
                        setValue(value)
                    end
                end)
                
                sliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                        if not hovering then
                            Utility:TweenObject(sliderElement, {
                                BackgroundColor3 = themeList.ElementColor
                            }, 0.1)
                        end
                    end
                end)
                
                uis.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
                        local percent = (mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                        local value = minvalue + (maxvalue - minvalue) * math.clamp(percent, 0, 1)
                        setValue(value)
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        
                        for _, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(sliderElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        
                        wait(1.5)
                        
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        
                        wait(0.1)
                        viewDe = false
                    end
                end)
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            sliderElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 14,
                            themeList.SchemeColor.g * 255 - 17,
                            themeList.SchemeColor.b * 255 - 13
                        )
                        moreInfo.TextColor3 = themeList.TextColor
                        icon.ImageColor3 = themeList.SchemeColor
                        sliderName.TextColor3 = themeList.TextColor
                        sliderValue.TextColor3 = themeList.SchemeColor
                        sliderTrack.BackgroundColor3 = Color3.fromRGB(
                            themeList.ElementColor.r * 255 + 5,
                            themeList.ElementColor.g * 255 + 5,
                            themeList.ElementColor.b * 255 + 5
                        )
                        sliderThumb.BackgroundColor3 = themeList.SchemeColor
                    end
                end)()
                
                local SliderFunction = {}
                
                -- Функция обновления слайдера
                function SliderFunction:UpdateSlider(newText, newMin, newMax, newValue)
                    if newText then sliderName.Text = newText end
                    if newMin then minvalue = newMin end
                    if newMax then maxvalue = newMax end
                    if newValue then setValue(newValue) end
                end
                
                return SliderFunction
            end

            -- Функция создания выпадающего списка
            function Elements:NewDropdown(dropname, dropinf, list, callback)
                dropname = dropname or "Dropdown"
                dropinf = dropinf or "Select an option"
                list = list or {}
                callback = callback or function() end
                
                local opened = false
                local DropYSize = 35
                
                local dropFrame = Instance.new("Frame")
                local dropOpen = Instance.new("TextButton")
                local dropOpenCorner = Instance.new("UICorner")
                local listIcon = Instance.new("ImageLabel")
                local itemTextbox = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local dropArrow = Instance.new("ImageLabel")
                local dropOptions = Instance.new("Frame")
                local dropOptionsLayout = Instance.new("UIListLayout")
                local Sample = Instance.new("ImageLabel")
                
                -- Основной фрейм
                dropFrame.Name = "dropFrame"
                dropFrame.Parent = sectionInners
                dropFrame.BackgroundTransparency = 1
                dropFrame.Size = UDim2.new(1, 0, 0, 35)
                dropFrame.ClipsDescendants = true
                
                -- Кнопка открытия
                dropOpen.Name = "dropOpen"
                dropOpen.Parent = dropFrame
                dropOpen.BackgroundColor3 = themeList.ElementColor
                dropOpen.Size = UDim2.new(1, 0, 0, 35)
                dropOpen.AutoButtonColor = false
                dropOpen.Font = Enum.Font.SourceSans
                dropOpen.Text = ""
                dropOpen.TextColor3 = Color3.new(0, 0, 0)
                dropOpen.TextSize = 14
                dropOpen.ClipsDescendants = true
                
                dropOpenCorner.CornerRadius = UDim.new(0, 4)
                dropOpenCorner.Parent = dropOpen
                
                -- Иконка списка
                listIcon.Name = "listIcon"
                listIcon.Parent = dropOpen
                listIcon.BackgroundTransparency = 1
                listIcon.Position = UDim2.new(0.02, 0, 0.2, 0)
                listIcon.Size = UDim2.new(0, 21, 0, 21)
                listIcon.Image = "rbxassetid://3926305904"
                listIcon.ImageColor3 = themeList.SchemeColor
                listIcon.ImageRectOffset = Vector2.new(644, 364)
                listIcon.ImageRectSize = Vector2.new(36, 36)
                
                -- Текущий выбранный элемент
                itemTextbox.Name = "itemTextbox"
                itemTextbox.Parent = dropOpen
                itemTextbox.BackgroundTransparency = 1
                itemTextbox.Position = UDim2.new(0.1, 0, 0.2, 0)
                itemTextbox.Size = UDim2.new(0.7, 0, 0, 21)
                itemTextbox.Font = Enum.Font.GothamSemibold
                itemTextbox.Text = dropname
                itemTextbox.TextColor3 = themeList.TextColor
                itemTextbox.TextSize = 14
                itemTextbox.TextXAlignment = Enum.TextXAlignment.Left
                itemTextbox.RichText = true
                
                -- Кнопка информации
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = dropOpen
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.15, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                -- Стрелка
                dropArrow.Name = "dropArrow"
                dropArrow.Parent = dropOpen
                dropArrow.BackgroundTransparency = 1
                dropArrow.Position = UDim2.new(0.9, 0, 0.25, 0)
                dropArrow.Size = UDim2.new(0, 15, 0, 15)
                dropArrow.Image = "rbxassetid://3926305904"
                dropArrow.ImageColor3 = themeList.SchemeColor
                dropArrow.ImageRectOffset = Vector2.new(284, 4)
                dropArrow.ImageRectSize = Vector2.new(24, 24)
                dropArrow.Rotation = 180
                
                -- Контейнер опций
                dropOptions.Name = "dropOptions"
                dropOptions.Parent = dropFrame
                dropOptions.BackgroundColor3 = themeList.ElementColor
                dropOptions.Position = UDim2.new(0, 0, 0, 40)
                dropOptions.Size = UDim2.new(1, 0, 0, 0)
                dropOptions.Visible = false
                
                local dropOptionsCorner = Instance.new("UICorner")
                dropOptionsCorner.CornerRadius = UDim.new(0, 4)
                dropOptionsCorner.Parent = dropOptions
                
                dropOptionsLayout.Name = "dropOptionsLayout"
                dropOptionsLayout.Parent = dropOptions
                dropOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropOptionsLayout.Padding = UDim.new(0, 3)
                
                -- Эффект нажатия
                Sample.Name = "Sample"
                Sample.Parent = dropOpen
                Sample.BackgroundTransparency = 1
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                -- Подсказка
                local moreInfo = Instance.new("TextLabel")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 14,
                    themeList.SchemeColor.g * 255 - 17,
                    themeList.SchemeColor.b * 255 - 13
                )
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..dropinf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.RichText = true
                
                local UICornerTip = Instance.new("UICorner")
                UICornerTip.CornerRadius = UDim.new(0, 4)
                UICornerTip.Parent = moreInfo
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                updateSectionFrame()
                
                -- Обработчики событий
                local hovering = false
                local ms = game.Players.LocalPlayer:GetMouse()
                
                -- Функция открытия/закрытия списка
                local function toggleDropdown()
                    opened = not opened
                    
                    if opened then
                        dropOptions.Visible = true
                        dropArrow.Rotation = 0
                        dropFrame.Size = UDim2.new(1, 0, 0, 35 + dropOptionsLayout.AbsoluteContentSize.Y)
                        Utility:TweenObject(dropOptions, {
                            Size = UDim2.new(1, 0, 0, dropOptionsLayout.AbsoluteContentSize.Y)
                        }, 0.2)
                    else
                        dropArrow.Rotation = 180
                        Utility:TweenObject(dropOptions, {
                            Size = UDim2.new(1, 0, 0, 0)
                        }, 0.2, nil, function()
                            dropOptions.Visible = false
                            dropFrame.Size = UDim2.new(1, 0, 0, 35)
                        end)
                    end
                    
                    updateSectionFrame()
                end
                
                dropOpen.MouseEnter:Connect(function()
                    if not focusing then
                        Utility:TweenObject(dropOpen, {
                            BackgroundColor3 = Color3.fromRGB(
                                themeList.ElementColor.r * 255 + 8,
                                themeList.ElementColor.g * 255 + 9,
                                themeList.ElementColor.b * 255 + 10
                            )
                        }, 0.1)
                        hovering = true
                    end
                end)
                
                dropOpen.MouseLeave:Connect(function()
                    if not focusing then
                        Utility:TweenObject(dropOpen, {
                            BackgroundColor3 = themeList.ElementColor
                        }, 0.1)
                        hovering = false
                    end
                end)
                
                dropOpen.MouseButton1Click:Connect(function()
                    if not focusing then
                        toggleDropdown()
                        
                        -- Эффект волны
                        local c = Sample:Clone()
                        c.Parent = dropOpen
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        
                        local len, size = 0.35, nil
                        if dropOpen.AbsoluteSize.X >= dropOpen.AbsoluteSize.Y then
                            size = (dropOpen.AbsoluteSize.X * 1.5)
                        else
                            size = (dropOpen.AbsoluteSize.Y * 1.5)
                        end
                        
                        c:TweenSizeAndPosition(
                            UDim2.new(0, size, 0, size),
                            UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)),
                            'Out', 'Quad', len, true, nil
                        )
                        
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    else
                        for _, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        
                        for _, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(dropOpen, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        
                        wait(1.5)
                        
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        
                        wait(0.1)
                        viewDe = false
                    end
                end)
                
                -- Создание элементов списка
                local function createOption(optionName)
                    local optionButton = Instance.new("TextButton")
                    local optionCorner = Instance.new("UICorner")
                    local optionSample = Instance.new("ImageLabel")
                    
                    optionButton.Name = "optionButton"
                    optionButton.Parent = dropOptions
                    optionButton.BackgroundColor3 = themeList.ElementColor
                    optionButton.Size = UDim2.new(1, -10, 0, 30)
                    optionButton.Position = UDim2.new(0, 5, 0, 0)
                    optionButton.AutoButtonColor = false
                    optionButton.Font = Enum.Font.GothamSemibold
                    optionButton.Text = "  "..optionName
                    optionButton.TextColor3 = Color3.fromRGB(
                        themeList.TextColor.r * 255 - 6,
                        themeList.TextColor.g * 255 - 6,
                        themeList.TextColor.b * 255 - 6
                    )
                    optionButton.TextSize = 14
                    optionButton.TextXAlignment = Enum.TextXAlignment.Left
                    
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionButton
                    
                    optionSample.Name = "optionSample"
                    optionSample.Parent = optionButton
                    optionSample.BackgroundTransparency = 1
                    optionSample.Image = "http://www.roblox.com/asset/?id=4560909609"
                    optionSample.ImageColor3 = themeList.SchemeColor
                    optionSample.ImageTransparency = 0.6
                    
                    local optionHovering = false
                    
                    optionButton.MouseEnter:Connect(function()
                        if not focusing then
                            Utility:TweenObject(optionButton, {
                                BackgroundColor3 = Color3.fromRGB(
                                    themeList.ElementColor.r * 255 + 8,
                                    themeList.ElementColor.g * 255 + 9,
                                    themeList.ElementColor.b * 255 + 10
                                )
                            }, 0.1)
                            optionHovering = true
                        end
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        if not focusing then
                            Utility:TweenObject(optionButton, {
                                BackgroundColor3 = themeList.ElementColor
                            }, 0.1)
                            optionHovering = false
                        end
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        if not focusing then
                            itemTextbox.Text = optionName
                            callback(optionName)
                            toggleDropdown()
                            
                            -- Эффект волны
                            local c = optionSample:Clone()
                            c.Parent = optionButton
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            
                            local len, size = 0.35, nil
                            if optionButton.AbsoluteSize.X >= optionButton.AbsoluteSize.Y then
                                size = (optionButton.AbsoluteSize.X * 1.5)
                            else
                                size = (optionButton.AbsoluteSize.Y * 1.5)
                            end
                            
                            c:TweenSizeAndPosition(
                                UDim2.new(0, size, 0, size),
                                UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)),
                                'Out', 'Quad', len, true, nil
                            )
                            
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                wait(len / 12)
                            end
                            c:Destroy()
                        else
                            for _, v in next, infoContainer:GetChildren() do
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                    end)
                    
                    coroutine.wrap(function()
                        while wait() do
                            if not optionHovering then
                                optionButton.BackgroundColor3 = themeList.ElementColor
                            end
                            optionButton.TextColor3 = Color3.fromRGB(
                                themeList.TextColor.r * 255 - 6,
                                themeList.TextColor.g * 255 - 6,
                                themeList.TextColor.b * 255 - 6
                            )
                            optionSample.ImageColor3 = themeList.SchemeColor
                        end
                    end)()
                end
                
                -- Добавление элементов в список
                for _, option in pairs(list) do
                    createOption(option)
                end
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            dropOpen.BackgroundColor3 = themeList.ElementColor
                        end
                        dropOptions.BackgroundColor3 = themeList.ElementColor
                        listIcon.ImageColor3 = themeList.SchemeColor
                        itemTextbox.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        dropArrow.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 14,
                            themeList.SchemeColor.g * 255 - 17,
                            themeList.SchemeColor.b * 255 - 13
                        )
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)()
                
                local DropdownFunction = {}
                
                -- Функция обновления списка
                function DropdownFunction:Refresh(newList)
                    for _, child in ipairs(dropOptions:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, option in pairs(newList) do
                        createOption(option)
                    end
                    
                    if opened then
                        dropFrame.Size = UDim2.new(1, 0, 0, 35 + dropOptionsLayout.AbsoluteContentSize.Y)
                        dropOptions.Size = UDim2.new(1, 0, 0, dropOptionsLayout.AbsoluteContentSize.Y)
                    end
                    
                    updateSectionFrame()
                end
                
                return DropdownFunction
            end

            -- Функция создания горячей клавиши
            function Elements:NewKeybind(keytext, keyinf, first, callback)
                keytext = keytext or "Keybind"
                keyinf = keyinf or "Press a key"
                callback = callback or function() end
                local oldKey = first.Name
                
                local keybindElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local keybindName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local icon = Instance.new("ImageLabel")
                local keybindValue = Instance.new("TextLabel")
                local Sample = Instance.new("ImageLabel")
                
                -- Основной элемент
                keybindElement.Name = "keybindElement"
                keybindElement.Parent = sectionInners
                keybindElement.BackgroundColor3 = themeList.ElementColor
                keybindElement.ClipsDescendants = true
                keybindElement.Size = UDim2.new(1, 0, 0, 35)
                keybindElement.AutoButtonColor = false
                keybindElement.Font = Enum.Font.SourceSans
                keybindElement.Text = ""
                keybindElement.TextColor3 = Color3.new(0, 0, 0)
                keybindElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = keybindElement
                
                -- Иконка
                icon.Name = "icon"
                icon.Parent = keybindElement
                icon.BackgroundTransparency = 1
                icon.Position = UDim2.new(0.02, 0, 0.2, 0)
                icon.Size = UDim2.new(0, 21, 0, 21)
                icon.Image = "rbxassetid://3926305904"
                icon.ImageColor3 = themeList.SchemeColor
                icon.ImageRectOffset = Vector2.new(364, 284)
                icon.ImageRectSize = Vector2.new(36, 36)
                
                -- Название
                keybindName.Name = "keybindName"
                keybindName.Parent = keybindElement
                keybindName.BackgroundTransparency = 1
                keybindName.Position = UDim2.new(0.1, 0, 0.2, 0)
                keybindName.Size = UDim2.new(0.6, 0, 0, 21)
                keybindName.Font = Enum.Font.GothamSemibold
                keybindName.Text = keytext
                keybindName.TextColor3 = themeList.TextColor
                keybindName.TextSize = 14
                keybindName.TextXAlignment = Enum.TextXAlignment.Left
                keybindName.RichText = true
                
                -- Значение клавиши
                keybindValue.Name = "keybindValue"
                keybindValue.Parent = keybindElement
                keybindValue.BackgroundTransparency = 1
                keybindValue.Position = UDim2.new(0.75, 0, 0.2, 0)
                keybindValue.Size = UDim2.new(0.2, 0, 0, 21)
                keybindValue.Font = Enum.Font.GothamSemibold
                keybindValue.Text = oldKey
                keybindValue.TextColor3 = themeList.SchemeColor
                keybindValue.TextSize = 14
                keybindValue.TextXAlignment = Enum.TextXAlignment.Right
                
                -- Кнопка информации
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = keybindElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.15, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                -- Эффект нажатия
                Sample.Name = "Sample"
                Sample.Parent = keybindElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                -- Подсказка
                local moreInfo = Instance.new("TextLabel")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 14,
                    themeList.SchemeColor.g * 255 - 17,
                    themeList.SchemeColor.b * 255 - 13
                )
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..keyinf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.RichText = true
                
                local UICornerTip = Instance.new("UICorner")
                UICornerTip.CornerRadius = UDim.new(0, 4)
                UICornerTip.Parent = moreInfo
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                updateSectionFrame()
                
                -- Обработчики событий
                local uis = game:GetService("UserInputService")
                local ms = game.Players.LocalPlayer:GetMouse()
                local selecting = false
                local hovering = false
                
                -- Обработчик нажатия клавиши
                local function keyPressed(input, gameProcessed)
                    if input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
                        if input.KeyCode.Name ~= "Unknown" then
                            keybindValue.Text = input.KeyCode.Name
                            oldKey = input.KeyCode.Name
                        end
                        selecting = false
                        keybindElement.Text = ""
                    end
                end
                
                -- Обработчик активации клавиши
                local function keyActive(input, gameProcessed)
                    if not gameProcessed and input.KeyCode.Name == oldKey then
                        callback()
                    end
                end
                
                keybindElement.MouseEnter:Connect(function()
                    if not focusing and not selecting then
                        Utility:TweenObject(keybindElement, {
                            BackgroundColor3 = Color3.fromRGB(
                                themeList.ElementColor.r * 255 + 8,
                                themeList.ElementColor.g * 255 + 9,
                                themeList.ElementColor.b * 255 + 10
                            )
                        }, 0.1)
                        hovering = true
                    end
                end)
                
                keybindElement.MouseLeave:Connect(function()
                    if not focusing and not selecting then
                        Utility:TweenObject(keybindElement, {
                            BackgroundColor3 = themeList.ElementColor
                        }, 0.1)
                        hovering = false
                    end
                end)
                
                keybindElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        if not selecting then
                            selecting = true
                            keybindValue.Text = "..."
                            uis.InputBegan:ConnectOnce(keyPressed)
                            
                            -- Эффект волны
                            local c = Sample:Clone()
                            c.Parent = keybindElement
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            
                            local len, size = 0.35, nil
                            if keybindElement.AbsoluteSize.X >= keybindElement.AbsoluteSize.Y then
                                size = (keybindElement.AbsoluteSize.X * 1.5)
                            else
                                size = (keybindElement.AbsoluteSize.Y * 1.5)
                            end
                            
                            c:TweenSizeAndPosition(
                                UDim2.new(0, size, 0, size),
                                UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)),
                                'Out', 'Quad', len, true, nil
                            )
                            
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                wait(len / 12)
                            end
                            c:Destroy()
                        end
                    else
                        for _, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        
                        for _, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(keybindElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        
                        wait(1.5)
                        
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        
                        wait(0.1)
                        viewDe = false
                    end
                end)
                
                -- Подключение обработчика клавиш
                uis.InputBegan:Connect(keyActive)
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            keybindElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 14,
                            themeList.SchemeColor.g * 255 - 17,
                            themeList.SchemeColor.b * 255 - 13
                        )
                        moreInfo.TextColor3 = themeList.TextColor
                        icon.ImageColor3 = themeList.SchemeColor
                        keybindName.TextColor3 = themeList.TextColor
                        keybindValue.TextColor3 = themeList.SchemeColor
                    end
                end)()
                
                local KeybindFunction = {}
                
                -- Функция обновления горячей клавиши
                function KeybindFunction:UpdateKeybind(newText, newKey)
                    if newText then keybindName.Text = newText end
                    if newKey then
                        oldKey = newKey.Name
                        keybindValue.Text = oldKey
                    end
                end
                
                return KeybindFunction
            end

            -- Функция создания цветового пикера
            function Elements:NewColorPicker(colText, colInf, defcolor, callback)
                colText = colText or "ColorPicker"
                colInf = colInf or "Select a color"
                defcolor = defcolor or Color3.fromRGB(255, 0, 0)
                callback = callback or function() end
                
                local colorOpened = false
                local currentColor = defcolor
                local rainbowMode = false
                local rainbowConnection
                
                local colorElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local colorHeader = Instance.new("Frame")
                local headerCorner = Instance.new("UICorner")
                local colorName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local colorPreview = Instance.new("Frame")
                local previewCorner = Instance.new("UICorner")
                local colorContent = Instance.new("Frame")
                local contentCorner = Instance.new("UICorner")
                local colorContentLayout = Instance.new("UIListLayout")
                local rgbWheel = Instance.new("ImageButton")
                local rgbCorner = Instance.new("UICorner")
                local rgbCursor = Instance.new("ImageLabel")
                local darknessSlider = Instance.new("ImageButton")
                local darknessCorner = Instance.new("UICorner")
                local darknessCursor = Instance.new("ImageLabel")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled = Instance.new("ImageLabel")
                local rainbowText = Instance.new("TextLabel")
                local rainbowButton = Instance.new("TextButton")
                local Sample = Instance.new("ImageLabel")
                
                -- Основной элемент
                colorElement.Name = "colorElement"
                colorElement.Parent = sectionInners
                colorElement.BackgroundColor3 = themeList.ElementColor
                colorElement.ClipsDescendants = true
                colorElement.Size = UDim2.new(1, 0, 0, 35)
                colorElement.AutoButtonColor = false
                colorElement.Font = Enum.Font.SourceSans
                colorElement.Text = ""
                colorElement.TextColor3 = Color3.new(0, 0, 0)
                colorElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = colorElement
                
                -- Заголовок
                colorHeader.Name = "colorHeader"
                colorHeader.Parent = colorElement
                colorHeader.BackgroundColor3 = themeList.ElementColor
                colorHeader.Size = UDim2.new(1, 0, 0, 35)
                
                headerCorner.CornerRadius = UDim.new(0, 4)
                headerCorner.Name = "headerCorner"
                headerCorner.Parent = colorHeader
                
                -- Название
                colorName.Name = "colorName"
                colorName.Parent = colorHeader
                colorName.BackgroundTransparency = 1
                colorName.Position = UDim2.new(0.1, 0, 0, 0)
                colorName.Size = UDim2.new(0.6, 0, 1, 0)
                colorName.Font = Enum.Font.GothamSemibold
                colorName.Text = colText
                colorName.TextColor3 = themeList.TextColor
                colorName.TextSize = 14
                colorName.TextXAlignment = Enum.TextXAlignment.Left
                colorName.RichText = true
                
                -- Кнопка информации
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = colorHeader
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.15, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                -- Превью цвета
                colorPreview.Name = "colorPreview"
                colorPreview.Parent = colorHeader
                colorPreview.BackgroundColor3 = currentColor
                colorPreview.Position = UDim2.new(0.8, 0, 0.2, 0)
                colorPreview.Size = UDim2.new(0, 21, 0, 21)
                
                previewCorner.CornerRadius = UDim.new(0, 4)
                previewCorner.Parent = colorPreview
                
                -- Контент цветового пикера
                colorContent.Name = "colorContent"
                colorContent.Parent = colorElement
                colorContent.BackgroundColor3 = themeList.ElementColor
                colorContent.Position = UDim2.new(0, 0, 0, 40)
                colorContent.Size = UDim2.new(1, 0, 0, 0)
                colorContent.Visible = false
                
                contentCorner.CornerRadius = UDim.new(0, 4)
                contentCorner.Parent = colorContent
                
                colorContentLayout.Name = "colorContentLayout"
                colorContentLayout.Parent = colorContent
                colorContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                colorContentLayout.Padding = UDim.new(0, 5)
                
                -- RGB колесо
                rgbWheel.Name = "rgbWheel"
                rgbWheel.Parent = colorContent
                rgbWheel.BackgroundColor3 = Color3.new(1, 1, 1)
                rgbWheel.Size = UDim2.new(1, -10, 0, 150)
                rgbWheel.Position = UDim2.new(0, 5, 0, 5)
                rgbWheel.Image = "http://www.roblox.com/asset/?id=6523286724"
                rgbWheel.AutoButtonColor = false
                
                rgbCorner.CornerRadius = UDim.new(0, 4)
                rgbCorner.Parent = rgbWheel
                
                rgbCursor.Name = "rgbCursor"
                rgbCursor.Parent = rgbWheel
                rgbCursor.BackgroundTransparency = 1
                rgbCursor.Size = UDim2.new(0, 14, 0, 14)
                rgbCursor.Image = "rbxassetid://3926309567"
                rgbCursor.ImageColor3 = Color3.new(0, 0, 0)
                rgbCursor.ImageRectOffset = Vector2.new(628, 420)
                rgbCursor.ImageRectSize = Vector2.new(48, 48)
                
                -- Слайдер темноты
                darknessSlider.Name = "darknessSlider"
                darknessSlider.Parent = colorContent
                darknessSlider.BackgroundColor3 = Color3.new(1, 1, 1)
                darknessSlider.Position = UDim2.new(0, 5, 0, 160)
                darknessSlider.Size = UDim2.new(1, -10, 0, 20)
                darknessSlider.Image = "http://www.roblox.com/asset/?id=6523291212"
                darknessSlider.AutoButtonColor = false
                
                darknessCorner.CornerRadius = UDim.new(0, 4)
                darknessCorner.Parent = darknessSlider
                
                darknessCursor.Name = "darknessCursor"
                darknessCursor.Parent = darknessSlider
                darknessCursor.AnchorPoint = Vector2.new(0.5, 0)
                darknessCursor.BackgroundTransparency = 1
                darknessCursor.Size = UDim2.new(0, 14, 0, 14)
                darknessCursor.Image = "rbxassetid://3926309567"
                darknessCursor.ImageColor3 = Color3.new(0, 0, 0)
                darknessCursor.ImageRectOffset = Vector2.new(628, 420)
                darknessCursor.ImageRectSize = Vector2.new(48, 48)
                
                -- Переключатель радуги
                toggleDisabled.Name = "toggleDisabled"
                toggleDisabled.Parent = colorContent
                toggleDisabled.BackgroundTransparency = 1
                toggleDisabled.Position = UDim2.new(0.05, 0, 0, 185)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://3926309567"
                toggleDisabled.ImageColor3 = themeList.SchemeColor
                toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
                toggleDisabled.ImageRectSize = Vector2.new(48, 48)
                
                toggleEnabled.Name = "toggleEnabled"
                toggleEnabled.Parent = colorContent
                toggleEnabled.BackgroundTransparency = 1
                toggleEnabled.Position = UDim2.new(0.05, 0, 0, 185)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://3926309567"
                toggleEnabled.ImageColor3 = themeList.SchemeColor
                toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
                toggleEnabled.ImageRectSize = Vector2.new(48, 48)
                toggleEnabled.ImageTransparency = 1
                
                rainbowText.Name = "rainbowText"
                rainbowText.Parent = colorContent
                rainbowText.BackgroundTransparency = 1
                rainbowText.Position = UDim2.new(0.1, 0, 0, 185)
                rainbowText.Size = UDim2.new(0.8, 0, 0, 21)
                rainbowText.Font = Enum.Font.GothamSemibold
                rainbowText.Text = "Rainbow"
                rainbowText.TextColor3 = themeList.TextColor
                rainbowText.TextSize = 14
                rainbowText.TextXAlignment = Enum.TextXAlignment.Left
                
                rainbowButton.Name = "rainbowButton"
                rainbowButton.Parent = toggleEnabled
                rainbowButton.BackgroundTransparency = 1
                rainbowButton.Size = UDim2.new(1, 0, 1, 0)
                rainbowButton.Font = Enum.Font.SourceSans
                rainbowButton.Text = ""
                rainbowButton.TextColor3 = Color3.new(0, 0, 0)
                rainbowButton.TextSize = 14
                
                -- Эффект нажатия
                Sample.Name = "Sample"
                Sample.Parent = colorHeader
                Sample.BackgroundTransparency = 1
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                -- Подсказка
                local moreInfo = Instance.new("TextLabel")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(
                    themeList.SchemeColor.r * 255 - 14,
                    themeList.SchemeColor.g * 255 - 17,
                    themeList.SchemeColor.b * 255 - 13
                )
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..colInf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.RichText = true
                
                local UICornerTip = Instance.new("UICorner")
                UICornerTip.CornerRadius = UDim.new(0, 4)
                UICornerTip.Parent = moreInfo
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                updateSectionFrame()
                
                -- Обработчики событий
                local ms = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                local rs = game:GetService("RunService")
                local colorPicking = false
                local darknessPicking = false
                local hovering = false
                
                -- Функция открытия/закрытия цветового пикера
                local function toggleColorPicker()
                    colorOpened = not colorOpened
                    
                    if colorOpened then
                        colorContent.Visible = true
                        colorElement.Size = UDim2.new(1, 0, 0, 220)
                        Utility:TweenObject(colorContent, {
                            Size = UDim2.new(1, 0, 0, 210)
                        }, 0.2)
                    else
                        Utility:TweenObject(colorContent, {
                            Size = UDim2.new(1, 0, 0, 0)
                        }, 0.2, nil, function()
                            colorContent.Visible = false
                            colorElement.Size = UDim2.new(1, 0, 0, 35)
                        end)
                    end
                    
                    updateSectionFrame()
                end
                
                -- Функция установки цвета
                local function setColor(color)
                    currentColor = color
                    colorPreview.BackgroundColor3 = color
                    callback(color)
                end
                
                -- Функция установки HSV
                local function setHSV(h, s, v)
                    local color = Color3.fromHSV(h, s, v)
                    setColor(color)
                end
                
                -- Функция обновления позиции курсоров
                local function updateColorPicker()
                    local h, s, v = Color3.toHSV(currentColor)
                    
                    -- Обновление RGB курсора
                    local x = s * rgbWheel.AbsoluteSize.X
                    local y = (1 - h) * rgbWheel.AbsoluteSize.Y
                    rgbCursor.Position = UDim2.new(0, x - 7, 0, y - 7)
                    
                    -- Обновление слайдера темноты
                    local darknessY = (1 - v) * darknessSlider.AbsoluteSize.Y
                    darknessCursor.Position = UDim2.new(0.5, 0, 0, darknessY - 7)
                    darknessCursor.ImageColor3 = Color3.fromHSV(h, s, 1)
                end
                
                -- Инициализация
                updateColorPicker()
                
                -- Обработка нажатия на RGB колесо
                rgbWheel.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        colorPicking = true
                        
                        local x = (ms.X - rgbWheel.AbsolutePosition.X) / rgbWheel.AbsoluteSize.X
                        local y = (ms.Y - rgbWheel.AbsolutePosition.Y) / rgbWheel.AbsoluteSize.Y
                        x = math.clamp(x, 0, 1)
                        y = math.clamp(y, 0, 1)
                        
                        local h = 1 - y
                        local s = x
                        local _, _, v = Color3.toHSV(currentColor)
                        
                        setHSV(h, s, v)
                        rgbCursor.Position = UDim2.new(0, x * rgbWheel.AbsoluteSize.X - 7, 0, y * rgbWheel.AbsoluteSize.Y - 7)
                    end
                end)
                
                -- Обработка нажатия на слайдер темноты
                darknessSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        darknessPicking = true
                        
                        local y = (ms.Y - darknessSlider.AbsolutePosition.Y) / darknessSlider.AbsoluteSize.Y
                        y = math.clamp(y, 0, 1)
                        
                        local h, s, _ = Color3.toHSV(currentColor)
                        local v = 1 - y
                        
                        setHSV(h, s, v)
                        darknessCursor.Position = UDim2.new(0.5, 0, 0, y * darknessSlider.AbsoluteSize.Y - 7)
                    end
                end)
                
                -- Обработка движения мыши
                uis.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if colorPicking then
                            local x = (ms.X - rgbWheel.AbsolutePosition.X) / rgbWheel.AbsoluteSize.X
                            local y = (ms.Y - rgbWheel.AbsolutePosition.Y) / rgbWheel.AbsoluteSize.Y
                            x = math.clamp(x, 0, 1)
                            y = math.clamp(y, 0, 1)
                            
                            local h = 1 - y
                            local s = x
                            local _, _, v = Color3.toHSV(currentColor)
                            
                            setHSV(h, s, v)
                            rgbCursor.Position = UDim2.new(0, x * rgbWheel.AbsoluteSize.X - 7, 0, y * rgbWheel.AbsoluteSize.Y - 7)
                        elseif darknessPicking then
                            local y = (ms.Y - darknessSlider.AbsolutePosition.Y) / darknessSlider.AbsoluteSize.Y
                            y = math.clamp(y, 0, 1)
                            
                            local h, s, _ = Color3.toHSV(currentColor)
                            local v = 1 - y
                            
                            setHSV(h, s, v)
                            darknessCursor.Position = UDim2.new(0.5, 0, 0, y * darknessSlider.AbsoluteSize.Y - 7)
                        end
                    end
                end)
                
                -- Обработка отпускания кнопки мыши
                uis.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        colorPicking = false
                        darknessPicking = false
                    end
                end)
                
                -- Обработка переключателя радуги
                rainbowButton.MouseButton1Click:Connect(function()
                    rainbowMode = not rainbowMode
                    
                    if rainbowMode then
                        Utility:TweenObject(toggleEnabled, {ImageTransparency = 0}, 0.1)
                        
                        rainbowConnection = rs.RenderStepped:Connect(function(delta)
                            local hue = tick() % 5 / 5
                            local h, s, v = Color3.toHSV(currentColor)
                            setHSV(hue, s, v)
                            updateColorPicker()
                        end)
                    else
                        Utility:TweenObject(toggleEnabled, {ImageTransparency = 1}, 0.1)
                        
                        if rainbowConnection then
                            rainbowConnection:Disconnect()
                            rainbowConnection = nil
                        end
                    end
                end)
                
                colorHeader.MouseEnter:Connect(function()
                    if not focusing then
                        Utility:TweenObject(colorHeader, {
                            BackgroundColor3 = Color3.fromRGB(
                                themeList.ElementColor.r * 255 + 8,
                                themeList.ElementColor.g * 255 + 9,
                                themeList.ElementColor.b * 255 + 10
                            )
                        }, 0.1)
                        hovering = true
                    end
                end)
                
                colorHeader.MouseLeave:Connect(function()
                    if not focusing then
                        Utility:TweenObject(colorHeader, {
                            BackgroundColor3 = themeList.ElementColor
                        }, 0.1)
                        hovering = false
                    end
                end)
                
                colorHeader.MouseButton1Click:Connect(function()
                    if not focusing then
                        toggleColorPicker()
                        
                        -- Эффект волны
                        local c = Sample:Clone()
                        c.Parent = colorHeader
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        
                        local len, size = 0.35, nil
                        if colorHeader.AbsoluteSize.X >= colorHeader.AbsoluteSize.Y then
                            size = (colorHeader.AbsoluteSize.X * 1.5)
                        else
                            size = (colorHeader.AbsoluteSize.Y * 1.5)
                        end
                        
                        c:TweenSizeAndPosition(
                            UDim2.new(0, size, 0, size),
                            UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)),
                            'Out', 'Quad', len, true, nil
                        )
                        
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    else
                        for _, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        
                        for _, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(colorHeader, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        
                        wait(1.5)
                        
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        
                        wait(0.1)
                        viewDe = false
                    end
                end)
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            colorHeader.BackgroundColor3 = themeList.ElementColor
                        end
                        colorContent.BackgroundColor3 = themeList.ElementColor
                        colorName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(
                            themeList.SchemeColor.r * 255 - 14,
                            themeList.SchemeColor.g * 255 - 17,
                            themeList.SchemeColor.b * 255 - 13
                        )
                        moreInfo.TextColor3 = themeList.TextColor
                        toggleDisabled.ImageColor3 = themeList.SchemeColor
                        toggleEnabled.ImageColor3 = themeList.SchemeColor
                        rainbowText.TextColor3 = themeList.TextColor
                    end
                end)()
                
                local ColorPickerFunction = {}
                
                -- Функция обновления цветового пикера
                function ColorPickerFunction:UpdateColorPicker(newText, newColor)
                    if newText then colorName.Text = newText end
                    if newColor then
                        setColor(newColor)
                        updateColorPicker()
                    end
                end
                
                return ColorPickerFunction
            end

            -- Функция создания метки
            function Elements:NewLabel(title)
                title = title or "Label"
                
                local label = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")
                
                -- Создание метки
                label.Name = "label"
                label.Parent = sectionInners
                label.BackgroundColor3 = themeList.SchemeColor
                label.Size = UDim2.new(1, 0, 0, 35)
                label.Font = Enum.Font.GothamSemibold
                label.Text = "  "..title
                label.TextColor3 = themeList.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.RichText = true
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = label
                
                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(label, {TextColor3 = Color3.new(0,0,0)}, 0.2)
                elseif themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(label, {TextColor3 = Color3.new(255,255,255)}, 0.2)
                end
                
                -- Обновление цветов
                coroutine.wrap(function()
                    while wait() do
                        label.BackgroundColor3 = themeList.SchemeColor
                        label.TextColor3 = themeList.TextColor
                    end
                end)()
                
                updateSectionFrame()
                
                local LabelFunction = {}
                
                -- Функция обновления метки
                function LabelFunction:UpdateLabel(newText)
                    label.Text = "  "..newText
                end
                
                return LabelFunction
            end
            
            return Elements
        end
        return Sections
    end
    
    return Tabs
end

return Kavo
