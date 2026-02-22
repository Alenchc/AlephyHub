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
    Icon = "rbxthumb://type=Asset&id=11210651131&w=150&h=150"
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
    Content = "v1.1.0:\n• Fixed Rendering Elements\n• Clean Interface\n• Full Tab Recovery"
})

Tabs.Player:AddSection("User Status")

Tabs.Player:AddParagraph({
    Title = "Username",
    Content = game.Players.LocalPlayer.Name
})

local PingLabel = Tabs.Player:AddParagraph({
    Title = "Ping",
    Content = "Calculating..."
})

local FPSLabel = Tabs.Player:AddParagraph({
    Title = "FPS",
    Content = "Calculating..."
})

-- Fix Ping & FPS pakai RenderStepped + GetNetworkPing (compatible Delta mobile)
task.spawn(function()
    local RunService = game:GetService("RunService")
    local lastTime = tick()
    local frameCount = 0

    RunService.RenderStepped:Connect(function()
        frameCount += 1

        if tick() - lastTime >= 1 then
            local fps = frameCount
            frameCount = 0
            lastTime = tick()

            local ping = 0
            pcall(function()
                ping = math.floor(game.Players.LocalPlayer:GetNetworkPing() * 1000)
            end)

            PingLabel:SetContent("Ping: " .. ping .. " ms")
            FPSLabel:SetContent("FPS: " .. tostring(fps))
        end
    end)
end)

-- [[ TAB AUTO ]]
Tabs.Auto:AddSection("Farming Tools")

Tabs.Auto:AddDropdown("SelectFarmItem", {
    Title = "Select Item to Farm",
    Values = {"Wood", "Stone", "Iron", "Gold", "Diamond"},
    Multi = false,
    Default = 1,
    Callback = function(Value) _G.SelectedFarmItem = Value end
})

Tabs.Auto:AddToggle("AutoFarm", {Title = "Auto Farm", Default = false}):OnChanged(function(Value)
    _G.AutoFarm = Value
end)

Tabs.Auto:AddToggle("AutoCollect", {Title = "Auto Collect", Default = false})

Tabs.Auto:AddInput("FarmDelayInput", {
    Title = "Farm Delay",
    Default = "0.08",
    Placeholder = "0.08",
    Numeric = true,
    Finished = true,
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

Tabs.Auto:AddSection("Planting & Harvesting")

Tabs.Auto:AddDropdown("SelectSeeds", {
    Title = "Select Seeds",
    Values = {"Seed A", "Seed B", "Seed C"},
    Multi = false,
    Default = 1,
    Callback = function(Value) _G.SelectedSeed = Value end
})

Tabs.Auto:AddToggle("AutoPlant", {Title = "Auto Plant", Default = false})

Tabs.Auto:AddDropdown("SelectHarvest", {
    Title = "Select Harvest Item",
    Values = {"Crop A", "Crop B", "Crop C"},
    Multi = false,
    Default = 1,
    Callback = function(Value) _G.SelectedHarvestItem = Value end
})

Tabs.Auto:AddToggle("AutoHarvest", {Title = "Auto Harvest", Default = false})

-- [[ TAB MICS ]]
Tabs.Mics:AddSection("Movement")

Tabs.Mics:AddToggle("WalkspeedToggle", {Title = "Walkspeed", Default = false}):OnChanged(function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value and 50 or 16
    end
end)

Tabs.Mics:AddToggle("Noclip", {Title = "No Clip", Default = false})

Tabs.Mics:AddSection("Visual")

Tabs.Mics:AddToggle("Zoom", {Title = "Infinite Zoom", Default = false})

-- [[ TAB WEBHOOK ]]
Tabs.Webhook:AddSection("Discord Notifier")

Tabs.Webhook:AddInput("WebhookURL", {
    Title = "Webhook Link",
    Placeholder = "URL Discord",
    Callback = function(Value) _G.WebhookURL = Value end
})

Tabs.Webhook:AddDropdown("NotifierOptions", {
    Title = "Select Notifier",
    Values = {"Autofarm", "Autoplant", "Autoharvest"},
    Multi = true,
    Default = {},
    Callback = function(Value) _G.SelectedNotifiers = Value end
})

Tabs.Webhook:AddButton({
    Title = "Run Webhook",
    Callback = function()
        Fluent:Notify({Title = "Alephy Hub", Content = "Webhook Executed!", Duration = 2})
    end
})

-- [[ MANAGERS ]]
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("AlephyConfig")
InterfaceManager:SetFolder("AlephyConfig/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)

-- [[ TOGGLE BUTTON (TOMBOL MERAH) ]]
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "AlephyToggle"
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 10
ScreenGui.Enabled = false
ScreenGui.Parent = game:GetService("CoreGui")

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ImageButton.Size = UDim2.new(0, 45, 0, 45)
ImageButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ImageButton.Image = "rbxthumb://type=Asset&id=11210651131&w=150&h=150"
ImageButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ImageButton

ImageButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    Window:Minimize()
end)

-- Deteksi minimize via recursive frame search (compatible Delta mobile)
task.spawn(function()
    task.wait(1)
    local coreGui = game:GetService("CoreGui")

    local function findMainFrame(parent)
        for _, v in ipairs(parent:GetChildren()) do
            if v:IsA("Frame") and v.AbsoluteSize.X > 200 then
                return v
            end
            local found = findMainFrame(v)
            if found then return found end
        end
    end

    while task.wait(0.3) do
        local fluentGui = coreGui:FindFirstChild("Fluent")

        if not fluentGui then
            if ScreenGui and ScreenGui.Parent then
                ScreenGui:Destroy()
            end
            break
        end

        local mainFrame = findMainFrame(fluentGui)
        if mainFrame then
            if not mainFrame.Visible then
                ScreenGui.Enabled = true
            else
                ScreenGui.Enabled = false
            end
        end
    end
end)
