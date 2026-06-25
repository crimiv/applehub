--!strict

local HttpGet = game.HttpGet
local GameId = game.GameId

local BaseURL = "https://raw.githubusercontent.com/crimiv/silverhub/refs/heads/main/"

local Games: {[number]: string} = loadstring(
    HttpGet(game, BaseURL .. "GameList.lua")
)()

local Script = Games[GameId]
if not Script then
    return
end

loadstring(HttpGet(game, BaseURL .. Script:gsub(" ", "%%20")))()
