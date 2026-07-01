local WindUI = LinuxHub.WindUI
local utils = LinuxHub.Utils
local config = LinuxHub.Config

local SkeletonLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()

local VisualTab = LinuxHub.Window:Tab({ Title = "Visual" })

local espEnabled = LinuxHub.Toggles.espEnabled or false
local skeletons = {}
local espUpdateCooldown = 0

local function GetPlayerRoleColor(player)
    if not player then return nil end
    if utils.PlayerHasTool(player, "Knife") then
        return config.colors.murderer
    elseif utils.PlayerHasTool(player, "Gun") then
        return config.colors.sheriff
    else
        return config.colors.innocent
    end
end

local function ClearESP()
    for _, skeleton in pairs(skeletons) do
        if skeleton and skeleton.Remove then
            skeleton:Remove()
        end
    end
    skeletons = {}
end

local function UpdateESP()
    if _G.LINUXHUB_UPDATING or not espEnabled then
        ClearESP()
        return
    end

    local localPlayer = game.Players.LocalPlayer
    if not localPlayer then return end

    local currentPlayers = game.Players:GetPlayers()

    for player, skeleton in pairs(skeletons) do
        if not table.find(currentPlayers, player) or player == localPlayer then
            skeleton:Remove()
            skeletons[player] = nil
        end
    end

    for _, player in pairs(currentPlayers) do
        if player == localPlayer then continue end
        if not player.Character then continue end

        local roleColor = GetPlayerRoleColor(player)
        if not roleColor then continue end

        local skeleton = skeletons[player]
        if not skeleton then
            skeleton = SkeletonLibrary:NewSkeleton(player, true, roleColor, 0.8, 2)
            skeletons[player] = skeleton
        else
            skeleton:SetColor(roleColor)
        end
    end
end

local function GetCurrentMurderer()
    for _, player in pairs(game.Players:GetPlayers()) do
        if utils.PlayerHasTool(player, "Knife") then
            return player
        end
    end
    return nil
end

local function GetCurrentSheriff()
    for _, player in pairs(game.Players:GetPlayers()) do
        if utils.PlayerHasTool(player, "Gun") then
            return player
        end
    end
    return nil
end

local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage:FindFirstChild("Remotes")
local extras = remotes and remotes:FindFirstChild("Extras")
local setMurdererRemote = extras and extras:FindFirstChild("SetMurderer")
local setSheriffRemote = extras and extras:FindFirstChild("SetSheriff")

if setMurdererRemote and setMurdererRemote:IsA("RemoteEvent") then
    setMurdererRemote.OnClientEvent:Connect(function(...)
        if _G.LINUXHUB_UPDATING then return end
        UpdateESP()
    end)
end

if setSheriffRemote and setSheriffRemote:IsA("RemoteEvent") then
    setSheriffRemote.OnClientEvent:Connect(function(...)
        if _G.LINUXHUB_UPDATING then return end
        UpdateESP()
    end)
end

local roundTimer = workspace:FindFirstChild("RoundTimerPart")
if roundTimer then
    roundTimer:GetAttributeChangedSignal("Time"):Connect(function()
        if _G.LINUXHUB_UPDATING then return end
        UpdateESP()
    end)
end

if espEnabled then UpdateESP() end

game.Players.PlayerAdded:Connect(function(player)
    if _G.LINUXHUB_UPDATING then return end
    player.CharacterAdded:Connect(function()
        if _G.LINUXHUB_UPDATING then return end
        task.wait(0.5)
        UpdateESP()
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if _G.LINUXHUB_UPDATING then return end
    if skeletons[player] then
        skeletons[player]:Remove()
        skeletons[player] = nil
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if _G.LINUXHUB_UPDATING then return end
    if espEnabled then
        local now = tick()
        if now - espUpdateCooldown >= 0.5 then
            espUpdateCooldown = now
            UpdateESP()
        end
    end
end)

VisualTab:Toggle({
    Title = "ESP Highlight",
    Value = espEnabled,
    Callback = function(state)
        espEnabled = state
        LinuxHub.Toggles.espEnabled = state
        if LinuxHub.SaveSettings then LinuxHub.SaveSettings() end
        WindUI:Notify({
            Title = "ESP Highlight",
            Content = espEnabled and "ESP Enabled" or "ESP Disabled",
            Duration = 2,
        })
        if not espEnabled then
            ClearESP()
        else
            UpdateESP()
        end
    end
})

LinuxHub.GetCurrentMurderer = GetCurrentMurderer
LinuxHub.GetCurrentSheriff = GetCurrentSheriff

LinuxHub.DisableAll = function()
    espEnabled = false
    LinuxHub.Toggles.espEnabled = false
    if LinuxHub.SaveSettings then LinuxHub.SaveSettings() end
    ClearESP()
end
