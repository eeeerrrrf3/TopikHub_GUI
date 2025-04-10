local Kavo = {}

local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}

function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil

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
            parent.Position  = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, TweenInfo.new(duration, ...), properties):Play()
end

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

local function CreateUI(theme)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    screenGui.Name = "KavoUI"

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 520, 0, 320)
    mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = theme.Header
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = "Kavo GUI"
    title.TextColor3 = theme.TextColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = header

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 35, 1, 0)
    closeButton.Position = UDim2.new(1, -35, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✖"
    closeButton.TextColor3 = theme.TextColor
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.Parent = header
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -35)
    contentFrame.Position = UDim2.new(0, 0, 0, 35)
    contentFrame.BackgroundColor3 = theme.ElementColor
    contentFrame.Parent = mainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame

    return screenGui
end

local ui = CreateUI(themes.Dark)
return Kavo
