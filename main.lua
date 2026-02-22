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

_G.AutoFarm = false -- Default OFF
spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Alenchc/AlephyHub/main/autofarm.lua"))()
end)

local Window = Fluent:CreateWindow({
    Title = "Alephy. [Beta Test]",
    SubTitle = "by Alench",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Icon = "rbxassetid://111353464984890" 
})

-- Floating button
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AlephyToggle"

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Image = "rbxassetid://111353464984890"
ImageButton.Draggable = true

ImageButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
end)

-- Notif sc
Fluent:Notify({
    Title = "Alephy Hub",
    Content = "Script successfully loaded! Welcome, " .. game.Players.LocalPlayer.Name,
    Duration = 5
})

local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "play" }),
    Mics = Window:AddTab({ Title = "Mics", Icon = "layers" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "factory" }),
    Setting = Window:AddTab({ Title = "Setting", Icon = "settings" })
}

--- --- --- --- --- --- --- --- --- --- --- ---
--- MENU PLAYER
--- --- --- --- --- --- --- --- --- --- --- ---
Tabs.Player:AddParagraph({
    Title = "Announcement / Update Log",
    Content = "v1.0.0 Beta:\n• Clean UI Released\n• Integrated with Delta Executor\n• Basic Auto Farm added"
})

local UserSection = Tabs.Player:AddSection("User Status")
local UserLabel = Tabs.Player:AddParagraph({ Title = "Username: " .. game.Players.LocalPlayer.Name })
local PingLabel = Tabs.Player:AddParagraph({ Title = "Ping: Calculating..." })
local FPSLabel = Tabs.Player:AddParagraph({ Title = "FPS: Calculating..." })

spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / task.wait())
       local pingNum = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        PingLabel:SetTitle("Ping: " .. math.floor(pingNum) .. " ms") 
        FPSLabel:SetTitle("FPS: " .. tostring(fps))
    end
end)

for i = 1, 5 do
    Tabs.Player:AddParagraph({ Title = " ", Content = " " })
end

Fluent:SetTheme("Dark") 

Window:SelectTab(1)

--- --- --- --- --- --- --- --- --- --- --- ---
--- MENU AUTO
--- --- --- --- --- --- --- --- --- --- --- ---
local AutoSection = Tabs.Auto:AddSection("Farming Tools")

Tabs.Auto:AddDropdown("SelectItem", {
    Title = "Select Item",
    Values = {"Wood", "Stone", "Gold", "Diamond"},
    Multi = false,
    Default = 1,
})

Tabs.Auto:AddToggle("AutoFarm", {Title = "Auto Farm", Default = false}):OnChanged(function(Value)
        _G.AutoFarm = Value -- Ini akan mengontrol loop di file autofarm.lua
        if Value then
            Fluent:Notify({
                Title = "Alephy Hub",
                Content = "Auto Farm Enabled",
                Duration = 2
            })
        end
    end)
end)

Tabs.Auto:AddToggle("AutoCollect", {Title = "Auto Collect", Default = false})

local PlantSection = Tabs.Auto:AddSection("Planting & Harvesting")
Tabs.Auto:AddDropdown("SelectSeeds", {
    Title = "Select Seeds",
    Values = {"Seed A", "Seed B"},
    Multi = false,
    Default = 1,
})

Tabs.Auto:AddToggle("AutoPlant", {Title = "Auto Plant", Default = false})
Tabs.Auto:AddToggle("AutoHarvest", {Title = "Auto Harvest", Default = false})

--- --- --- --- --- --- --- --- --- --- --- ---
--- MENU MICS
--- --- --- --- --- --- --- --- --- --- --- ---
Tabs.Mics:AddToggle("WalkspeedToggle", {Title = "Walkspeed", Default = false}):OnChanged(function(Value)
    if Value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50 
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

Tabs.Mics:AddToggle("Noclip", {Title = "No Clip", Default = false})
Tabs.Mics:AddToggle("Fly", {Title = "Fly", Default = false})
Tabs.Mics:AddToggle("Zoom", {Title = "Infinite Zoom", Default = false})

--- --- --- --- --- --- --- --- --- --- --- ---
--- MENU WEBHOOK
--- --- --- --- --- --- --- --- --- --- --- ---
Tabs.Webhook:AddInput("WebhookURL", {
    Title = "Webhook Link",
    Placeholder = "Enter Discord Webhook URL",
    Callback = function(Value) _G.WebhookURL = Value end
})

Tabs.Webhook:AddDropdown("Notifier", {
    Title = "Select Notifier",
    Values = {"Autofarm", "Autoplant", "Autoharvest"},
    Multi = true,
    Default = {},
})

--- --- --- --- --- --- --- --- --- --- --- ---
--- MENU SETTING
--- --- --- --- --- --- --- --- --- --- --- ---
Tabs.Setting:AddButton({
    Title = "Reset Menu",
    Callback = function() Window:Destroy() end
})

-- Konfigurasi Save & Load otomatis
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("AlephyConfig")
SaveManager:SetFolder("AlephyConfig/Configs")

InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
