--[[
 弓箭发射器的View
]]

local BowView = {}

BowView.args = {
    bullet = Types.GameObject,
    target = Types.GameObject,
    offset = Types.Vector2,
    rotation = Types.Vector2,
}

local args = BowView.args

function BowView:Start()
end

function BowView:OnEnable()
end

function BowView:OnDisable()
end

return BowView