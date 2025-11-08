local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

local bannedRemotes = {
    ReplicatedStorage:WaitForChild("8WX"):WaitForChild("c5e56a9e-c828-4d2a-a755-7086cca2a88d"),
    ReplicatedStorage:WaitForChild("8WX"):WaitForChild("c2499a7d-2993-4c90-aa4d-df3bc5e06930"),
    ReplicatedStorage:WaitForChild("8WX"):WaitForChild("86437dfc-c1d3-4a4c-90cb-041fa4d6a802"),
    ReplicatedStorage:WaitForChild("8WX"):WaitForChild("d43e2acd-d917-48e2-8265-2a5917e3800e")
}

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" then
        for _, remote in ipairs(bannedRemotes) do
            if self == remote then
                return
            end
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

    local function loadHamburgScript()
        local Window = OrionLib:MakeWindow({
            Name = "BadBull - V1.1",
            HidePremium = false,
            SaveConfig = true,
            ConfigFolder = "HamburgScript",
            IntroText = "Script By Mr. Ohio",
            Theme = "BloodTheme",
            
        })


        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local Workspace = game:GetService("Workspace")

    
        local noclipActive = false
        local infiniteJumpActive = false
        local antiFallActive = false
        local godModeActive = false
        local staminaHooked = false
        local espPlayers = false

        local char, hum, hrp
        local function updateCharacter()
            char = Player.Character or Player.CharacterAdded:Wait()
            hum = char:WaitForChild("Humanoid")
            hrp = char:WaitForChild("HumanoidRootPart")
        end
        updateCharacter()
        Player.CharacterAdded:Connect(updateCharacter)

    
        local MiscTab     = Window:MakeTab({Name="Misc", Icon="rbxassetid://3926305904", PremiumOnly=false})
        
    


        MiscTab:AddToggle({Name = "Toggle NoClip", Default = false, Callback = function(v) noclipActive = v end})
        MiscTab:AddToggle({Name = "Toggle Infinite Jump", Default = false, Callback = function(v) infiniteJumpActive = v end})
        MiscTab:AddToggle({Name = "Toggle Anti-Fall", Default = false, Callback = function(v) antiFallActive = v end})
        MiscTab:AddToggle({Name = "Toggle GodMode", Default = false, Callback = function(v) godModeActive = v end})

        MiscTab:AddToggle({
            Name = "Toggle Infinite Stamina",
            Default = false,
            Callback = function(value)
                if value and not staminaHooked then
                    local success, err = pcall(function()
                        local func
                        for _, v in pairs(getgc(true)) do
                            if type(v) == "function" and debug.getinfo(v).name == "setStamina" then
                                func = v
                                break
                            end
                        end
                        if func then
                            hookfunction(func, function(...) local args={...} return args[1], math.huge end)
                            staminaHooked = true
                        end
                    end)
                    if not success then
                        warn("Executor not compatible: "..tostring(err))
                    end
                end
            end
        })

-- Onglet Car Mods
local CarModTab = Window:MakeTab({
    Name = " Car Mods",
    Icon = "rbxassetid://3926305904",
    PremiumOnly = false
})

-- SECTION Utility
local PlayerSection = CarModTab:AddSection({
    Name = "Utility"
})

-- Bring Car
CarModTab:AddButton({
    Name = "Bring Car",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        local vehicle = nil

        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            vehicle = vehiclesFolder:FindFirstChild(player.Name)
        end

        if not vehicle then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find(player.Name:lower()) then
                    vehicle = v
                    break
                end
            end
        end

        if vehicle and vehicle:IsA("Model") then
            local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
            if seat then
                if not vehicle.PrimaryPart then
                    vehicle.PrimaryPart = seat
                end
                vehicle:SetPrimaryPartCFrame(root.CFrame * CFrame.new(0, 3, -8))
                task.wait(0.2)
                if humanoid and not humanoid.SeatPart then
                    seat:Sit(humanoid)
                end
            else
                warn("vehicle seat not found.")
            end
        else
            warn("vehicle not found.")
        end
    end
})


CarModTab:AddButton({
    Name = "Enter in own Car",
    Callback = function()
        local player = game.Players.LocalPlayer
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then return end

        local vehicle = vehiclesFolder:FindFirstChild(player.Name)
        if not vehicle then
            warn("Spawn your car !!!!!!!")
            return
        end

        local seat = vehicle:FindFirstChild("DriveSeat")
        if not seat then
            warn("Driveseat not found")
            return
        end

        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local root = character:WaitForChild("HumanoidRootPart")

        humanoid.Sit = false
        root.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
        seat:Sit(humanoid)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Tp to Car",
            Text = "Tadaaaaaaa..... !",
            Duration = 3
        })
    end
})


local PlayerSection = CarModTab:AddSection({
    Name = "Carfly"
})

local flightEnabled = false
local flightSpeed = 1
local flightGui
local guiFlightDirection = Vector3.new(0, 0, 0)
local buttonDirections = {
    W = Vector3.new(0, 0, -1),
    A = Vector3.new(-1, 0, 0),
    S = Vector3.new(0, 0, 1),
    D = Vector3.new(1, 0, 0),
}

local function createFlightGui()
    local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    screenGui.Name = "FlightControlGui"
    screenGui.Enabled = false

    local frame = Instance.new("Frame", screenGui)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.8, 0)
    frame.Size = UDim2.new(0, 200, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BackgroundTransparency = 0.2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0.1, 0)
    Instance.new("UIDragDetector", frame)

    local buttonSize = UDim2.new(0, 60, 0, 60)
    local positions = {
        W = UDim2.new(0.5, -30, 0, 0),
        A = UDim2.new(0, 0, 0.5, -30),
        S = UDim2.new(0.5, -30, 1, -60),
        D = UDim2.new(1, -60, 0.5, -30),
    }
    local rotations = {W = 0, A = -90, S = 180, D = 90}

    for key, direction in pairs(buttonDirections) do
        local button = Instance.new("ImageButton", frame)
        button.Name = key.."Button"
        button.Position = positions[key]
        button.Size = buttonSize
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        button.BackgroundTransparency = 0.1
        button.Image = "rbxassetid://11432834725"
        button.Rotation = rotations[key]
        Instance.new("UICorner", button).CornerRadius = UDim.new(0.1, 0)

        button.MouseButton1Down:Connect(function()
            guiFlightDirection = guiFlightDirection + direction
        end)
        button.MouseButton1Up:Connect(function()
            guiFlightDirection = Vector3.zero
        end)
    end
    return screenGui
end

local function toggleFlightGui(Value)
    if not flightGui then
        flightGui = createFlightGui()
    end
    guiFlightDirection = Vector3.zero
    flightGui.Enabled = Value
end

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    if flightEnabled then
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Sit then
            local seat = char.Humanoid.SeatPart
            if seat and seat.Name == "DriveSeat" then
                local vehicle = seat.Parent
                if vehicle then
                    if not vehicle.PrimaryPart then
                        vehicle.PrimaryPart = seat
                    end
                    local camLook = workspace.CurrentCamera.CFrame.LookVector
                    vehicle:PivotTo(CFrame.new(vehicle.PrimaryPart.Position, vehicle.PrimaryPart.Position + camLook) *
                        CFrame.new(
                            ((UIS:IsKeyDown(Enum.KeyCode.D) and flightSpeed or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and flightSpeed or 0)) + guiFlightDirection.X * flightSpeed,
                            ((UIS:IsKeyDown(Enum.KeyCode.E) and flightSpeed/2 or 0) - (UIS:IsKeyDown(Enum.KeyCode.Q) and flightSpeed/2 or 0)) + guiFlightDirection.Y * flightSpeed,
                            ((UIS:IsKeyDown(Enum.KeyCode.S) and flightSpeed or 0) - (UIS:IsKeyDown(Enum.KeyCode.W) and flightSpeed or 0)) + guiFlightDirection.Z * flightSpeed
                        ))
                    seat.AssemblyLinearVelocity = Vector3.zero
                    seat.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end
end)

local flyToggle = CarModTab:AddToggle({
    Name = "Car Fly",
    Default = false,
    Callback = function(Value)
        flightEnabled = Value
    end
})

CarModTab:AddToggle({
    Name = "Mobile Fly Menu",
    Default = false,
    Callback = function(Value)
        toggleFlightGui(Value)
    end
})

CarModTab:AddSlider({
    Name = "Car Fly Speed",
    Min = 10,
    Max = 190,
    Default = 60,
    Increment = 10,
    ValueName = "Speed",
    Callback = function(Value)
        flightSpeed = Value / 50
    end
})

CarModTab:AddBind({
    Name = "Car Fly Keybind",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        flightEnabled = not flightEnabled
        flyToggle:Set(flightEnabled)
    end
})


local PlayerSection = CarModTab:AddSection({
    Name = "Car"
})

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local vehicleGodMode = false
local lastVehicle = nil

local function updateVehicle()
    if not vehicleGodMode then return end
    if not lastVehicle or not lastVehicle.Parent then
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        lastVehicle = vehiclesFolder and vehiclesFolder:FindFirstChild(player.Name) or nil
    end
    if lastVehicle then
        lastVehicle:SetAttribute("IsOn", true)
        lastVehicle:SetAttribute("currentHealth", 999999999999)
        lastVehicle:SetAttribute("currentFuel", math.huge)
    end
end

CarModTab:AddButton({
    Name = "Car Godmode",
    Default = false,
    Callback = function(value)
        vehicleGodMode = value
        if not vehicleGodMode then
            lastVehicle = nil
        end
    end
})

RunService.Heartbeat:Connect(updateVehicle)


CarModTab:AddSlider({
    Name = "Engine Armor Brakes",
    Min = 0,
    Max = 6,
    Default = 0,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 1,
    ValueName = "Level",
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        local vehicleFolder = workspace:WaitForChild("Vehicles")
        local playerVehicle = vehicleFolder:FindFirstChild(player.Name)
        if playerVehicle then
            playerVehicle:SetAttribute("armorLevel", value)
            playerVehicle:SetAttribute("brakesLevel", value)
            playerVehicle:SetAttribute("engineLevel", value)
        end
    end
})



local VehiclesFolder = workspace:WaitForChild("Vehicles")
local LocalPlayer = game.Players.LocalPlayer


local SuspensionBase = {}


local function setSuspensionHeight(offset)
    local vehicle = VehiclesFolder:FindFirstChild(LocalPlayer.Name)
    if not vehicle then return end

    -- Applique la vraie suspension (SpringConstraint)
    for _, part in ipairs(vehicle:GetDescendants()) do
        if part:IsA("SpringConstraint") then
            if not SuspensionBase[part] then
                SuspensionBase[part] = {
                    FreeLength = part.FreeLength,
                    Stiffness = part.Stiffness,
                    Damping = part.Damping
                }
            end

            local base = SuspensionBase[part]
            part.FreeLength = math.max(base.FreeLength + offset, 0.5)
            part.Stiffness = base.Stiffness * (1 + offset/10) -- évite que ça s’écrase
            part.Damping = base.Damping * (1 + offset/15) -- garde stabilité
        end
    end


    if vehicle.PrimaryPart then
        vehicle:SetPrimaryPartCFrame(vehicle.PrimaryPart.CFrame * CFrame.new(0, offset * 0.05, 0))
    end
end


CarModTab:AddSlider({
    Name = "Suspension Height (Bug)",
    Min = 1,
    Max = 4,
    Default = 0,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 0.5,
    ValueName = "Offset",
    Callback = function(value)
        setSuspensionHeight(value)
    end
})



local carBoostPower = 250
CarModTab:AddSlider({
    Name = "Car Boost Power",
    Min = 100,
    Max = 500,
    Default = carBoostPower,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 10,
    ValueName = "Studs/sec",
    Callback = function(value)
        carBoostPower = value
    end
})

CarModTab:AddButton({
    Name = "Car Boost",
    Callback = function()
        local player = game.Players.LocalPlayer
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then return end
        local vehicle = vehiclesFolder:FindFirstChild(player.Name)
        if not vehicle then return end
        local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
        if not seat then return end
        local primaryPart = vehicle.PrimaryPart or seat
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        if humanoid.SeatPart ~= seat then return end
        primaryPart.AssemblyLinearVelocity = seat.CFrame.LookVector * carBoostPower
    end
})


local carJumpPower = 90
CarModTab:AddSlider({
    Name = "Car Jump Height",
    Min = 80,
    Max = 500,
    Default = carJumpPower,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 1,
    ValueName = "Studs",
    Callback = function(value)
        carJumpPower = value
    end
})

CarModTab:AddButton({
    Name = "Car Jump",
    Callback = function()
        local player = game.Players.LocalPlayer
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then return end
        local vehicle = vehiclesFolder:FindFirstChild(player.Name)
        if not vehicle then return end
        local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
        if not seat then return end
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        if humanoid.SeatPart ~= seat then return end
        seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + Vector3.new(0, carJumpPower, 0)
    end
})


local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VehiclesFolder = workspace:FindFirstChild("Vehicles")


local accelMultiplier = 1      
local accelEnabled = false     
local originalAttrs = {}       
local lastVehicleRef = nil     


CarModTab:AddSlider({
    Name = "Acceleration Multiplier",
    Min = 1,
    Max = 3, 
    Default = 1,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 0.1,
    ValueName = "x",
    Callback = function(value)
        accelMultiplier = value
    end
})


CarModTab:AddToggle({
    Name = "Enable Accel Multiplier",
    Default = false,
    Callback = function(v)
        accelEnabled = v
        -- si on désactive, restore du véhicule précédemment modifié
        if not accelEnabled and lastVehicleRef then
            pcall(function()
                if originalAttrs[lastVehicleRef] then
                    for attrName, orig in pairs(originalAttrs[lastVehicleRef]) do
                        lastVehicleRef:SetAttribute(attrName, orig)
                    end
                end
            end)
            originalAttrs[lastVehicleRef] = nil
            lastVehicleRef = nil
        end
    end
})


local ATTRS_TO_MULT = {
    "MaxSpeed",
    "ReverseMaxSpeed",
    "MaxAccelerateForce",
    "MaxBrakeForce"
}

local function saveAndApplyAttributes(vehicle, mult)
    if not vehicle then return false end
    originalAttrs[vehicle] = originalAttrs[vehicle] or {}
    local applied = false
    for _, attrName in ipairs(ATTRS_TO_MULT) do
        local val = vehicle:GetAttribute(attrName)
        if val ~= nil then
           
            if originalAttrs[vehicle][attrName] == nil then
                originalAttrs[vehicle][attrName] = val
            end
            
            local newVal = originalAttrs[vehicle][attrName] * mult
            vehicle:SetAttribute(attrName, newVal)
            applied = true
        end
    end
    return applied
end

local function restoreAttributes(vehicle)
    if not vehicle or not originalAttrs[vehicle] then return end
    for attrName, orig in pairs(originalAttrs[vehicle]) do
        pcall(function() vehicle:SetAttribute(attrName, orig) end)
    end
    originalAttrs[vehicle] = nil
end


local function applyVelocityFallback(seat, mult, dt)
    if not seat then return end
    local currentVel = seat.AssemblyLinearVelocity
    local forward = seat.CFrame.LookVector
    local forwardSpeed = forward:Dot(currentVel)

    

    local bonus = 40 * (mult - 1) 
    local targetVel = forward * (math.max(forwardSpeed, 0) + bonus)

  
    local newVel = currentVel:Lerp(targetVel, math.clamp(5 * dt, 0, 1))
    seat.AssemblyLinearVelocity = newVel
end


RunService.Heartbeat:Connect(function(dt)
    if not accelEnabled then return end

   
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    local vehicle = vehiclesFolder and vehiclesFolder:FindFirstChild(player.Name)

    if vehicle and vehicle:IsA("Model") then
        lastVehicleRef = vehicle

        
        local applied = false
        pcall(function() applied = saveAndApplyAttributes(vehicle, accelMultiplier) end)

     
        if applied then
       
            return
        end
    end

    
    if vehicle then
        local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
        if seat and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum.SeatPart == seat and UIS:IsKeyDown(Enum.KeyCode.W) then
           
                pcall(function() applyVelocityFallback(seat, accelMultiplier, dt) end)
            end
        end
    end
end)


workspace.ChildRemoved:Connect(function(child)
    if lastVehicleRef and child == lastVehicleRef then
        restoreAttributes(lastVehicleRef)
        lastVehicleRef = nil
    end
end)


local AutoRobTab = Window:MakeTab({
    Name = "Auto Rob (BETA)",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


isRunning = false
autoSellToggleValue = false
autoServerHop = false
logText = "Logs: Ready"
configFileName = "paradox_config5.json"


function loadConfig()
    if isfile(configFileName) then
        local data = readfile(configFileName)
        local success, config = pcall(function()
            return game:GetService("HttpService"):JSONDecode(data)
        end)
        if success and type(config) == "table" then
            autoSellToggleValue = config.autoSellToggle or false
        end
    end
end

function saveConfig()
    local cfg = {
        autoSellToggle = autoSellToggleValue
    }
    local json = game:GetService("HttpService"):JSONEncode(cfg)
    writefile(configFileName, json)
end

loadConfig()


function setLog(msg)
    logText = "Logs: " .. msg
    OrionLib:MakeNotification({
        Name = "Auto Rob Log",
        Content = msg,
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

Players = game:GetService("Players")
plr = Players.LocalPlayer
ReplicatedStorage = game:GetService("ReplicatedStorage")
TweenService = game:GetService("TweenService")
VirtualInputManager = game:GetService("VirtualInputManager")
HttpService = game:GetService("HttpService")
TeleportService = game:GetService("TeleportService")
ProximityPromptTimeBet = 2.5

function getRemote(guid)
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("8WX"):WaitForChild(guid)
    end)
    if not success then
        warn("Remote not found: " .. guid)
        return nil
    end
    return remote
end
                                        
EquipRemoteEvent = getRemote("40b23e8d-c721-47f8-9170-bbf8e467a35e")
buyRemoteEvent = getRemote("c945bfd5-0319-4bb7-8bfd-5ab218d3efe3")
sellRemoteEvent = getRemote("523be4a6-b3ed-4056-99dd-693827918ec9")
placeBombRemoteEvent = getRemote("ee32a070-689d-44c7-93f4-ff844b2d3cd9")
fireBombRemoteEvent = getRemote("5fe9c567-b320-420d-9c13-e8978db80228")
robRemoteEvent = getRemote("337a4616-007d-4ddf-9e15-cd8bfc9b776e")

function safeCall(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        setLog("Erreur : " .. tostring(err))
    end
    return success
end

function JumpOut()
    local character = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

function ensurePlayerInVehicle()
    local vehicle = workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(plr.Name)
    local character = plr.Character or plr.CharacterAdded:Wait()
    if vehicle and character then
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        local driveSeat = vehicle:FindFirstChild("DriveSeat")
        if humanoid and driveSeat and humanoid.SeatPart ~= driveSeat then
            driveSeat:Sit(humanoid)
        end
    end
end

function clickAtCoordinates(scaleX, scaleY, duration)
    safeCall(function()
        local cam = workspace.CurrentCamera
        local x = cam.ViewportSize.X * scaleX
        local y = cam.ViewportSize.Y * scaleY
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        if duration and duration > 0 then task.wait(duration) end
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
end

function plrTween(destination)
    safeCall(function()
        local character = plr.Character
        if not character or not character.PrimaryPart then return end
        local distance = (character.PrimaryPart.Position - destination).Magnitude
        local tweenDuration = distance / 28
        local info = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

        local cfVal = Instance.new("CFrameValue")
        cfVal.Value = character:GetPivot()
        local conn = cfVal.Changed:Connect(function(cf)
            character:PivotTo(cf)
        end)

        local tween = TweenService:Create(cfVal, info, { Value = CFrame.new(destination) })
        tween:Play()
        tween.Completed:Wait()
        conn:Disconnect()
        cfVal:Destroy()
    end)
end

function tweenTo(destination)
    safeCall(function()
        local car = workspace.Vehicles:FindFirstChild(plr.Name)
        if not car then return end
        car:SetAttribute("ParkingBrake", true)
        car:SetAttribute("Locked", true)
        car.PrimaryPart = car:FindFirstChild("DriveSeat", true)
        local character = plr.Character or plr.CharacterAdded:Wait()
        if car.DriveSeat and character and character:FindFirstChildOfClass("Humanoid") then
            car.DriveSeat:Sit(character:FindFirstChildOfClass("Humanoid"))
        end

        local distance = (car.PrimaryPart.Position - destination).Magnitude
        local tweenDuration = distance / 175
        local info = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

        local cfVal = Instance.new("CFrameValue")
        cfVal.Value = car:GetPivot()
        local conn = cfVal.Changed:Connect(function(cf)
            car:PivotTo(cf)
            car.DriveSeat.AssemblyLinearVelocity = Vector3.new()
            car.DriveSeat.AssemblyAngularVelocity = Vector3.new()
        end)

        local tween = TweenService:Create(cfVal, info, { Value = CFrame.new(destination) })
        tween:Play()
        tween.Completed:Wait()
        car:SetAttribute("ParkingBrake", true)
        car:SetAttribute("Locked", true)
        conn:Disconnect()
        cfVal:Destroy()
    end)
end

function MoveToDealer()
    safeCall(function()
        local vehicle = workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(plr.Name)
        if not vehicle then
            setLog("Error: No vehicle found.")
            return
        end

        local dealers = workspace:FindFirstChild("Dealers")
        if not dealers then
            setLog("Error: Dealers not found.")
            tweenTo(Vector3.new(1656.3526611328125, -25.936052322387695, 2821.137451171875))
            return
        end

        local character = plr.Character or plr.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local closest, dist = nil, math.huge
        for _, d in ipairs(dealers:GetChildren()) do
            local head = d:FindFirstChild("Head")
            if head then
                local cur = (hrp.Position - head.Position).Magnitude
                if cur < dist then
                    dist = cur
                    closest = head
                end
            end
        end

        if not closest then
            setLog("Error: No dealer found.")
            tweenTo(Vector3.new(1656.3526611328125, -25.936052322387695, 2821.137451171875))
            return
        end

        tweenTo(closest.Position + Vector3.new(0, 5, 0))
    end)
end

function checkContainer(container)
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Bomb" then
            return true
        end
    end
    return false
end


PlaceID = game.PlaceId
AllIDs = {}
foundAnything = ""
actualHour = os.time()

do
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile("NotSameServersAutoRob.json"))
    end)
    if ok and type(decoded) == "table" then
        AllIDs = decoded
    else
        AllIDs = { actualHour }
        writefile("NotSameServersAutoRob.json", HttpService:JSONEncode(AllIDs))
    end
end

function TPReturner()
    safeCall(function()
        local url
        if foundAnything == "" then
            url = ('https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100'):format(PlaceID)
        else
            url = ('https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100&cursor=%s'):format(PlaceID, foundAnything)
        end
        local site = HttpService:JSONDecode(game:HttpGet(url))
        if site.nextPageCursor then
            foundAnything = site.nextPageCursor
        end
        for _, v in ipairs(site.data or {}) do
            if tonumber(v.playing) < tonumber(v.maxPlayers) then
                local serverID = tostring(v.id)
                local visited = false
                for _, id in ipairs(AllIDs) do
                    if id == serverID then
                        visited = true
                        break
                    end
                end
                if not visited then
                    table.insert(AllIDs, serverID)
                    writefile("NotSameServersAutoRob.json", HttpService:JSONEncode(AllIDs))
                    TeleportService:TeleportToPlaceInstance(PlaceID, serverID, plr)
                    task.wait(4)
                    return
                end
            end
        end
    end)
end

function ServerHop()
    safeCall(function()
        TPReturner()
        if foundAnything ~= "" then
            TPReturner()
        end
    end)
end

function makePoliceNearbyFn(playerRef)
    local policeTeam = game:GetService("Teams"):FindFirstChild("Police")
    return function()
        if not policeTeam then return false end
        local myChar = playerRef.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return false end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Team == policeTeam and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distance = (hrp.Position - myHRP.Position).Magnitude
                    if distance <= 40 then
                        return true
                    end
                end
            end
        end
        return false
    end
end

function interactWithVisibleMeshParts(folder)
    safeCall(function()
        if not folder then return end
        local player = plr
        local isPoliceNearby = makePoliceNearbyFn(player)

        local meshParts = {}
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("MeshPart") and child.Transparency == 0 then
                table.insert(meshParts, child)
            end
        end

        table.sort(meshParts, function(a, b)
            local posA = (a.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local posB = (b.Position - player.Character.HumanoidRootPart.Position).Magnitude
            return posA < posB
        end)

        for _, meshPart in ipairs(meshParts) do
            if not isRunning then break end
            if isPoliceNearby() then
                setLog("Police is nearby, Interaction aborted")
                return
            end
            if player.Character.Humanoid.Health <= 25 then
                setLog("Player is hurt, Interaction aborted")
                return
            end

            if meshPart.Transparency ~= 1 then
                plrTween(meshPart.Position)
                task.wait(0.5)
                VirtualInputManager:SendKeyEvent(true, "E", false, game)

                local args
                if meshPart.Parent and meshPart.Parent.Name == "Money" then
                    args = { meshPart, "jK5", true }
                else
                    args = { meshPart, "VKN", true }
                end
                if robRemoteEvent then
                    robRemoteEvent:FireServer(unpack(args))
                else
                    setLog("robRemoteEvent missing - Skipped")
                end
                task.wait(ProximityPromptTimeBet)
                args[3] = false
                if robRemoteEvent then
                    robRemoteEvent:FireServer(unpack(args))
                end

                VirtualInputManager:SendKeyEvent(false, "E", false, game)
                task.wait(0.2)
            end
        end
    end)
end





function interactWithVisibleMeshParts2(folder)
    safeCall(function()
        if not folder then return end
        local player = plr
        local isPoliceNearby = makePoliceNearbyFn(player)

        local meshParts = {}
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("MeshPart") and child.Transparency == 0 then
                table.insert(meshParts, child)
            end
        end

        table.sort(meshParts, function(a, b)
            local posA = (a.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local posB = (b.Position - player.Character.HumanoidRootPart.Position).Magnitude
            return posA < posB
        end)

        for _, meshPart in ipairs(meshParts) do
            if not isRunning then break end
            if isPoliceNearby() then
                setLog("Police is nearby, Interaction aborted")
                return
            end
            if player.Character.Humanoid.Health <= 25 then
                setLog("Player is hurt, Interaction aborted")
                return
            end
            if meshPart.Transparency == 1 then
            else
                plrTween(meshPart.Position)
                task.wait(0.5)
                VirtualInputManager:SendKeyEvent(true, "E", false, game)

                local argsTbl
                if meshPart.Parent and meshPart.Parent.Name == "Money" then
                    argsTbl = { meshPart, "jK5", true }
                else
                    argsTbl = { meshPart, "VKN", true }
                end
                if robRemoteEvent then
                    robRemoteEvent:FireServer(unpack(argsTbl))
                else
                    setLog("robRemoteEvent missing - Skipped")
                end
                task.wait(ProximityPromptTimeBet)
                argsTbl[3] = false
                if robRemoteEvent then
                    robRemoteEvent:FireServer(unpack(argsTbl))
                end

                VirtualInputManager:SendKeyEvent(false, "E", false, game)
            end
            task.wait(0.2)
        end
    end)
end


cameraConnection = nil
function resetCamera()
    if cameraConnection then
        cameraConnection:Disconnect()
        cameraConnection = nil
    end
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = plr.Character and plr.Character:FindFirstChild("Humanoid")
end


function runAutoRob()
    if not isRunning then return end
    isRunning = true
    setLog("AutoRob started")
    safeCall(function()
        task.spawn(function()
            local camera = workspace.CurrentCamera
            local function bindCamera()
                if cameraConnection then return end
                local character = plr.Character or plr.CharacterAdded:Wait()
                cameraConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if not isRunning then
                        resetCamera()
                        return
                    end
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local backOffset = root.CFrame.LookVector * -6
                    local cameraPosition = root.Position + backOffset + Vector3.new(0, 5, 0)
                    local lookAtPosition = root.Position + Vector3.new(0, 2, 0)
                    camera.CFrame = CFrame.new(cameraPosition, lookAtPosition)
                end)
            end
            bindCamera()
        end)

        while isRunning do
            task.wait()
            local player = plr
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")

            local musikPos = Vector3.new(-1739.5330810546875, 11, 3052.31103515625)
            local musikStand = Vector3.new(-1744.177001953125, 11.125, 3012.20263671875)
            local musikSafe = Vector3.new(-1743.4300537109375, 11.124999046325684, 3049.96630859375)

            ensurePlayerInVehicle()
            task.wait(0.5)
            clickAtCoordinates(0.5, 0.9)
            task.wait(0.5)
            tweenTo(Vector3.new(-1370.972412109375, 5.499999046325684, 3127.154541015625))

            local musikPart = workspace.Robberies["Club Robbery"].Club.Door.Accessory.Black
            local bankLight = workspace.Robberies.BankRobbery.LightGreen.Light
            local bankLight2 = workspace.Robberies.BankRobbery.LightRed.Light

          
            if musikPart.Rotation == Vector3.new(180, 0, 180) then
                clickAtCoordinates(0.5, 0.9)
                setLog("Safe is open, Going to rob")

                local hasBomb = checkContainer(plr.Backpack) or checkContainer(plr.Character)
                if not hasBomb then
                    ensurePlayerInVehicle()
                    task.wait(0.5)
                    MoveToDealer()
                    task.wait(0.5)
                    MoveToDealer()
                    task.wait(0.5)
                    if buyRemoteEvent then
                        buyRemoteEvent:FireServer(unpack({ "Bomb", "Dealer" }))
                    else
                        setLog("buyRemoteEvent missing - Skipped")
                    end
                    task.wait(0.5)
                end

                ensurePlayerInVehicle()
                task.wait(0.5)
                tweenTo(musikPos)
                task.wait(0.5)
                JumpOut()
                task.wait(0.5)

                if EquipRemoteEvent then
                    EquipRemoteEvent:FireServer(unpack({ "Bomb" }))
                else
                    setLog("EquipRemoteEvent missing - Skipped")
                end
                task.wait(0.5)
                plrTween(musikStand)
                task.wait(0.5)

                local tool = plr.Character and plr.Character:FindFirstChild("Bomb")
                if tool and placeBombRemoteEvent then
                    local cam = workspace.CurrentCamera
                    local x = cam.ViewportSize.X * 0.5
                    local y = cam.ViewportSize.Y * 0.5
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 0)
                    task.wait(0.3)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 0)
                    task.wait(0.1)

                    local success = safeCall(function()
                        placeBombRemoteEvent:FireServer(unpack({ tool }))
                    end)
                    if not success then
                        setLog("Bomb placing failed, Aborting AutoRob")
                        isRunning = false
                        return
                    end
                    setLog("Bomb placed, Waiting to detonate")
                    task.wait(0.5)
                    if fireBombRemoteEvent then
                        fireBombRemoteEvent:FireServer()
                        setLog("Bomb detonated, Proceeding")
                    else
                        setLog("fireBombRemoteEvent missing - Skipped")
                    end
                else
                    setLog("Tool 'Bomb' or placeBombRemoteEvent missing - Aborting AutoRob")
                    isRunning = false
                    return
                end

                plrTween(musikSafe)
                task.wait(1.8)
                plrTween(musikStand)

                local safeFolder = workspace.Robberies["Club Robbery"].Club
                interactWithVisibleMeshParts(safeFolder:FindFirstChild("Items"))
                interactWithVisibleMeshParts(safeFolder:FindFirstChild("Money"))
                task.wait(0.5)

                ensurePlayerInVehicle()
                if autoSellToggleValue then
                    ensurePlayerInVehicle()
                    MoveToDealer()
                    task.wait(0.5)
                    local sellArgs = { "Gold", "Dealer" }
                    if sellRemoteEvent then
                        sellRemoteEvent:FireServer(unpack(sellArgs))
                        sellRemoteEvent:FireServer(unpack(sellArgs))
                        sellRemoteEvent:FireServer(unpack(sellArgs))
                    else
                        setLog("sellRemoteEvent missing - Skipped")
                    end
                    tweenTo(Vector3.new(-1370.972412109375, 5.499999046325684, 3127.154541015625))
                end

                ensurePlayerInVehicle()
                tweenTo(Vector3.new(-1370.972412109375, 5.499999046325684, 3127.154541015625))
            else
                setLog("Safe is not open, Leave or wait for cooldown")
            end

         
            if (not bankLight2.Enabled) and bankLight.Enabled then
                clickAtCoordinates(0.5, 0.9)
                setLog("Bank is open, Going to rob")

                ensurePlayerInVehicle()
                local hasBomb2 = checkContainer(plr.Backpack) or checkContainer(plr.Character)
                if not hasBomb2 then
                    ensurePlayerInVehicle()
                    task.wait(0.5)
                    MoveToDealer()
                    task.wait(0.5)
                    MoveToDealer()
                    task.wait(0.5)
                    if buyRemoteEvent then
                        buyRemoteEvent:FireServer(unpack({ "Bomb", "Dealer" }))
                    else
                        setLog("buyRemoteEvent missing - Skipped")
                    end
                    task.wait(0.5)
                end

                tweenTo(Vector3.new(-1202.86181640625, 7.877995491027832, 3164.614501953125))
                tweenTo(Vector3.new(-1202.86181640625, 7.877995491027832, 3164.614501953125))
                JumpOut()
                task.wait(0.5)

                plrTween(Vector3.new(-1242.367919921875, 7.749999046325684, 3144.705322265625))
                task.wait(0.5)
                if EquipRemoteEvent then
                    EquipRemoteEvent:FireServer(unpack({ "Bomb" }))
                else
                    setLog("EquipRemoteEvent missing - Skipped")
                end
                task.wait(0.5)

                local tool2 = plr.Character and plr.Character:FindFirstChild("Bomb")
                if tool2 and placeBombRemoteEvent then
                    local cam = workspace.CurrentCamera
                    local x = cam.ViewportSize.X * 0.5
                    local y = cam.ViewportSize.Y * 0.5
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 0)
                    task.wait(0.3)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 0)
                    task.wait(0.1)

                    local success = safeCall(function()
                        placeBombRemoteEvent:FireServer(unpack({ tool2 }))
                    end)
                    if not success then
                        setLog("Bomb placing failed, Aborting AutoRob")
                        isRunning = false
                        return
                    end
                    setLog("Bomb placed, Waiting to detonate")
                    task.wait(0.5)
                    if fireBombRemoteEvent then
                        fireBombRemoteEvent:FireServer()
                        setLog("Bomb detonated, Proceeding")
                    else
                        setLog("fireBombRemoteEvent missing - Skipped")
                    end
                else
                    setLog("Tool 'Bomb' or placeBombRemoteEvent missing - Aborting AutoRob")
                    isRunning = false
                    return
                end

                plrTween(Vector3.new(-1246.291015625, 7.749999046325684, 3120.8505859375))
                task.wait(2.5)

                local safeFolder2 = workspace.Robberies.BankRobbery
                interactWithVisibleMeshParts2(safeFolder2:FindFirstChild("Gold"))
                interactWithVisibleMeshParts2(safeFolder2:FindFirstChild("Gold"))
                interactWithVisibleMeshParts2(safeFolder2:FindFirstChild("Money"))
                interactWithVisibleMeshParts2(safeFolder2:FindFirstChild("Money"))

                ensurePlayerInVehicle()
                if autoSellToggleValue then
                    task.wait(0.5)
                    MoveToDealer()
                    task.wait(0.5)
                    MoveToDealer()
                    task.wait(0.5)
                    local sellArgs2 = { "Gold", "Dealer" }
                    if sellRemoteEvent then
                        sellRemoteEvent:FireServer(unpack(sellArgs2))
                        sellRemoteEvent:FireServer(unpack(sellArgs2))
                        sellRemoteEvent:FireServer(unpack(sellArgs2))
                    else
                        setLog("sellRemoteEvent missing - Skipped")
                    end
                    task.wait(0.5)
                end
            else
                setLog("Bank is not open, Leave or wait for cooldown")
            end

      
            tweenTo(Vector3.new(1058.7470703125, 5.733738899230957, 2218.6943359375))
            task.wait(0.5)

            local containerFolder = workspace.Robberies.ContainerRobberies
            local containers = {}
            for _, m in ipairs(containerFolder:GetChildren()) do
                if m.Name == "ContainerRobbery" then
                    table.insert(containers, m)
                end
            end
            local container1 = containers[1]
            local container2 = containers[2]
            local con1Planks = container1 and container1:FindFirstChild("WoodPlanks", true)
            local con2Planks = container2 and container2:FindFirstChild("WoodPlanks", true)

            if con1Planks and con1Planks.Transparency == 1 then
                ensurePlayerInVehicle()
                task.wait(0.5)
                MoveToDealer()
                task.wait(0.5)
                if buyRemoteEvent then
                    buyRemoteEvent:FireServer(unpack({ "Bomb", "Dealer" }))
                else
                    setLog("buyRemoteEvent missing - Skipped")
                end
                task.wait(0.5)
                tweenTo(con1Planks.Position)
                tweenTo(con1Planks.Position)
                task.wait(0.5)
                JumpOut()
                task.wait(0.5)
                plrTween(con1Planks.Position)
                task.wait(0.5)
                if EquipRemoteEvent then
                    EquipRemoteEvent:FireServer(unpack({ "Bomb" }))
                else
                    setLog("EquipRemoteEvent missing - Skipped")
                end
                task.wait(0.5)
                local tool3 = plr.Character and plr.Character:FindFirstChild("Bomb")
                if tool3 and placeBombRemoteEvent then
                    local cam = workspace.CurrentCamera
                    local x = cam.ViewportSize.X * 0.5
                    local y = cam.ViewportSize.Y * 0.5
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 0)
                    task.wait(0.3)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 0)
                    task.wait(0.1)

                    local success = safeCall(function()
                        placeBombRemoteEvent:FireServer(unpack({ tool3 }))
                    end)
                    if not success then
                        setLog("Bomb placing failed, Aborting AutoRob")
                        isRunning = false
                        return
                    end
                    setLog("Bomb placed, Waiting to detonate")
                    task.wait(0.5)
                    if fireBombRemoteEvent then
                        fireBombRemoteEvent:FireServer()
                        setLog("Bomb detonated, Proceeding")
                    else
                        setLog("fireBombRemoteEvent missing - Skipped")
                    end
                else
                    setLog("Tool 'Bomb' or placeBombRemoteEvent missing - Aborting AutoRob")
                    isRunning = false
                    return
                end
                ensurePlayerInVehicle()
                tweenTo(Vector3.new(1096.401, 57.31, 2226.765))
                task.wait(2)
                tweenTo(con1Planks.Position)
                JumpOut()
                task.wait(0.5)
                plrTween(con1Planks.Position)
                interactWithVisibleMeshParts2(container1:FindFirstChild("Items"))
                interactWithVisibleMeshParts2(container1:FindFirstChild("Items"))
                interactWithVisibleMeshParts2(container1:FindFirstChild("Money"))
                interactWithVisibleMeshParts2(container1:FindFirstChild("Money"))
                task.wait(0.2)
                ensurePlayerInVehicle()
                task.wait(0.2)
                tweenTo(Vector3.new(1096.401, 57.31, 2226.765))
            else
                setLog("Container1 not open, Leave or wait for cooldown")
            end

            if con2Planks and con2Planks.Transparency == 1 then
                ensurePlayerInVehicle()
                task.wait(0.5)
                MoveToDealer()
                task.wait(0.5)
                if buyRemoteEvent then
                    buyRemoteEvent:FireServer(unpack({ "Bomb", "Dealer" }))
                else
                    setLog("buyRemoteEvent missing - Skipped")
                end
                task.wait(0.5)
                tweenTo(con2Planks.Position)
                task.wait(0.5)
                JumpOut()
                task.wait(0.5)
                plrTween(con2Planks.Position)
                task.wait(0.5)
                if EquipRemoteEvent then
                    EquipRemoteEvent:FireServer(unpack({ "Bomb" }))
                else
                    setLog("EquipRemoteEvent missing - Skipped")
                end
                task.wait(0.5)
                local tool4 = plr.Character and plr.Character:FindFirstChild("Bomb")
                if tool4 and placeBombRemoteEvent then
                    local cam = workspace.CurrentCamera
                    local x = cam.ViewportSize.X * 0.5
                    local y = cam.ViewportSize.Y * 0.5
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 0)
                    task.wait(0.3)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 0)
                    task.wait(0.1)

                    local success = safeCall(function()
                        placeBombRemoteEvent:FireServer(unpack({ tool4 }))
                    end)
                    if not success then
                        setLog("Bomb placing failed, Aborting AutoRob")
                        isRunning = false
                        return
                    end
                    setLog("Bomb placed, Waiting to detonate")
                    task.wait(0.5)
                    if fireBombRemoteEvent then
                        fireBombRemoteEvent:FireServer()
                        setLog("Bomb detonated, Proceeding")
                    else
                        setLog("fireBombRemoteEvent missing - Skipped")
                    end
                else
                    setLog("Tool 'Bomb' or placeBombRemoteEvent missing - Aborting AutoRob")
                    isRunning = false
                    return
                end
                ensurePlayerInVehicle()
                tweenTo(Vector3.new(1096.401, 57.31, 2226.765))
                task.wait(2)
                tweenTo(con2Planks.Position)
                JumpOut()
                task.wait(0.5)
                plrTween(con2Planks.Position)
                interactWithVisibleMeshParts2(container2:FindFirstChild("Items"))
                interactWithVisibleMeshParts2(container2:FindFirstChild("Items"))
                interactWithVisibleMeshParts2(container2:FindFirstChild("Money"))
                interactWithVisibleMeshParts2(container2:FindFirstChild("Money"))
                task.wait(0.5)
                ensurePlayerInVehicle()
                tweenTo(Vector3.new(1656.3526611328125, -25.936052322387695, 2821.137451171875))
                if autoServerHop then
                    ServerHop()
                end
            else
                setLog("Container2 not open, Leave or wait for cooldown")
            end

            local anyRobberyAvailable = (musikPart.Rotation == Vector3.new(180, 0, 180)) or 
                                      ((not bankLight2.Enabled) and bankLight.Enabled)
            
            if not anyRobberyAvailable and autoServerHop then
                setLog("No robberies available, Server hopping...")
                task.wait(2)
                ServerHop()
            end

            task.wait(5)
        end
    end)
end


AutoRobTab:AddButton({
    Name = "Start Auto Rob",
    Callback = function()
        if not isRunning then
            isRunning = true
            setLog("AutoRob  Starting")
            task.spawn(runAutoRob)
        else
            setLog("Already  !")
        end
    end
})

AutoRobTab:AddButton({
    Name = "Stop Auto rob",
    Callback = function()
        if isRunning then
            isRunning = false
            setLog("AutoRob end")
            resetCamera()
        else
            setLog("Already arrested! ")
        end
    end
})

AutoRobTab:AddToggle({
    Name = "Auto-Sell",
    Default = autoSellToggleValue,
    Callback = function(Value)
        autoSellToggleValue = Value
        setLog("Auto-Sell: " .. (autoSellToggleValue and "ON" or "OFF"))
        saveConfig()
    end
})

AutoRobTab:AddToggle({
    Name = "Auto Server Hop",
    Default = autoServerHop,
    Callback = function(Value)
        autoServerHop = Value
        setLog("Auto Server Hop: " .. (autoServerHop and "ON" or "OFF"))
    end
})

AutoRobTab:AddParagraph("Logs", logText)



local VisualTab = Window:MakeTab({
    Name = "Esp",
    Icon = "rbxassetid://3926305904",
    PremiumOnly = false
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


local ESPEnabled = false
local ESPSettings = {
    ShowName = false,
    ShowUsername = false,
    ShowDistance = false,
    ShowTeam = false,
    ESPColor = Color3.fromRGB(150,150,150), -- Gris
    TextSize = 20,
    MaxDistance = 100
}


local function getESPText(plr)
    local text = ""
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return "" end
    if ESPSettings.ShowName then text = text .. plr.DisplayName .. " " end
    if ESPSettings.ShowUsername then text = text .. "(" .. plr.Name .. ") " end
    if ESPSettings.ShowDistance then
        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
        text = text .. "["..math.floor(dist).."m] "
    end
    if ESPSettings.ShowTeam and plr.Team and plr.Team.Name then
        text = text .. "["..plr.Team.Name.."] "
    end
    return text
end


local function getBillboard(head)
    local bb = head:FindFirstChild("ESP_BB")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "ESP_BB"
        bb.Size = UDim2.new(0, 200, 0, ESPSettings.TextSize)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 2, 0)
        bb.Parent = head

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "ESP_Text"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextStrokeTransparency = 0.6
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.Parent = bb
    end
    return bb
end


local function adjustOffset(plr, index)
    local char = plr.Character
    if char and char:FindFirstChild("Head") then
        local bb = getBillboard(char.Head)
        bb.StudsOffset = Vector3.new(0, 2 + index * 0.5, 0)
    end
end


RunService.RenderStepped:Connect(function()
    if not ESPEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local bb = plr.Character.Head:FindFirstChild("ESP_BB")
                if bb then bb:Destroy() end
            end
        end
        return
    end

    local indexCounter = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
            if dist <= ESPSettings.MaxDistance then
                local bb = getBillboard(head)
                local label = bb.ESP_Text
                label.Text = getESPText(plr)
                label.TextColor3 = ESPSettings.ESPColor
                label.TextSize = ESPSettings.TextSize

               
                local key = math.floor(head.Position.X*10).."_"..math.floor(head.Position.Z*10)
                indexCounter[key] = (indexCounter[key] or 0) + 1
                adjustOffset(plr, indexCounter[key])
            else
                local bb = head:FindFirstChild("ESP_BB")
                if bb then bb:Destroy() end
            end
        end
    end
end)


VisualTab:AddToggle({ Name = "Enable ESP", Default = false, Callback = function(v) ESPEnabled = v end })
VisualTab:AddToggle({ Name = "Show Nametag", Default = false, Callback = function(v) ESPSettings.ShowName = v end })
VisualTab:AddToggle({ Name = "Show Username", Default = false, Callback = function(v) ESPSettings.ShowUsername = v end })
VisualTab:AddToggle({ Name = "Show Distance", Default = false, Callback = function(v) ESPSettings.ShowDistance = v end })
VisualTab:AddToggle({ Name = "Show Team", Default = false, Callback = function(v) ESPSettings.ShowTeam = v end })


VisualTab:AddSlider({
    Name = "ESP Text Size",
    Min = 10,
    Max = 40,
    Default = ESPSettings.TextSize,
    Callback = function(v) ESPSettings.TextSize = v end
})


VisualTab:AddSlider({
    Name = "Max ESP Distance",
    Min = 10,
    Max = 500,
    Default = ESPSettings.MaxDistance,
    Callback = function(v) ESPSettings.MaxDistance = v end
})



local AimbotTab = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://3926305904",
    PremiumOnly = false
})


local AimbotEnabled = false
local AimPart = "Head"              
local AimbotFOV = 100
local AimbotSmoothnessUI = 5         
local AimbotSmoothness = AimbotSmoothnessUI / 10 
local AimbotMaxDistance = 500
local AimbotKey = Enum.KeyCode.L
local FOVCircleVisible = true
local PredictionEnabled = false
local PredictionFactor = 0.0575


local MobileAimbotEnabled = false
local aimbotGui, aimbotButton

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = AimbotFOV
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 1.5
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Position = UserInputService:GetMouseLocation()


AimbotTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(val)
        AimbotEnabled = val
        FOVCircle.Visible = AimbotEnabled and FOVCircleVisible
    end
})

AimbotTab:AddToggle({
    Name = "Mobile Aimbot",
    Default = false,
    Callback = function(val)
        MobileAimbotEnabled = val
        if MobileAimbotEnabled then
            
            if not aimbotGui then
                aimbotGui = Instance.new("ScreenGui")
                aimbotGui.Name = "MobileAimbotGui"
                aimbotGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

                aimbotButton = Instance.new("TextButton")
                aimbotButton.Size = UDim2.new(0, 200, 0, 50)
                aimbotButton.Position = UDim2.new(0.5, -100, 0.8, 0)
                aimbotButton.Text = "Aimbot: OFF"
                aimbotButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                aimbotButton.TextColor3 = Color3.fromRGB(255,255,255)
                aimbotButton.Font = Enum.Font.SourceSans
                aimbotButton.TextSize = 20
                aimbotButton.Parent = aimbotGui
                Instance.new("UICorner", aimbotButton)

                aimbotButton.MouseButton1Click:Connect(function()
                    AimbotEnabled = not AimbotEnabled
                    if AimbotEnabled then
                        aimbotButton.Text = "Aimbot: ON"
                        aimbotButton.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    else
                        aimbotButton.Text = "Aimbot: OFF"
                        aimbotButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
                    end
                    FOVCircle.Visible = AimbotEnabled and FOVCircleVisible
                end)

         
                local dragging, dragStart, startPos = false, nil, nil
                aimbotButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        dragStart = input.Position
                        startPos = aimbotButton.Position
                    end
                end)
                aimbotButton.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local delta = input.Position - dragStart
                        aimbotButton.Position = UDim2.new(
                            startPos.X.Scale,
                            startPos.X.Offset + delta.X,
                            startPos.Y.Scale,
                            startPos.Y.Offset + delta.Y
                        )
                    end
                end)
                aimbotButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
            end
        else
           
            if aimbotGui then
                aimbotGui:Destroy()
                aimbotGui = nil
                aimbotButton = nil
            end
        end
    end
})

AimbotTab:AddBind({
    Name = "Aimbot Key",
    Default = AimbotKey,
    Hold = false,
    Callback = function()
        AimbotEnabled = not AimbotEnabled
        FOVCircle.Visible = AimbotEnabled and FOVCircleVisible
    end
})

AimbotTab:AddDropdown({
    Name = "Aim Part",
    Default = "Head",
    Options = {"Head", "HumanoidRootPart"},
    Callback = function(value)
        AimPart = value
    end
})

AimbotTab:AddSlider({
    Name = "FOV Size",
    Min = 10,
    Max = 300,
    Default = AimbotFOV,
    Callback = function(value)
        AimbotFOV = value
        FOVCircle.Radius = value
    end
})

AimbotTab:AddColorpicker({
    Name = "FOV Color",
    Default = Color3.fromRGB(255,0,0),
    Callback = function(value)
        FOVCircle.Color = value
    end
})

AimbotTab:AddToggle({
    Name = "Show FOV",
    Default = FOVCircleVisible,
    Callback = function(value)
        FOVCircleVisible = value
        FOVCircle.Visible = AimbotEnabled and value
    end
})

AimbotTab:AddSlider({
    Name = "Max Distance",
    Min = 10,
    Max = 2000,
    Default = AimbotMaxDistance,
    Callback = function(value)
        AimbotMaxDistance = value
    end
})

AimbotTab:AddSlider({
    Name = "Smoothness (1=slow / 10=fast)",
    Min = 1,
    Max = 10,
    Default = AimbotSmoothnessUI,
    Increment = 1,
    Callback = function(value)
        AimbotSmoothnessUI = value
        AimbotSmoothness = math.clamp(value / 10, 0.01, 1)
    end
})

AimbotTab:AddToggle({
    Name = "Prediction",
    Default = PredictionEnabled,
    Callback = function(value)
        PredictionEnabled = value
    end
})

AimbotTab:AddSlider({
    Name = "Prediction Factor",
    Min = 0,
    Max = 0.5,
    Default = PredictionFactor,
    Increment = 0.005,
    Callback = function(value)
        PredictionFactor = value
    end
})


local function get_target_part(char)
    if not char then return nil end
    return char:FindFirstChild(AimPart) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function get_predicted_position(part)
    if not part then return nil end
    if not PredictionEnabled then return part.Position end
    local vel = part.Velocity or Vector3.new(0,0,0)
    local predict = Vector3.new(vel.X, math.clamp(vel.Y * 0.5, -5, 10), vel.Z) * PredictionFactor
    return part.Position + predict
end

local function GetClosestPlayer()
    local closest = nil
    local shortestDist = AimbotFOV
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character.Parent then
            local targetPart = get_target_part(plr.Character)
            if targetPart then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    local mag = (plr.Character.HumanoidRootPart.Position - localRoot.Position).Magnitude
                    if dist <= shortestDist and mag <= AimbotMaxDistance then
                        shortestDist = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end


RunService:BindToRenderStep("AimbotRenderStep", Enum.RenderPriority.Camera.Value + 1, function(delta)

    if FOVCircle then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = AimbotFOV
    end

    if not AimbotEnabled then return end
    if not LocalPlayer or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local targetPlayer = GetClosestPlayer()
    if not targetPlayer or not targetPlayer.Character then return end

    local targetPart = get_target_part(targetPlayer.Character)
    if not targetPart then return end

    local aimPos = get_predicted_position(targetPart)
    if not aimPos then return end

    local camPos = Camera.CFrame.Position
    local desiredCFrame = CFrame.new(camPos, aimPos)


    local alpha = AimbotSmoothness
    local lerpAlpha = math.clamp(alpha * math.clamp(delta * 60, 0.01, 1), 0.01, 1)

    Camera.CFrame = Camera.CFrame:Lerp(desiredCFrame, lerpAlpha)
end)

-- Cleanup on script disable/unload (optional)
local function cleanupAimbot()
    if FOVCircle and FOVCircle.Visible then
        FOVCircle.Visible = false
    end
    if aimbotGui then
        aimbotGui:Destroy()
        aimbotGui = nil
        aimbotButton = nil
    end
  
    pcall(function() RunService:UnbindFromRenderStep("AimbotRenderStep") end)
end

_G.MyAimbot = {
    Enable = function() AimbotEnabled = true; FOVCircle.Visible = FOVCircleVisible end,
    Disable = function() AimbotEnabled = false; FOVCircle.Visible = false end,
    Cleanup = cleanupAimbot
}

    
    local TeleportsTab = Window:MakeTab({
        Name = "Teleport",
        Icon = "rbxassetid://3926305904",
        PremiumOnly = false
    })

  
    local function moveCarToTarget(destination)
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local LocalPlayer = Players.LocalPlayer
        local VehiclesFolder = workspace:WaitForChild("Vehicles")

        local car = VehiclesFolder:FindFirstChild(LocalPlayer.Name)
        if not car then
            warn("No car found")
            return
        end

        local driveSeat = car:FindFirstChild("DriveSeat", true)
        if not driveSeat then
            warn("No DriveSeat found")
            return
        end

        car.PrimaryPart = driveSeat
        driveSeat:Sit(LocalPlayer.Character:WaitForChild("Humanoid"))

        local function moveTo(target)
            local dist = (car.PrimaryPart.Position - target).Magnitude
            local time = dist / 175
            local info = TweenInfo.new(time, Enum.EasingStyle.Linear)
            local cfVal = Instance.new("CFrameValue")
            cfVal.Value = car:GetPivot()

            cfVal.Changed:Connect(function(cf)
                car:PivotTo(cf)
                driveSeat.AssemblyLinearVelocity = Vector3.zero
                driveSeat.AssemblyAngularVelocity = Vector3.zero
            end)

            local tween = TweenService:Create(cfVal, info, { Value = CFrame.new(target) })
            tween:Play()
            tween.Completed:Wait()
            cfVal:Destroy()
        end

        local start = car.PrimaryPart.Position
        moveTo(start + Vector3.new(0, -5, 0))
        moveTo(destination + Vector3.new(0, -5, 0))
        moveTo(destination)
    end


    TeleportsTab:AddButton({
        Name = "Teleport to Nearest Dealer",
        Callback = function()
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local dealers = workspace:FindFirstChild("Dealers")
            if not dealers then return end

            local closest, shortest = nil, math.huge
            for _, dealer in pairs(dealers:GetChildren()) do
                if dealer:FindFirstChild("Head") then
                    local dist = (character.HumanoidRootPart.Position - dealer.Head.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = dealer.Head
                    end
                end
            end
            if closest then
                moveCarToTarget(closest.Position + Vector3.new(0, 5, 0))
            end
        end
    })

    
    TeleportsTab:AddButton({
        Name = "Teleport to Robbable Vending Machine",
        Callback = function()
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local machines = workspace:FindFirstChild("Robberies") and workspace.Robberies:FindFirstChild("VendingMachines")
            if not machines then return end

            local closest, shortest = nil, math.huge
            for _, model in pairs(machines:GetChildren()) do
                for _, part in pairs(model:GetChildren()) do
                    if part:IsA("Part") and part.Color == Color3.fromRGB(73, 147, 0) then
                        local dist = (character.HumanoidRootPart.Position - part.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = part
                        end
                    end
                end
            end

            if closest then
                moveCarToTarget(closest.Position)
            else
                OrionLib:MakeNotification({
                    Name = "Not Found",
                    Content = "Robbable Vending Machine not found!",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    })
    
   
    TeleportsTab:AddButton({ Name = "Teleport to Bank", Callback = function() moveCarToTarget(Vector3.new(-1166.91, 5.86, 3190.407)) end })
 
    TeleportsTab:AddButton({ Name = "Teleport to Jewel Store", Callback = function() moveCarToTarget(Vector3.new(-427.862, 49.628, 3500.895)) end })

    TeleportsTab:AddButton({ Name = "Teleport to Club", Callback = function() moveCarToTarget(Vector3.new(-1865.73, 5.63, 3015.14)) end })
  
    TeleportsTab:AddButton({ Name = "Teleport to Farm Shop", Callback = function() moveCarToTarget(Vector3.new(-904.34, 5.35, -1167.26)) end })
  
    TeleportsTab:AddButton({ Name = "Teleport to Gas-N-Go", Callback = function() moveCarToTarget(Vector3.new(-1543.59, 5.82, 3799.58)) end })

    TeleportsTab:AddButton({ Name = "Teleport to Ares Gas Station", Callback = function() moveCarToTarget(Vector3.new(-865.29, 5.61, 1509.46)) end })
    
    TeleportsTab:AddButton({ Name = "Teleport to Osso", Callback = function() moveCarToTarget(Vector3.new(-35.25, 5.71, -761.23)) end })
    
    TeleportsTab:AddButton({ Name = "Teleport to Green Container", Callback = function() moveCarToTarget(Vector3.new(1164.07, 29.16, 2152.81)) end })
 
    TeleportsTab:AddButton({ Name = "Teleport to Golden Container", Callback = function() moveCarToTarget(Vector3.new(1125.94, 29.16, 2331.82)) end })
   
    TeleportsTab:AddButton({ Name = "Teleport to ADAC", Callback = function() moveCarToTarget(Vector3.new(-152.12, 5.52, 452.47)) end })
    
    TeleportsTab:AddButton({ Name = "Teleport to Tuning", Callback = function() moveCarToTarget(Vector3.new(-1372.408, 5.656, 170.811)) end })
   
    TeleportsTab:AddButton({ Name = "Teleport to Hospital", Callback = function() moveCarToTarget(Vector3.new(-288.187, 5.787, 1121.457)) end })
 
    TeleportsTab:AddButton({ Name = "Teleport to Police Station", Callback = function() moveCarToTarget(Vector3.new(-1674.341, 5.807, 2746.140)) end })
    
    TeleportsTab:AddButton({ Name = "Teleport to Fire Department", Callback = function() moveCarToTarget(Vector3.new(-1674.341, 5.807, 2746.140)) end })
    
    TeleportsTab:AddButton({ Name = "Teleport to Car Dealer", Callback = function() moveCarToTarget(Vector3.new(-1390.604, 5.615, 941.208)) end })
   
    TeleportsTab:AddButton({ Name = "Teleport to Car Bus Company", Callback = function() moveCarToTarget(Vector3.new(-1680.241, 5.618, -1278.784)) end })
 
    TeleportsTab:AddButton({ Name = "Teleport to Clothing Store", Callback = function() moveCarToTarget(Vector3.new(-1680.241, 5.618, -1278.784)) end })
    
    TeleportsTab:AddButton({ Name = "Teleport to Prison", Callback = function() moveCarToTarget(Vector3.new(-566.475, 5.810, 2851.558)) end })
    
    TeleportsTab:AddButton({ Name = "Teleport inside Prison", Callback = function() moveCarToTarget(Vector3.new(-606.739, 5.490, 3049.082)) end })

    TeleportsTab:AddLabel("Notes:You can get kick ")



    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    local clickTPEnabled = false

    MiscTab:AddButton({
        Name = "Click TP (CTRL + Click)",
        Callback = function()
            clickTPEnabled = not clickTPEnabled
            OrionLib:MakeNotification({
                Name = "Click TP",
                Content = clickTPEnabled and "On" or "OFF",
                Time = 2
            })
        end
    })


    Mouse.Button1Down:Connect(function()
        if clickTPEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            if Mouse.Target then
                LocalPlayer.Character:MoveTo(Mouse.Hit.p + Vector3.new(0,3,0))
            end
        end
    end)

  



MiscTab:AddToggle({
    Name = "Fake Death",
    Default = false,
    Callback = function(state)
        local character = game.Players.LocalPlayer.Character
        if character then
            character:SetAttribute("Tased", state)
        end
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local autoCloot = false
local holdingConnection = nil

local function toggleAutoCloot(state)
    autoCloot = state

    if autoCloot then
        if holdingConnection then
            holdingConnection:Disconnect()
        end

        holdingConnection = RunService.Heartbeat:Connect(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        end)

    else
        if holdingConnection then
            holdingConnection:Disconnect()
            holdingConnection = nil
        end
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

MiscTab:AddToggle({
    Name = "Auto Collect",
    Default = false,
    Callback = function(Value)
        toggleAutoCloot(Value)
    end    
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local AntiArrestEnabled = false
local moving = false
local lastSafeTime = tick()
local originalPosition = nil
local vehicleInUse = nil

MiscTab:AddToggle({
    Name = "Anti Arrest",
    Default = false,
    Callback = function(state)
        AntiArrestEnabled = state
        if not state then
            moving = false
            originalPosition = nil
            vehicleInUse = nil
        end
    end
})

local function getVehicle()
    local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
    if vehiclesFolder then
        local vehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
        if vehicle and vehicle:IsA("Model") then
            return vehicle
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(LocalPlayer.Name:lower()) then
            return obj
        end
    end

    return nil
end

local function getNearbyPolice(radius)
    local nearby = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team and player.Team.Name:lower():find("police") then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and myRoot then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist <= radius then
                    table.insert(nearby, player)
                end
            end
        end
    end
    return nearby
end

local function enterVehicle(vehicle)
    if not vehicle then return end
    local seat = nil

    for _, part in pairs(vehicle:GetDescendants()) do
        if part:IsA("VehicleSeat") or part:IsA("Seat") then
            seat = part
            break
        end
    end

    if seat then
        seat:Sit(LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    end
end

local function moveCarToTarget(vehicle, targetPosition)
    if not vehicle or not vehicle.PrimaryPart then return end
    if moving then return end
    moving = true

    local speed = 15
    local direction = (targetPosition - vehicle.PrimaryPart.Position).Unit

    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not AntiArrestEnabled then
            connection:Disconnect()
            moving = false      
            return
        end

        local step = direction * speed * dt
        local newPos = vehicle.PrimaryPart.Position + step
        local distanceLeft = (targetPosition - newPos).Magnitude

        if distanceLeft <= 2 then
            vehicle:SetPrimaryPartCFrame(CFrame.new(targetPosition))
            connection:Disconnect()
            moving = false
        else
            vehicle:SetPrimaryPartCFrame(CFrame.new(newPos))
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not AntiArrestEnabled then return end

    local policeNearby = getNearbyPolice(50)
    local vehicle = getVehicle()

    if vehicle and vehicle.PrimaryPart then
        if not vehicleInUse then
            vehicleInUse = vehicle
            originalPosition = vehicle.PrimaryPart.Position
        end

        enterVehicle(vehicle)

        if #policeNearby > 0 then
            lastSafeTime = tick()

            local avgPos = Vector3.new(0, 0, 0)
            local count = 0
            for _, cop in pairs(policeNearby) do
                local root = cop.Character and cop.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    avgPos += root.Position
                    count += 1
                end
            end

            if count > 0 then
                avgPos /= count
                local currentPos = vehicle.PrimaryPart.Position
                local directionAway = (currentPos - avgPos).Unit
                local safeDistance = 80
                local targetPos = currentPos + directionAway * safeDistance

                moveCarToTarget(vehicle, targetPos)
            end
        else
            if tick() - lastSafeTime > 5 and originalPosition then
                moveCarToTarget(vehicle, originalPosition)
                originalPosition = nil
                vehicleInUse = nil
            end
        end
    end
end)

local SafetyTab = Window:MakeTab({
    Name = "Safety",
    Icon = "rbxassetid://3926305904",
    PremiumOnly = false
})


local carSpeed = 150
SafetyTab:AddSlider({
    Name = "Car Speed (For the self revive)",
    Min = 50,
    Max =  175,
    Default = 150,
    Callback = function(v)
        carSpeed = v
    end
})






local HOSPITAL_POS = Vector3.new(-120.30, 5.61, 1077.29)


local function findHospitalSeat()
    local b = workspace:FindFirstChild("Buildings")
    if not b then return nil end
    local hosp = b:FindFirstChild("Hospital")
    if not hosp then return nil end
    local bed = hosp:FindFirstChild("HospitalBed")
    if not bed then return nil end
    return bed:FindFirstChild("Seat")
end


local function getMyCar()
    local vf = workspace:FindFirstChild("Vehicles")
    if not vf then return nil end
    return vf:FindFirstChild(LocalPlayer.Name)
end


local function ensureSit(seat, humanoid)
    if not seat or not humanoid then return false end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
        hrp.AssemblyLinearVelocity = Vector3.new()
        hrp.AssemblyAngularVelocity = Vector3.new()
    end
    for _ = 1, 10 do
        seat:Sit(humanoid)
        task.wait(0.12)
        if humanoid.Sit then return true end
    end
    return humanoid.Sit
end


local function tweenCarTo(car, destination)
    if not car or not car.Parent then return false end

    local seat = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then return false end
    if not car.PrimaryPart then car.PrimaryPart = seat end

    local function moveTo(targetPos)
        local startCF = car:GetPivot()
        local targetCF = CFrame.new(targetPos)
        local dist = (startCF.Position - targetPos).Magnitude
  
        local dur = math.clamp(dist / carSpeed, 0.25, 8)

        local cfVal = Instance.new("CFrameValue")
        cfVal.Value = startCF
        local con = cfVal.Changed:Connect(function(cf)
            if car and car.Parent then
                car:PivotTo(cf)
                if seat then
                    seat.AssemblyLinearVelocity = Vector3.new()
                    seat.AssemblyAngularVelocity = Vector3.new()
                end
            end
        end)

        local tw = TweenService:Create(cfVal, TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Value = targetCF})
        tw:Play()
        tw.Completed:Wait()

        con:Disconnect()
        cfVal:Destroy()
    end

    moveTo(car.PrimaryPart.Position + Vector3.new(0, -4, 0))
    moveTo(destination + Vector3.new(0, -4, 0))
    moveTo(destination)
    return true
end


local busySelfRevive = false
local function selfReviveOnce()
    if busySelfRevive then return end
    busySelfRevive = true

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum  = char:WaitForChild("Humanoid")
    local hrp  = char:WaitForChild("HumanoidRootPart")

    if hum.Health > hum.MaxHealth * 0.27 then
        OrionLib:MakeNotification({
            Name = "Self Revive",
            Content = "You are not dead: .",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
        busySelfRevive = false
        return
    end

    local car = getMyCar()
    local carOrigCF = nil
    local hadCar = (car ~= nil)

    if hadCar then
        local seat = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("VehicleSeat")
        if seat then
            ensureSit(seat, hum)
        end
        carOrigCF = car:GetPivot()
        tweenCarTo(car, HOSPITAL_POS)
    end

    local bedSeat = findHospitalSeat()
    if not bedSeat then
        OrionLib:MakeNotification({
            Name = "Self Revive",
            Content = " not found.",
            Image = "rbxassetid://4483345998",
            Time = 4
        })
        busySelfRevive = false
        return
    end

    if hum.Sit then
        hum.Sit = false
        hum.Jump = true
        task.wait(0.15)
    end

    hrp.CFrame = bedSeat.CFrame * CFrame.new(0, 1.2, 0)
    hrp.AssemblyLinearVelocity = Vector3.new()
    hrp.AssemblyAngularVelocity = Vector3.new()

    for _ = 1, 10 do
        bedSeat:Sit(hum)
        task.wait(0.12)
        if hum.Sit then break end
    end


    local t0 = time()
    while hum.Health < hum.MaxHealth * 0.80 and (time() - t0) < reviveSpeed do
        task.wait(0.2)
    end

    hum.Sit = false
    hum.Jump = true
    task.wait(0.1)

    if hadCar and car and car.Parent then
        local seat = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("VehicleSeat")
        if seat then
            hrp.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
            ensureSit(seat, hum)
        end
        if carOrigCF then
            tweenCarTo(car, carOrigCF.Position)
        end
    end

    OrionLib:MakeNotification({
        Name = "Self Revive",
        Content = "Nigga.",
        Image = "rbxassetid://4483345998",
        Time = 3
    })

    busySelfRevive = false
end


SafetyTab:AddButton({
    Name = "Self Revive (Hospital)",
    Callback = function()
        task.spawn(selfReviveOnce)
    end
})


local autoSelfRevive = false
SafetyTab:AddToggle({
    Name = "Auto Self Revive",
    Default = false,
    Callback = function(v)
        autoSelfRevive = v
    end
})

LocalPlayer.CharacterAdded:Connect(function(character)
    local hum = character:WaitForChild("Humanoid")
    hum.HealthChanged:Connect(function()
        if autoSelfRevive and hum.Health <= hum.MaxHealth * 0.80 then
            task.spawn(selfReviveOnce)
        end
    end)
end)

if LocalPlayer.Character then
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.HealthChanged:Connect(function()
            if autoSelfRevive and hum.Health <= hum.MaxHealth * 0.80 then
                task.spawn(selfReviveOnce)
            end
        end)
    end
end



SafetyTab:AddToggle({
    Name = "Anti-Taser",
    Default = false,
    Callback = function(state)
        AntiTaserEnabled = state
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
    if AntiTaserEnabled then
        local char = game.Players.LocalPlayer.Character
        if char and char:GetAttribute("Tased") == true then
            char:SetAttribute("Tased", false)
        end
    end
end)



    local GunModTab = Window:MakeTab({
        Name = "Gun Mods",
        Icon = "rbxassetid://3926305904", 
        PremiumOnly = false
    })

 
    GunModTab:AddToggle({
        Name = "Auto Reload",
        Default = false,
        Callback = function(state)
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local VirtualInputManager = game:GetService("VirtualInputManager")

            local trackedWeapons = {
                "G36",
                "Glock 17",
                "MP5",
                "M4 Carabine",
                "Sniper",
                "M58B Shotgun"
            }

            task.spawn(function()
                while state do
                    pcall(function()
                        local character = LocalPlayer.Character
                        if character then
                            for _, weaponName in ipairs(trackedWeapons) do
                                local weapon = character:FindFirstChild(weaponName) or workspace:FindFirstChild(weaponName)
                                if weapon then
                                    local magSize = weapon:GetAttribute("MagCurrentSize") 
                                        or weapon:GetAttribute("Ammo") 
                                        or weapon:GetAttribute("Clip") 
                                        or (weapon:FindFirstChild("Ammo") and weapon.Ammo.Value)

                                    if magSize and magSize == 0 then
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                        task.wait(0.1)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                                        task.wait(1)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    })

local NoRecoilEnabled = false
GunModTab:AddToggle({
    Name = "No Recoil",
    Default = false,
    Callback = function(Value)
        NoRecoilEnabled = Value
    end
})


local RapidFireEnabled = false
GunModTab:AddToggle({
    Name = "Rapid Fire",
    Default = false,
    Callback = function(Value)
        RapidFireEnabled = Value
    end
})




task.spawn(function()
    local plr = game:GetService("Players").LocalPlayer
    while true do
        if NoRecoilEnabled then
            local Tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
            if Tool then
                Tool:SetAttribute("Recoil", 0)
                Tool:SetAttribute("Instability", 0)
            end
        end
        if RapidFireEnabled then
            local Tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
            if Tool then
                Tool:SetAttribute("ShootDelay", 0)
                Tool:SetAttribute("Automatic", true)
            end
        end
        task.wait(0.1)
    end
end)

local WeaponColorEnabled = false
local WeaponRainbowEnabled = false
local SelectedWeaponColor = Color3.fromRGB(255, 215, 0) -- par défaut OR
local WeaponTransparency = 0.3

GunModTab:AddToggle({
    Name = "Weapon Color",
    Default = false,
    Callback = function(Value)
        WeaponColorEnabled = Value
    end
})

GunModTab:AddColorpicker({
    Name = "Weapon Color Picker",
    Default = Color3.fromRGB(255, 215, 0),
    Callback = function(Value)
        SelectedWeaponColor = Value
    end
})

GunModTab:AddToggle({
    Name = "Weapon Rainbow Mode",
    Default = false,
    Callback = function(Value)
        WeaponRainbowEnabled = Value
    end
})


local function applyWeaponAppearance(tool)
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            if WeaponColorEnabled then
                part.Material = Enum.Material.ForceField
                if WeaponRainbowEnabled then
                    local t = tick() * 2
                    local r = math.floor(math.sin(t) * 127 + 128)
                    local g = math.floor(math.sin(t + 2) * 127 + 128)
                    local b = math.floor(math.sin(t + 4) * 127 + 128)
                    part.Color = Color3.fromRGB(r, g, b)
                else
                    part.Color = SelectedWeaponColor
                end
                part.Transparency = WeaponTransparency
            else
                part.Material = Enum.Material.Plastic
                part.Transparency = 0
                part.Color = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end


task.spawn(function()
    local plr = game:GetService("Players").LocalPlayer
    while task.wait(0.1) do
        local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            applyWeaponAppearance(tool)
        end
    end
end)



    GunModTab:AddLabel("Notes :  Idk if the auto  reload  work.")



    
    





  
    MiscTab:AddToggle({
        Name = "Anti-AFK",
        Default = true,
        Callback = function(Value)
            if Value then
                local vu = game:GetService("VirtualUser")
                game.Players.LocalPlayer.Idled:Connect(function()
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end
        end
    })


    local speedEnabled = false
    local speedMultiplier = 2 
    local speedKey = Enum.KeyCode.T 


    MiscTab:AddToggle({
        Name = "SpeedHack (Safe)",
        Default = false,
        Callback = function(v)
            speedEnabled = v
        end
    })

    MiscTab:AddSlider({
        Name = "Speed Multiplier",
        Min = 0.50, 
        Max = 0.80, 
        Default = 0.50,
        Increment = 0.50,
        ValueName = "",
        Callback = function(val)
            speedMultiplier = val
        end
    })


    MiscTab:AddBind({
        Name = "SpeedHack Key",
        Default = Enum.KeyCode.T,
        Hold = false,
        Callback = function()
            speedEnabled = not speedEnabled
            OrionLib:MakeNotification({
                Name = "SpeedHack",
                Content = "SpeedHack " .. (speedEnabled and "ON" or "OFF"),
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    })


    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    RunService.RenderStepped:Connect(function()
        if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (moveDir * (speedMultiplier / 2)) 
            end
        end
    end)

    MiscTab:AddButton({
        Name = "Get out of Vehicle",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")

            if humanoid and humanoid.SeatPart then
                humanoid.Sit = false -- Aufstehen
                task.wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            else
                OrionLib:MakeNotification({
                    Name = "Not in the seat",
                    Content = "You are not in a vehicle or seat right now!",
                    Image = "rbxassetid://4483345998",
                    Time = 4
                })
            end
        end
    })
    
    local spinEnabled = false
    local spinSpeed = 5 

    MiscTab:AddToggle({
        Name = "SpinBot",
        Default = false,
        Callback = function(v)
            spinEnabled = v
        end
    })

    MiscTab:AddSlider({
        Name = "Spin Speed",
        Min = 1,
        Max = 500,
        Default = 5,
        Increment = 1,
        ValueName = "",
        Callback = function(val)
            spinSpeed = val
        end
    })

  
    RunService.RenderStepped:Connect(function()
        if spinEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                -- rotation fluide du HRP
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
        end
    end)




local flyEnabled = false
local flySpeed = 1
local flyKey = Enum.KeyCode.V 

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer


local FlyToggle = MiscTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if not v and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum then hum.PlatformStand = false end
            if hrp then hrp.Velocity = Vector3.zero end -- stop complet
        end
    end
})


MiscTab:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 3,
    Default = 2,
    Increment = 1,
    ValueName = "x",
    Callback = function(val)
        flySpeed = val
    end
})


MiscTab:AddBind({
    Name = "Fly Toggle Key",
    Default = Enum.KeyCode.V,
    Hold = false,
    Callback = function(key)
        flyKey = key
    end
})


local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end


UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == flyKey then
        flyEnabled = not flyEnabled
        FlyToggle:Set(flyEnabled)
        if flyEnabled then
            notify("Fly", " ON")
        else
            notify("Fly", " OFF")
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hum then hum.PlatformStand = false end
                if hrp then hrp.Velocity = Vector3.zero end
            end
        end
    end
end)


RunService.RenderStepped:Connect(function()
    if not flyEnabled then return end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end

        local camCF = workspace.CurrentCamera.CFrame
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end

     
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)

  
        hrp.Velocity = Vector3.zero
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (moveDir.Unit * flySpeed)
        end
    end
end)


local Players = game:GetService("Players")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local jumpBoostPower = 350

MiscTab:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 350,
    Default = 0,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        jumpBoostPower = Value
    end    
})

humanoid.Jumping:Connect(function()
    if jumpBoostPower > 0 then
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(
            humanoidRootPart.AssemblyLinearVelocity.X,
            jumpBoostPower,
            humanoidRootPart.AssemblyLinearVelocity.Z
        )
    end
end)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local clickToDeleteEnabled = false
local clickToDeleteConnection


local function toggleClickToDelete(enable)
    if enable then
        clickToDeleteConnection = mouse.Button1Down:Connect(function()
            if mouse.Target then
                mouse.Target:Destroy()
            end
        end)
    elseif clickToDeleteConnection then
        clickToDeleteConnection:Disconnect()
        clickToDeleteConnection = nil
    end
end


MiscTab:AddToggle({
    Name = "Click  Delete",
    Default = false,
    Callback = function(Value)
        clickToDeleteEnabled = Value
        toggleClickToDelete(clickToDeleteEnabled)
    end
})

    MiscTab:AddButton({
        Name = "Reset Character",
        Callback = function()
            local char = Player.Character
            if char then
                char:BreakJoints()
            end
        end
    })

  
    MiscTab:AddButton({
        Name = "Change Server",
        Callback = function()
            local TeleportService = game:GetService("TeleportService")
            local PlaceID = game.PlaceId
            TeleportService:Teleport(PlaceID, Player)
        end
    })

    
MiscTab:AddSlider({
    Name = "Camera Max Zoom",
    Min = 20,
    Max = 1200,
    Default = 20,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 1,
    ValueName = "Distance",
    Callback = function(Value)
        game.Players.LocalPlayer.CameraMaxZoomDistance = Value
    end  
})

    MiscTab:AddButton({
        Name = "Steal Nearest Bike",
        Callback = function()

            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart

            local function isUUID(name)
                local pattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
                return string.match(name, pattern) ~= nil
            end

            local function onCharacterAdded(newCharacter)
                character = newCharacter
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            end

            player.CharacterAdded:Connect(onCharacterAdded)
            if player.Character then
                onCharacterAdded(player.Character)
            end

            local vehiclesFolder = workspace:WaitForChild("Vehicles")

            local function findNearestDriveSeat()
                local closestDistance = math.huge
                local closestSeat = nil

                for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
                    if isUUID(vehicle.Name) then
                        local driveSeat = vehicle:FindFirstChild("DriveSeat", true)
                        if driveSeat and driveSeat:IsA("Seat") then
                            local distance = (driveSeat.Position - humanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestSeat = driveSeat
                            end
                        end
                    end
                end

                return closestSeat
            end

            local seat = findNearestDriveSeat()
            if seat then
                seat:Sit(character:WaitForChild("Humanoid"))
            end
        end    
    })







    local GraphicsTab = Window:MakeTab({Name="Graphics", Icon="rbxassetid://3926305904", PremiumOnly=false})


    local fullBright = false
    local xrayActive = false
   

 
    GraphicsTab:AddToggle({
        Name = "FullBright",
        Default = false,
        Callback = function(v)
            fullBright = v
            if fullBright then
                for _, light in pairs(game.Lighting:GetChildren()) do
                    if light:IsA("BloomEffect") or light:IsA("ColorCorrectionEffect") or light:IsA("SunRaysEffect") then
                        light.Enabled = false
                    end
                end
                game.Lighting.Ambient = Color3.fromRGB(255,255,255)
                game.Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
            else
                game.Lighting.Ambient = Color3.fromRGB(128,128,128)
                game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
            end
        end
    })




local InfoTab = Window:MakeTab({
    Name = "Info Server",
    Icon = "rbxassetid://3926305904", 
    PremiumOnly = false
})


local totalLabel = InfoTab:AddLabel("Total Players: 0")
local policeLabel = InfoTab:AddLabel("Police: 0")
local fireLabel = InfoTab:AddLabel("Firedepartements: 0")
local adacLabel = InfoTab:AddLabel("ADAC: 0")
local busLabel = InfoTab:AddLabel("Bus Company: 0")
local truckLabel = InfoTab:AddLabel("Truck Company: 0")
local citizenLabel = InfoTab:AddLabel("Citizen: 0")
local youLabel = InfoTab:AddLabel("You: N/A")


local function updateInfo()
    local players = game.Players:GetPlayers()
    local total = #players
    local police, fire, adac, bus, truck, citizen = 0,0,0,0,0,0

    for _,plr in pairs(players) do
        if plr.Team then
            local lname = plr.Team.Name:lower()
            if lname:find("police") then
                police += 1
            elseif lname:find("fire") then
                fire += 1
            elseif lname:find("adac") then
                adac += 1
            elseif lname:find("bus") then
                bus += 1
            elseif lname:find("truck") then
                truck += 1
            else
                citizen += 1
            end
        else
            citizen += 1
        end
    end

    totalLabel:Set("Total Players: " .. total)
    policeLabel:Set("Police: " .. police)
    fireLabel:Set("Firedepartements: " .. fire)
    adacLabel:Set("ADAC: " .. adac)
    busLabel:Set("Bus Company: " .. bus)
    truckLabel:Set("Truck Company: " .. truck)
    citizenLabel:Set("Citizen: " .. citizen)

    local me = game.Players.LocalPlayer
    if me.Team then
        youLabel:Set("You: " .. me.Name .. " (" .. me.Team.Name .. ")")
    else
        youLabel:Set("You: " .. me.Name .. " (No Team)")
    end
end


task.spawn(function()
    while task.wait(2) do
        updateInfo()
    end
end)

updateInfo()
    
    GraphicsTab:AddToggle({
        Name = "XRay",
        Default = false,
        Callback = function(v)
            xrayActive = v
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 1 and part.CanCollide then
                    if xrayActive then
                        part.Transparency = 0.6
                    else
                        part.Transparency = 0
                    end
                end
            end
        end
    })

  
    
    local nightVisionEnabled = false
    local fpsBoostEnabled = false


    GraphicsTab:AddToggle({
        Name = "Night Vision",
        Default = false,
        Callback = function(value)
            nightVisionEnabled = value
            if nightVisionEnabled then
                -- Change la luminosité, contraste, etc.
                game:GetService("Lighting").ClockTime = 0
                game:GetService("Lighting").Ambient = Color3.fromRGB(50,50,50)
                game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(80,80,80)
                game:GetService("Lighting").FogEnd = 1000
            else
                -- Revenir aux paramètres par défaut
                game:GetService("Lighting").ClockTime = 14
                game:GetService("Lighting").Ambient = Color3.fromRGB(196,196,196)
                game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(196,196,196)
                game:GetService("Lighting").FogEnd = 100000
            end
        end
    })

    -- Toggle FPS Booster
    GraphicsTab:AddToggle({
        Name = "FPS Booster",
        Default = false,
        Callback = function(value)
            fpsBoostEnabled = value
            if fpsBoostEnabled then
                -- Supprime les decals, textures, effets pour booster FPS
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Texture") or v:IsA("Decal") then
                        v.Transparency = 1
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                        v.Enabled = false
                    end
                end
            else
                -- Remet les textures et effets
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Texture") or v:IsA("Decal") then
                        v.Transparency = 0
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                        v.Enabled = true
                    end
                end
            end
        end
    })

local fpsLabel 

GraphicsTab:AddToggle({
    Name = "Show  FPS",
    Default = false,
    Callback = function(Value)
        if Value then
         
            if not fpsLabel then
                local screenGui = Instance.new("ScreenGui")
                screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

                fpsLabel = Instance.new("TextLabel")
                fpsLabel.Size = UDim2.new(0, 200, 0, 50)
                fpsLabel.Position = UDim2.new(0, 10, 0, 10)
                fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                fpsLabel.BackgroundTransparency = 0.5
                fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                fpsLabel.TextSize = 24
                fpsLabel.Text = "FPS: 0"
                fpsLabel.Parent = screenGui

          
                local lastUpdate = tick()
                local frameCount = 0
                local fps = 0

                game:GetService("RunService").RenderStepped:Connect(function()
                    frameCount = frameCount + 1
                    local currentTime = tick()

                
                    if currentTime - lastUpdate >= 1 then
                        fps = frameCount
                        fpsLabel.Text = "FPS: " .. fps
                        frameCount = 0
                        lastUpdate = currentTime
                    end
                end)
            end
        else
           
            if fpsLabel then
                fpsLabel.Visible = false
            end
        end
    end
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local isForceField = false
local rainbowEnabled = false
local ghostColor = Color3.fromRGB(255, 215, 0)
local currentColorIndex = 1


local rainbowColors = {
    Color3.fromRGB(255, 0, 0),     
    Color3.fromRGB(255, 127, 0),   
    Color3.fromRGB(255, 215, 0),   
    Color3.fromRGB(0, 255, 0),     
    Color3.fromRGB(0, 0, 255),     
    Color3.fromRGB(148, 0, 211),   
    Color3.fromRGB(255, 255, 255)  
}


local function applyMaterial(char, state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then
            if state then
                part.Material = Enum.Material.ForceField
                part.Color = ghostColor
            else
                part.Material = Enum.Material.Plastic
                part.Color = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end


local function toggleMaterial(state)
    isForceField = state
    local char = player.Character or player.CharacterAdded:Wait()
    applyMaterial(char, isForceField)
end


player.CharacterAdded:Connect(function(char)
    if isForceField then
        task.wait(1)
        applyMaterial(char, true)
    end
end)


task.spawn(function()
    while true do
        if rainbowEnabled and isForceField then
            ghostColor = rainbowColors[currentColorIndex]
            local char = player.Character
            if char then
                applyMaterial(char, true)
            end
            currentColorIndex = (currentColorIndex % #rainbowColors) + 1
        end
        task.wait(0.3)
    end
end)


GraphicsTab:AddToggle({
    Name = "Player Ghost",
    Default = false,
    Callback = function(Value)
        toggleMaterial(Value)
    end
})

GraphicsTab:AddColorpicker({
    Name = "Player Ghost Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        ghostColor = Value
        if isForceField then
            local char = player.Character
            if char then
                applyMaterial(char, true)
            end
        end
    end
})

GraphicsTab:AddToggle({
    Name = "Rainbow Player ghost",
    Default = false,
    Callback = function(Value)
        rainbowEnabled = Value
    end
})


   





      


        RunService.RenderStepped:Connect(function()
            updateCharacter()

            if noclipActive and char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            if antiFallActive and hrp then
                local ray = Workspace:Raycast(hrp.Position, Vector3.new(0,-5,0))
                if not ray and hrp.Velocity.Y < -1 then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, -1, hrp.Velocity.Z)
                end
            end

            if godModeActive and hum then
                hum.Health = hum.MaxHealth
            end

            if espPlayers then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
                        createBillboard(plr.Character.Head, plr.Name, Color3.fromRGB(255,0,0))
                    end
                end
            else
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr.Character and plr.Character:FindFirstChild("Head") then
                        local bb = plr.Character.Head:FindFirstChild("ESPBillboard")
                        if bb then bb:Destroy() end
                    end
                end
            end
        end)

        UserInputService.JumpRequest:Connect(function()
            if infiniteJumpActive and hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end   


    
    OrionLib:Init()
    
    loadHamburgScript()
