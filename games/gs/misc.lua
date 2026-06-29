local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local WindUI = LinuxHub.WindUI

local MiscTab = LinuxHub.Window:Tab({ Title = "Misc" })

local disable3DEnabled = LinuxHub.Toggles.disable3DEnabled or false
local originalQualityLevel = 10
local originalGlobalShadows = true

local function setRendering(state)
    local UserSettings = game:GetService("UserSettings")
    if state then
        originalQualityLevel = UserSettings.Rendering.QualityLevel
        originalGlobalShadows = Lighting.GlobalShadows
        UserSettings.Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
    else
        UserSettings.Rendering.QualityLevel = originalQualityLevel
        Lighting.GlobalShadows = originalGlobalShadows
    end
end

local function startDisable3D()
    if disable3DEnabled then return end
    disable3DEnabled = true
    LinuxHub.Toggles.disable3DEnabled = true
    pcall(setRendering, true)
    if LinuxHub.SaveSettings then LinuxHub.SaveSettings() end
    pcall(WindUI.Notify, WindUI, { Title = "3D Rendering", Content = "Disabled (Lowest Graphics)", Duration = 2 })
end

local function stopDisable3D()
    disable3DEnabled = false
    LinuxHub.Toggles.disable3DEnabled = false
    pcall(setRendering, false)
    if LinuxHub.SaveSettings then LinuxHub.SaveSettings() end
    pcall(WindUI.Notify, WindUI, { Title = "3D Rendering", Content = "Enabled (Restored)", Duration = 2 })
end

pcall(function()
    MiscTab:Toggle({
        Title = "Disable 3D Rendering",
        Value = disable3DEnabled,
        Callback = function(state)
            if state then startDisable3D() else stopDisable3D() end
        end
    })
end)

LinuxHub.DisableAll = LinuxHub.DisableAll or function() end
local oldDisable = LinuxHub.DisableAll
LinuxHub.DisableAll = function()
    if disable3DEnabled then
        pcall(stopDisable3D)
    end
    oldDisable()
end
