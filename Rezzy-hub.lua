local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local success, errorMsg = pcall(function()
local writefile, readfile
pcall(function()
writefile = writefile
readfile = readfile
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "Rezzy hub"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

local BG = Color3.fromRGB(0, 0, 0)
local ACCENT = Color3.fromRGB(255, 140, 0)
local BTN = Color3.fromRGB(30, 30, 30)
local ON = Color3.fromRGB(255, 140, 0)
local TEXT = Color3.fromRGB(255, 255, 255)

local W = 250
local H = 340
local TITLE = 48

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, W, 0, H)
Frame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
Frame.BackgroundColor3 = BG
Frame.BackgroundTransparency = 0.05
Frame.Active = true
Frame.Draggable = true
Frame.Parent = Gui

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = ACCENT
Stroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 0, TITLE)
Title.BackgroundTransparency = 1
Title.Text = "Rezzy hub"
Title.TextColor3 = ACCENT
Title.TextSize = 22
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Frame

local Gear = Instance.new("TextButton")
Gear.Size = UDim2.new(0, 38, 0, 38)
Gear.Position = UDim2.new(1, -78, 0, 5)
Gear.BackgroundColor3 = BTN
Gear.Text = "⚙"
Gear.TextColor3 = TEXT
Gear.TextSize = 22
Gear.Font = Enum.Font.GothamBold
Gear.Parent = Frame

local GStroke = Instance.new("UIStroke", Gear)
GStroke.Color = ACCENT
GStroke.Thickness = 1.6

local Min = Instance.new("TextButton")
Min.Size = UDim2.new(0, 38, 0, 38)
Min.Position = UDim2.new(1, -38, 0, 5)
Min.BackgroundColor3 = BTN
Min.Text = "−"
Min.TextColor3 = TEXT
Min.TextSize = 26
Min.Font = Enum.Font.GothamBold
Min.Parent = Frame

local MStroke = Instance.new("UIStroke", Min)
MStroke.Color = ACCENT
MStroke.Thickness = 1.6

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -TITLE - 16)
Content.Position = UDim2.new(0, 12, 0, TITLE + 8)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local open = false
local minimized = false
local featureStates = {}
local buttonInstances = {}
local connections = {}
local configPath = "Crusty.json"

local featureFunctions = {
    ["STEAL BOOST"] = {state = false, func = nil},
    ["SPEED BOOST"] = {state = false, func = nil},
    ["AUTO SPIN"] = {state = false, func = nil},
    ["UNWALK"] = {state = false, func = nil},
    ["AUTO BAT"] = {state = false, func = nil},
    ["ESP BASE"] = {state = false, func = nil},
    ["ESP PLAYERS"] = {state = false, func = nil},
    ["ESP HITBOX"] = {state = false, func = nil},
    ["ANTI LAG"] = {state = false, func = nil},
    ["ANTI RAGDOLL"] = {state = false, func = nil},
    ["ANTI TURRET"] = {state = false, func = nil},
    ["EXPAND HITBOX"] = {state = false, func = nil},
    ["XRAY"] = {state = false, func = nil},
    ["KICK ON STEAL"] = {state = false, func = nil},
    ["ANTI TRAP"] = {state = false, func = nil},
    ["TOGGLE FRIENDS"] = {state = false, func = nil},
    ["AIMBOT"] = {state = false, func = nil}
}

for name, _ in pairs(featureFunctions) do
    featureStates[name] = false
end

local function saveConfig()
    if not writefile then return end
    local configData = {
        version = 1,
        states = featureStates,
        position = {Frame.Position.X.Scale, Frame.Position.X.Offset, Frame.Position.Y.Scale, Frame.Position.Y.Offset}
    }
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(configData)
    end)
    if success then
        pcall(function()
            writefile(configPath, encoded)
        end)
    end
end

local function loadConfig()
    if not readfile then return end
    local success, fileContent = pcall(function()
        return readfile(configPath)
    end)
    if not success then return end
    local success2, configData = pcall(function()
        return HttpService:JSONDecode(fileContent)
    end)
    if not success2 or not configData.states then return end
    for name, state in pairs(configData.states) do
        if featureFunctions[name] then
            featureStates[name] = state
            if featureFunctions[name].func and state then
                task.spawn(function()
                    task.wait(0.1)
                    featureFunctions[name].func(state)
                end)
            end
        end
    end
    if configData.position then
        Frame.Position = UDim2.new(
            configData.position[1] or 0.5,
            configData.position[2] or -W/2,
            configData.position[3] or 0.5,
            configData.position[4] or -H/2
        )
    end
end

Gear.MouseEnter:Connect(function()
    TweenService:Create(Gear, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
end)
Gear.MouseLeave:Connect(function()
    TweenService:Create(Gear, TweenInfo.new(0.2), {BackgroundColor3 = BTN}):Play()
end)
Min.MouseEnter:Connect(function()
    TweenService:Create(Min, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
end)
Min.MouseLeave:Connect(function()
    TweenService:Create(Min, TweenInfo.new(0.2), {BackgroundColor3 = BTN}):Play()
end)
Min.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, W, 0, TITLE)
        Content.Visible = false
        Min.Text = "+"
    else
        Frame.Size = UDim2.new(0, W, 0, H)
        Content.Visible = true
        Min.Text = "−"
    end
    saveConfig()
end)

local function btn(y, name, press)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 44)
    b.Position = UDim2.new(0, 0, 0, y)
    b.BackgroundColor3 = featureStates[name] and ON or BTN
    b.Text = name
    b.TextColor3 = TEXT
    b.TextSize = 16
    b.Font = Enum.Font.GothamSemibold
    b.TextScaled = true
    b.TextWrapped = true
    b.Parent = Content
    local s = Instance.new("UIStroke", b)
    s.Color = ACCENT
    s.Thickness = 1.6
    buttonInstances[name] = b
    b.MouseEnter:Connect(function()
        if not featureStates[name] then
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if not featureStates[name] then
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = BTN}):Play()
        end
    end)
    if press then
        b.MouseButton1Click:Connect(function()
            if featureFunctions[name] and featureFunctions[name].func then
                featureFunctions[name].func(true)
            end
            TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = ON}):Play()
            task.wait(0.1)
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = BTN}):Play()
            saveConfig()
        end)
    else
        b.MouseButton1Click:Connect(function()
            featureStates[name] = not featureStates[name]
            local targetColor = featureStates[name] and ON or BTN
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
            if featureFunctions[name] and featureFunctions[name].func then
                featureFunctions[name].func(featureStates[name])
            end
            saveConfig()
        end)
    end
    return b
end

local function pair(x1, x2, y, n1, n2)
    local w = (W - 24 - 8) / 2
    local b1 = Instance.new("TextButton")
    b1.Size = UDim2.new(0, w, 0, 42)
    b1.Position = UDim2.new(0, x1, 0, y)
    b1.BackgroundColor3 = featureStates[n1] and ON or BTN
    b1.Text = n1
    b1.TextColor3 = TEXT
    b1.TextSize = 14
    b1.Font = Enum.Font.GothamSemibold
    b1.TextScaled = true
    b1.TextWrapped = true
    b1.Parent = Content
    local s1 = Instance.new("UIStroke", b1)
    s1.Color = ACCENT
    s1.Thickness = 1.4
    local b2 = Instance.new("TextButton")
    b2.Size = UDim2.new(0, w, 0, 42)
    b2.Position = UDim2.new(0, x2, 0, y)
    b2.BackgroundColor3 = featureStates[n2] and ON or BTN
    b2.Text = n2
    b2.TextColor3 = TEXT
    b2.TextSize = 14
    b2.Font = Enum.Font.GothamSemibold
    b2.TextScaled = true
    b2.TextWrapped = true
    b2.Parent = Content
    local s2 = Instance.new("UIStroke", b2)
    s2.Color = ACCENT
    s2.Thickness = 1.4
    buttonInstances[n1] = b1
    buttonInstances[n2] = b2
    local function setupHover(button, name)
        button.MouseEnter:Connect(function()
            if not featureStates[name] then
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end
        end)
        button.MouseLeave:Connect(function()
            if not featureStates[name] then
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = BTN}):Play()
            end
        end)
    end
    setupHover(b1, n1)
    setupHover(b2, n2)
    b1.MouseButton1Click:Connect(function()
        featureStates[n1] = not featureStates[n1]
        local targetColor = featureStates[n1] and ON or BTN
        TweenService:Create(b1, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
        if featureFunctions[n1] and featureFunctions[n1].func then
            featureFunctions[n1].func(featureStates[n1])
        end
        saveConfig()
    end)
    b2.MouseButton1Click:Connect(function()
        featureStates[n2] = not featureStates[n2]
        local targetColor = featureStates[n2] and ON or BTN
        TweenService:Create(b2, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
        if featureFunctions[n2] and featureFunctions[n2].func then
            featureFunctions[n2].func(featureStates[n2])
        end
        saveConfig()
    end)
end

local function clear()
    for _, v in pairs(Content:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    buttonInstances = {}
end

local xrayConnection = nil
local originalProps = {}
featureFunctions["XRAY"].func = function(state)
    if xrayConnection then 
        xrayConnection:Disconnect() 
        xrayConnection = nil 
    end
    for part, props in pairs(originalProps) do
        if part and part.Parent then 
            part.Transparency = props.Transparency 
            part.Material = props.Material 
        end
    end
    originalProps = {}
    if state then
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                local containers = {plot:FindFirstChild("Decorations"), plot:FindFirstChild("AnimalPodiums")}
                for _, container in ipairs(containers) do
                    if container then
                        for _, obj in ipairs(container:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                originalProps[obj] = {
                                    Transparency = obj.Transparency, 
                                    Material = obj.Material
                                }
                                obj.Transparency = 0.9
                                obj.Material = Enum.Material.Plastic
                            end
                        end
                    end
                end
            end
        end
        xrayConnection = workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("BasePart") and obj.Transparency < 0.9 then
                originalProps[obj] = {
                    Transparency = obj.Transparency, 
                    Material = obj.Material
                }
                obj.Transparency = 0.9
                obj.Material = Enum.Material.Plastic
            end
        end)
    end
end

local AntiRagdollActive = false
local AntiRagdollConnections = {}
local function EnableAntiRagdoll()
    if AntiRagdollActive then return end
    AntiRagdollActive = true
    local character = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local animator = humanoid:WaitForChild("Animator")
    local maxVelocity = 40
    local clampVelocity = 25
    local maxClamp = 15
    local lastVelocity = Vector3.new(0, 0, 0)
    local function IsRagdollState()
        local state = humanoid:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
    end
    local function CleanRagdollEffects()
        for _, obj in pairs(character:GetDescendants()) do
            if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                obj:Destroy()
            elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                obj:Destroy()
            elseif obj:IsA("Motor6D") then
                obj.Enabled = true
            end
        end
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            local animName = track.Animation and track.Animation.Name:lower() or ""
            if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                track:Stop(0)
            end
        end
    end
    local function ReEnableControls()
        pcall(function()
            require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():Enable()
        end)
    end
    table.insert(AntiRagdollConnections, humanoid.StateChanged:Connect(function(_, newState)
        if IsRagdollState() then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            CleanRagdollEffects()
            camera.CameraSubject = humanoid
            ReEnableControls()
        end
    end))
    table.insert(AntiRagdollConnections, RunService.Heartbeat:Connect(function()
        if IsRagdollState() then
            CleanRagdollEffects()
            local vel = hrp.AssemblyLinearVelocity
            local velChange = (vel - lastVelocity).Magnitude
            if velChange > maxVelocity and vel.Magnitude > clampVelocity then
                hrp.AssemblyLinearVelocity = vel.Unit * math.min(vel.Magnitude, maxClamp)
            end
            lastVelocity = vel
        end
    end))
    table.insert(AntiRagdollConnections, character.DescendantAdded:Connect(function()
        if IsRagdollState() then CleanRagdollEffects() end
    end))
    ReEnableControls()
    CleanRagdollEffects()
    table.insert(AntiRagdollConnections, Player.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
        hrp = newChar:WaitForChild("HumanoidRootPart")
        animator = humanoid:WaitForChild("Animator")
        lastVelocity = Vector3.new(0, 0, 0)
        ReEnableControls()
        CleanRagdollEffects()
    end))
end
local function DisableAntiRagdoll()
    AntiRagdollActive = false
    for _, conn in pairs(AntiRagdollConnections) do
        conn:Disconnect()
    end
    AntiRagdollConnections = {}
end
featureFunctions["ANTI RAGDOLL"].func = function(state)
    if state then
        EnableAntiRagdoll()
    else
        DisableAntiRagdoll()
    end
end

featureFunctions["KICK ON STEAL"].func = function(state)
    if state then
        local keyword = "you stole"
        local kickMessage = "You stole brainrot!"
        local function hasKeyword(text)
            if typeof(text) ~= "string" then return false end
            return string.find(string.lower(text), keyword) ~= nil
        end
        local function kickPlayer()
            pcall(function()
                Player:Kick(kickMessage)
            end)
        end
        local function scanGuiObjects(parent)
            for _, obj in ipairs(parent:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    if hasKeyword(obj.Text) then
                        kickPlayer()
                        return true
                    end
                    obj:GetPropertyChangedSignal("Text"):Connect(function()
                        if hasKeyword(obj.Text) then
                            kickPlayer()
                        end
                    end)
                end
            end
            return false
        end
        local function setupGuiWatcher(gui)
            gui.DescendantAdded:Connect(function(desc)
                if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                    if hasKeyword(desc.Text) then
                        kickPlayer()
                    end
                    desc:GetPropertyChangedSignal("Text"):Connect(function()
                        if hasKeyword(desc.Text) then
                            kickPlayer()
                        end
                    end)
                end
            end)
        end
        for _, gui in ipairs(Player.PlayerGui:GetChildren()) do
            setupGuiWatcher(gui)
        end
        Player.PlayerGui.ChildAdded:Connect(function(gui)
            setupGuiWatcher(gui)
            scanGuiObjects(gui)
        end)
        scanGuiObjects(Player.PlayerGui)
        connections["KICK ON STEAL"] = {
            Player.PlayerGui.DescendantAdded:Connect(function(desc)
                if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                    if hasKeyword(desc.Text) then
                        kickPlayer()
                    end
                end
            end)
        }
    else
        if connections["KICK ON STEAL"] then
            for _, conn in pairs(connections["KICK ON STEAL"]) do
                conn:Disconnect()
            end
            connections["KICK ON STEAL"] = nil
        end
    end
end

featureFunctions["ANTI TRAP"].func = function(state)
    if state then
        local processedTraps = {}
        local BARRIER_OFFSET = 3
        local function isTrapPlaced(trapModel)
            local primaryPart = trapModel.PrimaryPart or trapModel:FindFirstChildWhichIsA("BasePart")
            return primaryPart and primaryPart.Anchored
        end
        local function createTrapBarrier(trapModel)
            if processedTraps[trapModel] then return end
            processedTraps[trapModel] = true
            local primaryPart = trapModel.PrimaryPart or trapModel:FindFirstChildWhichIsA("BasePart")
            if not primaryPart then return end
            local cf, size = trapModel:GetBoundingBox()
            local barrier = Instance.new("Part")
            barrier.Name = "TrapBarrier"
            barrier.Size = size + Vector3.new(BARRIER_OFFSET * 2, size.Y, BARRIER_OFFSET * 2)
            barrier.CFrame = cf
            barrier.Anchored = true
            barrier.CanCollide = true
            barrier.Transparency = 0.8
            barrier.Material = Enum.Material.ForceField
            barrier.Color = Color3.fromRGB(0, 255, 0)
            barrier.Parent = workspace
            barrier.CanQuery = false
            for _, part in pairs(trapModel:GetDescendants()) do
                if part:IsA("BasePart") and part ~= barrier then
                    part.CanCollide = false
                    part.Transparency = 1
                end
                if part:IsA("TouchTransmitter") then
                    part:Destroy()
                end
            end
        end
        local function findTraps()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:lower():find("trap") then
                    if isTrapPlaced(obj) then
                        createTrapBarrier(obj)
                    end
                end
            end
        end
        findTraps()
        connections["ANTI TRAP"] = workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("Model") and obj.Name:lower():find("trap") then
                task.wait(0.5)
                if obj.Parent and isTrapPlaced(obj) then
                    createTrapBarrier(obj)
                end
            end
        end)
    else
        if connections["ANTI TRAP"] then
            connections["ANTI TRAP"]:Disconnect()
            connections["ANTI TRAP"] = nil
        end
    end
end

featureFunctions["ESP BASE"].func = function(state)
    if state then
        local plotsFolder = workspace:WaitForChild("Plots", 5)
        if not plotsFolder then return end
        local baseEspInstances = {}
        local function updateBaseESP()
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local purchases = plot:FindFirstChild("Purchases")
                local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
                local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
                local billboard = baseEspInstances[plot.Name]
                local timeLabel = mainPart and mainPart:FindFirstChild("BillboardGui") and 
                                 mainPart.BillboardGui:FindFirstChild("RemainingTime")
                if timeLabel and mainPart then
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "BaseESP_" .. plot.Name
                        billboard.Size = UDim2.new(0, 50, 0, 25)
                        billboard.StudsOffset = Vector3.new(0, 5, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = mainPart
                        billboard.MaxDistance = 1000
                        billboard.Parent = plot
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextScaled = true
                        label.Font = Enum.Font.Arcade
                        label.TextColor3 = Color3.fromRGB(255, 255, 0)
                        label.TextStrokeTransparency = 0
                        label.TextStrokeColor3 = Color3.new(0, 0, 0)
                        label.Parent = billboard
                        baseEspInstances[plot.Name] = billboard
                    end
                    local label = billboard:FindFirstChildWhichIsA("TextLabel")
                    if label then
                        label.Text = timeLabel.Text
                    end
                elseif billboard then
                    billboard:Destroy()
                    baseEspInstances[plot.Name] = nil
                end
            end
        end
        connections["ESP BASE"] = RunService.Heartbeat:Connect(updateBaseESP)
        updateBaseESP()
    else
        if connections["ESP BASE"] then
            connections["ESP BASE"]:Disconnect()
            connections["ESP BASE"] = nil
        end
        for _, billboard in pairs(workspace:GetDescendants()) do
            if billboard:IsA("BillboardGui") and billboard.Name:find("BaseESP_") then
                billboard:Destroy()
            end
        end
    end
end

featureFunctions["ESP PLAYERS"].func = function(state)
    if state then
        local espInstances = {}
        local function createESP(targetPlayer)
            if targetPlayer == Player then return end
            if espInstances[targetPlayer] then return end
            local character = targetPlayer.Character
            if not character then return end
            local head = character:FindFirstChild("Head")
            if not head then return end
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "PlayerESP_" .. targetPlayer.Name
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 5, 0)
            billboard.AlwaysOnTop = true
            billboard.Adornee = head
            billboard.MaxDistance = 500
            billboard.Parent = head
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = targetPlayer.Name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.Parent = billboard
            espInstances[targetPlayer] = billboard
            local characterAddedConn = targetPlayer.CharacterAdded:Connect(function(newChar)
                task.wait(0.5)
                local newHead = newChar:FindFirstChild("Head")
                if newHead and espInstances[targetPlayer] then
                    espInstances[targetPlayer].Adornee = newHead
                    espInstances[targetPlayer].Parent = newHead
                end
            end)
            local characterRemovingConn = targetPlayer.CharacterRemoving:Connect(function()
                if espInstances[targetPlayer] then
                    espInstances[targetPlayer]:Destroy()
                    espInstances[targetPlayer] = nil
                end
            end)
            connections["ESP_PLAYERS_" .. targetPlayer.Name] = {characterAddedConn, characterRemovingConn}
        end
        local function cleanupAllESP()
            for player, billboard in pairs(espInstances) do
                if billboard then
                    billboard:Destroy()
                end
            end
            espInstances = {}
            for key, conns in pairs(connections) do
                if string.find(key, "ESP_PLAYERS_") then
                    for _, conn in ipairs(conns) do
                        if conn then conn:Disconnect() end
                    end
                    connections[key] = nil
                end
            end
        end
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= Player then
                createESP(targetPlayer)
            end
        end
        connections["ESP PLAYERS_MAIN"] = {
            Players.PlayerAdded:Connect(function(newPlayer)
                createESP(newPlayer)
            end),
            Players.PlayerRemoving:Connect(function(removedPlayer)
                if espInstances[removedPlayer] then
                    espInstances[removedPlayer]:Destroy()
                    espInstances[removedPlayer] = nil
                end
            end)
        }
    else
        if connections["ESP PLAYERS_MAIN"] then
            for _, conn in pairs(connections["ESP PLAYERS_MAIN"]) do
                conn:Disconnect()
            end
            connections["ESP PLAYERS_MAIN"] = nil
        end
        for key, conns in pairs(connections) do
            if string.find(key, "ESP_PLAYERS_") then
                for _, conn in ipairs(conns) do
                    if conn then conn:Disconnect() end
                end
                connections[key] = nil
            end
        end
        for _, billboard in pairs(workspace:GetDescendants()) do
            if billboard:IsA("BillboardGui") and billboard.Name:find("PlayerESP_") then
                billboard:Destroy()
            end
        end
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                for _, billboard in pairs(player.Character:GetDescendants()) do
                    if billboard:IsA("BillboardGui") and billboard.Name:find("PlayerESP_") then
                        billboard:Destroy()
                    end
                end
            end
        end
    end
end

featureFunctions["AUTO BAT"].func = function(state)
    if state then
        local batLoopActive = true
        local batLoopConnection
        local function swingBatLoop()
            while batLoopActive do
                local character = Player.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        local bat = character:FindFirstChild("Bat") or Player.Backpack:FindFirstChild("Bat")
                        if bat then
                            if bat.Parent == Player.Backpack then
                                humanoid:EquipTool(bat)
                                task.wait(0.1)
                            end
                            local equippedBat = character:FindFirstChild("Bat")
                            if equippedBat then
                                equippedBat:Activate()
                            end
                        end
                    end
                end
                task.wait(0.15)
            end
        end
        batLoopConnection = task.spawn(swingBatLoop)
        connections["AUTO BAT"] = {
            Disconnect = function()
                batLoopActive = false
                if batLoopConnection then
                    coroutine.close(batLoopConnection)
                end
            end
        }
    else
        if connections["AUTO BAT"] then
            connections["AUTO BAT"].Disconnect()
            connections["AUTO BAT"] = nil
        end
    end
end

featureFunctions["TOGGLE FRIENDS"].func = function(state)
    local ToggleFriendsRemote
    pcall(function()
        ToggleFriendsRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/PlotService/ToggleFriends")
    end)
    if ToggleFriendsRemote then
        pcall(function() ToggleFriendsRemote:FireServer() end)
    end
end

local savedAnimations = {}
local unwalkWatcher = nil
featureFunctions["UNWALK"].func = function(state)
    if state then
        local function isWalkAnim(anim)
            return anim and anim:IsA("Animation") and anim.Name:lower():find("walk")
        end
        local function saveAndClear(anim)
            if not savedAnimations[anim] then
                savedAnimations[anim] = anim.AnimationId
                anim.AnimationId = ""
            end
        end
        local function added(desc)
            if isWalkAnim(desc) then
                saveAndClear(desc)
            end
        end
        local function scan(character)
            local animate = character and character:FindFirstChild("Animate")
            if not animate then return end
            local function clear(folder, name)
                local anim = folder and folder:FindFirstChild(name)
                if anim and anim:IsA("Animation") then
                    saveAndClear(anim)
                end
            end
            clear(animate:FindFirstChild("walk"), "WalkAnim")
            clear(animate:FindFirstChild("run"), "RunAnim")
        end
        local function enable()
            local char = Player.Character
            if not char then return end
            savedAnimations = {}
            scan(char)
            if unwalkWatcher then unwalkWatcher:Disconnect() end
            unwalkWatcher = char.DescendantAdded:Connect(added)
        end
        enable()
        connections["UNWALK"] = {
            unwalkWatcher,
            Player.CharacterAdded:Connect(function(c)
                scan(c)
                if unwalkWatcher then unwalkWatcher:Disconnect() end
                unwalkWatcher = c.DescendantAdded:Connect(added)
            end)
        }
    else
        if connections["UNWALK"] then
            for _, conn in pairs(connections["UNWALK"]) do
                if conn then conn:Disconnect() end
            end
            connections["UNWALK"] = nil
            for anim, id in pairs(savedAnimations) do
                if anim and anim.Parent then
                    anim.AnimationId = id
                end
            end
            savedAnimations = {}
        end
    end
end

featureFunctions["AUTO SPIN"].func = function(state)
    if state then
        local SPIN_SPEED = 35
        local function addSpin(character)
            local hrp = character:WaitForChild("HumanoidRootPart")
            if hrp:FindFirstChild("PanquakeSpin") then return end
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "PanquakeSpin"
            bav.AngularVelocity = Vector3.new(0, SPIN_SPEED, 0)
            bav.MaxTorque = Vector3.new(0, 1e7, 0)
            bav.P = 1250
            bav.Parent = hrp
        end
        local function removeSpin(character)
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("PanquakeSpin") then
                hrp.PanquakeSpin:Destroy()
            end
        end
        if Player.Character then
            addSpin(Player.Character)
        end
        connections["AUTO SPIN"] = Player.CharacterAdded:Connect(function(char)
            task.wait(1)
            addSpin(char)
        end)
    else
        if connections["AUTO SPIN"] then
            connections["AUTO SPIN"]:Disconnect()
            connections["AUTO SPIN"] = nil
            if Player.Character then
                local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp:FindFirstChild("PanquakeSpin") then
                    hrp.PanquakeSpin:Destroy()
                end
            end
        end
    end
end

local currentSpeed = 0
local velocityConnection = nil
local function updateBoost()
    if velocityConnection then
        velocityConnection:Disconnect()
        velocityConnection = nil
    end
    if featureStates["STEAL BOOST"] then
        currentSpeed = 29
    elseif featureStates["SPEED BOOST"] then
        currentSpeed = 55
    else
        currentSpeed = 0
        return
    end
    velocityConnection = RunService.Heartbeat:Connect(function()
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp then
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    local newVelocity = Vector3.new(moveDir.X, 0, moveDir.Z) * currentSpeed
                    hrp.Velocity = Vector3.new(newVelocity.X, hrp.Velocity.Y, newVelocity.Z)
                end
            end
        end
    end)
end

featureFunctions["SPEED BOOST"].func = function(state)
    featureStates["SPEED BOOST"] = state
    if buttonInstances["SPEED BOOST"] then
        buttonInstances["SPEED BOOST"].BackgroundColor3 = state and ON or BTN
    end
    updateBoost()
end

featureFunctions["STEAL BOOST"].func = function(state)
    featureStates["STEAL BOOST"] = state
    if buttonInstances["STEAL BOOST"] then
        buttonInstances["STEAL BOOST"].BackgroundColor3 = state and ON or BTN
    end
    updateBoost()
end

featureFunctions["ESP HITBOX"].func = function(state)
    if state then
        local HitboxSize = 14
        local HitboxTransparency = 0.5
        local function updateHitboxes()
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= Player then
                    local character = targetPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                            hrp.Transparency = HitboxTransparency
                            hrp.Color = Color3.fromRGB(255, 255, 255)
                            hrp.Material = Enum.Material.Neon
                            hrp.CanCollide = false
                        end
                    end
                end
            end
        end
        connections["ESP HITBOX"] = RunService.Heartbeat:Connect(updateHitboxes)
        updateHitboxes()
    else
        if connections["ESP HITBOX"] then
            connections["ESP HITBOX"]:Disconnect()
            connections["ESP HITBOX"] = nil
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= Player then
                    local character = targetPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                            hrp.Color = Color3.fromRGB(255, 255, 255)
                            hrp.Material = Enum.Material.Plastic
                        end
                    end
                end
            end
        end
    end
end

featureFunctions["ANTI LAG"].func = function(state)
    if state then
        local function removeClothingAndMeshes(character)
            for _, child in pairs(character:GetDescendants()) do
                if child:IsA("Clothing") or child:IsA("CharacterMesh") then
                    child:Destroy()
                elseif child:IsA("BasePart") and child:FindFirstChildWhichIsA("SpecialMesh") then
                    child:ClearAllChildren()
                end
            end
        end
        if Player.Character then
            removeClothingAndMeshes(Player.Character)
        end
        connections["ANTI LAG"] = Player.CharacterAdded:Connect(removeClothingAndMeshes)
    else
        if connections["ANTI LAG"] then
            connections["ANTI LAG"]:Disconnect()
            connections["ANTI LAG"] = nil
        end
    end
end

featureFunctions["ANTI TURRET"].func = function(state)
    if state then
        local DETECTION_DISTANCE = 70
        local PULL_DISTANCE = -8
        local target = nil
        local antiTurretConnection = nil
        local lastAttack = 0
        local attackCooldown = 0.5
        local function getCharacter()
            return Player.Character
        end
        local function getWeapon()
            local char = getCharacter()
            if not char then return nil end
            return Player.Backpack:FindFirstChild("Bat") or char:FindFirstChild("Bat")
        end
        local function findTarget()
            local char = getCharacter()
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local rootPos = char.HumanoidRootPart.Position
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name:find("Sentry") and not obj.Name:lower():find("bullet") then
                    local ownerId = obj.Name:match("Sentry_(%d+)")
                    if ownerId and tonumber(ownerId) == Player.UserId then
                        continue
                    end
                    local part = obj:IsA("BasePart") and obj
                        or obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                    if part and (rootPos - part.Position).Magnitude <= DETECTION_DISTANCE then
                        return obj
                    end
                end
            end
        end
        local function moveTarget(obj)
            local char = getCharacter()
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
            local root = char.HumanoidRootPart
            local cf = root.CFrame * CFrame.new(0, 0, PULL_DISTANCE)
            if obj:IsA("BasePart") then
                obj.CFrame = cf
                obj.Velocity = Vector3.new(0, 0, 0)
                obj.RotVelocity = Vector3.new(0, 0, 0)
            elseif obj:IsA("Model") then
                local main = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if main then
                    main.CFrame = cf
                    main.Velocity = Vector3.new(0, 0, 0)
                    main.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        local function attack()
            if tick() - lastAttack < attackCooldown then return end
            lastAttack = tick()
            local char = getCharacter()
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local weapon = getWeapon()
            if not weapon then return end
            if weapon.Parent == Player.Backpack then
                hum:EquipTool(weapon)
                task.wait(0.05)
            end
            local handle = weapon:FindFirstChild("Handle")
            if handle then
                handle.CanCollide = false
            end
            pcall(function()
                weapon:Activate()
            end)
            for _, r in pairs(weapon:GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    pcall(function()
                        r:FireServer()
                    end)
                end
            end
        end
        local function startAntiTurret()
            if antiTurretConnection then return end
            antiTurretConnection = RunService.Heartbeat:Connect(function()
                if target and target.Parent == workspace then
                    moveTarget(target)
                    attack()
                else
                    target = findTarget()
                end
            end)
        end
        startAntiTurret()
        connections["ANTI TURRET"] = {
            antiTurretConnection,
            Player.CharacterAdded:Connect(function()
                task.wait(0.5)
                if featureStates["ANTI TURRET"] then
                    startAntiTurret()
                end
            end)
        }
    else
        if connections["ANTI TURRET"] then
            for _, conn in pairs(connections["ANTI TURRET"]) do
                if conn then conn:Disconnect() end
            end
            connections["ANTI TURRET"] = nil
        end
    end
end

featureFunctions["AIMBOT"].func = function(state)
    if state then
        local UseItemRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem")
        local range = 100
        local laserConnection = nil
        local webConnection = nil
        local function getNearestPlayer(maxRange)
            maxRange = maxRange or math.huge
            if not Player.Character then return nil end
            local myPos = Player.Character:FindFirstChild("HumanoidRootPart").Position
            local nearest = nil
            local shortest = maxRange
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = pl.Character.HumanoidRootPart
                    local dist = (hrp.Position - myPos).Magnitude
                    if dist < shortest then
                        shortest = dist
                        nearest = pl
                    end
                end
            end
            return nearest
        end
        local function useLaserCape(targetPart)
            if not targetPart then return end
            local args = {targetPart.Position, targetPart}
            pcall(function()
                UseItemRemote:FireServer(unpack(args))
            end)
        end
        local function useWebSlinger(targetPart)
            if not targetPart then return end
            local tool = Player.Backpack:FindFirstChild("Web Slinger") or (Player.Character and Player.Character:FindFirstChild("Web Slinger"))
            if tool and tool:FindFirstChild("Handle") then
                local handle = tool.Handle
                local args = {
                    Vector3.new(targetPart.Position.X, targetPart.Position.Y, targetPart.Position.Z),
                    targetPart,
                    handle
                }
                pcall(function()
                    UseItemRemote:FireServer(unpack(args))
                end)
            end
        end
        local function setupLaserAim()
            local laserTool = Player.Backpack:FindFirstChild("Laser Cape") or (Player.Character and Player.Character:FindFirstChild("Laser Cape"))
            if not laserTool then return end
            if laserConnection then
                laserConnection:Disconnect()
            end
            laserConnection = laserTool.Activated:Connect(function()
                local target = getNearestPlayer(range)
                if target and target.Character then
                    local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        useLaserCape(targetPart)
                    end
                end
            end)
        end
        local function setupWebAim()
            local webTool = Player.Backpack:FindFirstChild("Web Slinger") or (Player.Character and Player.Character:FindFirstChild("Web Slinger"))
            if not webTool then return end
            if webConnection then
                webConnection:Disconnect()
            end
            webConnection = webTool.Activated:Connect(function()
                local target = getNearestPlayer(range)
                if target and target.Character then
                    local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        useWebSlinger(targetPart)
                    end
                end
            end)
        end
        local function setupAimbot()
            setupLaserAim()
            setupWebAim()
        end
        setupAimbot()
        connections["AIMBOT"] = {
            laserConnection,
            webConnection,
            Player.CharacterAdded:Connect(function()
                task.wait(2)
                if featureStates["AIMBOT"] then
                    setupAimbot()
                end
            end)
        }
    else
        if connections["AIMBOT"] then
            for _, conn in pairs(connections["AIMBOT"]) do
                if conn then conn:Disconnect() end
            end
            connections["AIMBOT"] = nil
        end
    end
end

featureFunctions["EXPAND HITBOX"].func = function(state)
    if state then
        local HitboxSize = 14
        local function updateExpandedHitboxes()
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= Player then
                    local character = targetPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        end
                    end
                end
            end
        end
        connections["EXPAND HITBOX"] = RunService.Heartbeat:Connect(updateExpandedHitboxes)
        updateExpandedHitboxes()
    else
        if connections["EXPAND HITBOX"] then
            connections["EXPAND HITBOX"]:Disconnect()
            connections["EXPAND HITBOX"] = nil
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= Player then
                    local character = targetPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(2, 2, 1)
                        end
                    end
                end
            end
        end
    end
end

local function updateButtonStates()
    for name, button in pairs(buttonInstances) do
        if button and button.Parent then
            button.BackgroundColor3 = featureStates[name] and ON or BTN
        end
    end
end

local function main()
    clear()
    local y = 0
    btn(y, "STEAL BOOST"); y = y + 48
    btn(y, "SPEED BOOST"); y = y + 48
    btn(y, "AUTO SPIN"); y = y + 48
    btn(y, "UNWALK"); y = y + 48
    btn(y, "AUTO BAT")
end

local function config()
    clear()
    local y = 0
    local half = (W - 24 - 8) / 2
    pair(0, half + 8, y, "ESP BASE", "ESP PLAYERS"); y = y + 46
    pair(0, half + 8, y, "ESP HITBOX", "ANTI LAG"); y = y + 46
    pair(0, half + 8, y, "ANTI RAGDOLL", "ANTI TURRET"); y = y + 46
    pair(0, half + 8, y, "EXPAND HITBOX", "XRAY"); y = y + 46
    pair(0, half + 8, y, "KICK ON STEAL", "ANTI TRAP"); y = y + 46
    pair(0, half + 8, y, "TOGGLE FRIENDS", "AIMBOT")
end

Gear.MouseButton1Click:Connect(function()
    open = not open
    if open then 
        config() 
    else 
        main() 
    end
    saveConfig()
end)

local dragging = false
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        saveConfig()
    end
end)

main()
loadConfig()
task.wait(0.1)
updateButtonStates()
if featureStates["STEAL BOOST"] or featureStates["SPEED BOOST"] then
    updateBoost()
end
for name, state in pairs(featureStates) do
    if state and featureFunctions[name] and featureFunctions[name].func then
        task.wait(0.05)
        featureFunctions[name].func(state)
    end
end

end)

if not success then
local ErrorGui = Instance.new("ScreenGui")
ErrorGui.Name = "PanquakeError"
ErrorGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local ErrorFrame = Instance.new("Frame")
ErrorFrame.Size = UDim2.new(0, 300, 0, 150)
ErrorFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
ErrorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ErrorFrame.Parent = ErrorGui

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(1, -20, 1, -20)
ErrorLabel.Position = UDim2.new(0, 10, 0, 10)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
ErrorLabel.Text = "Script Error: " .. tostring(errorMsg)
ErrorLabel.TextWrapped = true
ErrorLabel.Parent = ErrorFrame

end

local function bypass()
for _, v in pairs(getgc(true)) do
if type(v) == "function" and islclosure(v) then
local upvals = getupvalues(v)
for i, upval in pairs(upvals) do
if type(upval) == "string" and upval:find("cheat") then
setupvalue(v, i, "nil")
elseif type(upval) == "table" then
for k, val in pairs(upval) do
if type(k) == "string" and k:find("anti") then
upval[k] = nil
end
end
end
end
elseif type(v) == "table" then
for k, val in pairs(v) do
if type(k) == "string" and (k:find("detect") or k:find("check") or k:find("anti")) then
v[k] = nil
end
end
end
end
for _, conn in pairs(getconnections(game:GetService("ScriptContext").Error)) do
conn:Disable()
end
for _, conn in pairs(getconnections(Player.Idled)) do
conn:Disable()
end
end

task.wait(1)
bypass()
