--!strict

local HttpService = game:GetService("HttpService")

local BASE_URL = "https://raw.githubusercontent.com/crimiv/silverhub/main/"

local success, games = pcall(function()
    return loadstring(game:HttpGet(BASE_URL .. "GameList.lua"))()
end)

if not success or type(games) ~= "table" then
    return
end

local scriptPath = games[game.PlaceId] or games[game.GameId]
if not scriptPath then
    return
end

loadstring(game:HttpGet(BASE_URL .. HttpService:UrlEncode(scriptPath)))()
