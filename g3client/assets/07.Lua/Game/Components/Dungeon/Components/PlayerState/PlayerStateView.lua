--[[
 玩家状态界面
]]

local PlayerStateView = {}

PlayerStateView.args = {
    btnBack = Types.Button,
    sldHP = Types.Slider,
    sldPhy = Types.Slider,
}

local args = PlayerStateView.args

function PlayerStateView:Awake()
    args.btnBack.onClick:AddListener(function ()
        Helper.Switch2Lobby(function ()
            DungeonKeeper.Reset()
        end, 
        function ()
            DungeonSystems.Shutdown()
        end)
    end)
end

function PlayerStateView:Start()
end

return PlayerStateView