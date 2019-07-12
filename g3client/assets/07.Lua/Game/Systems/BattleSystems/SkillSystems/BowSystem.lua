--[[
发射器-弓箭系统
]]

BowSystem = {}

local self = BowSystem

function BowSystem.Initialize()
    BlockManager.AddListener({Bow}, self.onBowCreated, {BlockState.added})
end

function BowSystem.Shutdown()
    BlockManager.RemoveListener({Bow}, self.onBowCreated)
end

function BowSystem.onBowCreated(block, k, v)
end