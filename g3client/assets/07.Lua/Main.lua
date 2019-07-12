if not Game then
	require 'Config.Config'
	require 'Foundation.Foundation'
	require 'Framework.Framework'
	require 'Game.Constants.Constants'
	require 'Game.Keeper.Keeper'
	require 'Game.Blocks.Blocks'
	require 'Game.Systems.Systems'
	require 'Game.Hotfix.Hotfix'
	require 'IPlugins.IPlugins'

	rapidjson = require 'rapidjson'
	util = require 'xlua.util'

	--可以通过Unity按需启动单元测试
	function RunUnitTest()
		require "UnitTest.UnitTest"	
	end

	-- 关闭游戏
	function Shutdown()
		CronManager.Shutdown()
		SequenceManager.Shutdown()
		ConnectionManager.Shutdown()
		TaskManager.Shutdown()
		ViewManager.Shutdown()
		GameObjectPool.Shutdown()
	end

	-- 事件系统
	FrameworkEventMgr = Event.New('framework')
	EventManager = Event.New('game')

	-- 初始化游戏系统
	GameObjectPool.Initialize()
	ViewManager.Initialize()
	TaskManager.Initialize()
	ConnectionManager.Initialize()
	SequenceManager.Initialize()
	CronManager.Initialize()

	CoroutineManager:StartupEnv('Schedule', 'Update')

	-- 创建游戏
	Game = require 'Game.Game'

	-- false是启动游戏，true则是单元测试
	local testMode = false

	-- 启动
	if not testMode then
		Game:Active()
	else
		RunUnitTest()
	end
else
	print('[Main] game reenter')
end
