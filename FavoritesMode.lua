print("Favorites Mode: Initializing Threat Custom Setting...")

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- 1. Grab Vynixu's Framework Source
local Creator = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors%20Entity%20Spawner/Source.lua"))()

-- 2. Clean Atmosphere Configuration
local function ApplyFavoritesSettings()
    Lighting.Ambient = Color3.fromRGB(15, 10, 8)
    Lighting.Brightness = 0.5
    Lighting.FogEnd = 100
end

ApplyFavoritesSettings()

-- 3. Construct the Threat Entity Template
local Threat = Creator.createEntity({
    CustomName = "Threat",
    Model = "rbxassetid://132786450712083", 
    Speed = 95,
    DelayTime = 2.5,
    HeightOffset = 0,
    CanKill = true,
    KillRange = 45,
    BreakLights = false,
    FlickerLights = {
        Enabled = false
    },
    Cycles = {
        Min = 4,
        Max = 8,
        WaitTime = 1.7
    },
    CamShake = {
        Enabled = true,
        Values = {2.2, 28, 0.1, 1},
        Range = 130
    },
    ResistCrucifix = false,
    BreakCrucifix = true,
    DeathMessage = {
        "You died to Threat.",
        "The lights turned pink...",
        "It only gets faster.",
        "Hide next time."
    }
})

-- OnSpawn Visual and Sound Triggers
Threat.Debug.OnEntitySpawned = function()
    local oldAmbient = Lighting.Ambient
    local oldColorShift = Lighting.ColorShift_Top

    Lighting.Ambient = Color3.fromRGB(170, 30, 110)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 40, 140)

    local spawnSound = Instance.new("Sound")
    spawnSound.SoundId = "rbxassetid://3359047385"
    spawnSound.Volume = 2
    spawnSound.Parent = Workspace
    spawnSound:Play()
    game:GetService("Debris"):AddItem(spawnSound, 5)

    local baseSound = Instance.new("Sound")
    baseSound.SoundId = "rbxassetid://92141520425325"
    baseSound.Volume = 1.8
    baseSound.Looped = true
    baseSound.Parent = Workspace
    baseSound:Play()

    task.delay(14, function()
        if baseSound then
            baseSound:Stop()
            baseSound:Destroy()
        end
        Lighting.Ambient = oldAmbient
        Lighting.ColorShift_Top = oldColorShift
    end)
end

-- 4. Hook Into the Running Game Engine's Room Tracker
local CurrentRooms = Workspace:WaitForChild("CurrentRooms")
local lastSpawnedDoor = 0

local function checkNewRoom(room)
    local doorNumber = tonumber(room.Name)
    if not doorNumber or doorNumber <= lastSpawnedDoor then return end
    
    lastSpawnedDoor = doorNumber

    -- 15% Chance to roll for Threat when opening a new door
    local spawnChance = math.random(1, 100)
    if spawnChance <= 15 then 
        -- Block spawns during stationary scripted events (Door 0, 50, 100)
        if doorNumber > 2 and doorNumber ~= 50 and doorNumber ~= 100 then
            task.wait(1) -- Slight delay after door opens for atmospheric tension
            print("Threat has successfully rolled a spawn for Door: " .. doorNumber)
            Creator.runEntity(Threat)
        end
    end
end

-- Listen for future rooms added while playing
CurrentRooms.ChildAdded:Connect(checkNewRoom)

print("Thank you for using Favorites Mode.")
