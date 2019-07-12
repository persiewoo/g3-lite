--[[
角色初始化系统
]]

CharacterInitializeSystem = {}

local self = CharacterInitializeSystem

function CharacterInitializeSystem.Initialize()
	BlockManager.AddListener({Creature, Location, Avatar, CharacterAI}, self.onAddCharacter, {BlockState.added})
end

function CharacterInitializeSystem.Shutdown()
	BlockManager.RemoveListener({Creature, Location, Avatar, CharacterAI}, self.onAddCharacter)
end

function CharacterInitializeSystem.onAddCharacter(block, k, v, state, tuple)
	local team = tuple.characterAI.team
	local index = tuple.characterAI.index

	tuple.location.position = BattleKeeper.GetStartPosition(team, index)
	tuple.avatar.order = BattleKeeper.GetAvatarOrder(index)
	tuple.avatar.flipX = (team == Constants.team.down)

	CharacterKeeper.AddCharacter(tuple.creature, team, index)
end