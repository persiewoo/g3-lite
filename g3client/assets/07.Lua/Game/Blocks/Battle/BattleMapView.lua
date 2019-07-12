--[[
 战斗地图显示
]]

local BattleMapView = {}

BattleMapView.args = {
	srdUp = Types.SpriteRenderer,
	srdDown = Types.SpriteRenderer,
	upPoses = Types.Transforms,
	downPoses = Types.Transforms,
	upStartPoses = Types.Transforms,
	downStartPoses = Types.Transforms,
}

local args = BattleMapView.args

function BattleMapView:Awake()
end

function BattleMapView:Start()
end

-- 返回指定区域的坐标集（世界坐标）
function BattleMapView:GetPoses(team)
	local poses = {}

	if team == Constants.team.up then
		for i = 0, args.upPoses.Length - 1 do
			poses[#poses + 1] = args.upPoses[i].position
		end
	elseif team == Constants.team.down then
		for i = 0, args.downPoses.Length - 1 do
			poses[#poses + 1] = args.downPoses[i].position
		end
	end

	return poses
end


-- 返回指定区域的开始坐标集（世界坐标）
function BattleMapView:GetStartPoses(team)
	local poses = {}

	if team == Constants.team.up then
		for i = 0, args.upStartPoses.Length - 1 do
			poses[#poses + 1] = args.upStartPoses[i].position
		end
	elseif team == Constants.team.down then
		for i = 0, args.downStartPoses.Length - 1 do
			poses[#poses + 1] = args.downStartPoses[i].position
		end
	end

	return poses
end

-- 设置地图信息
function BattleMapView:SetMap(c)
	local path = 'Assets/Res/Images/BattleMap/' .. c.path .. '.png'
	local spr = ResourceManager:LoadSprite(path)
	
	args.srdUp.sprite = spr
	args.srdDown.sprite = spr

	args.srdUp.transform.localPosition = Vector3(c.upOffset[1], c.upOffset[2], 0)
	args.srdDown.transform.localPosition = Vector3(c.downOffset[1], c.downOffset[2], 0)
end

return BattleMapView