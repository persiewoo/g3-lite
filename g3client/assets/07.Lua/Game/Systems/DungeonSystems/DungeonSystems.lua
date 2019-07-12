--[[
地下城系统
]]

require 'Game.Systems.DungeonSystems.ControllerSystem'
require 'Game.Systems.DungeonSystems.DungeonInitializeSystem'
require 'Game.Systems.DungeonSystems.BehaviorSystem'
require 'Game.Systems.DungeonSystems.MovingSystem'
require 'Game.Systems.DungeonSystems.CameraSystem'
require 'Game.Systems.DungeonSystems.CreatureLocationSystem'
require 'Game.Systems.DungeonSystems.RenderingSortSystem'
require 'Game.Systems.DungeonSystems.MoveToSystem'
require 'Game.Systems.DungeonSystems.FollowingSystem'

DungeonSystems = ISystems({
    ControllerSystem,
    DungeonInitializeSystem,
    BehaviorSystem,
    MovingSystem,
    CameraSystem,
    CreatureLocationSystem,
    RenderingSortSystem,
    MoveToSystem,
    FollowingSystem,
})
