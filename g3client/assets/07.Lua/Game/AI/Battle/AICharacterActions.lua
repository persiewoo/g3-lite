--[[
 AI Character 行为
]]

local AICharacterActions = {}

AICharacterActions.args = {
}

local args = AICharacterActions.args

function AICharacterActions:AIStart(name)
end

-- 进场
function AICharacterActions:StartEnter()
	self.controller.state = Constants.charState.enter
	return TaskStatus.Success
end

-- 准备攻击
function AICharacterActions:PrepareAttack()
    self.controller.state = Constants.charState.fighting
	self.controller.attackState = Constants.attackState.sel
	return TaskStatus.Success
end

return AICharacterActions