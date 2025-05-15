local Notification = {}

local GUI = game:GetService("CoreGui"):FindFirstChild("STX_Nofitication")

function Notification:Notify(nofdebug, middledebug, all)
    local ambientShadow = Instance.new("ImageLabel")
    local Window = Instance.new("Frame")
    local Outline_A = Instance.new("Frame")
    local WindowTitle = Instance.new("TextLabel")
    local WindowDescription = Instance.new("TextLabel")

    ambientShadow.Name = "ambientShadow"
    ambientShadow.Parent = GUI
    ambientShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    ambientShadow.BackgroundTransparency = 1.000
    ambientShadow.BorderSizePixel = 0
    ambientShadow.Position = UDim2.new(0.5, 0, 0.75, 0)
    ambientShadow.Size = UDim2.new(0, 0, 0, 0)
    ambientShadow.Image = "rbxassetid://1316045217"
    ambientShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ambientShadow.ImageTransparency = 0.400
    ambientShadow.ScaleType = Enum.ScaleType.Slice
    ambientShadow.SliceCenter = Rect.new(10, 10, 118, 118)

    Window.Name = "Window"
    Window.Parent = ambientShadow
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 5, 0, 5)
    Window.Size = UDim2.new(0, 180, 0, 70)
    Window.ZIndex = 2

    Outline_A.Name = "Outline_A"
    Outline_A.Parent = Window
    Outline_A.BackgroundColor3 = middledebug.OutlineColor
    Outline_A.BorderSizePixel = 0
    Outline_A.Position = UDim2.new(0, 0, 0, 25)
    Outline_A.Size = UDim2.new(0, 180, 0, 2)
    Outline_A.ZIndex = 5

    WindowTitle.Name = "WindowTitle"
    WindowTitle.Parent = Window
    WindowTitle.BackgroundTransparency = 1.000
    WindowTitle.Position = UDim2.new(0, 28, 0, 2)
    WindowTitle.Size = UDim2.new(0, 146, 0, 22)
    WindowTitle.ZIndex = 4
    WindowTitle.Font = Enum.Font.GothamSemibold
    WindowTitle.Text = nofdebug.Title
    WindowTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    WindowTitle.TextSize = 12.000
    WindowTitle.TextXAlignment = Enum.TextXAlignment.Left

    WindowDescription.Name = "WindowDescription"
    WindowDescription.Parent = Window
    WindowDescription.BackgroundTransparency = 1.000
    WindowDescription.Position = UDim2.new(0, 28, 0, 30)
    WindowDescription.Size = UDim2.new(0, 146, 0, 36)
    WindowDescription.ZIndex = 4
    WindowDescription.Font = Enum.Font.GothamSemibold
    WindowDescription.Text = nofdebug.Description
    WindowDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
    WindowDescription.TextSize = 12.000
    WindowDescription.TextWrapped = true
    WindowDescription.TextXAlignment = Enum.TextXAlignment.Left
    WindowDescription.TextYAlignment = Enum.TextYAlignment.Top

    local ImageButton = Instance.new("ImageButton")
    ImageButton.Parent = Window
    ImageButton.BackgroundTransparency = 1.000
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0, 4, 0, 4)
    ImageButton.Size = UDim2.new(0, 18, 0, 18)
    ImageButton.ZIndex = 5
    ImageButton.AutoButtonColor = false
    ImageButton.Image = all.Image
    ImageButton.ImageColor3 = all.ImageColor

    coroutine.wrap(function()
        ambientShadow:TweenSize(UDim2.new(0, 190, 0, 80), "Out", "Linear", 0.2)
        Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)
        task.wait(middledebug.Time)
        ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
        task.wait(0.2)
        ambientShadow:Destroy()
    end)()
end

return Notification
