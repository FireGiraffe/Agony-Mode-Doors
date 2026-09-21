local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- thing that actually spawns entities
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()

local function DoorsBottomText(...)
	local messages = {...}
	
	task.spawn(function()
		for _, text in ipairs(messages) do
			pcall(function()
				local MainGame = require(localPlayer.PlayerGui.MainUI.Initiator.Main_Game)
				MainGame.caption(text, true)
			end)
			task.wait(2)
		end
	end)
end

-- text for like original creators yea
DoorsBottomText(
	"Favorites Mode Activated",
	"Made as a collection for my favorite entities.",
	"Made by FireGiraffe",
	"Credits to Noonie, ThatOneAmethystCreature, and many more."
)

local LatestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")

local MIN_DOOR = 8
local MAX_DOOR = 98

local hasSpawnedThreat = false
local hasSpawnedRipper = false
local hasSpawnedCease = false
local hasSpawnedRebound = false
local entityActive = false

-- rebound stuff
local reboundActive = false
local reboundRoomsLeft = 0

local function isSafeToSpawn()
	local door = LatestRoom.Value
	if door == 50 or door == 100 then return false end

	local success, inChase = pcall(function()
		local MainGame = require(localPlayer.PlayerGui.MainUI.Initiator.Main_Game)
		return MainGame.chase or MainGame.isSeekChase or false
	end)

	if success and inChase then return false end
	return true
end

-------------------------------------------------
-- THREAT
-------------------------------------------------
local function spawnThreat()
	if hasSpawnedThreat or entityActive or not isSafeToSpawn() then return end
	hasSpawnedThreat = true
	entityActive = true
	print("[Favorites Mode] Threat spawning")

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
		Movement = {Speed = 425, Delay = 1, Reversed = false},
		Damage = {Enabled = true, IgnoreHiding = false, Range = 45, Amount = 125},
		Rebounding = {Enabled = true, Type = "Ambush", Min = 5, Max = 8, Delay = 2},
		Lights = {Flicker = {Enabled = true, Duration = 1}, Shatter = false, Repair = false},
		Earthquake = {Enabled = false},
		CameraShake = {Enabled = true, Values = {1.8, 75, 0.1, 1}, Range = 120},
		Crucifixion = {Type = "Curious", Enabled = true, Range = 40, Resist = false, Break = true},
		Death = {
			Type = "Guiding",
			Hints = {"You died to Threat.", "The lights turn pink signaling its arrival.", "Threat is also extremely loud, indicating when it rebounds.", "Use what you've learned from Ambush!"},
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
		baseSound.Looped = false
		baseSound.Parent = model
		baseSound:Play()
	end)

	Threat:SetCallback("OnDespawned", function()
		entityActive = false
	end)

	Threat:Run(true)
end

-------------------------------------------------
-- RIPPER
-------------------------------------------------
local function spawnRipper()
	if hasSpawnedRipper or entityActive or not isSafeToSpawn() then return end
	hasSpawnedRipper = true
	entityActive = true
	print("[Favorites Mode] Ripper spawning")

	local redColor = Color3.fromRGB(180, 20, 20)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") then
			v.Color = redColor
		end
	end
	Lighting.Ambient = Color3.fromRGB(80, 10, 10)

	local roar = Instance.new("Sound")
	roar.SoundId = "rbxassetid://12971875415"
	roar.Volume = 3
	roar.Parent = workspace
	roar:Play()
	game:GetService("Debris"):AddItem(roar, 6)

	task.delay(3.5, function()
		if not isSafeToSpawn() then
			entityActive = false
			return
		end

		local Ripper = Spawner:Create({
			Entity = {
				Name = "Ripper",
				Asset = "https://raw.githubusercontent.com/FireGiraffe/Favorites-Mode-Doors/main/Ripper.rbxm",
				HeightOffset = 0
			},
			Movement = {Speed = 160, Delay = 0.2, Reversed = false},
			Damage = {Enabled = true, IgnoreHiding = false, Range = 50, Amount = 125},
			Rebounding = {Enabled = false, Type = "Ambush", Min = 1, Max = 1, Delay = 2},
			Lights = {Flicker = {Enabled = false}, Shatter = false, Repair = false},
			Earthquake = {Enabled = false},
			CameraShake = {Enabled = true, Values = {2.5, 30, 0.1, 1}, Range = 140},
			Crucifixion = {Type = "Curious", Enabled = true, Range = 40, Resist = false, Break = true},
			Death = {
				Type = "Guiding",
				Hints = {"You died to Ripper.", "His arrival is shown by the light color and his roar.", "Hide until he is gone."},
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
-- CEASE
-------------------------------------------------
local function spawnCease()
	if hasSpawnedCease or entityActive or not isSafeToSpawn() then return end
	hasSpawnedCease = true
	entityActive = true
	print("[Favorites Mode] Cease spawning")

	local blueColor = Color3.fromRGB(40, 80, 200)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") then
			v.Color = blueColor
		end
	end
	Lighting.Ambient = Color3.fromRGB(20, 40, 90)

	local Cease = Spawner:Create({
		Entity = {
			Name = "Cease",
			Asset = "https://raw.githubusercontent.com/FireGiraffe/Favorites-Mode-Doors/main/Cease.rbxm",
			HeightOffset = 0
		},
		Movement = {Speed = 110, Delay = 1.5, Reversed = false},
		Damage = {Enabled = false, IgnoreHiding = true, Range = 55, Amount = 125}, -- disabled normal damage
		Rebounding = {Enabled = false, Type = "Ambush", Min = 1, Max = 1, Delay = 2},
		Lights = {Flicker = {Enabled = false}, Shatter = false, Repair = false},
		Earthquake = {Enabled = false},
		CameraShake = {Enabled = true, Values = {1.2, 15, 0.1, 1}, Range = 100},
		Crucifixion = {Type = "Curious", Enabled = true, Range = 40, Resist = false, Break = true},
		Death = {
			Type = "Guiding",
			Hints = {"You died to Cease.", "The lights turn blue showing its arrival.", "You must not move.", "Stand completely still."},
			Cause = "Cease"
		}
	})

	local moveConnection
	Cease:SetCallback("OnSpawned", function()
		local model = Cease.Model
		if not model then return end

		local character = localPlayer.Character
		if not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local root = character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root then return end

		moveConnection = RunService.Heartbeat:Connect(function()
			if not model or not model.Parent then return end

			local distance = (root.Position - model:GetPivot().Position).Magnitude

			-- Only kill if player is moving AND within 100 studs
			if humanoid.MoveDirection.Magnitude > 0.1 and distance <= 100 then
				humanoid.Health = 0
			end
		end)
	end)

	Cease:SetCallback("OnDespawned", function()
		if moveConnection then
			moveConnection:Disconnect()
		end
		entityActive = false
	end)

	Cease:Run(true)
end

-------------------------------------------------
-- REBOUND
-------------------------------------------------
local function spawnRebound(isRespawn)
	if entityActive and not isRespawn then return end
	if not isSafeToSpawn() then return end

	entityActive = true
	print("[Favorites Mode] Rebound", isRespawn and "respawning" or "spawning")

	local lightBlue = Color3.fromRGB(100, 160, 255)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") then
			v.Color = lightBlue
		end
	end
	Lighting.Ambient = Color3.fromRGB(40, 70, 120)

	local sound = Instance.new("Sound")
	if isRespawn then
		sound.SoundId = "rbxassetid://103418561127185" -- respawn sound
	else
		sound.SoundId = "rbxassetid://136836151370178" -- first spawn sound
	end
	sound.Volume = 2.5
	sound.Parent = workspace
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 6)

	local Rebound = Spawner:Create({
		Entity = {
			Name = "Rebound",
			Asset = "https://raw.githubusercontent.com/FireGiraffe/Favorites-Mode-Doors/main/Rebound.rbxm",
			HeightOffset = 0
		},
		Movement = {
			Speed = 200,
			Delay = 1.2,
			Reversed = false
		},
		Damage = {
			Enabled = true,
			IgnoreHiding = false,
			Range = 50,
			Amount = 100
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
			Values = {2.2, 28, 0.1, 1},
			Range = 130
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
				"You died to Rebound.",
				"He will keep coming from the front multiple times for every door you open.",
				"Study rooms to find a place to hide.",
				"He goes away eventually."
			},
			Cause = "Rebound"
		}
	})

	Rebound:SetCallback("OnDespawned", function()
		entityActive = false
	end)

	Rebound:Run(true)
end

-------------------------------------------------
-- spawning for entities
-------------------------------------------------
LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
	local door = LatestRoom.Value
	if door < MIN_DOOR or door > MAX_DOOR then return end
	if not isSafeToSpawn() then return end

	-- Rebound multi-room logic
	if reboundActive and reboundRoomsLeft > 0 then
		reboundRoomsLeft -= 1
		spawnRebound(true) 
		if reboundRoomsLeft <= 0 then
			reboundActive = false
		end
		return
	end

	if entityActive then return end

	local roll = math.random(1, 100)

	-- spawn rates
	if not hasSpawnedThreat and roll <= 14 then
		spawnThreat()

	elseif not hasSpawnedRipper and roll <= 20 then
		spawnRipper()

	elseif not hasSpawnedCease and roll <= 26 then
		spawnCease()

	elseif not hasSpawnedRebound and roll <= 18 then
		hasSpawnedRebound = true
		reboundActive = true
		reboundRoomsLeft = math.random(4, 6)
		spawnRebound(false)
	end
end)

task.wait(10)
-- sprint
loadstring(game:HttpGet("https://raw.githubusercontent.com/FireGiraffe/Favorites-Mode-Doors/refs/heads/main/Sprint.lua"))() 

print("Thanks for using Favorites Mode.")
