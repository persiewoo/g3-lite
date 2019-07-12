--[[
技能系统
]]

require 'Game.Systems.BattleSystems.SkillSystems.SpellSystem'
require 'Game.Systems.BattleSystems.SkillSystems.BowSystem'
require 'Game.Systems.BattleSystems.SkillSystems.BulletSystem'

SkillSystems = ISystems({
    SpellSystem,
    BowSystem,
    BulletSystem
})
