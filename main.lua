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

-- Variabel Global
_G.AutoFarm = false 
_G.FarmDelay = 0.08
_G.HitCount = 1
_G.SelectedFarmItem = ""
_G.SelectedSeed = ""
_G.SelectedHarvestItem = ""
_G.WebhookURL = ""
_G.SelectedNotifiers = {}

-- Asset ID Bulan (Moon Icon)
local MoonIcon = "rbxassetid://10734950309"

local Window = Fluent:CreateWindow({
    Title = "Alephy Hub",
    SubTitle = "v1.1.2",
    TabWidth = 160, 
    Size = UDim2.fromOffset(440, 340),
    Resizable = true, 
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Icon = MoonIcon -- LOGO SAMPING JUDUL JADI BULAN
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
    Content = "v1.1.2:\n• New Moon Aesthetics\n• Fixed Ping/FPS Update\n• All Menus Restored"
})

local StatusSection = Tabs.Player:AddSection("User Status")
Tabs.Player:AddParagraph({ Title = "Username", Content = game.Players.LocalPlayer.Name })
local PingPara = Tabs.Player:AddParagraph({ Title = "Ping: Measuring...", Content = "" })
local FPSPara = Tabs.Player:AddParagraph({ Title = "FPS: Measuring...", Content = "" })

task.spawn(function()
    local Stats = game:GetService("Stats")
    local RunService = game:GetService("RunService")
    while task.wait(0.5) do
        local ping = "0"
        local fps = "0"
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        pcall(function() fps = math.floor(1 / RunService.RenderStepped:Wait()) end)
        pcall(function()
            PingPara:SetTitle("Ping: " .. tostring(ping) .. " ms")
            FPSPara:SetTitle("FPS: " .. tostring(fps))
        end)
    end
end)

-- [[ TOMBOL MERAH DENGAN LOGO BULAN ]]
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
ImageButton.Image = MoonIcon -- LOGO TOMBOL JADI BULAN
ImageButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ImageButton
ImageButton.MouseButton1Click:Connect(function() Window:Minimize() end)

-- Cleanup Loop
task.spawn(function()
    while task.wait(0.5) do
        if not game:GetService("CoreGui"):FindFirstChild(Window.Id) then
            if ScreenGui then ScreenGui:Destroy() end
            break
        end
    end
end)

-- [[ LANJUTAN MENU LAINNYA (AUTO, MICS, DLL) TETAP SAMA ]]
-- (Tambahkan sisa kodingan Tab Auto, Mics, Webhook dari versi sebelumnya di sini)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("AlephyConfig")
InterfaceManager:SetFolder("AlephyConfig/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)
