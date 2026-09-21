-- Favorites Mode (Full)
-- Threat + Ripper
-- Fixed: Threat sound doesn't loop + entities can't spawn together

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local localPlayer = Players.LocalPlayer

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()

local function DoorsBottomText(text)
	pcall(function()
		local MainGame = require(localPlayer.PlayerGui.MainUI.Initiator.Main_Game)
		MainGame.caption(text, true)
	end)
end

DoorsBottomText("Favorites Mode Activated")

local LatestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")

local MIN_DOOR = 8
local MAX_DOOR = 98
local hasSpawnedThreat = false
local hasSpawnedRipper = false
local entityActive = false          -- prevents both spawning at once

-------------------------------------------------
-- THREAT
-------------------------------------------------
local function spawnThreat()
	if hasSpawnedThreat or entityActive then return end
	hasSpawnedThreat = true
	entityActive = true
	print("[Favorites Mode] Threat is spawning on door", LatestRoom.Value)

	local pinkColor = Color3.fromRGB(255, 20, 147)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") then
			v.Color = pinkColor
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
			Flicker = {Enabled = true, Duration = 1},
			Shatter = false,
			Repair = false
		},
		Earthquake = {Enabled = true},
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

		-- Spawn sound (plays once)
		local spawnSound = Instance.new("Sound")
		spawnSound.SoundId = "rbxassetid://3359047385"
		spawnSound.Volume = 2
		spawnSound.Parent = workspace
		spawnSound:Play()
		game:GetService("Debris"):AddItem(spawnSound, 5)

		-- Base sound (plays once, NO loop)
		local baseSound = Instance.new("Sound")
		baseSound.SoundId = "rbxassetid://92141520425325"
		baseSound.Volume = 1.8
		baseSound.Looped = false          -- fixed
		baseSound.Parent = model
		baseSound:Play()
	end)

	Threat:SetCallback("OnDespawned", function()
		entityActive = false
	end)

	Threat:Run(true)
end

-------------------------------------------------
-- RIPPER (roar → wait 3.5s → spawn)
-------------------------------------------------
local function spawnRipper()
	if hasSpawnedRipper or entityActive then return end
	hasSpawnedRipper = true
	entityActive = true
	print("[Favorites Mode] Ripper roar started on door", LatestRoom.Value)

	local redColor = Color3.fromRGB(180, 20, 20)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") then
			v.Color = redColor
		end
	end
	Lighting.Ambient = Color3.fromRGB(80, 10, 10)

	-- Roar first
	local roar = Instance.new("Sound")
	roar.SoundId = "rbxassetid://12971875415"
	roar.Volume = 3
	roar.Parent = workspace
	roar:Play()
	game:GetService("Debris"):AddItem(roar, 6)

	task.delay(3.5, function()
		print("[Favorites Mode] Ripper is now spawning...")

		local Ripper = Spawner:Create({
			Entity = {
				Name = "Ripper",
				Asset = "https://raw.githubusercontent.com/FireGiraffe/Favorites-Mode-Doors/main/Ripper.rbxm",
				HeightOffset = 0
			},
			Movement = {
				Speed = 160,
				Delay = 0.2,
				Reversed = false
			},
			Damage = {
				Enabled = true,
				IgnoreHiding = false,
				Range = 50,
				Amount = 125
			},
			Rebounding = {
				Enabled = false,
				Type = "Ambush",
				Min = 1,
				Max = 1,
				Delay = 2
			},
			Lights = {
				Flicker = {Enabled = false},
				Shatter = false,
				Repair = false
			},
			Earthquake = {Enabled = true},
			CameraShake = {
				Enabled = true,
				Values = {2.5, 30, 0.1, 1},
				Range = 140
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
					"You died to Ripper.",
					"His arrival is shown by the light color and his roar.",
					"He waits for you to get out of the locker once he reaches the door.",
					"Hide until he is gone."
				},
				Cause = "Ripper"
			}
		})

		Ripper:SetCallback("OnDespawned", function()
			entityActive = false
		end)

		Ripper:Run(true)
	end)
end

-------------------------------------------------
-- NATURAL SPAWNING
-------------------------------------------------
LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
	local door = LatestRoom.Value
	if door < MIN_DOOR or door > MAX_DOOR then return end
	if entityActive then return end          -- extra safety

	if not hasSpawnedThreat and math.random(1, 100) <= 18 then
		spawnThreat()
	elseif not hasSpawnedRipper and math.random(1, 100) <= 14 then
		spawnRipper()
	end
end)

print("[Favorites Mode] Loaded")
