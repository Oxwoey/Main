local Notification = {}

local CoreGui = game:GetService("CoreGui")
local GUI = CoreGui:FindFirstChild("STX_Nofitication") or Instance.new("ScreenGui", CoreGui)
GUI.Name = "STX_Nofitication"
GUI.ResetOnSpawn = false

function Notification:NotifyGrab(playerName)
    local ambientShadow = Instance.new("ImageLabel")
    local Window = Instance.new("Frame")
    local Outline_A = Instance.new("Frame")
    local WindowText = Instance.new("TextLabel")
    local Image = Instance.new("ImageLabel")

    ambientShadow.Name = "ambientShadow"
    ambientShadow.Parent = GUI
    ambientShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    ambientShadow.BackgroundTransparency = 1.000
    ambientShadow.BorderSizePixel = 0
    ambientShadow.Position = UDim2.new(0.5, 0, 0.85, 0)
    ambientShadow.Size = UDim2.new(0, 0, 0, 0)
    ambientShadow.Image = "rbxassetid://1316045217"
    ambientShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ambientShadow.ImageTransparency = 0.4
    ambientShadow.ScaleType = Enum.ScaleType.Slice
    ambientShadow.SliceCenter = Rect.new(10, 10, 118, 118)

    Window.Name = "Window"
    Window.Parent = ambientShadow
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 5, 0, 5)
    Window.Size = UDim2.new(0, 230, 0, 50)
    Window.ZIndex = 2

    Outline_A.Name = "Outline_A"
    Outline_A.Parent = Window
    Outline_A.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Outline_A.BorderSizePixel = 0
    Outline_A.Position = UDim2.new(0, 0, 1, -2)
    Outline_A.Size = UDim2.new(0, 230, 0, 2)
    Outline_A.ZIndex = 5

    Image.Name = "Icon"
    Image.Parent = Window
    Image.BackgroundTransparency = 1
    Image.Position = UDim2.new(0, 6, 0.5, -12)
    Image.Size = UDim2.new(0, 24, 0, 24)
    Image.Image = "rbxassetid://6023426923"
    Image.ImageColor3 = Color3.fromRGB(0, 255, 0)
    Image.ZIndex = 4

    WindowText.Name = "WindowText"
    WindowText.Parent = Window
    WindowText.BackgroundTransparency = 1.000
    WindowText.Position = UDim2.new(0, 36, 0, 0)
    WindowText.Size = UDim2.new(1, -40, 1, 0)
    WindowText.ZIndex = 4
    WindowText.Font = Enum.Font.GothamSemibold
    WindowText.Text = "Grab player: " .. tostring(playerName)
    WindowText.TextColor3 = Color3.fromRGB(255, 255, 255)
    WindowText.TextSize = 14.000
    WindowText.TextXAlignment = Enum.TextXAlignment.Left

    coroutine.wrap(function()
        ambientShadow:TweenSize(UDim2.new(0, 240, 0, 60), "Out", "Linear", 0.2)
        Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", 4)
        task.wait(4)
        ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
        task.wait(0.2)
        ambientShadow:Destroy()
    end)()
end

return Notification
