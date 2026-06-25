local WindUI = AppleHub.WindUI

local AdminTab = AppleHub.Window:Tab({ Title = "Admin" })

local function LoadAdmin(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
    else
    end
end

AdminTab:Button({
    Title = "Load Nameless Admin",
    Callback = function()
        LoadAdmin("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua")
    end
})

AdminTab:Button({
    Title = "Load Infinite Yield",
    Callback = function()
        LoadAdmin("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
})