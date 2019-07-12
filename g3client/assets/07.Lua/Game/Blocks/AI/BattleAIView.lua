--[[
 Battle AI View
]]

local BattleAIView = {}

BattleAIView.args = {
}

local args = BattleAIView.args

BattleAIView.bt = nil

function BattleAIView:Start()
    self.bt = self.gameObject:GetComponent(typeof(BehaviorTree))
end

function BattleAIView:OnEnable()
end

function BattleAIView:OnDisable()
end

function BattleAIView:StateChanged(v)
    self.bt:GetVariable('battleState').Value = v
end

return BattleAIView