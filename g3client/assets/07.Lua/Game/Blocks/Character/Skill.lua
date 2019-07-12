--[[
 技能
]]

Skill = Block('skill', {
    -- 技能列表
    skills = nil,

    -- 当前技能
    current = nil,

    -- 目标
    target = nil,

    -- 当前攻击序列
    atkIndex = 0,

    -- 攻击序列
    atkSequence = {}
})
