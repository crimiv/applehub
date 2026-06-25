local WindUI = AppleHub.WindUI

local MiscTab = AppleHub.Window:Tab({ Title = "Misc" })

local antiFlingEnabled = AppleHub.Toggles.antiFlingEnabled or false
local autoAntiFlingEnabled = AppleHub.Toggles.autoAntiFlingEnabled or false
local antiFlingHeartbeat = nil
local lastFlingDetectTime = 0
local flingCooldown = 3

local function EnableAntiFling()
    if not antiFlingEnabled then
        antiFlingEnabled = true
        AppleHub.Toggles.antiFlingEnabled = true
        if AppleHub.SaveSettings then AppleHub.SaveSettings() end
        WindUI:Notify({
            Title = "Anti-Fling",
            Content = "Fling detected! Anti-Fling enabled.",
            Duration = 3,
        })
        SetupAntiFling()
    end
end

local function AntiFlingLoop()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer then return end
    local localChar = localPlayer.Character
    if not localChar then return end

    if autoAntiFlingEnabled and not antiFlingEnabled then
        local detectFling = false
        local root = localChar:FindFirstChild("HumanoidRootPart")
        if root then
            if root.Velocity.Magnitude > 120 then
                detectFling = true
            end
        end
        for _, child in ipairs(localChar:GetDescendants()) do
            if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") then
                detectFling = true
                break
            end
        end
        if detectFling and tick() - lastFlingDetectTime > flingCooldown then
            lastFlingDetectTime = tick()
            EnableAntiFling()
        end
    end

    if not antiFlingEnabled then return end

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player == localPlayer then continue end
        local char = player.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                root.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0, 0, 0)
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
                root.CanCollide = false
            end)
        end
    end

    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if localRoot then
        if localRoot.Velocity.Magnitude > 150 then
            localRoot.Velocity = Vector3.new(0, 0, 0)
            localRoot.RotVelocity = Vector3.new(0, 0, 0)
        end
        for _, child in ipairs(localChar:GetDescendants()) do
            if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") or child:IsA("BodyForce") or child:IsA("BodyGyro") or child:IsA("BodyPosition") or child:IsA("BodyThrust") then
                child:Destroy()
            end
        end
    end
end

local function SetupAntiFling()
    if antiFlingHeartbeat then
        antiFlingHeartbeat:Disconnect()
        antiFlingHeartbeat = nil
    end
    antiFlingHeartbeat = game:GetService("RunService").Heartbeat:Connect(AntiFlingLoop)
end

SetupAntiFling()

MiscTab:Toggle({
    Title = "Anti-Fling",
    Value = antiFlingEnabled,
    Callback = function(state)
        antiFlingEnabled = state
        AppleHub.Toggles.antiFlingEnabled = state
        if AppleHub.SaveSettings then AppleHub.SaveSettings() end
        WindUI:Notify({
            Title = "Anti-Fling",
            Content = antiFlingEnabled and "Enabled" or "Disabled",
            Duration = 2,
        })
    end
})

MiscTab:Toggle({
    Title = "Auto Anti-Fling",
    Value = autoAntiFlingEnabled,
    Callback = function(state)
        autoAntiFlingEnabled = state
        AppleHub.Toggles.autoAntiFlingEnabled = state
        if AppleHub.SaveSettings then AppleHub.SaveSettings() end
        WindUI:Notify({
            Title = "Auto Anti-Fling",
            Content = autoAntiFlingEnabled and "Enabled" or "Disabled",
            Duration = 2,
        })
    end
})

AppleHub.DisableAll = function()
    antiFlingEnabled = false
    AppleHub.Toggles.antiFlingEnabled = false
    autoAntiFlingEnabled = false
    AppleHub.Toggles.autoAntiFlingEnabled = false
    if AppleHub.SaveSettings then AppleHub.SaveSettings() end
end