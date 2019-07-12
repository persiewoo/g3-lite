--[[
角色攻击状态系统
]]

CharacterAttackStateSystem = {}

local self = CharacterAttackStateSystem

function CharacterAttackStateSystem.Initialize()
    BlockManager.AddListener({CharacterAI, Skill, filter = {CharacterAI}}, self.onAttackStateChanged)
end

function CharacterAttackStateSystem.Shutdown()
    BlockManager.RemoveListener({CharacterAI, Skill}, self.onAttackStateChanged)
end

function CharacterAttackStateSystem.onAttackStateChanged(characterAI, k, v, state, tuple)
    if k ~= 'attackState' then
        return
    end

    local skill = tuple.skill

    -- 选择技能状态
    if v == Constants.attackState.sel and #skill.skills > 0 then
        -- 选择一个技能
        local s = skill.skills[#skill.skills]
        
        skill.target = CharacterKeeper.SelectTarget(characterAI.team, s)
        skill.current = s
    end
end