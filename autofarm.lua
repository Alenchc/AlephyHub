-- File: autofarm.lua
local player = game.Players.LocalPlayer

-- Fungsi utama autofarm
local function runAutoFarm()
    while _G.AutoFarm do -- Mengecek apakah fitur sedang ON
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local radius = 50
            for _, item in pairs(workspace:GetDescendants()) do
                if _G.AutoFarm == false then break end -- Berhenti instan jika OFF
                
                if item:IsA("BasePart") and item:FindFirstChild("TouchInterest") then
                    local hrp = character.HumanoidRootPart
                    if (item.Position - hrp.Position).Magnitude <= radius then
                        firetouchinterest(hrp, item, 0)
                        firetouchinterest(hrp, item, 1)
                    end
                end
            end
        end
        task.wait(0.05) -- Delay sesuai permintaan kamu 0.05
    end
end

-- Menjalankan fungsi dalam loop background
spawn(function()
    while true do
        if _G.AutoFarm then
            runAutoFarm()
        end
        task.wait(1)
    end
end)
