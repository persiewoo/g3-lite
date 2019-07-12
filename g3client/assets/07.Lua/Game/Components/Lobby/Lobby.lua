--[[
 大厅
]]

local Lobby = Component('__lobby__', Config.ViewConstants.top, 'Lobby/LobbyView', 'Base')

function Lobby:OnEnable()
end

function Lobby:OnViewLoaded()
end

function Lobby:EnterDungeon()
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    Helper.Switch2Dungeon(Config.Dungeon[1001], function ()
        DungeonSystems.Initialize()
    end)
end

function Lobby:EnterBattle()
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    Helper.Switch2Battle(math.random(1, #Config.BattleMap.configs), {1000, 1001, 3000, 3000, 3000, 3000}, {3000, 1000, 1001, 1000, 2000, 1001}, function ()
        BattleSystems.Initialize()
    end)
end

return Lobby