--[[
 战斗界面
]]

local BattleView = {}

BattleView.args = {
	btnBack = Types.Button
}

local args = BattleView.args

function BattleView:Awake()
	args.btnBack.onClick:AddListener(function ()
		Helper.Switch2Lobby(function ()
            BattleKeeper.Reset()
            CharacterKeeper.Reset()
        end, 
        function ()
            BattleSystems.Shutdown()
        end)
	end)
end

function BattleView:Start()
end

return BattleView