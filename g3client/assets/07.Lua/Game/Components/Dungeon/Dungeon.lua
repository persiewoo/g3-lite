--[[
 副本
]]

local Dungeon = Component('__dungeon__', Config.ViewConstants.top, 'Dungeon/DungeonView', 'Base')

function Dungeon:OnEnable()
end

function Dungeon:OnViewLoaded()
    self.Joystick:Active()
    self.InventoryBar:Active()
    self.PlayerState:Active()
end

return Dungeon