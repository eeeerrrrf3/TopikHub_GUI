local Kavo = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("User InputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}

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

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

-- Обновленная цветовая схема
local themes = {
    SchemeColor = Color3.fromRGB(100, 150, 200),
    Background = Color3.fromRGB(50, 50, 60),
    Header = Color3.fromRGB(40, 40, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(30, 30, 40)
}

local themeStyles = {
    RJTheme1 = {
        SchemeColor = Color3.fromRGB(112, 112, 112),
        Background = Color3.fromRGB(15, 15, 15),
        Header = Color3.fromRGB(15, 15, 15),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    -- Добавьте другие темы по аналогии
}

local oldTheme = ""
local SettingsT = {}
local Name = "KavoConfig.JSON"

pcall(function()
    if not pcall(function() readfile(Name) end) then
        writefile(Name, game:service'HttpService':JSONEncode(SettingsT))
    end
    Settings = game:service'HttpService':JSONEncode(readfile(Name))
end)

local LibName = tostring(math.random(1, 100))..tostring(math.random(1, 50))..tostring(math.random(1, 100))

function Kavo:ToggleUI()
    if game.CoreGui[LibName].Enabled then
        game.CoreGui[LibName].Enabled = false
    else
        game.CoreGui[LibName].Enabled = true
    end
end

function Kavo.CreateLib(kavName, themeList)
    if not themeList then
        themeList = themes
    end

    -- Удалите старые GUI
    for i, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then
            v:Destroy()
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainHeader = Instance.new("Frame")
    local headerCover = Instance.new("UICorner")
    local coverup = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local close = Instance.new("ImageButton")
    local MainSide = Instance.new("Frame")
    local sideCorner = Instance.new("UICorner")
    local tabFrames = Instance.new("Frame")
    local tabListing = Instance.new("UIListLayout")
    local pages = Instance.new("Frame")
    local Pages = Instance.new("Folder")
    local infoContainer = Instance.new("Frame")

    -- Настройка GUI
    Kavo:DraggingEnabled(MainHeader, Main)

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.Position = UDim2.new(0.336, 0, 0.275, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = Main

    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(0, 525, 0, 29)
    headerCover.CornerRadius = UDim.new(0, 4)
    headerCover.Parent = MainHeader

    coverup.Name = "coverup"
    coverup.Parent = MainHeader
    coverup.BackgroundColor3 = themeList.Header
    coverup.BorderSizePixel = 0
    coverup.Position = UDim2.new(0, 0, 0.7586, 0)
    coverup.Size = UDim2.new(0, 525, 0, 7)

    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.Position = UDim2.new(0.017, 0, 0.3448, 0)
    title.Size = UDim2.new(0, 204, 0, 8)
    title.Font = Enum.Font.SourceSansBold
    title.Text = kavName
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextSize = 16.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1.000
    close.Position = UDim2.new(0.95, 0, 0.138, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.MouseButton1Click:Connect(function()
        game.TweenService:Create(close, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            ImageTransparency = 1
        }):Play()
        wait()
        game.TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2), 0, Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2))
        }):Play()
        wait(1)
        ScreenGui:Destroy()
    end)

    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(0, 0, 0.091, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)
    sideCorner.CornerRadius = UDim.new(0, 4)
    sideCorner.Parent = MainSide

    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabFrames.BackgroundTransparency = 1.000
    tabFrames.Position = UDim2.new(0.0439, 0, 0, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)

    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder

    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pages.BackgroundTransparency = 1.000
    pages.BorderSizePixel = 0
    pages.Position = UDim2.new(0.299, 0, 0.1226, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)

    Pages.Name = "Pages"
    Pages.Parent = pages

    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    infoContainer.BackgroundTransparency = 1.000
    infoContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
    infoContainer.ClipsDescendants = true
    infoContainer.Position = UDim2.new(0.299, 0, 0.874, 0)
    infoContainer.Size = UDim2.new(0, 368, 0, 33)

    coroutine.wrap(function()
        while wait() do
            Main.BackgroundColor3 = themeList.Background
            MainHeader.BackgroundColor3 = themeList.Header
            MainSide.BackgroundColor3 = themeList.Header
            coverup.BackgroundColor3 = themeList.Header
        end
    end)()

    function Kavo:ChangeColor(prope, color)
        if prope == "Background" then
            themeList.Background = color
        elseif prope == "SchemeColor" then
            themeList.SchemeColor = color
        elseif prope == "Header" then
            themeList.Header = color
        elseif prope == "TextColor" then
            themeList.TextColor = color
        elseif prope == "ElementColor" then
            themeList.ElementColor = color
        end
    end

    local Tabs = {}
    local first = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")

        local function UpdateSize()
            local cS = pageListing.AbsoluteContentSize
            game.TweenService:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)
            }):Play()
        end

        page.Name = "Page"
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0, 0, 0, 0)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.Visible = false
        page.ScrollBarImageColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 16, themeList.SchemeColor.g * 255 - 15, themeList.SchemeColor.b * 255 - 28)

        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)

        tabButton.Name = tabName .. "TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        Objects[tabButton] = "SchemeColor"
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.SourceSansBold
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        Objects[tabButton] = "TextColor3"
        tabButton.TextSize = 14.000
        tabButton.BackgroundTransparency = 1

        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0
            UpdateSize()
        else
            page.Visible = false
            tabButton.BackgroundTransparency = 1
        end

        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = tabButton
        table.insert(Tabs, tabName)

        UpdateSize()
        page.ChildAdded:Connect(UpdateSize)
        page.ChildRemoved:Connect(UpdateSize)

        tabButton.MouseButton1Click:Connect(function()
            UpdateSize()
            for i, v in next, Pages:GetChildren() do
                v.Visible = false
            end
            page.Visible = true
            for i, v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then
                    Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2)
                end
            end
            Utility:TweenObject(tabButton, {BackgroundTransparency = 0}, 0.2)
        end)

        local Sections = {}
        local focusing = false
        local viewDe = false

        coroutine.wrap(function()
            while wait() do
                page.BackgroundColor3 = themeList.Background
                tabButton.TextColor3 = themeList.TextColor
                tabButton.BackgroundColor3 = themeList.SchemeColor
            end
        end)()

        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            local sectionFunctions = {}
            local modules = {}
            hidden = hidden or false
            local sectionFrame = Instance.new("Frame")
            local sectionlistoknvm = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sHeadCorner = Instance.new("UICorner")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")

            if hidden then
                sectionHead.Visible = false
            else
                sectionHead.Visible = true
            end

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionFrame.BorderSizePixel = 0

            sectionlistoknvm.Name = "sectionlistoknvm"
            sectionlistoknvm.Parent = sectionFrame
            sectionlistoknvm.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlistoknvm.Padding = UDim.new(0, 5)

            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            Objects[sectionHead] = "BackgroundColor3"
            sectionHead.Size = UDim2.new(0, 352, 0, 33)

            sHeadCorner.CornerRadius = UDim.new(0, 4)
            sHeadCorner.Name = "sHeadCorner"
            sHeadCorner.Parent = sectionHead

            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionName.BackgroundTransparency = 1.000
            sectionName.BorderColor3 = Color3.fromRGB(27, 42, 53)
            sectionName.Position = UDim2.new(0.0198863633, 0, 0, 0)
            sectionName.Size = UDim2.new(0.980113626, 0, 1, 0)
            sectionName.Font = Enum.Font.Gotham
            sectionName.Text = secName
            sectionName.RichText = true
            sectionName.TextColor3 = themeList.TextColor
            Objects[sectionName] = "TextColor3"
            sectionName.TextSize = 14.000
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionInners.BackgroundTransparency = 1.000
            sectionInners.Position = UDim2.new(0, 0, 0.190751448, 0)

            sectionElListing.Name = "sectionElListing"
            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 3)

            coroutine.wrap(function()
                while wait() do
                    sectionFrame.BackgroundColor3 = themeList.Background
                    sectionHead.BackgroundColor3 = themeList.SchemeColor
                    sectionName.TextColor3 = themeList.TextColor
                end
            end)()

            local function updateSectionFrame()
                local innerSc = sectionElListing.AbsoluteContentSize
                sectionInners.Size = UDim2.new(1, 0, 0, innerSc.Y)
                local frameSc = sectionlistoknvm.AbsoluteContentSize
                sectionFrame.Size = UDim2.new(0, 352, 0, frameSc.Y)
            end

            updateSectionFrame()
            UpdateSize()

            local Elements = {}

            function Elements:NewButton(bname, tipINf, callback)
                local ButtonFunction = {}
                tipINf = tipINf or "Tip: Clicking this nothing will happen!"
                bname = bname or "Click Me!"
                callback = callback or function() end

                local buttonElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local btnInfo = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local touch = Instance.new("ImageLabel")
                local Sample = Instance.new("ImageLabel")

                buttonElement.Name = bname
                buttonElement.Parent = sectionInners
                buttonElement.BackgroundColor3 = themeList.ElementColor
                buttonElement.ClipsDescendants = true
                buttonElement.Size = UDim2.new(0, 352, 0, 33)
                buttonElement.AutoButtonColor = false
                buttonElement.Font = Enum.Font.SourceSans
                buttonElement.Text = ""
                buttonElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                buttonElement.TextSize = 14.000
                Objects[buttonElement] = "BackgroundColor3"

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = buttonElement

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = buttonElement
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.LayoutOrder = 9
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                Objects[viewInfo] = "ImageColor3"
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                Sample.Name = "Sample"
                Sample.Parent = buttonElement
                Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Sample.BackgroundTransparency = 1.000
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Objects[Sample] = "ImageColor3"
                Sample.ImageTransparency = 0.600

                local moreInfo = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..tipINf
                moreInfo.RichText = true
                moreInfo.TextColor3 = themeList.TextColor
                Objects[moreInfo] = "TextColor3"
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                Objects[moreInfo] = "BackgroundColor3"

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = moreInfo

                touch.Name = "touch"
                touch.Parent = buttonElement
                touch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                touch.BackgroundTransparency = 1.000
                touch.BorderColor3 = Color3.fromRGB(27, 42, 53)
                touch.Position = UDim2.new(0.0199999996, 0, 0.180000007, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                Objects[touch] = "SchemeColor"
                touch.ImageRectOffset = Vector2.new(84, 204)
                touch.ImageRectSize = Vector2.new(36, 36)
                touch.ImageTransparency = 0

                btnInfo.Name = "btnInfo"
                btnInfo.Parent = buttonElement
                btnInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btnInfo.BackgroundTransparency = 1.000
                btnInfo.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
                btnInfo.Size = UDim2.new(0, 314, 0, 14)
                btnInfo.Font = Enum.Font.GothamSemibold
                btnInfo.Text = bname
                btnInfo.RichText = true
                btnInfo.TextColor3 = themeList.TextColor
                Objects[btnInfo] = "TextColor3"
                btnInfo.TextSize = 14.000
                btnInfo.TextXAlignment = Enum.TextXAlignment.Left

                if themeList.SchemeColor == Color3.fromRGB(255, 255, 255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.fromRGB(0, 0, 0)}, 0.2)
                end 
                if themeList.SchemeColor == Color3.fromRGB(0, 0, 0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                end 

                updateSectionFrame()
                UpdateSize()

                local ms = game.Players.LocalPlayer:GetMouse()

                local btn = buttonElement
                local sample = Sample

                btn.MouseButton1Click:Connect(function()
                    if not focusing then
                        callback()
                        local c = sample:Clone()
                        c.Parent = btn
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local len, size = 0.35, nil
                        if btn.AbsoluteSize.X >= btn.AbsoluteSize.Y then
                            size = (btn.AbsoluteSize.X * 1.5)
                        else
                            size = (btn.AbsoluteSize.Y * 1.5)
                        end
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                        c:Destroy()
                    else
                        for i, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)

                local hovering = false
                btn.MouseEnter:Connect(function()
                    if not focusing then
                        game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 8, themeList.ElementColor.g * 255 + 9, themeList.ElementColor.b * 255 + 10)
                        }):Play()
                        hovering = true
                    end
                end)

                btn.MouseLeave:Connect(function()
                    if not focusing then 
                        game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            BackgroundColor3 = themeList.ElementColor
                        }):Play()
                        hovering = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            buttonElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                        touch.ImageColor3 = themeList.SchemeColor
                        btnInfo.TextColor3 = themeList.TextColor
                    end
                end)()

                function ButtonFunction:UpdateButton(newTitle)
                    btnInfo.Text = newTitle
                end
                return ButtonFunction
            end

            function Elements:NewTextBox(tname, tTip, callback)
                tname = tname or "Textbox"
                tTip = tTip or "Gets a value of Textbox"
                callback = callback or function() end
                local textboxElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local viewInfo = Instance.new("ImageButton")
                local write = Instance.new("ImageLabel")
                local TextBox = Instance.new("TextBox")
                local UICorner_2 = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")

                textboxElement.Name = "textboxElement"
                textboxElement.Parent = sectionInners
                textboxElement.BackgroundColor3 = themeList.ElementColor
                textboxElement.ClipsDescendants = true
                textboxElement.Size = UDim2.new(0, 352, 0, 33)
                textboxElement.AutoButtonColor = false
                textboxElement.Font = Enum.Font.SourceSans
                textboxElement.Text = ""
                textboxElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                textboxElement.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = textboxElement

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = textboxElement
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.LayoutOrder = 9
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                write.Name = "write"
                write.Parent = textboxElement
                write.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                write.BackgroundTransparency = 1.000
                write.BorderColor3 = Color3.fromRGB(27, 42, 53)
                write.Position = UDim2.new(0.0199999996, 0, 0.180000007, 0)
                write.Size = UDim2.new(0, 21, 0, 21)
                write.Image = "rbxassetid://3926305904"
                write.ImageColor3 = themeList.SchemeColor
                write.ImageRectOffset = Vector2.new(324, 604)
                write.ImageRectSize = Vector2.new(36, 36)

                TextBox.Parent = textboxElement
                TextBox.BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 - 6, themeList.ElementColor.g * 255 - 6, themeList.ElementColor.b * 255 - 7)
                TextBox.BorderSizePixel = 0
                TextBox.ClipsDescendants = true
                TextBox.Position = UDim2.new(0.488749921, 0, 0.212121218, 0)
                TextBox.Size = UDim2.new(0, 150, 0, 18)
                TextBox.ZIndex = 99
                TextBox.ClearTextOnFocus = false
                TextBox.Font = Enum.Font.Gotham
                TextBox.PlaceholderColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 19, themeList.SchemeColor.g * 255 - 26, themeList.SchemeColor.b * 255 - 35)
                TextBox.PlaceholderText = "Type here!"
                TextBox.Text = ""
                TextBox.TextColor3 = themeList.SchemeColor
                TextBox.TextSize = 12.000

                UICorner_2.CornerRadius = UDim.new(0, 4)
                UICorner_2.Parent = TextBox

                togName.Name = "togName"
                togName.Parent = textboxElement
                togName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                togName.BackgroundTransparency = 1.000
                togName.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
                togName.Size = UDim2.new(0, 138, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = tname
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14.000
                togName.TextXAlignment = Enum.TextXAlignment.Left

                local moreInfo = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..tTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = moreInfo

                updateSectionFrame()
                UpdateSize()

                local btn = textboxElement
                local infBtn = viewInfo

                btn.MouseButton1Click:Connect(function()
                    if focusing then
                        for i, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)

                local hovering = false
                btn.MouseEnter:Connect(function()
                    if not focusing then
                        game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 8, themeList.ElementColor.g * 255 + 9, themeList.ElementColor.b * 255 + 10)
                        }):Play()
                        hovering = true
                    end
                end)

                btn.MouseLeave:Connect(function()
                    if not focusing then
                        game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            BackgroundColor3 = themeList.ElementColor
                        }):Play()
                        hovering = false
                    end
                end)

                TextBox.FocusLost:Connect(function(EnterPressed)
                    if focusing then
                        for i, v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                    if not EnterPressed then 
                        return
                    else
                        callback(TextBox.Text)
                        wait(0.18)
                        TextBox.Text = ""  
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i, v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        wait(0)
                        viewDe = false
                    end
                end)

                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            textboxElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                        write.ImageColor3 = themeList.SchemeColor
                        togName.TextColor3 = themeList.TextColor
                        TextBox.PlaceholderColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 19, themeList.SchemeColor.g * 255 - 26, themeList.SchemeColor.b * 255 - 35)
                        TextBox.TextColor3 = themeList.SchemeColor
                    end
                end)()
            end

            -- Добавьте другие элементы, такие как NewToggle, NewSlider и т.д., аналогично

function Elements:NewToggle(tname, nTip, callback)
    local TogFunction = {}
    tname = tname or "Toggle"
    nTip = nTip or "Prints Current Toggle State"
    callback = callback or function() end
    local toggled = false

    local toggleElement = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local togName = Instance.new("TextLabel")
    local viewInfo = Instance.new("ImageButton")
    local toggleDisabled = Instance.new("ImageLabel")
    local toggleEnabled = Instance.new("ImageLabel")

    toggleElement.Name = "toggleElement"
    toggleElement.Parent = sectionInners
    toggleElement.BackgroundColor3 = themeList.ElementColor
    toggleElement.Size = UDim2.new(0, 352, 0, 33)
    toggleElement.AutoButtonColor = false
    toggleElement.Font = Enum.Font.SourceSans
    toggleElement.Text = ""
    
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = toggleElement

    togName.Name = "togName"
    togName.Parent = toggleElement
    togName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    togName.BackgroundTransparency = 1.000
    togName.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
    togName.Size = UDim2.new(0, 288, 0, 14)
    togName.Font = Enum.Font.GothamSemibold
    togName.Text = tname
    togName.TextColor3 = themeList.TextColor
    togName.TextSize = 14.000
    togName.TextXAlignment = Enum.TextXAlignment.Left

    viewInfo.Name = "viewInfo"
    viewInfo.Parent = toggleElement
    viewInfo.BackgroundTransparency = 1.000
    viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor

    toggleDisabled.Name = "toggleDisabled"
    toggleDisabled.Parent = toggleElement
    toggleDisabled.BackgroundTransparency = 1.000
    toggleDisabled.Position = UDim2.new(0.0199999996, 0, 0.180000007, 0)
    toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
    toggleDisabled.Image = "rbxassetid://3926309567"
    toggleDisabled.ImageColor3 = themeList.SchemeColor

    toggleEnabled.Name = "toggleEnabled"
    toggleEnabled.Parent = toggleElement
    toggleEnabled.BackgroundTransparency = 1.000
    toggleEnabled.Position = UDim2.new(0.0199999996, 0, 0.180000007, 0)
    toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
    toggleEnabled.Image = "rbxassetid://3926309567"
    toggleEnabled.ImageColor3 = themeList.SchemeColor
    toggleEnabled.ImageTransparency = 1.000

    toggleElement.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleEnabled.ImageTransparency = toggled and 0 or 1
        toggleDisabled.ImageTransparency = toggled and 1 or 0
        callback(toggled)
    end)

    return TogFunction
end

            function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
    slidInf = slidInf or "Slider"
    slidTip = slidTip or "Slider tip here"
    maxvalue = maxvalue or 100
    minvalue = minvalue or 0
    callback = callback or function() end

    local sliderElement = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local togName = Instance.new("TextLabel")
    local sliderBtn = Instance.new("TextButton")
    local sliderDrag = Instance.new("Frame")
    local val = Instance.new("TextLabel")

    sliderElement.Name = "sliderElement"
    sliderElement.Parent = sectionInners
    sliderElement.BackgroundColor3 = themeList.ElementColor
    sliderElement.Size = UDim2.new(0, 352, 0, 33)
    sliderElement.AutoButtonColor = false
    sliderElement.Font = Enum.Font.SourceSans
    sliderElement.Text = ""

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = sliderElement

    togName.Name = "togName"
    togName.Parent = sliderElement
    togName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    togName.BackgroundTransparency = 1.000
    togName.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
    togName.Size = UDim2.new(0, 138, 0, 14)
    togName.Font = Enum.Font.GothamSemibold
    togName.Text = slidInf
    togName.TextColor3 = themeList.TextColor
    togName.TextSize = 14.000
    togName.TextXAlignment = Enum.TextXAlignment.Left

    sliderBtn.Name = "sliderBtn"
    sliderBtn.Parent = sliderElement
    sliderBtn.BackgroundColor3 = themeList.ElementColor
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Position = UDim2.new(0.488749951, 0, 0.393939406, 0)
    sliderBtn.Size = UDim2.new(0, 149, 0, 6)
    sliderBtn.AutoButtonColor = false
    sliderBtn.Font = Enum.Font.SourceSans
    sliderBtn.Text = ""

    sliderDrag.Name = "sliderDrag"
    sliderDrag.Parent = sliderBtn
    sliderDrag.BackgroundColor3 = themeList.SchemeColor
    sliderDrag.Size = UDim2.new(0, 0, 1, 0)

    val.Name = "val"
    val.Parent = sliderElement
    val.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    val.BackgroundTransparency = 1.000
    val.Position = UDim2.new(0.352386296, 0, 0.272727281, 0)
    val.Size = UDim2.new(0, 41, 0, 14)
    val.Font = Enum.Font.GothamSemibold
    val.Text = minvalue
    val.TextColor3 = themeList.TextColor
    val.TextSize = 14.000
    val.TextXAlignment = Enum.TextXAlignment.Right

    sliderBtn.MouseButton1Down:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local startPos = mouse.X
        local sliderWidth = sliderBtn.AbsoluteSize.X

        local function updateSlider()
            local delta = mouse.X - startPos
            local newSize = math.clamp(sliderDrag.AbsoluteSize.X + delta, 0, sliderWidth)
            sliderDrag.Size = UDim2.new(0, newSize, 1, 0)
            local value = math.floor((newSize / sliderWidth) * (maxvalue - minvalue) + minvalue)
            val.Text = value
            callback(value)
        end

        local moveConnection
        moveConnection = mouse.Move:Connect(updateSlider)

        local releaseConnection
        releaseConnection = game:GetService("User InputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                moveConnection:Disconnect()
                releaseConnection:Disconnect()
            end
        end)
    end)

    return {
        UpdateSlider = function(newValue)
            val.Text = newValue
            local newSize = math.clamp((newValue - minvalue) / (maxvalue - minvalue) * sliderBtn.AbsoluteSize.X, 0, sliderBtn.AbsoluteSize.X)
            sliderDrag.Size = UDim2.new(0, newSize, 1, 0)
        end
    }
end

            function Elements:NewDropdown(dropname, dropinf, list, callback)
    local DropFunction = {}
    dropname = dropname or "Dropdown"
    list = list or {}
    dropinf = dropinf or "Dropdown info"
    callback = callback or function() end   

    local opened = false
    local dropFrame = Instance.new("Frame")
    local dropOpen = Instance.new("TextButton")
    local itemTextbox = Instance.new("TextLabel")
    local viewInfo = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    local UIListLayout = Instance.new("UIListLayout")

    dropFrame.Name = "dropFrame"
    dropFrame.Parent = sectionInners
    dropFrame.BackgroundColor3 = themeList.Background
    dropFrame.BorderSizePixel = 0
    dropFrame.Size = UDim2.new(0, 352, 0, 33)
    dropFrame.ClipsDescendants = true

    dropOpen.Name = "dropOpen"
    dropOpen.Parent = dropFrame
    dropOpen.BackgroundColor3 = themeList.ElementColor
    dropOpen.Size = UDim2.new(0, 352, 0, 33)
    dropOpen.AutoButtonColor = false
    dropOpen.Font = Enum.Font.SourceSans
    dropOpen.Text = ""
    dropOpen.MouseButton1Click:Connect(function()
        opened = not opened
        dropFrame:TweenSize(opened and UDim2.new(0, 352, 0, 33 + (#list * 33)) or UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
    end)

    itemTextbox.Name = "itemTextbox"
    itemTextbox.Parent = dropOpen
    itemTextbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    itemTextbox.BackgroundTransparency = 1.000
    itemTextbox.Position = UDim2.new(0.097, 0, 0.273, 0)
    itemTextbox.Size = UDim2.new(0, 138, 0, 14)
    itemTextbox.Font = Enum.Font.GothamSemibold
    itemTextbox.Text = dropname
    itemTextbox.TextColor3 = themeList.TextColor
    itemTextbox.TextSize = 14.000
    itemTextbox.TextXAlignment = Enum.TextXAlignment.Left

    viewInfo.Name = "viewInfo"
    viewInfo.Parent = dropOpen
    viewInfo.BackgroundTransparency = 1.000
    viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = dropOpen

    UIListLayout.Parent = dropFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 3)

    for _, v in ipairs(list) do
        local optionSelect = Instance.new("TextButton")
        local UICorner_2 = Instance.new("UICorner")

        optionSelect.Name = "optionSelect"
        optionSelect.Parent = dropFrame
        optionSelect.BackgroundColor3 = themeList.ElementColor
        optionSelect.Size = UDim2.new(0, 352, 0, 33)
        optionSelect.AutoButtonColor = false
        optionSelect.Font = Enum.Font.GothamSemibold
        optionSelect.Text = "  " .. v
        optionSelect.TextColor3 = themeList.TextColor
        optionSelect.TextSize = 14.000
        optionSelect.TextXAlignment = Enum.TextXAlignment.Left

        UICorner_2.CornerRadius = UDim.new(0, 4)
        UICorner_2.Parent = optionSelect

        optionSelect.MouseButton1Click:Connect(function()
            callback(v)
            itemTextbox.Text = v
            opened = false
            dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
        end)
    end

    return DropFunction
end

            function Elements:NewKeybind(keytext, keyinf, first, callback)
    keytext = keytext or "KeybindText"
    keyinf = keyinf or "Keybind Info"
    callback = callback or function() end
    local oldKey = first.Name
    local keybindElement = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local togName = Instance.new("TextLabel")
    local viewInfo = Instance.new("ImageButton")
    local Sample = Instance.new("ImageLabel")
    local togName_2 = Instance.new("TextLabel")

    keybindElement.Name = "keybindElement"
    keybindElement.Parent = sectionInners
    keybindElement.BackgroundColor3 = themeList.ElementColor
    keybindElement.Size = UDim2.new(0, 352, 0, 33)
    keybindElement.AutoButtonColor = false
    keybindElement.Font = Enum.Font.SourceSans
    keybindElement.Text = ""

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = keybindElement

    togName.Name = "togName"
    togName.Parent = keybindElement
    togName.BackgroundColor3 = themeList.TextColor
    togName.BackgroundTransparency = 1.000
    togName.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
    togName.Size = UDim2.new(0, 222, 0, 14)
    togName.Font = Enum.Font.GothamSemibold
    togName.Text = keytext
    togName.TextColor3 = themeList.TextColor
    togName.TextSize = 14.000
    togName.TextXAlignment = Enum.TextXAlignment.Left

    viewInfo.Name = "viewInfo"
    viewInfo.Parent = keybindElement
    viewInfo.BackgroundTransparency = 1.000
    viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor

    Sample.Name = "Sample"
    Sample.Parent = keybindElement
    Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Sample.BackgroundTransparency = 1.000
    Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
    Sample.ImageColor3 = themeList.SchemeColor
    Sample.ImageTransparency = 0.600

    togName_2.Name = "togName"
    togName_2.Parent = keybindElement
    togName_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    togName_2.BackgroundTransparency = 1.000
    togName_2.Position = UDim2.new(0.727386296, 0, 0.272727281, 0)
    togName_2.Size = UDim2.new(0, 70, 0, 14)
    togName_2.Font = Enum.Font.GothamSemibold
    togName_2.Text = oldKey
    togName_2.TextColor3 = themeList.SchemeColor
    togName_2.TextSize = 14.000
    togName_2.TextXAlignment = Enum.TextXAlignment.Right

    keybindElement.MouseButton1Click:Connect(function()
        togName_2.Text = ". . ."
        local a, b = game:GetService('User InputService').InputBegan:wait()
        if a.KeyCode.Name ~= "Unknown" then
            togName_2.Text = a.KeyCode.Name
            oldKey = a.KeyCode.Name
        end
    end)

    game:GetService("User InputService").InputBegan:connect(function(current, ok)
        if not ok then
            if current.KeyCode.Name == oldKey then
                callback()
            end
        end
    end)

    return {
        UpdateKeybind = function(newText)
            togName.Text = newText
        end
    }
end

            

            
            return Elements
        end
        return Sections
    end  
    return Tabs
end

return Kavo
