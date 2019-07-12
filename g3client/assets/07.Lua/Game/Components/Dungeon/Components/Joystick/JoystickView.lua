--[[
 虚拟摇杆界面
]]

local JoystickView = {}

JoystickView.args = {
}

local args = JoystickView.args

function JoystickView:Awake()
	local vjs = self.gameObject:GetComponent(typeof(CS.VirtualJoystick))

	if not vjs then
		error('fail to get component VirtualJoystick')
		return
	end

	vjs.owner = self
	vjs.onDragging = self.onDragging
	vjs.onTapDown = self.onTapDown
	vjs.onTapUp = self.onTapUp
end

function JoystickView:Start()
end

function JoystickView:onDragging(pos, percent)
	self.controller.entity.axis2d.offset = pos
	self.controller.entity.axis2d.percent = percent
	self.controller.entity.axis2d.dir = pos.normalized
end

function JoystickView:onTapDown(pos, percent)
	self.controller.entity.axis2d.offset = pos
	self.controller.entity.axis2d.percent = percent
	self.controller.entity.axis2d.dir = pos.normalized
	self.controller.entity.touch.state = true
end

function JoystickView:onTapUp(pos, percent)
	self.controller.entity.touch.state = false
	self.controller.entity.axis2d.percent = percent
	self.controller.entity.axis2d.dir = Vector2.zero
	self.controller.entity.axis2d.offset = pos
end

return JoystickView