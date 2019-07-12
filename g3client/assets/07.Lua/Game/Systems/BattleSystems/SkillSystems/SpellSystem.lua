--[[
法术系统
]]

SpellSystem = {}

local self = SpellSystem

self.co = nil

self.prototype = {
    [Config.EmitterType.bow] = {block = Bow, tag = Constants.emitter.bow},
}

function SpellSystem.Initialize()
    GameObjectPool.New(Constants.emitter.bow, 'Assets/Res/Prefabs/Emitter/Bow.prefab')
    BlockManager.AddListener({Cast}, self.onCastSpell)

    self.co = Coroutine.Start(self.update)
end

function SpellSystem.Shutdown()
    if self.co then
        Coroutine.Stop(self.co)
        self.co = nil
    end

    GameObjectPool.Delete(Constants.emitter.bow)
    BlockManager.RemoveListener({Cast}, self.onCastSpell)
end

-- 刷新
function SpellSystem.update()
    while true do
        local blocks = BlockManager.GetMatchedBlocks(Spell)
        local alived = false
        local removeBlocks = {}

        for i = 1, #blocks do 
            alived = self.onSpellUpdated(blocks[i])

            if not alived then
                removeBlocks[#removeBlocks + 1] = blocks[i]
            end
        end

        for i = 1, #removeBlocks do
            local emitter = removeBlocks[i].entity.tags['emitter']
            if emitter and emitter.gameObject then
                print('--------------------- remove ' .. removeBlocks[i].blockName)
                GameObjectPool.Free(emitter.gameObject)
            end

            removeBlocks[i].ownerDestroyed = true
        end

        Coroutine.Wait(1)
    end
end

-- 新增法术时
function SpellSystem.onCastSpell(cast, k, v, state, tuple)
    -- local cs = Config.Spell[spell.id]
    -- local prototype = self.prototype[cs.emitter]

    -- if not prototype or not prototype.block then
    --     return
    -- end

    -- spell.entity:AddBlock(prototype.block:New(cs, GameObjectPool.Alloc(prototype.tag)), 'emitter')
end

function SpellSystem.onSpellUpdated(block)
    return false
end