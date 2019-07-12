--[[
共享系统
]]

require 'Game.Systems.SharedSystems.DestroySystem'
require 'Game.Systems.SharedSystems.AvatarSystem'
require 'Game.Systems.SharedSystems.BehaviorTreeSystem'

SharedSystems = ISystems({
    DestroySystem,
    AvatarSystem,
    BehaviorTreeSystem,
})