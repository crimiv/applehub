local repo = "https://raw.githubusercontent.com/crimiv/linuxhub/main/"
local versionURL = repo .. "version.txt"

local function LoadScript(path)
    loadstring(game:HttpGet(repo .. path))()
end

local function CheckUpdate()
    local success, currentVersion = pcall(game.HttpGet, game, versionURL)
    if success then
        currentVersion = currentVersion:gsub("%s+", "")
        if currentVersion ~= LinuxHub.Version then
            loadstring(game:HttpGet(repo .. "main.lua"))()
            return true
        end
    end
    return false
end

if not LinuxHub then
    LinuxHub = { Version = "1.0", Toggles = {}, DisableAll = function() end }
end

if CheckUpdate() then return end

local games = loadstring(game:HttpGet(repo .. "games.lua"))()
local gameScript = games[game.PlaceId] or games.fallback

if gameScript then
    LoadScript(gameScript)
else
    LoadScript("games/universal/init.lua")
end
