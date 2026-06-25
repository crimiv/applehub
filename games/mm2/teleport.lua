local WindUI = AppleHub.WindUI
local utils = AppleHub.Utils

local TeleportTab = AppleHub.Window:Tab({ Title = "Teleport" })

local function TeleportToLobby()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer then
        utils.Notify({ Title = "Error", Content = "Local player not found", Duration = 2 })
        return
    end
    local character = localPlayer.Character
    if not character then
        utils.Notify({ Title = "Error", Content = "Character not found", Duration = 2 })
        return
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        utils.Notify({ Title = "Error", Content = "HumanoidRootPart not found", Duration = 2 })
        return
    end
    local lobby = workspace:FindFirstChild("RegularLobby")
    if not lobby then
        utils.Notify({ Title = "Error", Content = "RegularLobby not found", Duration = 2 })
        return
    end
    local parts = lobby:GetDescendants()
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            rootPart.CFrame = part.CFrame
            utils.Notify({ Title = "Teleport", Content = "Teleported to lobby", Duration = 2 })
            return
        end
    end
    utils.Notify({ Title = "Error", Content = "No BasePart found in lobby", Duration = 2 })
end

local function FindCurrentMapContainer()
    local mapNames = {"House2", "BioLab", "Office3", "Hospital3", "Factory", "MilBase", "Bank2", "Hotel2", "Mansion2", "PoliceStation", "ResearchFacility", "Workplace"}
    for _, name in ipairs(mapNames) do
        local map = workspace:FindFirstChild(name)
        if map then
            local coinContainer = map:FindFirstChild("CoinContainer")
            if coinContainer then
                return coinContainer
            end
            return map
        end
    end
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") or child:IsA("Folder") then
            local coinContainer = child:FindFirstChild("CoinContainer")
            if coinContainer then
                return coinContainer
            end
            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    return child
                end
            end
        end
    end
    return nil
end

local function TeleportToCurrentMap()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer then
        utils.Notify({ Title = "Error", Content = "Local player not found", Duration = 2 })
        return
    end
    local character = localPlayer.Character
    if not character then
        utils.Notify({ Title = "Error", Content = "Character not found", Duration = 2 })
        return
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        utils.Notify({ Title = "Error", Content = "HumanoidRootPart not found", Duration = 2 })
        return
    end
    local currentMapContainer = FindCurrentMapContainer()
    if not currentMapContainer then
        utils.Notify({ Title = "Error", Content = "Could not find current map", Duration = 2 })
        return
    end
    local targetPart = nil
    if currentMapContainer:IsA("BasePart") then
        targetPart = currentMapContainer
    else
        for _, part in ipairs(currentMapContainer:GetDescendants()) do
            if part:IsA("BasePart") then
                targetPart = part
                break
            end
        end
        if not targetPart then
            for _, child in ipairs(currentMapContainer:GetChildren()) do
                if child:IsA("BasePart") then
                    targetPart = child
                    break
                end
            end
        end
    end
    if not targetPart then
        utils.Notify({ Title = "Error", Content = "No BasePart found in map", Duration = 2 })
        return
    end
    rootPart.CFrame = targetPart.CFrame
    utils.Notify({ Title = "Teleport", Content = "Teleported to current map", Duration = 2 })
end

TeleportTab:Button({
    Title = "Teleport to Lobby",
    Callback = function()
        TeleportToLobby()
    end
})

TeleportTab:Button({
    Title = "Teleport to Current Map",
    Callback = function()
        TeleportToCurrentMap()
    end
})