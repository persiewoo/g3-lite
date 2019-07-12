--[[
 AI 场景战斗行为
]]

local AIBattleActions = {}

AIBattleActions.args = {
}

local args = AIBattleActions.args

function AIBattleActions:AIStart(name)
end

-- 进场阶段
function AIBattleActions:StartEnter()
	self.controller.state = Constants.battleState.enter
	return TaskStatus.Success
end

-- 战斗阶段
function AIBattleActions:StartFighting()
	self.controller.state = Constants.battleState.fighting
	return TaskStatus.Success
end

return AIBattleActions