--[[
对战系统
]]

require 'Game.Systems.BattleSystems.BattleInitializeSystem'
require 'Game.Systems.BattleSystems.BattleStateSystem'
require 'Game.Systems.BattleSystems.CharacterSystems.CharacterSystems'
require 'Game.Systems.BattleSystems.SkillSystems.SkillSystems'

BattleSystems = ISystems({
    BattleInitializeSystem,
    BattleStateSystem,
    CharacterSystems,
    SkillSystems
})
