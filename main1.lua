local Kavo = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Modern color palette
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

-- Modern styling parameters
local ModernStyles = {
    CornerRadius = UDim.new(0, 8),
    ElementPadding = 5,
    ShadowTransparency = 0.7,
    ShadowBlur = 10,
    AnimationSpeed = 0.15,
    HoverEffect = {
        Brightness = 0.1,
        SizeIncrease = UDim2.new(0.02, 0, 0.02, 0)
    }
}

local Utility = {}
local Objects = {}

-- Improved dragging with smoothness and bounds checking
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    
    local dragging = false
    local dragInput, mousePos, framePos
    local dragStartPos
    local dragStartTime
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            dragStartPos = mousePos
            dragStartTime = os.clock()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    
                    -- Check if this was a click (short drag)
                    if os.clock() - dragStartTime < 0.2 and (mousePos - dragStartPos).Magnitude < 5 then
                        -- Handle click if needed
                    end
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
            local newPos = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, 
                                    framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            
            -- Smooth tween instead of direct assignment
            TweenService:Create(parent, TweenInfo.new(0.1), {
                Position = newPos
            }):Play()
        end
    end)
end

-- Enhanced tweening with more options
function Utility:TweenObject(obj, properties, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration = duration or 0.2
    
    TweenService:Create(obj, TweenInfo.new(duration, easingStyle, easingDirection), properties):Play()
end

-- Modern close button animation
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
    close.ImageColor3 = theme.TextColor
    
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

-- Modern tab button
local function createTabButton(name, parent, theme, isFirst)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name.."TabButton"
    tabButton.Parent = parent
    tabButton.BackgroundColor3 = isFirst and theme.SchemeColor or Color3.new(0, 0, 0)
    tabButton.BackgroundTransparency = isFirst and 0 or 0.8
    tabButton.Size = UDim2.new(0, 135, 0, 32)
    tabButton.AutoButtonColor = false
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.Text = name
    tabButton.TextColor3 = isFirst and theme.TextColor or Color3.fromRGB(180, 180, 180)
    tabButton.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabButton
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = theme.SchemeColor
    stroke.Transparency = isFirst and 0 or 0.8
    stroke.Thickness = 1
    stroke.Parent = tabButton
    
    -- Hover effect
    tabButton.MouseEnter:Connect(function()
        if tabButton.BackgroundTransparency > 0 then
            Utility:TweenObject(tabButton, {
                BackgroundTransparency = 0.6,
                TextColor3 = theme.TextColor
            }, 0.15)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not isFirst then
            Utility:TweenObject(tabButton, {
                BackgroundTransparency = 0.8,
                TextColor3 = Color3.fromRGB(180, 180, 180)
            }, 0.15)
        end
    end)
    
    return tabButton
end

-- Modern element with hover effects
local function createModernElement(name, parent, theme)
    local element = Instance.new("TextButton")
    element.Name = name
    element.Parent = parent
    element.BackgroundColor3 = theme.ElementColor
    element.Size = UDim2.new(0, 352, 0, 36)
    element.AutoButtonColor = false
    element.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = ModernStyles.CornerRadius
    corner.Parent = element
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = element
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = ModernStyles.ShadowTransparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    
    -- Hover effect
    element.MouseEnter:Connect(function()
        Utility:TweenObject(element, {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(element.BackgroundColor3.R * 255 + 15, 0, 255),
                math.clamp(element.BackgroundColor3.G * 255 + 15, 0, 255),
                math.clamp(element.BackgroundColor3.B * 255 + 15, 0, 255)
            )
        }, ModernStyles.AnimationSpeed)
        
        Utility:TweenObject(shadow, {
            ImageTransparency = ModernStyles.ShadowTransparency - 0.2,
            Size = UDim2.new(1, 12, 1, 12),
            Position = UDim2.new(0, -6, 0, -6)
        }, ModernStyles.AnimationSpeed)
    end)
    
    element.MouseLeave:Connect(function()
        Utility:TweenObject(element, {
            BackgroundColor3 = theme.ElementColor
        }, ModernStyles.AnimationSpeed)
        
        Utility:TweenObject(shadow, {
            ImageTransparency = ModernStyles.ShadowTransparency,
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(0, -5, 0, -5)
        }, ModernStyles.AnimationSpeed)
    end)
    
    return element
end

-- Modern toggle switch
local function createModernToggle(parent, theme)
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.BackgroundTransparency = 1
    toggle.Size = UDim2.new(0, 40, 0, 20)
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Parent = toggle
    track.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    track.Size = UDim2.new(1, 0, 0.5, 0)
    track.Position = UDim2.new(0, 0, 0.25, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = track
    
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Parent = toggle
    thumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    thumb.Size = UDim2.new(0.5, 0, 1, 0)
    thumb.Position = UDim2.new(0, 0, 0, 0)
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = thumb
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    
    function toggle:SetState(state, instant)
        if state then
            Utility:TweenObject(thumb, {
                Position = UDim2.new(0.5, 0, 0, 0),
                BackgroundColor3 = theme.SchemeColor
            }, instant and 0 or 0.2)
            
            Utility:TweenObject(track, {
                BackgroundColor3 = Color3.fromRGB(
                    theme.SchemeColor.R * 255 * 0.5,
                    theme.SchemeColor.G * 255 * 0.5,
                    theme.SchemeColor.B * 255 * 0.5
                )
            }, instant and 0 or 0.2)
        else
            Utility:TweenObject(thumb, {
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            }, instant and 0 or 0.2)
            
            Utility:TweenObject(track, {
                BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            }, instant and 0 or 0.2)
        end
    end
    
    return toggle
end

-- Modern slider
local function createModernSlider(parent, theme)
    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.BackgroundTransparency = 1
    slider.Size = UDim2.new(1, 0, 0, 20)
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Parent = slider
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0.5, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Parent = track
    fill.BackgroundColor3 = theme.SchemeColor
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Parent = slider
    thumb.BackgroundColor3 = theme.SchemeColor
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.Position = UDim2.new(0.5, -6, 0.5, -6)
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = thumb
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    
    function slider:SetValue(value, min, max)
        local range = max - min
        local position = (value - min) / range
        position = math.clamp(position, 0, 1)
        
        Utility:TweenObject(fill, {
            Size = UDim2.new(position, 0, 1, 0)
        }, 0.1)
        
        Utility:TweenObject(thumb, {
            Position = UDim2.new(position, -6, 0.5, -6)
        }, 0.1)
    end
    
    return slider
end

function Kavo.CreateLib(title, theme)
    -- Use modern theme if not specified
    theme = theme or ModernThemes.Dark
    
    -- Create main UI container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI_"..tostring(math.random(1, 10000))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Main window frame
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = theme.Background
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Modern corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = ModernStyles.CornerRadius
    corner.Parent = Main
    
    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = Main
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = ModernStyles.ShadowTransparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = theme.Header
    Header.Size = UDim2.new(1, 0, 0, 40)
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, ModernStyles.CornerRadius.Offset)
    headerCorner.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title
    Title.TextColor3 = theme.TextColor
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
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
    TabContainer.BackgroundColor3 = theme.Header
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    
    local tabContainerCorner = Instance.new("UICorner")
    tabContainerCorner.CornerRadius = UDim.new(0, ModernStyles.CornerRadius.Offset)
    tabContainerCorner.Parent = TabContainer
    
    -- Tab list
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.ScrollBarThickness = 5
    TabList.ScrollBarImageColor3 = theme.SchemeColor
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
        local tabButton = createTabButton(tabName, TabList, theme, firstTab)
        
        -- Create page frame
        local page = Instance.new("ScrollingFrame")
        page.Name = tabName.."Page"
        page.Parent = Pages
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = firstTab
        page.ScrollBarThickness = 5
        page.ScrollBarImageColor3 = theme.SchemeColor
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Parent = page
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, ModernStyles.ElementPadding)
        
        -- Update page size
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y)
        end)
        
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
            
            page.Visible = true
            
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
            header.TextColor3 = theme.TextColor
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
            contentLayout.Padding = UDim.new(0, ModernStyles.ElementPadding)
            
            -- Update section size
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                content.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
                section.Size = UDim2.new(1, 0, 0, 35 + contentLayout.AbsoluteContentSize.Y)
            end)
            
            local Elements = {}
            
            function Elements:NewButton(buttonText, buttonTooltip, callback)
                buttonText = buttonText or "Button"
                callback = callback or function() end
                
                local button = createModernElement("Button", content, theme)
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = button
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -40, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = buttonText
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local icon = Instance.new("ImageLabel")
                icon.Name = "Icon"
                icon.Parent = button
                icon.BackgroundTransparency = 1
                icon.Size = UDim2.new(0, 20, 0, 20)
                icon.Position = UDim2.new(1, -30, 0.5, -10)
                icon.Image = "rbxassetid://3926305904"
                icon.ImageRectOffset = Vector2.new(964, 324)
                icon.ImageRectSize = Vector2.new(36, 36)
                icon.ImageColor3 = theme.SchemeColor
                
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
                
                -- Tooltip (would need proper implementation)
                
                local buttonFunctions = {}
                
                function buttonFunctions:Update(newText)
                    label.Text = newText or buttonText
                end
                
                return buttonFunctions
            end
            
            function Elements:NewToggle(toggleText, defaultState, callback)
                toggleText = toggleText or "Toggle"
                defaultState = defaultState or false
                callback = callback or function() end
                
                local toggleElement = createModernElement("Toggle", content, theme)
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = toggleElement
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -60, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = toggleText
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local toggle = createModernToggle(toggleElement, theme)
                toggle.Position = UDim2.new(1, -40, 0.5, -10)
                toggle:SetState(defaultState, true)
                
                local currentState = defaultState
                
                toggleElement.MouseButton1Click:Connect(function()
                    currentState = not currentState
                    toggle:SetState(currentState)
                    callback(currentState)
                end)
                
                local toggleFunctions = {}
                
                function toggleFunctions:SetState(state)
                    currentState = state
                    toggle:SetState(state)
                end
                
                return toggleFunctions
            end
            
            function Elements:NewSlider(sliderText, minValue, maxValue, defaultValue, callback)
                sliderText = sliderText or "Slider"
                minValue = minValue or 0
                maxValue = maxValue or 100
                defaultValue = defaultValue or minValue
                callback = callback or function() end
                
                local sliderElement = createModernElement("Slider", content, theme)
                sliderElement.Size = UDim2.new(1, 0, 0, 50)
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = sliderElement
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -20, 0, 20)
                label.Position = UDim2.new(0, 10, 0, 5)
                label.Font = Enum.Font.GothamSemibold
                label.Text = sliderText
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "Value"
                valueLabel.Parent = sliderElement
                valueLabel.BackgroundTransparency = 1
                valueLabel.Size = UDim2.new(0, 60, 0, 20)
                valueLabel.Position = UDim2.new(1, -70, 0, 5)
                valueLabel.Font = Enum.Font.GothamSemibold
                valueLabel.Text = tostring(defaultValue)
                valueLabel.TextColor3 = theme.SchemeColor
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                local slider = createModernSlider(sliderElement, theme)
                slider.Position = UDim2.new(0, 10, 0, 30)
                slider.Size = UDim2.new(1, -20, 0, 20)
                slider:SetValue(defaultValue, minValue, maxValue)
                
                -- Slider interaction
                local dragging = false
                
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                        local percent = (mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
                        percent = math.clamp(percent, 0, 1)
                        local value = math.floor(minValue + (maxValue - minValue) * percent)
                        valueLabel.Text = tostring(value)
                        slider:SetValue(value, minValue, maxValue)
                        callback(value)
                    end
                end)
                
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                        local percent = (mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
                        percent = math.clamp(percent, 0, 1)
                        local value = math.floor(minValue + (maxValue - minValue) * percent)
                        valueLabel.Text = tostring(value)
                        slider:SetValue(value, minValue, maxValue)
                        callback(value)
                    end
                end)
                
                local sliderFunctions = {}
                
                function sliderFunctions:SetValue(value)
                    value = math.clamp(value, minValue, maxValue)
                    valueLabel.Text = tostring(value)
                    slider:SetValue(value, minValue, maxValue)
                end
                
                return sliderFunctions
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
