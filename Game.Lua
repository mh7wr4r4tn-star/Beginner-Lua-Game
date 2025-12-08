-- ServerScriptService -> Script

local Players = game:GetService("Players")
local monster = workspace.Monster
local monsterSpeed = 16
local spawnMonsterDelay = 30 -- seconds until monster spawns

-- Function to move monster towards nearest player
local function moveMonster()
    while true do
        wait(0.1)
        local nearestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (monster.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end

        if nearestPlayer and nearestPlayer.Character then
            local direction = (nearestPlayer.Character.HumanoidRootPart.Position - monster.Position).Unit
            monster.Velocity = direction * monsterSpeed
        else
            monster.Velocity = Vector3.new(0,0,0)
        end
    end
end

-- Monster collision detection
monster.Touched:Connect(function(hit)
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if player then
        player:LoadCharacter() -- respawn player
        print(player.Name .. " was caught by the monster!")
    end
end)

-- Spawn monster after a delay
delay(spawnMonsterDelay, function()
    print("Monster is on the hunt!")
    moveMonster()
end)
