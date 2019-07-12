--[[
 角色AI 显示层
]]

local CharacterAIView = {}

CharacterAIView.args = {
}

local args = CharacterAIView.args

CharacterAIView.bt = nil

function CharacterAIView:Start()
	self.bt = self.gameObject:GetComponent(typeof(BehaviorTree))
end

function CharacterAIView:StateChanged(k, v)
	if k == 'state' then
		self.bt:GetVariable('charState').Value = v
	elseif k == 'attackState' then
		self.bt:GetVariable('attackState').Value = v
	elseif k == 'attackable' then
		self.bt:GetVariable('canAttack').Value = v
	elseif k == 'battleState' then
		self.bt:GetVariable('battleState').Value = v
	end
end

return CharacterAIView