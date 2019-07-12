--[[
对战状态行为树系统
]]

BattleStateSystem = {}

local self = BattleStateSystem

function BattleStateSystem.Initialize()
    BlockManager.AddListener({Battle, BattleAI, filter = {BattleAI}}, self.onBattleAIChanged)
end

function BattleStateSystem.Shutdown()
    BlockManager.RemoveListener({Battle, BattleAI}, self.onBattleAIChanged)
end

function BattleStateSystem.onBattleAIChanged(battleAI, k, v, state, tuple)
    if k ~= 'state' then
        return
    end

    print('battle state ' .. v)

    battleAI.view:StateChanged(v)
end