--[[
 sequence 管理
]]

SequenceManager = {}

local self = SequenceManager

self.queue = {}
self.step = 0
self.state = 'idle'
self.worker = nil

function SequenceManager.Initialize()
    print('[SequenceManager] initialize')
end

function SequenceManager.Shutdown()
    print('[SequenceManager] shutdown')
end

function SequenceManager.reset()
    self.queue = {}
    self.step = 0
    self.state = 'idle'
    if self.worker then
        CSCoroutine.Stop(self.worker)
        self.worker = nil
    end
end

function SequenceManager.Start()
    self.step = #self.queue > 0 and 1 or 0
    if self.step == 0 then
        return
    end

    self.state = 'running'
    self.worker = CSCoroutine.Start(function ()
        print('[SequenceManager] worker start')

        local seqs = self.queue
        local total = #seqs

        coroutine.yield(Delay.wait500MilliSeconds)

        while self.step > 0 and self.step <= total do
            local task = seqs[self.step]
            if task.state == 'idle' then
                task:Start()
            elseif task.state == 'running' then
                coroutine.yield(Delay.wait10MilliSeconds)
            elseif task.state == 'finished' then
                self.step = self.step + 1
                coroutine.yield(Delay.wait10MilliSeconds)
            else
                error('[SequenceManager] worker fatal exception')
                break
            end
        end

        print('[SequenceManager] run end')
        self.reset()
    end)
end

-- 添加序列
function SequenceManager.AddSeq(order, seq)
    if seq.__signature__ ~= '__sequence_signature__' then
        error('[SequenceManager] add invalid seq ' .. (seq.name and seq.name or '__invalid_seq__'))
        return
    end

    seq.order = order
    self.queue[#self.queue + 1] = seq

    table.sort(self.queue, function (l, r)
        return l.order > r.order
    end)
end