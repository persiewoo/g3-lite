--[[
角色状态系统
]]

CharacterStateSystem = {}

local self = CharacterStateSystem

function CharacterStateSystem.Initialize()
    BlockManager.AddListener({CharacterAI, MoveTo, Creature, filter = {CharacterAI}}, self.onCharacterStateChanged)
    BlockManager.AddJunctorListener({CharacterAI, BattleAI}, self.onCharacterAIChanged)
end

function CharacterStateSystem.Shutdown()
    BlockManager.RemoveListener({CharacterAI, MoveTo, Creature}, self.onCharacterStateChanged)
    BlockManager.RemoveListener({CharacterAI, BattleAI}, self.onCharacterAIChanged)
end

function CharacterStateSystem.onCharacterStateChanged(characterAI, k, v, state, tuple)
    if k ~= 'state' then
        return
    end

    -- 如果是进场
    if v == Constants.charState.enter then
        tuple.moveTo.speed = tuple.creature.speed
        tuple.moveTo.position = BattleKeeper.GetTargetPosition(characterAI.team, characterAI.index)
    end
end

function CharacterStateSystem.onCharacterAIChanged(block, k, v, state, tuple)
    if block:TypeOf(BattleAI) and k == 'state' then
        tuple.characterAI.view:StateChanged('battleState', v)
    elseif block:TypeOf(CharacterAI) then
        tuple.characterAI.view:StateChanged(k, v)
    end
end