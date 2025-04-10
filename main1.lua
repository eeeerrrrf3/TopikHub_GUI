local Kavo = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("User InputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Modern color palette with nil checks
local ModernThemes = {
    Dark = {
        Background = Color3.fromRGB(25, 28, 36),
        Header = Color3.fromRGB(35, 38, 46),
        SchemeColor = Color3.fromRGB(0, 170, 255),
        TextColor = Color3.fromRGB(240, 240, 240),
        ElementColor = Color3.fromRGB(40, 43, 51),
        AccentColor = Color3.fromRGB(0, 150, 225)
    },
    Light = {
        Background = Color3.fromRGB(240, 242, 245),
        Header = Color3.fromRGB(230, 232, 235),
        SchemeColor = Color3.fromRGB(0, 120, 215),
        TextColor = Color3.fromRGB(40, 40, 40),
        ElementColor = Color3.fromRGB(220, 222, 225),
        AccentColor = Color3.fromRGB(0, 100, 180)
    }
}

-- Safe color assignment function
local function safeSetColor(object, property, color)
    if object and object[property] and color then
        object[property] = color
    else
        warn("Failed to set color:", object, property, color)
    end
end

function Kavo.CreateLib(title, theme)
    -- Validate and set default theme
    if type(theme) ~= "table" then
        theme = ModernThemes.Dark
    else
        -- Ensure all required colors are defined
        theme.Background = theme.Background or ModernThemes.Dark.Background
        theme.Header = theme.Header or ModernThemes.Dark.Header
        theme.SchemeColor = theme.SchemeColor or ModernThemes.Dark.SchemeColor
        theme.TextColor = theme.TextColor or ModernThemes.Dark.TextColor
        theme.ElementColor = theme.ElementColor or ModernThemes.Dark.ElementColor
        theme.AccentColor = theme.AccentColor or ModernThemes.Dark.AccentColor
    end

    -- Create main UI container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI_"..tostring(math.random(1, 10000))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    -- Main window frame with safe color assignment
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow"
    Main.Parent = ScreenGui
    safeSetColor(Main, "BackgroundColor3", theme.Background)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)

    -- Header with safe color assignment
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    safeSetColor(Header, "BackgroundColor3", theme.Header)
    Header.Size = UDim2.new(1, 0, 0, 40)

    -- Title label with safe color assignment
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title or "Modern UI"
    safeSetColor(Title, "TextColor3", theme.TextColor)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button creation
    local function createCloseButton(parent, theme)
        local close = Instance.new("ImageButton")
        close.Name = "CloseButton"
        close.Parent = parent
        close.BackgroundTransparency = 1
        close.Position = UDim2.new(0.95, 0, 0.1, 0)
        close.Size = UDim2.new(0, 20, 0, 20)
        close.Image = "rbxassetid://3926305904"
        close.ImageRectOffset = Vector2.new(284, 4)
        close.ImageRectSize = Vector2.new(24, 24)
        safeSetColor(close, "ImageColor3", theme.TextColor)

        -- Hover effect
        close.MouseEnter:Connect(function()
            Utility:TweenObject(close, {
                Rotation = 90,
                ImageColor3 = Color3.fromRGB(255, 85, 85)
            }, 0.2)
        end)

        close.MouseLeave:Connect(function()
            Utility:TweenObject(close, {
                Rotation = 0,
                ImageColor3 = theme.TextColor
            }, 0.2)
        end)

        return close
    end

    -- Create close button
    local CloseButton = createCloseButton(Header, theme)
    CloseButton.MouseButton1Click:Connect(function()
        Utility:TweenObject(Main, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.2)

        wait(0.2)
        ScreenGui:Destroy()
    end)

    -- Enable dragging
    Kavo:DraggingEnabled(Header, Main)

    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Main
    safeSetColor(TabContainer, "BackgroundColor3", theme.Header)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 150, 1, -40)

    -- Tab list
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.ScrollBarThickness = 5
    safeSetColor(TabList, "ScrollBarImageColor3", theme.SchemeColor)
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Parent = TabList
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)

    -- Content area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 155, 0, 45)
    Content.Size = UDim2.new(1, -160, 1, -50)

    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = Content

    -- Update tab list size
    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y)
    end)

    local Tabs = {}
    local firstTab = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"

        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName.."TabButton"
        tabButton.Parent = TabList
        safeSetColor(tabButton, "BackgroundColor3", theme.ElementColor)
        tabButton.Size = UDim2.new(0, 135, 0, 32)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabName
        safeSetColor(tabButton, "TextColor3", theme.TextColor)
        tabButton.TextSize = 14

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tabButton

        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = theme.SchemeColor
        stroke.Transparency = firstTab and 0 or 0.8
        stroke.Thickness = 1
        stroke.Parent = tabButton

        -- Tab button click handler
        tabButton.MouseButton1Click:Connect(function()
            for _, v in ipairs(Pages:GetChildren()) do
                v.Visible = false
            end

            for _, v in ipairs(TabList:GetChildren()) do
                if v:IsA("TextButton") then
                    Utility:TweenObject(v, {
                        BackgroundTransparency = 0.8,
                        TextColor3 = Color3.fromRGB(180, 180, 180)
                    }, 0.15)

                    local stroke = v:FindFirstChildOfType("UIStroke")
                    if stroke then
                        Utility:TweenObject(stroke, {
                            Transparency = 0.8
                        }, 0.15)
                    end
                end
            end

            local page = Pages:FindFirstChild(tabName.."Page")
            if page then
                page.Visible = true
            end

            Utility:TweenObject(tabButton, {
                BackgroundTransparency = 0,
                TextColor3 = theme.TextColor
            }, 0.15)

            local stroke = tabButton:FindFirstChildOfType("UIStroke")
            if stroke then
                Utility:TweenObject(stroke, {
                    Transparency = 0
                }, 0.15)
            end
        end)

        -- Create page frame
        local page = Instance.new("ScrollingFrame")
        page.Name = tabName.."Page"
        page.Parent = Pages
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = firstTab
        page.ScrollBarThickness = 5
        safeSetColor(page, "ScrollBarImageColor3", theme.SchemeColor)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Parent = page
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 5)

        -- Update page size
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
        end)

        firstTab = false
    end

    return Tabs
end

return Kavo
