--[[
Creature AI Conditions
]]

local AICreatureConditionals = {}

AICreatureConditionals.args = {
}

local args = AICreatureConditionals.args

-- 发现了目标
function AICreatureConditionals:TargetFound()
    local myself = DungeonKeeper.GetCreature(self.controller.creatureId)
    local player = DungeonKeeper.GetPlayer()
    local diff = myself.location.position - player.location.position

    local cc = Config.Character[myself.creature.id]

    if diff.magnitude > cc.view then
        return TaskStatus.Failure
    end

    return TaskStatus.Success
end

-- 是否能攻击目标
function AICreatureConditionals:CanAttack()
    return TaskStatus.Success
end

-- 不冷静，使劲干
function AICreatureConditionals:NotBeCool()
    return self.controller.cool and TaskStatus.Failure or TaskStatus.Success
end

-- 是否在警戒区
function AICreatureConditionals:IsInGuardArea()
    local myself = DungeonKeeper.GetCreature(self.controller.creatureId)
    local diff = self.controller.bornPosition - myself.location.position

    return diff.magnitude > self.controller.guardRange and TaskStatus.Failure or TaskStatus.Success
end

-- 是否距离警戒区域太远了
function AICreatureConditionals:IsFarFromGuardArea()
    local myself = DungeonKeeper.GetCreature(self.controller.creatureId)
    local diff = self.controller.bornPosition - myself.location.position

    return diff.magnitude > self.controller.pursueRange and TaskStatus.Success or TaskStatus.Failure
end

return AICreatureConditionals