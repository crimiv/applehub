local WindUI = BanditHub.WindUI

local SettingsTab = BanditHub.Window:Tab({ Title = "Settings" })

local themes = {"Default"}
local currentTheme = "Default"


SettingsTab:Dropdown({
    Title = "Theme",
    Values = themes,
    Default = currentTheme,
    Callback = function(value)
        currentTheme = value
        BanditHub.CurrentTheme = value
        WindUI:SetTheme(value)
        if BanditHub.SaveSettings then BanditHub.SaveSettings() end
        WindUI:Notify({ Title = "Theme", Content = "Switched to " .. value, Duration = 2 })
    end
})