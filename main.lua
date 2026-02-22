--[[
    ╔══════════════════════════════════════════════════════╗
    ║                ALEPHY. [BETA TEST]                   ║
    ╟──────────────────────────────────────────────────────╢
    ║  Author  : Alench                                    ║
    ║  Version : 1.0.0 (Beta)                              ║
    ║  Status  : Stable for Delta Executor                 ║
    ║  Update  : Initial UI Release                        ║
    ╚══════════════════════════════════════════════════════╝
]]

---@diagnostic disable: undefined-global, deprecated

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Inisialisasi awal
_G.AutoFarm = false 

-- Panggil Autofarm
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alenchc/AlephyHub/main/autofarm.lua"))()
    end)
end)

local Window = Fluent:CreateWindow({
    Title = "Alephy. [Beta Test]",
    SubTitle = "by Alench",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460), -- Ukuran tetap
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Icon = "rbxassetid://11210651131"
})

--- --- --- --- --- --- --- --- --- --- --- ---
--- FIX TOMBOL MELAYANG (ROUNDED & ANTI MACET)
--- --- --- --- --- --- --- --- --- --- --- ---
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AlephyToggle"
ScreenGui.IgnoreGuiInset = true 

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Image = "rbxassetid://11210651131"
ImageButton.Active = true
ImageButton.Draggable = true -- Bawaan Roblox biar enteng

UICorner.CornerRadius = UDim.new(0, 15) -- Membuat tombol rounded (tidak lancip)
UICorner.Parent = ImageButton

-- Fungsi Klik (Menggunakan VirtualInputManager agar tidak macet saat UI tertutup)
ImageButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
end)

--- --- --- --- --- --- --- --- --- --- --- ---
--- MENU SETUP
--- --- --- --- --- --- --- --- --- --- --- ---
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "play" }),
    Mics = Window:AddTab({ Title = "Mics", Icon = "layers" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "factory" }),
    Setting = Window:AddTab({ Title = "Setting", Icon = "settings" })
}

Tabs.Player:AddSection("User Status")
local PingLabel = Tabs.Player:AddParagraph({ Title = "Ping: Calculating..." })
local FPSLabel = Tabs.Player:AddParagraph({ Title = "FPS: Calculating..." })

task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / task.wait())
        local pingNum = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        PingLabel:SetTitle("Ping: " .. math.floor(pingNum) .. " ms") 
        FPSLabel:SetTitle("FPS: " .. tostring(fps))
    end
end)

local FarmSection = Tabs.Auto:AddSection("Farming Tools")
Tabs.Auto:AddToggle("AutoFarm", {Title = "Auto Farm", Default = false}):OnChanged(function(Value)
    _G.AutoFarm = Value
end)

Tabs.Auto:AddToggle("AutoCollect", {Title = "Auto Collect", Default = false})

local MovementSection = Tabs.Mics:AddSection("Movement")
Tabs.Mics:AddToggle("WalkspeedToggle", {Title = "Walkspeed", Default = false}):OnChanged(function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value and 50 or 16
    end
end)

-- Setting Management
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("AlephyConfig")
SaveManager:SetFolder("AlephyConfig/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
