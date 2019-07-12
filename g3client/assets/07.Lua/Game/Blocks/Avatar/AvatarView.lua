--[[
 avatar显示
]]

local AvatarView = {}

AvatarView.args = {
	skeletonAnim = Types.SkeletonAnimation,
    root = Types.GameObject,
    scale = 1
}

local args = AvatarView.args

function AvatarView:Awake()
    args.root.transform.localScale = Vector3(args.scale, args.scale, args.scale)
end

function AvatarView:Start()
end

function AvatarView:OnEnable()
end

function AvatarView:OnDisable()
end

function AvatarView:ChangeSortingOrder(order)
    args.skeletonAnim.gameObject:GetComponent(typeof(UnityEngine.MeshRenderer)).sortingOrder = order
end

function AvatarView:FlipX(flip)
    args.skeletonAnim.skeleton.FlipX = flip
end

-- 在基础缩放的情况下，再缩放
function AvatarView:Scale(ratio)
    args.scale = args.scale * ratio
    args.root.transform.localScale = Vector3(args.scale, args.scale, args.scale)
end

function AvatarView:Setup(avatar)
    self:ChangeSortingOrder(avatar.order)
    self:FlipX(avatar.flipX)
    self:Scale(avatar.scale)
end

return AvatarView