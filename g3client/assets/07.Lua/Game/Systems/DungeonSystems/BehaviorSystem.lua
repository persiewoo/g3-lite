--[[
角色行为系统
]]

BehaviorSystem = {}

local self = BehaviorSystem

local behavior2Animations = {
    [Constants.behavior.idle] = Constants.charAnimation.idle,
    [Constants.behavior.run] = Constants.charAnimation.run,
}

function BehaviorSystem.Initialize()
    BlockManager.AddListener({Behavior, Animation, filter = {Behavior}}, self.onBehaviorChanged)
    BlockManager.AddListener({Moving, Animation, filter = {Moving}}, self.onMovingChanged)
end

function BehaviorSystem.Shutdown()
    BlockManager.RemoveListener({Behavior, Animation}, self.onBehaviorChanged)
    BlockManager.RemoveListener({Moving, Animation}, self.onMovingChanged)
end

function BehaviorSystem.onBehaviorChanged(block, k, v, state, tuple)
    if k ~= 'state' then
        return
    end

    if v == Constants.behavior.idle then
        tuple.animation.view:SetTimeScale(1.0)
    end

    tuple.animation.view:PlayAnimation(behavior2Animations[v])
end

function BehaviorSystem.onMovingChanged(block, k, v, state, tuple)
    if k == 'timeScale' then
        tuple.animation.view:SetTimeScale(v)
    end
end