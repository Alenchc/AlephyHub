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

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

if game:GetService("CoreGui"):FindFirstChild("AlephyToggle") then
    game:GetService("CoreGui").AlephyToggle:Destroy()
end

_G.AutoFarm = false 
_G.FarmDelay = 0.08
_G.HitCount = 1
_G.SelectedFarmItem = ""
_G.SelectedSeed = ""
_G.SelectedHarvestItem = ""
_G.WebhookURL = ""
_G.SelectedNotifiers = {}

pcall(function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alenchc/AlephyHub/main/autofarm.lua"))()
    end)
end)

local Window = Fluent:CreateWindow({
    Title = "Alephy Hub",
    SubTitle = "v1.1.0",
    TabWidth = 160, 
    Size = UDim2.fromOffset(440, 340),
    Resizable = true, 
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Icon = "rbxassetid://11210651131"
})

local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "play" }),
    Mics = Window:AddTab({ Title = "Mics", Icon = "layers" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "factory" }),
    Setting = Window:AddTab({ Title = "Setting", Icon = "settings" })
}

-- [[ TAB PLAYER ]]
Tabs.Player:AddSection("Announcement")

Tabs.Player:AddParagraph({
    Title = "Update Log",
    Content = "v1.1.0:\n• Fixed Rendering Elements\n• Clean Interface\n• Fixed Ping & FPS Tracker"
})

Tabs.Player:AddSection("User Status")

Tabs.Player:AddParagraph({
    Title = "Username",
    Content = game.Players.LocalPlayer.Name
})

local PingLabel = Tabs.Player:AddParagraph({
    Title = "Ping",
    Content = "Measuring..."
})

local FPSLabel = Tabs.Player:AddParagraph({
    Title = "FPS",
    Content = "Measuring..."
})

-- Logic Ping & FPS yang sudah di-fix
task.spawn(function()
    local RunService = game:GetService("RunService")
    while task.wait(1) do
        -- Fix Ping
        local ping = 0
        pcall(function()
            -- Metode Stats lebih stabil di banyak executor
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        
        -- Fix FPS (Lebih akurat pake RenderStepped)
        local fps = math.floor(1 / RunService.RenderStepped:Wait())

        -- Update Content & Title (Biar maksa refresh UI)
        PingLabel:SetTitle("Ping: " .. ping .. " ms")
        FPSLabel:SetTitle("FPS: " .. fps)
    end
end)

-- [[ TAB AUTO ]]
local SectionFarm = Tabs.Auto:AddSection("Farming Tools")
Tabs.Auto:AddDropdown("SelectFarmItem", {
    Title = "Select Item to Farm",
    Values = {"Wood", "Stone", "Iron", "Gold", "Diamond"},
    Multi = false,
    Default = 1,
    Callback = function(Value) _G.SelectedFarmItem = Value end
})
Tabs.Auto:AddToggle("AutoFarm", {Title = "Auto Farm", Default = false}):OnChanged(function(Value) _G.AutoFarm = Value end)
Tabs.Auto:AddToggle("AutoCollect", {Title = "Auto Collect", Default = false})
Tabs.Auto:AddInput("FarmDelayInput", {
    Title = "Farm Delay", Default = "0.08", Placeholder = "0.08", Numeric = true, Finished = true,
    Callback = function(Value) _G.FarmDelay = tonumber(Value) or 0.08 end
})
Tabs.Auto:AddButton({
    Title = "Set Position",
    Callback = function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            _G.SavedPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            Fluent:Notify({Title = "Alephy Hub", Content = "Position Set!", Duration = 2})
        end
    end
})

local SectionPlant = Tabs.Auto:AddSection("Planting & Harvesting")
Tabs.Auto:AddDropdown("SelectSeeds", {
    Title = "Select Seeds", Values = {"Seed A", "Seed B", "Seed C"}, Multi = false, Default = 1,
    Callback = function(Value) _G.SelectedSeed = Value end
})
Tabs.Auto:AddToggle("AutoPlant", {Title = "Auto Plant", Default = false})
Tabs.Auto:AddDropdown("SelectHarvest", {
    Title = "Select Harvest Item", Values = {"Crop A", "Crop B", "Crop C"}, Multi = false, Default = 1,
    Callback = function(Value) _G.SelectedHarvestItem = Value end
})
Tabs.Auto:AddToggle("AutoHarvest", {Title = "Auto Harvest", Default = false})

-- [[ TAB MICS ]]
local SectionMove = Tabs.Mics:AddSection("Movement")
Tabs.Mics:AddToggle("WalkspeedToggle", {Title = "Walkspeed", Default = false}):OnChanged(function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value and 50 or 16
    end
end)
Tabs.Mics:AddToggle("Noclip", {Title = "No Clip", Default = false})
local SectionVisual = Tabs.Mics:AddSection("Visual")
Tabs.Mics:AddToggle("Zoom", {Title = "Infinite Zoom", Default = false})

-- [[ TAB WEBHOOK ]]
local SectionWeb = Tabs.Webhook:AddSection("Discord Notifier")
Tabs.Webhook:AddInput("WebhookURL", {
    Title = "Webhook Link", Placeholder = "URL Discord",
    Callback = function(Value) _G.WebhookURL = Value end
})
Tabs.Webhook:AddDropdown("NotifierOptions", {
    Title = "Select Notifier", Values = {"Autofarm", "Autoplant", "Autoharvest"}, Multi = true, Default = {},
    Callback = function(Value) _G.SelectedNotifiers = Value end
})
Tabs.Webhook:AddButton({
    Title = "Run Webhook",
    Callback = function()
        Fluent:Notify({Title = "Alephy Hub", Content = "Webhook Executed!", Duration = 2})
    end
})

-- [[ TOMBOL MERAH ]]
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AlephyToggle"
ScreenGui.IgnoreGuiInset = true 
ScreenGui.DisplayOrder = 10
ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ImageButton.Size = UDim2.new(0, 45, 0, 45)
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Image = "rbxassetid://11210651131"
ImageButton.Draggable = true
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ImageButton
ImageButton.MouseButton1Click:Connect(function() Window:Minimize() end)

task.spawn(function()
    while task.wait(0.5) do
        if not game:GetService("CoreGui"):FindFirstChild(Window.Id) then
            if ScreenGui then ScreenGui:Destroy() end
            break
        end
    end
end)

-- [[ MANAGERS ]]
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("AlephyConfig")
InterfaceManager:SetFolder("AlephyConfig/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)
