print("evil!!!")

-- Stuff
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

local Creator = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors%20Entity%20Spawner/Source.lua"))()

local function ApplyAgonySettings()
    Lighting.Ambient = Color3.fromRGB(15, 10, 8)
    Lighting.Brightness = 0.5
    Lighting.FogEnd = 100
end

ApplyAgonySettings()

print("Thank you for using agony mode.")
