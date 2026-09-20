-- Favorites Mode
-- Threat + Ripper

local Players = game:GetService("Players")
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

-- Shared settings
local MIN_DOOR = 8
local MAX_DOOR = 98
local hasSpawnedThreat = false
local hasSpawnedRipper = false
local currentDoor = 0

local function getDoorNumber()
	local success, result = pcall(function()
		return require(localPlayer.PlayerGui.MainUI.Initiator.Main_Game).currentRoom or 0
	end)
	return success and result or 0
end

-- ====================== THREAT ======================
local function spawnThreat()
	if hasSpawnedThreat then return end
	hasSpawnedThreat = true
	print("[Favorites Mode] Threat is spawning...")

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

		local spawnSound = Instance.new("Sound")
		spawnSound.SoundId = "rbxassetid://3359047385"
		spawnSound.Volume = 2
		spawnSound.Parent = workspace
		spawnSound:Play()
		game:GetService("Debris"):AddItem(spawnSound, 5)

		local baseSound = Instance.new("Sound")
		baseSound.SoundId = "rbxassetid://92141520425325"
		baseSound.Volume = 1.8
		baseSound.Looped = true
		baseSound.Parent = model
		baseSound:Play()
	end)

	Threat:Run(true)
end

-- ====================== RIPPER ======================
local function spawnRipper()
	if hasSpawnedRipper then return end
	hasSpawnedRipper = true
	print("[Favorites Mode] Ripper is spawning...")

	-- Turn lights deep red (Ripper's signature)
	local redColor = Color3.fromRGB(180, 20, 20)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") then
			v.Color = redColor
		end
	end
	Lighting.Ambient = Color3.fromRGB(80, 10, 10)

	local Ripper = Spawner:Create({
		Entity = {
			Name = "Ripper",
			Asset = "https://raw.githubusercontent.com/FireGiraffe/Favorites-Mode-Doors/main/Ripper.rbxm",
			HeightOffset = 0
		},
		Movement = {
			Speed = 280,          -- very fast
			Delay = 1.5,
			Reversed = false
		},
		Damage = {
			Enabled = true,
			IgnoreHiding = false,
			Range = 50,
			Amount = 125
		},
		Rebounding = {
			Enabled = false,      -- Ripper does NOT rebound like Ambush
			Type = "Ambush",
			Min = 1,
			Max = 1,
			Delay = 2
		},
		Lights = {
			Flicker = {Enabled = false}, -- no normal flicker, just red
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
				"The room turned red...",
				"He is much faster than Rush.",
				"Hide until he is gone."
			},
			Cause = "Ripper"
		}
	})

	Ripper:SetCallback("OnSpawned", function()
		local model = Ripper.Model
		if not model then return end

		-- Loud roar (you can replace the ID later if you have the real one)
		local roar = Instance.new("Sound")
		roar.SoundId = "rbxassetid://12971875415" -- placeholder roar
		roar.Volume = 3
		roar.Parent = workspace
		roar:Play()
		game:GetService("Debris"):AddItem(roar, 6)
	end)

	Ripper:Run(true)
end

-- Natural spawning loop
task.spawn(function()
	while true do
		task.wait(1)

		local door = getDoorNumber()
		if door > currentDoor then
			currentDoor = door

			if door >= MIN_DOOR and door <= MAX_DOOR then
				-- Threat chance
				if not hasSpawnedThreat and math.random(1, 100) <= 15 then
					spawnThreat()
				end

				-- Ripper chance
				if not hasSpawnedRipper and math.random(1, 100) <= 12 then
					spawnRipper()
				end
			end
		end
	end
end)

print("[Favorites Mode] Loaded with Threat + Ripper")
