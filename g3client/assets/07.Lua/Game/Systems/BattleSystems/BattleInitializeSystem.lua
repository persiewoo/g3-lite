--[[
战斗初始化系统
]]

BattleInitializeSystem = {}

local self = BattleInitializeSystem

function BattleInitializeSystem.Initialize()
	EventManager:AddListener(EventTypes.Battle_LoadFinished, self.onSceneLoadFinished)
	EventManager:AddListener(EventTypes.System_SceneLoadFinished, self.onBattleLoadFinished)

	BlockManager.AddListener({BattleMap}, self.onBattleMapAdded, {BlockState.added})
end

function BattleInitializeSystem.Shutdown()
	EventManager:RemoveListener(EventTypes.Battle_LoadFinished, self.onBattleLoadFinished)
	EventManager:RemoveListener(EventTypes.System_SceneLoadFinished, self.onSceneLoadFinished)

	BlockManager.RemoveListener({BattleMap}, self.onBattleMapAdded)
end

function BattleInitializeSystem.onSceneLoadFinished(name)
	if name ~= 'Battle' then
		return
	end
end

-- 战斗所有资源都已经载入完成
function BattleInitializeSystem.onBattleLoadFinished()
end

function BattleInitializeSystem.onBattleMapAdded(battleMap, k, v)
	battleMap.view:SetMap(battleMap.config)
end
