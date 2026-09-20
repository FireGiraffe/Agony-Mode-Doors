-- Favorites Mode
-- Natural Threat spawning + real Doors bottom text

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local localPlayer = Players.LocalPlayer

-- Load Entity Spawner
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()

-- Real Doors bottom text function
local function DoorsBottomText(text)
	local success = pcall(function()
		local MainGame = require(localPlayer.PlayerGui.MainUI.Initiator.Main_Game)
		MainGame.caption(text, true)
	end)
	
	if not success then
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Favorites Mode",
			Text = text,
			Duration = 5
		})
	end
end

-- Show the message when the mode loads
DoorsBottomText("Favorites Mode Activated")

-- Settings for Threat
local MIN_DOOR = 8
local MAX_DOOR = 98
local SPAWN_CHANCE = 12 -- % chance per door
local hasSpawned = false
local currentDoor = 0

-- Get current door number
local function getDoorNumber()
	local success, result = pcall(function()
		return require(localPlayer.PlayerGui.MainUI.Initiator.Main_Game).currentRoom or 0
	end)
	return success and result or 0
end

-- Spawn Threat
local function spawnThreat()
	if hasSpawned then return end
	hasSpawned = true

	print("[Favorites Mode] Threat is spawning...")

	-- Tint lights pink
	local pinkColor = Color3.fromRGB(255, 20, 147)
	for _, light in pairs(workspace:GetDescendants()) do
		if light:IsA("PointLight") or light:IsA("SpotLight") then
			light.Color = pinkColor
		end
	end

	local Threat = Spawner:Create({
		Entity = {
			Name = "Threat",
			Asset = "https://raw.githubusercontent.com/FireGiraffe/Favorites-Mode-Doors/main/Threat.rbxm",
			HeightOffset = 0
		},
		Movement = {
			Speed = 225,
			Delay = 2,
			Reversed = false
		},
		Damage = {
			Enabled = true,
			IgnoreHiding = false,
			Range = 45,
			Amount = 125
		},
		Rebounding = {
			Enabled = true,
			Type = "Ambush",
			Min = 5,
			Max = 8,
			Delay = 2
		},
		Lights = {
			Flicker = {
				Enabled = true,
				Duration = 1
			},
			Shatter = false,
			Repair = false
		},
		Earthquake = {
			Enabled = true
		},
		CameraShake = {
			Enabled = true,
			Values = {1.8, 25, 0.1, 1},
			Range = 120
		},
		Crucifixion = {
			Type = "Curious",
			Enabled = true,
			Range = 40,
			Resist = false,
			Break = true
		},
		Death = {
			Type = "Guiding",
			Hints = {
				"You died to Threat.",
				"The lights turn pink signaling its arrival.",
				"Threat is extremely loud.",
				"Use what you've learned from Ambush!"
			},
			Cause = "Threat"
		}
	})

	Threat:SetCallback("OnSpawned", function()
		local model = Threat.Model
		if not model then return end

		-- Spawn sound
		local spawnSound = Instance.new("Sound")
		spawnSound.SoundId = "rbxassetid://3359047385"
		spawnSound.Volume = 2
		spawnSound.Parent = workspace
		spawnSound:Play()
		game:GetService("Debris"):AddItem(spawnSound, 5)

		-- Base sound
		local baseSound = Instance.new("Sound")
		baseSound.SoundId = "rbxassetid://92141520425325"
		baseSound.Volume = 1.8
		baseSound.Looped = true
		baseSound.Parent = model
		baseSound:Play()
	end)

	Threat:Run(true)
end

-- Natural spawning loop
task.spawn(function()
	while true do
		task.wait(1)

		local door = getDoorNumber()
		if door > currentDoor then
			currentDoor = door

			if door >= MIN_DOOR and door <= MAX_DOOR and not hasSpawned then
				if math.random(1, 100) <= SPAWN_CHANCE then
					spawnThreat()
				end
			end
		end
	end
end)

print("[Favorites Mode] Successfully loaded")
