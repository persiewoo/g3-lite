--[[
 AIBT 显示层
]]

local AIBTView = {}

AIBTView.args = {
    ebt = Types.ExternalBehaviorTree,
    owner = Types.GameObject,
}

local args = AIBTView.args

AIBTView.bt = nil

function AIBTView:AwakeCS()
    self.bt = self.gameObject:AddComponent(typeof(BehaviorTree))
    self.bt.ExternalBehavior = args.ebt
    self.bt.RestartWhenComplete = true
    self.bt.PauseWhenDisabled = true
end

function AIBTView:Awake()
    if self.bt:GetVariable('owner') then
        self.bt:GetVariable('owner').Value = args.owner
    end

    -- 默认不激活
    self:Stop()
end

function AIBTView:Run()
    self.bt:EnableBehavior()
end

function AIBTView:Stop()
    self.bt:DisableBehavior()
end

return AIBTView