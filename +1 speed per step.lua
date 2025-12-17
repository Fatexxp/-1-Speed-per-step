local Players = game:GetService("Players")
local player = Players.LocalPlayer

local targetPosition = CFrame.new(2098, 107, -3212)
local enabled = false

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
end)

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(220, 120)
frame.Position = UDim2.fromOffset(50, 50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Shadow
local shadow = Instance.new("UIStroke")
shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
shadow.Thickness = 1
shadow.Color = Color3.fromRGB(0, 0, 0)
shadow.Transparency = 0.5
shadow.Parent = frame

-- Title Bar (draggable)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Speed Teleport"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.Parent = titleBar

-- Buttons
local onButton = Instance.new("TextButton")
onButton.Size = UDim2.fromOffset(180, 35)
onButton.Position = UDim2.fromOffset(20, 40)
onButton.Text = "ON"
onButton.TextColor3 = Color3.new(1, 1, 1)
onButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
onButton.Font = Enum.Font.Gotham
onButton.TextSize = 16
onButton.Parent = frame

local offButton = Instance.new("TextButton")
offButton.Size = UDim2.fromOffset(180, 35)
offButton.Position = UDim2.fromOffset(20, 80)
offButton.Text = "OFF"
offButton.TextColor3 = Color3.new(1, 1, 1)
offButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
offButton.Font = Enum.Font.Gotham
offButton.TextSize = 16
offButton.Parent = frame

onButton.MouseButton1Click:Connect(function()
	enabled = true
end)

offButton.MouseButton1Click:Connect(function()
	enabled = false
end)

-- Drag functionality (only title bar)
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Teleport loop
task.spawn(function()
	while true do
		if enabled and hrp then
			hrp.CFrame = targetPosition
		end
		task.wait(1)
	end
end)
