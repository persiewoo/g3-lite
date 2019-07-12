--[[
 动画显示相关
]]

local AnimationView = {}

AnimationView.args = {
	skeletonAnim = Types.SkeletonAnimation,
	animStand = Types.AnimationReferenceAsset,
	animRun = Types.AnimationReferenceAsset,
	animAttacked = Types.AnimationReferenceAsset,
	animDead = Types.AnimationReferenceAsset,
	animWinBegin = Types.AnimationReferenceAsset,
	animWinLoop = Types.AnimationReferenceAsset,
	animLoseBegin = Types.AnimationReferenceAsset,
	animLoseLoop = Types.AnimationReferenceAsset,
	animAttacks = Types.AnimationReferenceAssets,
}

local args = AnimationView.args
local anims = {}
local current = nil

function AnimationView:AwakeCS()
	args.skeletonAnim.gameObject:AddComponent(typeof(CS.SpineEventDelegate))
end

function AnimationView:Awake()
	anims[Constants.charAnimation.idle] = {anim = args.animStand, loop = true}
	anims[Constants.charAnimation.run] = {anim = args.animRun, loop = true}
	anims[Constants.charAnimation.attacked] = {anim = args.animAttacked, loop = false}

	current = Constants.charAnimation.idle

	local bridge = args.skeletonAnim.gameObject:GetComponent(typeof(CS.SpineEventDelegate))
	if bridge then
		bridge.onEnd:AddListener(function (name)
			if name ~= anims[current].anim.name then
				return
			end
			
			self.controller.onEnd = current
		end)

		bridge.onComplete:AddListener(function (name)
			if name ~= anims[current].anim.name then
				return
			end

			self.controller.onComplete = current
		end)

		bridge.onEvent:AddListener(function (name, event)
			if name ~= anims[current].anim.name then
				return
			end

			self.controller.onEvent = {anim = current, event = event}
		end)
	end
end

function AnimationView:HasAnim(animType)
	return anims[animType] and anims[animType].anim
end

function AnimationView:PlayAnimation(v)
	current = v
	if anims[v] and anims[v].anim then
		args.skeletonAnim.AnimationState:SetAnimation(0, anims[v].anim.Animation, anims[v].loop)
	else
		self.controller.onComplete = current
	end
end

function AnimationView:ChangeAttackAnims(v)
	for i = 0, args.animAttacks.Length - 1 do
		if v.prepareAnim and args.animAttacks[i].name == v.prepareAnim then
			anims[Constants.charAnimation.prepare] = {anim = args.animAttacks[i], loop = false}
		elseif v.startAnim and args.animAttacks[i].name == v.startAnim then
			anims[Constants.charAnimation.startAttack] = {anim = args.animAttacks[i], loop = false}
		elseif v.loopAnim and args.animAttacks[i].name == v.loopAnim then
			anims[Constants.charAnimation.attacking] = {anim = args.animAttacks[i], loop = true}
		elseif v.endAnim and args.animAttacks[i].name == v.endAnim then
			anims[Constants.charAnimation.endAttack] = {anim = args.animAttacks[i], loop = false}
		end
	end
end

function AnimationView:SetTimeScale(timeScale)
	args.skeletonAnim.timeScale = timeScale or 1.0
end

return AnimationView