--[[
 物理刚体
]]

local Body2dView = {}

Body2dView.args = {
    rigidbody = Types.Rigidbody2D
}

local args = Body2dView.args

-- 移动到位置
function Body2dView:MoveTo(pos)
    args.rigidbody:MovePosition(pos)
    local pos = self.gameObject.transform.position
    return Vector2(pos.x, pos.y)
end

return Body2dView