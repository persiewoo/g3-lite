--[[
道具界面
]]

local InventoryView = {}

InventoryView.args = {
    btnItem = Types.Button
}

local args = InventoryView.args

function InventoryView:Awake()
    args.btnItem.onClick:AddListener(function ()
        print('--------- i am clicked ----------')
    end)
end

return InventoryView