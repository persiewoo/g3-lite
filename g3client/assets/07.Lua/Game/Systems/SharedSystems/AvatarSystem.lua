--[[
avatar系统
]]

AvatarSystem = {}

local self = AvatarSystem

function AvatarSystem.Initialize()
    BlockManager.AddListener({Avatar}, self.onAvatarChanged, {BlockState.added, BlockState.changed})
end

function AvatarSystem.Shutdown()
    BlockManager.RemoveListener({Avatar}, self.onAvatarChanged)
end

function AvatarSystem.onAvatarChanged(avatar, k, v, state)
    if state == BlockState.added then
        avatar.view:Setup(avatar)
        return
    end

    if k == 'order' then
        avatar.view:ChangeSortingOrder(v)
    elseif k == 'flipX' then
        avatar.view:FlipX(v)
    elseif k == 'scale' then
        avatar.view:Scale(v)
    end
end