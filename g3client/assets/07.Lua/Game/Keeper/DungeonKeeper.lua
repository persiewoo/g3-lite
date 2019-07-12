--[[
地下城相关的服务
]]

DungeonKeeper = {}

local self = DungeonKeeper

self.root = nil
self.creatureRef = 1
self.creatures = {}

function DungeonKeeper.CreateDungeonPlayer(id, sync, onLoaded)
    local c = Config.Character[id]
    local ac = Config.Avatar[c.avatar]
    local path = ac.dpath

    local onFinished = function (prefab)
        local go = GameObject.Instantiate(prefab)
        go.transform:SetParent(self.root, false)
        go.name = c.name .. ':' .. id

        go.transform:SetParent(go.transform, false)
        go.transform.localPosition = Vector3.zero
        
        local entity = Entity(go.name)

        entity:AddBlock(Creature:New({id = id}))
        entity:AddBlock(Avatar:New({config = ac, gameObject = go.transform:Find('Avatar').gameObject}))
        entity:AddBlock(Animation:New({gameObject = go.transform:Find('Animation').gameObject}))
        entity:AddBlock(Body2d:New({gameObject = go.transform:Find('Physical').gameObject}))
        entity:AddBlock(AIBT:New({gameObject = go.transform:Find('AI').gameObject}))
        entity:AddBlock(DgCreatureActions:New({gameObject = go.transform:Find('Actions').gameObject}))
        entity:AddBlock(Location:New({gameObject = go}))
        entity:AddBlock(Behavior:New())
        entity:AddBlock(Moving:New())
        entity:AddBlock(Controllable:New({type = 0, enable = true}))

        if onLoaded then
            onLoaded(entity)
        end

        self.creatures[tostring(0)] = entity
    end

    if sync then
        ResourceManager:LoadAsset(path, onFinished)
    else
        ResourceManager:LoadAssetAsync(path, onFinished)
    end
end

-- 创建一堆怪物
function DungeonKeeper.CreateMonster(id, sync, onLoaded)
    local c = Config.Character[id]
    local ac = Config.Avatar[c.avatar]
    local path = ac.dpath

    print('--------------- load monster ' .. path)

    local onFinished = function (prefab)
        local go = GameObject.Instantiate(prefab)
        local creatureId = self.creatureRef
        go.transform:SetParent(self.root, false)
        go.name = c.name .. ':' .. id .. ':' .. creatureId

        self.creatureRef = self.creatureRef + 1

        go.transform:SetParent(go.transform, false)
        go.transform.localPosition = Vector3.zero
        
        local entity = Entity(go.name)

        entity:AddBlock(Creature:New({id = id}))
        entity:AddBlock(Avatar:New({config = ac, gameObject = go.transform:Find('Avatar').gameObject}))
        entity:AddBlock(Animation:New({gameObject = go.transform:Find('Animation').gameObject}))
        entity:AddBlock(Body2d:New({gameObject = go.transform:Find('Physical').gameObject}))
        entity:AddBlock(AIBT:New({gameObject = go.transform:Find('AI').gameObject}))
        entity:AddBlock(DgCreatureActions:New({gameObject = go.transform:Find('Actions').gameObject, creatureId = creatureId}))
        entity:AddBlock(Location:New({gameObject = go}))
        entity:AddBlock(Behavior:New())
        entity:AddBlock(Moving:New())

        if onLoaded then
            onLoaded(entity)
        end

        self.creatures[tostring(creatureId)] = entity 
    end

    if sync then
        ResourceManager:LoadAsset(path, onFinished)
    else
        ResourceManager:LoadAssetAsync(path, onFinished)
    end
end

function DungeonKeeper.Reset()
    for k, v in pairs(self.creatures) do
        v.destroyed = true
    end

    self.root = nil
    self.creatureRef = 1
    self.creatures = {}
end

function DungeonKeeper.GetCreature(creatureId)
    return self.creatures[tostring(creatureId)]
end

function DungeonKeeper.GetPlayer()
    return self.creatures[tostring(0)]
end