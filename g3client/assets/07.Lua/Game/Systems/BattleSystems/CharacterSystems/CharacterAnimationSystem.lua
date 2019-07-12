--[[
角色动作系统
]]

CharacterAnimationSystem = {}

local self = CharacterAnimationSystem

function CharacterAnimationSystem.Initialize()
	BlockManager.AddListener({CharacterAI, Animation, filter = {CharacterAI}}, self.onCharacterStateChanged)
	BlockManager.AddListener({Animation, CharacterAI, Skill, Cast, filter = {Animation}}, self.onAnimationChanged)
	BlockManager.AddListener({Skill, Animation, CharacterAI, filter = {Skill}}, self.onSkillChanged)
end

function CharacterAnimationSystem.Shutdown()
	BlockManager.RemoveListener({CharacterAI, Animation}, self.onCharacterStateChanged)
	BlockManager.RemoveListener({Animation, CharacterAI, Skill, Cast}, self.onAnimationChanged)
	BlockManager.RemoveListener({Skill, Animation, CharacterAI}, self.onSkillChanged)
end

-- 根据角色状态调整动画
function CharacterAnimationSystem.onCharacterStateChanged(characterAI, k, v, state, tuple)
	if k == 'state' then
		if v == Constants.charState.idle then
			tuple.animation.view:PlayAnimation(Constants.charAnimation.idle)
		elseif v == Constants.charState.enter then
			tuple.animation.view:PlayAnimation(Constants.charAnimation.run)
		elseif v == Constants.charState.fighting then
			tuple.animation.view:PlayAnimation(Constants.charAnimation.idle)
		end
	elseif k == 'moving' then
		if v then
			tuple.animation.view:PlayAnimation(Constants.charAnimation.run)
		else
			tuple.animation.view:PlayAnimation(Constants.charAnimation.idle)
		end
	elseif k == 'attackState' then
		if v == Constants.attackState.idle then
			tuple.animation.view:PlayAnimation(Constants.charAnimation.idle)
		end
	end
end

-- 监听动画改变
function CharacterAnimationSystem.onAnimationChanged(animation, k, v, state, tuple)
	if k == 'onEnd' then
	elseif k == 'onComplete' then
		if tuple.characterAI.state == Constants.charState.fighting then
			local hasNext = false
			if Constants.anim2NextState[v] then
				for i = Constants.anim2NextState[v], Constants.attackState.finish do
					if Constants.state2AtkAnim[i] and tuple.animation.view:HasAnim(Constants.state2AtkAnim[i]) then
						tuple.characterAI.attackState = i
						tuple.animation.view:PlayAnimation(Constants.state2AtkAnim[i])
						hasNext = true
						break
					end
				end
			end

			-- 动作已经结束
			if not hasNext then
				tuple.characterAI.attackState = Constants.attackState.idle
			end
		end
    elseif k == 'onEvent' then
        if v.event.Name == 'fire' then
            tuple.cast.target = tuple.skill.target
        	tuple.cast.skill = tuple.skill.current
        end
	end
end

-- 技能改变时，根据配置修改攻击动作，并准备进入下一个攻击状态
function CharacterAnimationSystem.onSkillChanged(block, k, v, state, tuple)
	if k == 'current' then
		tuple.animation.view:ChangeAttackAnims({startAnim = v.startAnim, loopAnim = v.loopAnim, endAnim = v.endAnim})

		-- 根据技能的动作，选择有效的攻击状态
        for i = Constants.attackState.prepare, Constants.attackState.finish do
            if Constants.state2AtkAnim[i] and tuple.animation.view:HasAnim(Constants.state2AtkAnim[i]) then
                tuple.characterAI.attackState = i
                tuple.animation.view:PlayAnimation(Constants.state2AtkAnim[i])
                break
            end
        end
	end
end