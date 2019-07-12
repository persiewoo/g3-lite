--[[
 角色AI信息
]]

CharacterAI = Block('characterAI', {
    state = Constants.charState.idle,
    attackState = Constants.attackState.idle,
    attackable = true,
    moving = false,
    team = Constants.team.up,
    index = 0
}, 'CharacterAIView')