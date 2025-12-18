local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- UPDATED WIN LOCATION
local targetPosition = CFrame.new(1204, 360, -3143) -- New end position
local treadmillPosition = CFrame.new(-92, -14, -762) -- Treadmill position

-- Start everything off
local teleportActive = false
local teleportLocation = nil -- nil until user chooses
local autoLoopActive = false

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
end)

-- UI LIB
local library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"
))({
	cheatname = "Speed Teleport",
	gamename = game.Name
})

library:init()

local Window = library.NewWindow({
	title = "Speed Teleport | Controller",
	size = UDim2.new(0, 510, 0.6, 6)
})

local MainTab = Window:AddTab(" Main ")
library:CreateSettingsTab(Window)

local Section = MainTab:AddSection("Teleport Control", 1)

-- MAIN TELEPORT TOGGLE
local mainToggle = Section:AddToggle({
	text = "Enable Main Teleport",
	state = false,
	flag = "MainTeleport",
	callback = function(v)
		if v then
			teleportActive = true
			teleportLocation = targetPosition
		else
			teleportActive = false
			teleportLocation = nil
		end
	end
})
mainToggle:SetState(false, true)

Section:AddButton({
	text = "Teleport Once",
	callback = function()
		if hrp then
			hrp.CFrame = targetPosition
		end
	end
})

-- TREADMILL TOGGLE
local treadmillToggle = Section:AddToggle({
	text = "Farm Energy (Treadmill)",
	state = false,
	flag = "TreadmillTeleport",
	callback = function(v)
		if v then
			teleportActive = true
			teleportLocation = treadmillPosition
		else
			teleportActive = false
			teleportLocation = nil
		end
	end
})
treadmillToggle:SetState(false, true)

Section:AddButton({
	text = "Teleport to Treadmill",
	callback = function()
		if hrp then
			hrp.CFrame = treadmillPosition
		end
	end
})

-- AUTO WIN + FARM LOOP TOGGLE
local loopToggle = Section:AddToggle({
	text = "Auto Win + Farm Loop",
	state = false,
	flag = "AutoLoop",
	callback = function(v)
		autoLoopActive = v
	end
})
loopToggle:SetState(false, true)

-- TELEPORT LOOP (main & treadmill)
task.spawn(function()
	while true do
		if teleportActive and hrp and teleportLocation then
			hrp.CFrame = teleportLocation
		end
		task.wait(1)
	end
end)

-- AUTO WIN + FARM LOOP
task.spawn(function()
	while true do
		if autoLoopActive and hrp then
			-- Step 1: Teleport to the end for a win
			hrp.CFrame = targetPosition
			task.wait(0.5)

			-- Step 2: Teleport to treadmill to farm energy
			hrp.CFrame = treadmillPosition
			task.wait(2)
		end
		task.wait(0.5)
	end
end)

library:SendNotification("Speed Teleport Loaded", 5)

