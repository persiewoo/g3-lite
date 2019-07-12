--[[
 GameObject 池，减少频繁创建删除
]]

GameObjectPool = {}

local self = GameObjectPool

self.chunks = {}

-- 初始化
function GameObjectPool.Initialize()
    self.root = GameObject('GameObjectPool').transform
    DontDestroyOnLoad(self.root)
end

-- 关闭
function GameObjectPool.Shutdown()
    if self.root then
        GameObject.Destroy(self.root)
    end

    self.chunks = {}
end

-- 新建对象池
function GameObjectPool.New (tag, path, initor)
    if not path then
        error('invalid path for pool ' .. tag .. ', confirm pls')
        return
    end

    if self.chunks[tag] then
        error('pool tag ' .. tag .. ' has exist, confirm pls')
        return nil
    end

    local chunkRoot = GameObject(tag).transform
    chunkRoot:SetParent(self.root, false)

    self.chunks[tag] = {items = {}, root = chunkRoot, path = path, prefab = nil, initor = initor, ref = 1}
end

-- 删除对象池
function GameObjectPool.Delete(tag)
    local chunk = self.chunks[tag]
    
    if not chunk then
        error ('invalid pool ' .. tag .. ' for delete')
        return
    end

    if chunk.root then
        GameObject.Destroy(chunk.root.gameObject)
    end

    self.chunks[tag] = nil
end

-- 分配
function GameObjectPool.Alloc (tag, ...)
    local chunk = self.chunks[tag]

    if not chunk then
        error('invalid pool tag ' .. tag .. ', confirm pls')
        return nil
    end

    local item = nil
    if #chunk.items == 0 then
        if not chunk.prefab then
            chunk.prefab = ResourceManager:LoadAsset(chunk.path)

            if not chunk.prefab then
                warn('fail to load prefab ' .. chunk.path)
                return 
            end
        end

        item = GameObject.Instantiate(chunk.prefab)
        item.name = tag .. ':' .. chunk.ref
        chunk.ref = chunk.ref + 1
    else
        item = chunk.items[1]
        table.remove(chunk.items, 1)
    end

    if item then
        item:SetActive(true)
        item.transform:SetParent(nil, false)

        if chunk.initor then
            chunk.initor(item, ...)
        end
    end

    return item
end

-- 释放
function GameObjectPool.Free (item)
    local strs = Split(item.name, "([^':']+)")
    local chunk = nil
    if #strs == 0 then
        error('invalid pool item ' .. item.name .. ' for free')
        return
    end

    chunk = self.chunks[strs[1]]
    if not chunk then
        error('invalid pool ' .. strs[1] .. ' for free')
        return
    end

    item.transform:SetParent(chunk.root, false)
    item:SetActive(false)

    chunk.items[#chunk.items + 1] = item
end