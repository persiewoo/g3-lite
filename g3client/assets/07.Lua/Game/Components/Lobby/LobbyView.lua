--[[
 大厅界面
]]

local LobbyView = {}

LobbyView.args = {
    btnEnterBattle = Types.Button,
    btnEnterDungeon = Types.Button,
}

local args = LobbyView.args

function LobbyView:Awake()
    args.btnEnterDungeon.onClick:AddListener(function ()
        self.controller:EnterDungeon()
    end)

    args.btnEnterBattle.onClick:AddListener(function ()
        self.controller:EnterBattle()
    end)
end

function LobbyView:Start()
end

function LobbyView:OnEnable()
end

function LobbyView:OnDisable()
end

return LobbyView