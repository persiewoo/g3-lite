--[[
 道具栏
]]

local InventoryBar = Component('__inventory_bar__', Config.ViewConstants.node, 'Dungeon/InventoryBarView', 'Operation/Inventorys')

function InventoryBar:OnEnable()
end

function InventoryBar:OnViewLoaded()
    self.cells.Inventory:SetCapacity(6, function (item, i)
    end,
    function (item, i)
        item:StartRendered()
    end)
end

return InventoryBar