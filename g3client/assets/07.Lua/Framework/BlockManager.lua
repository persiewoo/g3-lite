--[[
 BlockManager
]]

BlockManager = {}

blockSignature = '__this_is_block__'

local self = BlockManager

self.blockListeners = {}
self.blocks = {}
self.junctors = {}
self.destroyListeners = {}

-- block状态
BlockState = {
    added = 1,
    changed = 2,
    deleted = 3,
    all = 4
}

-- block改变时触发
function BlockManager.onBlockChanged (block, k, v, state)
    local listeners = self.blockListeners[block.blockName]
    for i = 1, #listeners do
        local pass = 0

        -- 过滤事件
        if not listeners[i].states[state] then
            pass = 1
        end

        -- 过滤不感兴趣感兴趣的组件
        if pass == 0 and listeners[i].filters and not self.includeTypeOf(listeners[i].filters, block) then
            pass = 2
        end

        if pass == 0 then
            -- 检查entity是否拥有指定block列表
            if listeners[i].blocks then
                if not block.entity.hasDestroyed and block.entity:hasBlocks(listeners[i].blocks) then
                    listeners[i].listener(block, k, v, state, self.entity2Tuple(block.entity, listeners[i].blocks))
                end
            -- junctor 模式
            elseif listeners[i].junctor then
                local junctors = self.getTargetJunctors(block, listeners[i].junctor)
                for j = 1, #junctors do
                    listeners[i].listener(block, k, v, state, junctors[j]:toTuple())
                end
            end
        end
    end
end

-- 准备进行entity释放
function BlockManager.onTryEntityDestroy(entity, block)
    local handlered = false

    for i = 1, #self.destroyListeners do
        local dl = self.destroyListeners[i]
        if #dl.blocks == 0 or entity:hasBlocks(dl.blocks) then
            dl.listener(entity, block)
            handlered = true
        end
    end

    -- 如果任何系统捕捉，则框架主动释放
    if not handlered then
        entity:Destroy()
    end
end

-- 注册
function BlockManager.register(name)
    if self.blockListeners[name] then
        error('block ' .. name ..  ' has existed!')
        return nil
    end

    self.blockListeners[name] = {}
    self.blocks[name] = {}
    self.junctors[name] = {}
end

-- block 创建时
function BlockManager.onBlockAlloced(blk)
    local blocks = self.blocks[blk.blockName]
    if not blocks then
        return
    end

    blocks[#blocks + 1] = blk
end

-- block 被删除时
function BlockManager.onBlockFreed(blk)
    local blocks = self.blocks[blk.blockName]
    if not blocks then
        return
    end

    for i = 1, #blocks do
        if blocks[i] == blk then
            table.remove(blocks, i)
            return
        end
    end
end

-- junctor 分配时
function BlockManager.onJunctorAlloced(junctor)
    -- 同一个block可以被关联到多个junctor中
    for i = 1, #junctor.blocks do
        local block = junctor.blocks[i]
        local refs = self.junctors[block.blockName][block]
        
        if not refs then
            refs = {}
            self.junctors[block.blockName][block] = refs
        end

        refs[#refs + 1] = junctor
    end
end

-- junctor 释放时
function BlockManager.onJunctorFreed(junctor)
    for i = 1, #junctor.blocks do
        local block = junctor.blocks[i]
        local refs = self.junctors[block.blockName][block]
        
        for j = 1, #refs do
            if refs[j] == junctor then
                table.remove(refs, j)
                break
            end
        end
    end
end

-- 模式匹配，并且指定block存在
function BlockManager.getTargetJunctors(block, junctor)
    local junctors = {}
    local refs = self.junctors[block.blockName][block]
    if not refs then
        return junctors
    end

    for i = 1, #refs do
        if refs[i]:TypeOf(junctor) then 
            junctors[#junctors + 1] = refs[i]
        end
    end

    return junctors
end

-- 获取同类的block列表
function BlockManager.GetMatchedBlocks(blk)
    return self.blocks[blk.blockName]
end

-- 获取同时拥有多种block的entity，并返回block列表
function BlockManager.GetMatchedTuples(blks)
    if not blks or #blks == 0 then
        return {}
    end

    local blocks = self.blocks[blks[1].blockName]
    if not blocks then
        return {}
    end

    local targets = {}

    for i = 1, #blocks do
        if blocks[i].entity:hasBlocks(blks) then
            targets[#targets + 1] = self.entity2Tuple(blocks[i].entity, blks)
        end
    end

    return targets
end

-- 添加Block监听
function BlockManager.AddListener (blocks, listener, states)
    if not listener then
        error('listener invalid, confirm pls')
        return
    end

    local newStates = {}

    newStates[BlockState.changed] = true
    if states and #states > 0 then
        newStates = {}
        for i = 1, #states do
            if states[i] == BlockState.all then
                newStates = {true, true, true}
                break
            else
                newStates[states[i]] = true
            end
        end
    end

    local filters = nil

    if blocks.filter and type(blocks.filter) == 'table' and #blocks.filter > 0 then
        filters = blocks.filter
    end

    for i = 1, #blocks do
        if blocks[i].__signature__ ~= blockSignature then
            error('it is not a block, confirm pls')
            return
        end

        local listeners = self.blockListeners[blocks[i].blockName]
        
        for j = 1, #listeners do
            local checkPattern = self.isTypeOf(listeners[j].blocks, blocks) or self.isTypeOf(listeners[j].junctor, blocks)

            if checkPattern and listeners[j].listener == listener then
                error('block ' .. blocks[i].blockName .. ' has same listener')
                return
            end
        end

        listeners[#listeners + 1] = {blocks = blocks, listener = listener, states = newStates, filters = filters}
    end
end

function BlockManager.AddJunctorListener(junctor, listener, states)
    if not listener then
        error('listener invalid, confirm pls')
        return
    end

    local newStates = {}

    newStates[BlockState.changed] = true
    if states and #states > 0 then
        newStates = {}
        for i = 1, #states do
            if states[i] == BlockState.all then
                newStates = {true, true, true}
                break
            else
                newStates[states[i]] = true
            end
        end
    end

    local filters = nil

    if junctor.filter and type(junctor.filter) == 'table' and #junctor.filter > 0 then
        filters = junctor.filter
    end

    for i = 1, #junctor do
        if junctor[i].__signature__ ~= blockSignature then
            error('it is not a block, confirm pls')
            return
        end

        local listeners = self.blockListeners[junctor[i].blockName]
        
        for j = 1, #listeners do
            local checkPattern = self.isTypeOf(listeners[j].blocks, blocks) or self.isTypeOf(listeners[j].junctor, junctor)

            if checkPattern and listeners[j].listener == listener then
                error('block ' .. junctor[i].blockName .. ' has same listener')
                return
            end
        end

        listeners[#listeners + 1] = {junctor = junctor, listener = listener, states = newStates, filters = filters}
    end
end

-- 删除Block监听
function BlockManager.RemoveListener (blocks, listener)
    for i = 1, #blocks do
        local listeners = self.blockListeners[blocks[i].blockName]

        for j = 1, #listeners do
            local checkPattern = self.isTypeOf(listeners[j].blocks, blocks) or self.isTypeOf(listeners[j].junctor, blocks)
            if checkPattern and listeners[j].listener == listener then
                table.remove(listeners, j)
                break
            end
        end
    end
end

-- 监听对象删除, 空block代表匹配所有
function BlockManager.AddDestroyListener(blocks, listener)
    if not listener or not blocks then
        error('listener or blocks invalid, confirm pls')
        return
    end

    self.destroyListeners[#self.destroyListeners + 1] = {blocks = blocks, listener = listener}
end

-- 取消对象删除监听
function BlockManager.RemoveDestroyListener(blocks, listener)
    if not blocks then
        return
    end

    for i = 1, #self.destroyListeners do
        local listeners = self.destroyListeners[i]

        if #listeners[i].blocks == 0 and #blocks == 0 and listeners[i].listener == listener then
            table.remove(listeners, i)
            break
        elseif self.isTypeOf(listeners[i].blocks, blocks) and listeners[j].listener == listener then
            table.remove(listeners, i)
            break
        end
    end
end

-- 模式匹配
function BlockManager.isTypeOf(lblks, rblks)
    if not lblks or not rblks or #lblks == 0 or #lblks ~= #rblks then
        return false
    end

    for i = 1, #lblks do
        if not lblks[i]:TypeOf(rblks[i]) then
            return false
        end
    end

    return true
end

function BlockManager.includeTypeOf(blocks, blk)
    for i = 1, #blocks do
        if blocks[i]:TypeOf(blk) then
            return true
        end
    end

    return false
end

-- 从entity获取指定的元组
function BlockManager.entity2Tuple(entity, blocks)
    local tuple = {}

    for i = 1, #blocks do
        tuple[blocks[i].blockName] = entity[blocks[i].blockName]
    end

    return tuple
end