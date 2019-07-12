--[[
Sequence基本模式
]]

Sequence = Class()

Sequence.__signature__ = '__sequence_signature__'
Sequence.name = '__undefined_sequence__'
Sequence.order = 1
Sequence.state = 'idle'

-- 任务启动
function Sequence:Start()
    print('[Sequence] sequence {' .. self.name .. '} startup')
    self.state = 'running'
    self:OnStart()
end

function Sequence:OnStart()
    error('[Sequence] sequence {' .. self.name .. '} redefine OnStart pls')
end

-- 清理任务
function Sequence:Cleanup()
    print('[Sequence] sequence {' .. self.name .. '} cleanup')
end

function Sequence:OnFinished()
    self.state = 'finished'
    print('[Sequence] sequence {' .. self.name .. '} finished')
end
