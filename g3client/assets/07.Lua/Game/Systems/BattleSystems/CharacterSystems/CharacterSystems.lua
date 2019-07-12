--[[
角色系统
]]

require 'Game.Systems.BattleSystems.CharacterSystems.CharacterInitializeSystem'
require 'Game.Systems.BattleSystems.CharacterSystems.CharacterAnimationSystem'
require 'Game.Systems.BattleSystems.CharacterSystems.CharacterAttackStateSystem'
require 'Game.Systems.BattleSystems.CharacterSystems.CharacterStateSystem'
require 'Game.Systems.BattleSystems.CharacterSystems.CharacterMoveSystem'
require 'Game.Systems.BattleSystems.CharacterSystems.CharacterLocationSystem'

CharacterSystems = ISystems({
    CharacterInitializeSystem,
    CharacterAnimationSystem,
    CharacterAttackStateSystem,
    CharacterStateSystem,
    CharacterMoveSystem,
    CharacterLocationSystem,
})