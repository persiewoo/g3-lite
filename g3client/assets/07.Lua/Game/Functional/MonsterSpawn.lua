--[[
 怪物生成器
]]

local MonsterSpawn = {}

MonsterSpawn.args = {
    charId = 0,
    minNum = 0,
    maxNum = 0,
    range = 10,

    -- 警戒范围
    guardRange = 20,

    -- 追击距离
    pursueRange = 50,
}

local args = MonsterSpawn.args

function MonsterSpawn:Awake()
    self:Spawn()
end

-- 生成怪物
function MonsterSpawn:Spawn()
    Coroutine.Start(function ()
        local num = math.random(args.minNum, args.maxNum)
        local entities = {}

        for i = 1, num do
            DungeonKeeper.CreateMonster(math.floor(args.charId), true, function (entity)
                local bornPos = Vector2(self.gameObject.transform.position.x, self.gameObject.transform.position.y)

                entity.location.manual = true
                entity.location.position = bornPos
                entity.location.manual = false

                -- 出生位置
                entity.dgCreatureActions.bornPosition = bornPos
                entity.dgCreatureActions.guardRange = args.guardRange
                entity.dgCreatureActions.pursueRange = args.pursueRange

                entities[#entities + 1] = entity
            end)
        end

        while #entities < num do
            Coroutine.Step()
        end

        Coroutine.Step()

        -- 所有怪物都创建成功，激活行为树
        for i = 1, num do
            entities[i].aibt.enable = true
        end
    end)
end

return MonsterSpawn