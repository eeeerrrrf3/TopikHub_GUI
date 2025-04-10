local Kavo = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Modern color palette with default values
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

-- Utility functions
local Utility = {}

-- Safe property setter with error handling
function Utility:SafeSet(obj, prop, value)
    if obj and obj[prop] ~= nil then
        if typeof(value) == typeof(obj[prop]) then
            obj[prop] = value
        else
            warn("Type mismatch for property", prop, "Expected", typeof(obj[prop]), "got", typeof(value))
        end
    else
        warn("Invalid object or property:", obj, prop)
    end
end

-- Improved tweening with safety checks
function Utility:TweenObject(obj, properties, duration, easingStyle, easingDirection)
    if not obj or typeof(obj) ~= "Instance" then return end
    
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration = duration or 0.2
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Modern dragging with bounds checking
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    if not frame or not parent then return end
    
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
            Utility:TweenObject(parent, {
                Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, 
                                    framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            }, 0.1)
        end
    end)
end

-- Modern UI components
local Components = {}

function Components:CreateButton(name, parent, theme)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    Utility:SafeSet(button, "BackgroundColor3", theme.ElementColor)
    button.Size = UDim2.new(1, 0, 0, 36)
    button.AutoButtonColor = false
    button.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = button
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = name
    Utility:SafeSet(label, "TextColor3", theme.TextColor)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        Utility:TweenObject(button, {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(theme.ElementColor.R * 255 + 15, 0, 255)/255,
                math.clamp(theme.ElementColor.G * 255 + 15, 0, 255)/255,
                math.clamp(theme.ElementColor.B * 255 + 15, 0, 255)/255
            )
        })
    end)
    
    button.MouseLeave:Connect(function()
        Utility:TweenObject(button, {
            BackgroundColor3 = theme.ElementColor
        })
    end)
    
    return button
end

-- Main library function
function Kavo.CreateLib(title, theme)
    -- Validate and set default theme
    if type(theme) ~= "table" then
        theme = ModernThemes.Dark
    else
        -- Ensure all required colors are defined
        for k, v in pairs(ModernThemes.Dark) do
            if theme[k] == nil then
                theme[k] = v
            end
        end
    end
    
    -- Create main UI container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI_"..tostring(math.random(1, 10000))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main window
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow"
    Main.Parent = ScreenGui
    Utility:SafeSet(Main, "BackgroundColor3", theme.Background)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = Main
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Utility:SafeSet(Header, "BackgroundColor3", theme.Header)
    Header.Size = UDim2.new(1, 0, 0, 40)
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title or "Modern UI"
    Utility:SafeSet(Title, "TextColor3", theme.TextColor)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
    local Close = Instance.new("ImageButton")
    Close.Name = "CloseButton"
    Close.Parent = Header
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(0.95, 0, 0.1, 0)
    Close.Size = UDim2.new(0, 20, 0, 20)
    Close.Image = "rbxassetid://3926305904"
    Close.ImageRectOffset = Vector2.new(284, 4)
    Close.ImageRectSize = Vector2.new(24, 24)
    Utility:SafeSet(Close, "ImageColor3", theme.TextColor)
    
    Close.MouseButton1Click:Connect(function()
        Utility:TweenObject(Main, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.2, nil, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Enable dragging
    Kavo:DraggingEnabled(Header, Main)
    
    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Main
    Utility:SafeSet(TabContainer, "BackgroundColor3", theme.Header)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    
    local tabContainerCorner = Instance.new("UICorner")
    tabContainerCorner.CornerRadius = UDim.new(0, 8)
    tabContainerCorner.Parent = TabContainer
    
    -- Tab list
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.ScrollBarThickness = 5
    Utility:SafeSet(TabList, "ScrollBarImageColor3", theme.SchemeColor)
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
        local tabButton = Components:CreateButton(tabName, TabList, theme)
        tabButton.Size = UDim2.new(0, 140, 0, 32)
        
        -- Create page frame
        local page = Instance.new("ScrollingFrame")
        page.Name = tabName.."Page"
        page.Parent = Pages
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = firstTab
        page.ScrollBarThickness = 5
        Utility:SafeSet(page, "ScrollBarImageColor3", theme.SchemeColor)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Parent = page
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 5)
        
        -- Update page size
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
        end)
        
        -- Tab button click handler
        tabButton.MouseButton1Click:Connect(function()
            for _, v in ipairs(Pages:GetChildren()) do
                v.Visible = false
            end
            page.Visible = true
        end)
        
        local Sections = {}
        
        function Sections:NewSection(sectionName)
            sectionName = sectionName or "Section"
            
            -- Section container
            local section = Instance.new("Frame")
            section.Name = "Section"
            section.Parent = page
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(1, 0, 0, 0)
            
            -- Section header
            local header = Instance.new("TextLabel")
            header.Name = "Header"
            header.Parent = section
            header.BackgroundTransparency = 1
            header.Size = UDim2.new(1, 0, 0, 30)
            header.Font = Enum.Font.GothamSemibold
            header.Text = sectionName
            Utility:SafeSet(header, "TextColor3", theme.TextColor)
            header.TextSize = 16
            header.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Section content
            local content = Instance.new("Frame")
            content.Name = "Content"
            content.Parent = section
            content.BackgroundTransparency = 1
            content.Position = UDim2.new(0, 0, 0, 35)
            content.Size = UDim2.new(1, 0, 0, 0)
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Parent = content
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Padding = UDim.new(0, 5)
            
            -- Update section size
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                content.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
                section.Size = UDim2.new(1, 0, 0, 35 + contentLayout.AbsoluteContentSize.Y)
            end)
            
            local Elements = {}
            
            function Elements:NewButton(buttonText, callback)
                buttonText = buttonText or "Button"
                callback = callback or function() end
                
                local button = Components:CreateButton(buttonText, content, theme)
                
                -- Click effect
                button.MouseButton1Click:Connect(function()
                    -- Ripple effect
                    local ripple = Instance.new("Frame")
                    ripple.Name = "Ripple"
                    ripple.Parent = button
                    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
                    ripple.BackgroundTransparency = 0.8
                    ripple.Size = UDim2.new(0, 0, 0, 0)
                    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                    
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(1, 0)
                    corner.Parent = ripple
                    
                    Utility:TweenObject(ripple, {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1
                    }, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    
                    game:GetService("Debris"):AddItem(ripple, 0.4)
                    
                    -- Call the callback
                    callback()
                end)
                
                local buttonFunctions = {}
                
                function buttonFunctions:Update(newText)
                    local label = button:FindFirstChild("Label")
                    if label then
                        label.Text = newText or buttonText
                    end
                end
                
                return buttonFunctions
            end
            
            -- Add more element types as needed...
            
            return Elements
        end
        
        firstTab = false
        return Sections
    end
    
    return Tabs
end

return Kavo
