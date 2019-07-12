--[[
 虚拟摇杆
]]

local Joystick = Component('__joystick__', Config.ViewConstants.node, 'Dungeon/JoystickView', 'Operation/Joystick')

local entity = Entity('joystick')

entity:AddBlock(Axis2d:New())
entity:AddBlock(Touch:New())

Joystick.entity = entity

function Joystick:OnEnable()
end

function Joystick:OnViewLoaded()
end

return Joystick