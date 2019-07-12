--[[
 玩家状态
]]

local PlayerState = Component('__player_state__', Config.ViewConstants.node, 'Dungeon/PlayerStateView', 'PlayerState')

function PlayerState:OnEnable()
end

function PlayerState:OnViewLoaded()
end

return PlayerState