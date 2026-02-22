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

_G.AutoFarm = false 

spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alenchc/AlephyHub/main/autofarm.lua"))()
    end)
end)

local Window = Fluent:CreateWindow({
    Title = "Alephy. [Beta Test]",
    SubTitle = "by Alench",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Icon = "rbxassetid://11210651131"
})

local CustomTheme = Fluent.Themes.Dark
CustomTheme.Accent = Color3.fromRGB(255, 0, 0)
CustomTheme.WindowBackground = Color3.fromRGB(25, 0, 0)
CustomTheme.TabBackground = Color3.fromRGB(35, 0, 0)
CustomTheme.ElementBackground = Color3.fromRGB(40, 0, 0)
CustomTheme.HeaderText = Color3.fromRGB(255, 255, 255) -- Tetap putih agar terbaca
CustomTheme.MainRed = Color3.fromRGB(255, 0, 0)
Fluent:SetTheme("Dark")

local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AlephyToggle"
ScreenGui.IgnoreGuiInset = true -- Biar aman dari margin layar
ScreenGui.DisplayOrder = 999

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Size = UDim2.new(0, 55, 0, 55)
ImageButton.Image = "rbxassetid://11210651131"
ImageButton.ZIndex = 10

UICorner.CornerRadius = UDim.new(0, 16) -- Level bulatnya (15px)
UICorner.Parent = ImageButton

local Dragging = false
local DragInput, DragStart, StartPos

ImageButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = ImageButton.Position
    end
end)

ImageButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        ImageButton.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

ImageButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

ImageButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
end)

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

local AnnounceSection = Tabs.Player:AddSection("Announcement")
Tabs.Player:AddParagraph({
    Title = "Update Log",
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

local FarmSection = Tabs.Auto:AddSection("Farming Tools")
Tabs.Auto:AddDropdown("SelectItem", {
    Title = "Select Item",
    Values = {"Wood", "Stone", "Gold", "Diamond"},
    Multi = false,
    Default = 1,
})

Tabs.Auto:AddToggle("AutoFarm", {Title = "Auto Farm", Default = false}):OnChanged(function(Value)
    _G.AutoFarm = Value
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

local MovementSection = Tabs.Mics:AddSection("Movement")
Tabs.Mics:AddToggle("WalkspeedToggle", {Title = "Walkspeed", Default = false}):OnChanged(function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value and 50 or 16
end)
Tabs.Mics:AddToggle("Noclip", {Title = "No Clip", Default = false})
Tabs.Mics:AddToggle("Fly", {Title = "Fly", Default = false})

local MiscSection = Tabs.Mics:AddSection("Visual")
Tabs.Mics:AddToggle("Zoom", {Title = "Infinite Zoom", Default = false})

local WebhookSection = Tabs.Webhook:AddSection("Discord Notifier")
Tabs.Webhook:AddInput("WebhookURL", {
    Title = "Webhook Link",
    Placeholder = "Enter Discord Webhook URL",
    Callback = function(Value) _G.WebhookURL = Value end
})

local ConfigSection = Tabs.Setting:AddSection("Configuration")
Tabs.Setting:AddButton({
    Title = "Reset Menu",
    Callback = function() Window:Destroy() end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("AlephyConfig")
SaveManager:SetFolder("AlephyConfig/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
