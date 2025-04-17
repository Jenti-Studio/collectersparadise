-- ExploitScript.lua
local AutoCollectModule = {}

local AutoCollect = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Create ScreenGui and Label
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Parent = screenGui
label.Text = "R TO AUTO FARM"
label.Position = UDim2.new(0.5, -100, 0, 50)  -- Position the label in the middle of the screen
label.Size = UDim2.new(0, 200, 0, 50)  -- Set the size of the label
label.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color
label.TextSize = 24  -- Set the text size
label.BackgroundTransparency = 1  -- Make background transparent

function AutoCollectModule:Toggle(Button)
    -- AutoCollect Status umschalten
    AutoCollect = not AutoCollect

    -- Visuelle Rückmeldung (ändert die Farbe des Buttons, falls vorhanden)
    if Button and Button:IsA("Frame") then
        if AutoCollect then
            Button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            Button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        end
    end

    -- Wenn AutoCollect aktiviert ist, bewege den Spieler zu den Sammelobjekten
    while AutoCollect do
        local ClosestDistance = math.huge
        local ClosestPart = nil

        -- Iteriere über alle Collectables im Spiel
        for _, Area in pairs(workspace.Map.CollectAreas:GetChildren()) do
            for _, Collectable in pairs(Area:GetChildren()) do
                if Collectable:IsA("BasePart") then
                    local distance = (Player.Character.HumanoidRootPart.Position - Collectable.Position).Magnitude
                    if distance < ClosestDistance then
                        ClosestDistance = distance
                        ClosestPart = Collectable
                    end
                end
            end
        end

        -- Überprüfen, ob der nächste Collectable erreichbar ist und den Spieler dahin bewegen
        if ClosestPart then
            local zoneName = tonumber(ClosestPart.Parent.Name)
            if zoneName and zoneName > (Player.Data.PlayerData.BestZone.Value + 1) then
                local targetZone = workspace.Map.CollectAreas:FindFirstChild(tostring(Player.Data.PlayerData.BestZone.Value + 1))
                if targetZone then
                    Player.Character.HumanoidRootPart.CFrame = targetZone.CFrame
                end
            end
            Player.Character.Humanoid:MoveTo(ClosestPart.Position)
        end

        -- Warten, bevor die nächste Iteration startet
        task.wait(0.1)
    end
end

-- Dein Exploit-Skript könnte hier ein Event oder ein Hotkey setzen:
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Hier Triggern wir die AutoCollect-Funktion, wenn die "R"-Taste gedrückt wird
    if input.KeyCode == Enum.KeyCode.R then
        AutoCollectModule:Toggle(nil) -- Kein GUI-Button übergeben, nur der Mechanismus
    end
end)

-- Funktion, um AutoCollect auch ohne Benutzerinteraktion zu starten (z.B. für Exploit-Tests)
task.wait(3) -- Optional: 3 Sekunden warten, dann automatisch starten
AutoCollectModule:Toggle(nil)
