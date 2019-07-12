--[[
战斗相关的服务
]]

BattleKeeper = {}

local self = BattleKeeper

self.map = nil
self.entity = nil
self.orders = {1, 4, 2, 5, 3, 6, 1, 4, 2, 5, 3, 6}

-- 创建战斗地图
function BattleKeeper.LoadMap(id, sync, handler)
    local path = 'Assets/Res/Prefabs/Battle/BattleMap.prefab'

    local onFinished = function (prefab)
        local go = GameObject.Instantiate(prefab)

        go.transform.localPosition = Vector3.zero
        go.name = 'battleMap' .. id

        self.map = go

        if handler then
            handler(self.map)
        end
    end

    if sync then
        ResourceManager:LoadAsset(path, onFinished)
    else
        ResourceManager:LoadAssetAsync(path, onFinished)
    end
end

-- 获取角色起始位置
function BattleKeeper.GetStartPosition(team, index)
    return self.entity.battleMap.view:GetStartPoses(team)[index]
end

-- 获取角色目标位置
function BattleKeeper.GetTargetPosition(team, index)
    return self.entity.battleMap.view:GetPoses(team)[index]
end

function BattleKeeper.CreateBattle(id)
    local path = 'Assets/Res/Prefabs/Battle/BattleAI.prefab'

    ResourceManager:LoadAsset(path, function (prefab)
        local go = GameObject.Instantiate(prefab)

        self.entity = Entity('battle')
        self.entity:AddBlock(Battle:New())
        self.entity:AddBlock(BattleAI:New({gameObject = go}))
        self.entity:AddBlock(BattleMap:New({gameObject = self.map, config = Config.BattleMap[id]}))
    end)
end

-- 重置战斗系统
function BattleKeeper.Reset()
    self.map = nil

    if self.entity then
        self.entity.destroyed = true
        self.entity = nil
    end
end

-- 获取渲染顺序
function BattleKeeper.GetAvatarOrder(index)
    return self.orders[index]
end
