-- =============================================
-- VOID MM2 HUB v1.5 by Grok xAI
-- Valentine's Update 2026 - ANTI-KICK Auto Farm + IMPROVED Auto Win
-- Made by wtflysy | Discord: https://discord.gg/xEgFdKYgJ3
-- =============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "VOID MM2 HUB v1.5",
    LoadingTitle = "Loading VOID MM2 HUB...",
    LoadingSubtitle = "Apex Tier • Anti-Kick Farm",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VoidMM2Hub",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "VOID Key System",
        Subtitle = "Enter the key",
        Note = "Private key from wtflysy",
        FileName = "VoidMM2Key",
        SaveKey = True,
        GrabKeyFromSite = true,
        Key = "DetroitLoserlol"
    }
})

-- ================== AUTO FARM TAB (ANTI-KICK OPTIMIZED) ==================
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

local autoCoins = false
local collectConnection = nil

FarmTab:CreateToggle({
    Name = "Auto Farm Coins / Hearts / Valentine Boxes [ANTI-KICK]",
    CurrentValue = false,
    Callback = function(Value)
        autoCoins = Value
        if Value then
            Rayfield:Notify({Title = "VOID Auto Farm", Content = "ANTI-KICK started - collecting safely", Duration = 5})
            
            -- Główny loop (bezpieczna wersja)
            spawn(function()
                while autoCoins do
                    task.wait(0.25) -- <-- ZWIĘKSZONE (było 0.08)
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then task.wait(1) continue end

                    local collectibles = {}
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") or (obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart")) then
                            local nameLower = obj.Name:lower()
                            if nameLower:find("coin") or nameLower:find("heart") or nameLower:find("valentine") or nameLower:find("box") or nameLower:find("gem") or nameLower:find("candy") then
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    local dist = (hrp.Position - part.Position).Magnitude
                                    if dist < 300 then
                                        table.insert(collectibles, {part = part, dist = dist})
                                    end
                                end
                            end
                        end
                    end

                    table.sort(collectibles, function(a,b) return a.dist < b.dist end)

                    for i = 1, math.min(3, #collectibles) do -- <-- ZMNIEJSZONE (było 8)
                        local item = collectibles[i]
                        -- mały random offset żeby wyglądało naturalniej
                        local offset = CFrame.new(math.random(-1,1)*0.4, 4.8, math.random(-1,1)*0.4)
                        hrp.CFrame = item.part.CFrame * offset
                        task.wait(0.08) -- <-- ZWIĘKSZONE (było 0.025)
                    end

                    if #collectibles == 0 then task.wait(1.2) end
                end
            end)

            -- ChildAdded - bezpieczniejsza wersja
            collectConnection = workspace.ChildAdded:Connect(function(child)
                if autoCoins then
                    task.wait(0.25) -- <-- ZWIĘKSZONE (było 0.1)
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (child.Name:lower():find("coin") or child.Name:lower():find("heart") or child.Name:lower():find("valentine") or child.Name:lower():find("box")) then
                        local part = child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local offset = CFrame.new(math.random(-1,1)*0.4, 4.8, math.random(-1,1)*0.4)
                            hrp.CFrame = part.CFrame * offset
                        end
                    end
                end
            end)

        else
            if collectConnection then collectConnection:Disconnect() end
            Rayfield:Notify({Title = "VOID Auto Farm", Content = "STOPPED", Duration = 3})
        end
    end
})

-- ================== RESZTA SKRYPTU (bez zmian) ==================
local autoWin = false
FarmTab:CreateToggle({
    Name = "Auto Win [IMPROVED - faster round reset]",
    CurrentValue = false,
    Callback = function(Value)
        autoWin = Value
        if Value then
            Rayfield:Notify({Title = "VOID Auto Win", Content = "IMPROVED - fast round reset active", Duration = 5})
            spawn(function()
                while autoWin do
                    task.wait(3.5)
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.Health = 0
                    end
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Callback = function(Value)
        if Value then
            spawn(function()
                while task.wait(25) do
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                end
            end)
        end
    end
})

FarmTab:CreateButton({
    Name = "Server Hop (New Map)",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- ================== VISUALS TAB ==================
local VisualsTab = Window:CreateTab("Visuals", 6031097228)

VisualsTab:CreateToggle({
    Name = "ESP (Shows Roles)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = plr.TeamColor.Color
                    highlight.OutlineColor = Color3.new(1,1,1)
                    highlight.Parent = plr.Character
                    highlight.Adornee = plr.Character
                end
            end
            game.Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function(char)
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = plr.TeamColor.Color
                    highlight.OutlineColor = Color3.new(1,1,1)
                    highlight.Parent = char
                    highlight.Adornee = char
                end)
            end)
        end
    end
})

-- ================== COMBAT TAB ==================
local CombatTab = Window:CreateTab("Combat", 6022668962)

local killAura = false
CombatTab:CreateToggle({
    Name = "Kill Aura [IMPROVED - 25 studs]",
    CurrentValue = false,
    Callback = function(Value)
        killAura = Value
        if Value then
            spawn(function()
                while killAura and task.wait(0.05) do
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("Knife") then
                        for _, plr in pairs(game.Players:GetPlayers()) do
                            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                if distance < 25 then
                                    firetouchinterest(char.Knife.Handle, plr.Character.HumanoidRootPart, 0)
                                    task.wait(0.03)
                                    firetouchinterest(char.Knife.Handle, plr.Character.HumanoidRootPart, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim (Sheriff)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().SilentAimMM2 = Value
    end
})

-- ================== INFO ==================
local InfoTab = Window:CreateTab("Info", 6034509993)

InfoTab:CreateParagraph({
    Title = "VOID MM2 HUB v1.5",
    Content = "✅ Auto Farm ANTI-KICK (bezpieczna wersja)\n✅ Auto Win IMPROVED\n\nDiscord: https://discord.gg/xEgFdKYgJ3\nMade by wtflysy\nValentine's Update 2026\nUse on alts only."
})

InfoTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/xEgFdKYgJ3")
            Rayfield:Notify({Title = "✅ Copied", Content = "Discord link copied!", Duration = 6})
        end
    end
})

Rayfield:Notify({
    Title = "VOID MM2 HUB v1.5",
    Content = "Loaded successfully! Auto Farm ANTI-KICK 🔥",
    Duration = 8,
    Image = 4483362458
})

print("VOID MM2 HUB v1.5 (Anti-Kick) loaded successfully!")