--[[
角色控制系统
]]

ControllerSystem = {}

local self = ControllerSystem

local function getRatio(config, percent)
    return math.clamp(percent + config.speedRatio[1], 0, config.speedRatio[2])
end

function ControllerSystem.Initialize()
    BlockManager.AddListener({Axis2d, Touch}, self.onTouchStateChanged)
end

function ControllerSystem.Shutdown()
    BlockManager.RemoveListener({Axis2d, Touch}, self.onTouchStateChanged)
end

function ControllerSystem.onTouchStateChanged(block, k, v, state, tuple)
    local targets = BlockManager.GetMatchedTuples({Controllable, Behavior, Avatar, Moving})
    if not targets or #targets == 0 then
        warn('invalid controllable target')
        return
    end

    local avatar = targets[1].avatar

    if block:TypeOf(Touch) then
        if tuple.touch.state then
            targets[1].behavior.state = Constants.behavior.run
            targets[1].moving.dir = tuple.axis2d.dir
            targets[1].moving.timeScale = getRatio(avatar.config, tuple.axis2d.percent)
            targets[1].moving.speed =  avatar.config.baseSpeed * targets[1].moving.timeScale
        else
            targets[1].behavior.state = Constants.behavior.idle
            targets[1].moving.dir = Vector2.zero
            targets[1].moving.timeScale = 1.0
            targets[1].moving.speed = 0
        end
    elseif tuple.axis2d.offset.x ~= 0 then
        targets[1].avatar.flipX = tuple.axis2d.offset.x < 0
        targets[1].moving.dir = tuple.axis2d.dir
            
        if tuple.touch.state then
            targets[1].moving.timeScale = getRatio(avatar.config, tuple.axis2d.percent)
        else
            targets[1].moving.timeScale = 1
        end

        targets[1].moving.speed = avatar.config.baseSpeed * targets[1].moving.timeScale
    end
end