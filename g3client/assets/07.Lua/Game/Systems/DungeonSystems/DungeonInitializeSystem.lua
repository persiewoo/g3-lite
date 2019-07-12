--[[
地下城初始化系统
]]

DungeonInitializeSystem = {}

local self = DungeonInitializeSystem

function DungeonInitializeSystem.Initialize()
    EventManager:AddListener(EventTypes.System_SceneLoadFinished, self.onSceneLoadFinished)
end

function DungeonInitializeSystem.Shutdown()
    EventManager:RemoveListener(EventTypes.System_SceneLoadFinished, self.onSceneLoadFinished)
end

function DungeonInitializeSystem.onSceneLoadFinished(name)
    if name ~= 'Dungeon' then
        return
    end

    DungeonKeeper.root = GameObject('Character').transform
    DungeonKeeper.CreateDungeonPlayer(1000, true, function(entity)
    end)
end