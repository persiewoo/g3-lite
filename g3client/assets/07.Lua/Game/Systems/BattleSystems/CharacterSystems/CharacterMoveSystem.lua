--[[
角色移动系统
]]

CharacterMoveSystem = {}

local self = CharacterMoveSystem

function CharacterMoveSystem.Initialize()
	BlockManager.AddListener({MoveTo, CharacterAI, Location, filter = {MoveTo}}, self.onCharacterMove)
	BlockManager.AddListener({MoveTo}, self.onMoveDeleted, {BlockState.deleted})
end

function CharacterMoveSystem.Shutdown()
	BlockManager.RemoveListener({MoveTo, CharacterAI, Location}, self.onCharacterMove)
	BlockManager.RemoveListener({MoveTo}, self.onMoveDeleted)
end

function CharacterMoveSystem.onCharacterMove(block, k, v, state, tuple)
	if k ~= 'position' then
		return
	end

	local co = tuple.moveTo.co
	local to = tuple.moveTo.position
	local speed = tuple.moveTo.speed

	co.v = Coroutine.Start(function ()
		local from = tuple.location.position
		local dt = (to - tuple.location.positon).magnitude / speed
		if dt > 0 then
			tuple.characterAI.moving = true
			
			local startDt = TimeManager.seconds
			local invDt = 1 / dt

			while TimeManager.seconds - startDt < dt do
				tuple.location.position = Vector3.Lerp(from, to, (TimeManager.seconds - startDt) * invDt)
				Coroutine.Step()
			end

			tuple.location.position = to
			tuple.characterAI.moving = false
		end

		Coroutine.Stop(co.v)
		co.v = nil
	end)
end

function CharacterMoveSystem.onMoveDeleted(moveTo, k, v)
	if moveTo.co.v then
		Coroutine.Stop(moveTo.co.v)
		moveTo.co.v = nil
	end
end
