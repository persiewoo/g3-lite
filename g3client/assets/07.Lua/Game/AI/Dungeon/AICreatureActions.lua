--[[
Creature AI 行为
]]

local AICreatureActions = {}

AICreatureActions.args = {
}

local args = AICreatureActions.args

-- 冷静一下
function AICreatureActions:BeCool()
    self.controller.cool = true
    return TaskStatus.Success
end

-- 选一个警戒位置为目标
function AICreatureActions:SelectGuardPosAsTarget()
    return TaskStatus.Success
end

-- 移动到指定位置
function AICreatureActions:MoveTo()
    return TaskStatus.Running
end

-- 选择出生点为目标
function AICreatureActions:SelectBornPosAsTarget()
    self.controller.targetPosition = self.controller.bornPosition
    return TaskStatus.Success
end

return AICreatureActions