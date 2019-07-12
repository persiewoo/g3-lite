--[[
 block 链接器，将非直接关联的block组合关联 
]]

local junctors = {}

function Junctor (name, pattern)
    local junctor = {}

    junctor.name = name
    junctor.blocks = {}
    
    for i = 1, #pattern do
        if pattern[i].__signature__  == blockSignature then
            junctor.blocks[#junctor.blocks + 1] = pattern[i]
        else
            error('fail to add invalid block to junctor, index ' .. i)
        end 
    end

    if #junctor.blocks > 0 then
        BlockManager.onJunctorAlloced(junctor)
    end

    junctors[junctor] = junctor

    -- 链接器模式匹配
    junctor.TypeOf = function (self, blocks)
        if #self.blocks == 0 or #self.blocks ~= #blocks then
            return false
        end

        for i = 1, #self.blocks do
            if not self.blocks[i]:TypeOf(blocks[i]) then
                return false
            end
        end

        return true
    end

    -- 是否拥有指定的block
    junctor.HasBlock = function (self, blk)
        for i = 1, #self.blocks do
            if self.blocks[i] == blk then
                return true
            end
        end

        return false
    end

    junctor.Destroy = function (self)
        BlockManager.onJunctorFreed(self)
        self.blocks = nil
        junctors[self] = nil
    end

    junctor.toTuple = function (self)
        local tuple = {}

        for i = 1, #self.blocks do
            tuple[self.blocks[i].blockName] = self.blocks[i]
        end

        return tuple
    end

    return junctor
end

-- 获取所有的链接器
function GetJunctors()
    local js = {}

    for k, v in pairs(junctors) do
        js[#js + 1] = v
    end

    return js
end