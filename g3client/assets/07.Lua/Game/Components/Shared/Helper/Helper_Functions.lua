--[[
  其他辅助功能
]]

Helper.Switch2Lobby = function (preLoaded, postLoaded)
    Game.Shared.CommonLoading:Active(true, function()
        TaskManager.Reset()

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if preLoaded and type(preLoaded) == 'function' then
                preLoaded()
            end
        end))

        TaskManager.AddTask(Task_NextContext.New(1,ViewManager.GetContext('Lobby')))
     
        TaskManager.AddTask(Task_LoadComponent.New(1, Game.Lobby))

        TaskManager.AddTask(Task_WaitSceneSwitched.New(1))

        TaskManager.AddTask(Task_LoadScene.New(1, ViewManager.GetContext('Lobby'), true))

        TaskManager.AddTask(Task_WaitAllSignals.New(1))

        TaskManager.AddTask(Task_ActiveContext.New(1))

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if postLoaded and type(postLoaded) == 'function' then
                postLoaded()
            end
        end))

        TaskManager.Start()
    end)
end

Helper.Switch2Dungeon = function (dungeonData, preLoaded, postLoaded)
    Game.Shared.CommonLoading:Active(true, function()
        TaskManager.Reset()

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if preLoaded and type(preLoaded) == 'function' then
                preLoaded()
            end
        end))

        TaskManager.AddTask(Task_NextContext.New(1, ViewManager.GetContext('Dungeon')))
     
        TaskManager.AddTask(Task_LoadComponent.New(1, Game.Dungeon))

        TaskManager.AddTask(Task_WaitSceneSwitched.New(1))

        TaskManager.AddTask(Task_LoadScene.New(1, ViewManager.GetContext('Dungeon'), true))

        TaskManager.AddTask(Task_AddScene.New(1, dungeonData.path, dungeonData.mapName))

        TaskManager.AddTask(Task_WaitAllSignals.New(1))

        TaskManager.AddTask(Task_ActiveContext.New(1))

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if postLoaded and type(postLoaded) == 'function' then
                postLoaded()
            end
        end))

        TaskManager.Start()
    end)
end

-- 切换到战斗场景接口
Helper.Switch2Battle = function (mapId, upTeam, downTeam, preLoaded, postLoaded)
	Game.Shared.CommonLoading:Active(true, function()
        TaskManager.Reset()

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if preLoaded and type(preLoaded) == 'function' then
                preLoaded()
            end
        end))

        TaskManager.AddTask(Task_NextContext.New(1, ViewManager.GetContext('Battle')))
     
        TaskManager.AddTask(Task_LoadComponent.New(1, Game.Battle))

        TaskManager.AddTask(Task_WaitSceneSwitched.New(1))

		TaskManager.AddTask(Task_LoadScene.New(1, ViewManager.GetContext('Battle'), true))

		TaskManager.AddTask(Task_WaitAllSignals.New(1))

		TaskManager.AddTask(Task_LoadBattleMap.New(1, mapId))

        TaskManager.AddTask(Task_Exec.New(1, function() BattleKeeper.CreateBattle(mapId) end))

		TaskManager.AddTask(Task_LoadTeam.New(#upTeam, upTeam, Constants.team.up))

		TaskManager.AddTask(Task_LoadTeam.New(#downTeam, downTeam, Constants.team.down))

		TaskManager.AddTask(Task_ActiveContext.New(1))

		TaskManager.AddTask(Task_BroadcastEvent.New(1, EventTypes.Battle_LoadFinished, 'Battle'))

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if postLoaded and type(postLoaded) == 'function' then
                postLoaded()
            end
        end))

		TaskManager.Start()
	end)
end

-- 切换回Login
Helper.Switch2Login = function (preLoaded, postLoaded)
	Game.Shared.CommonLoading:Active(true, function()
        TaskManager.Reset()

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if preLoaded and type(preLoaded) == 'function' then
                preLoaded()
            end
        end))

        TaskManager.AddTask(Task_NextContext.New(1, ViewManager.GetContext('Login')))
     
        TaskManager.AddTask(Task_LoadComponent.New(1, Game.Login))

		TaskManager.AddTask(Task_LoadScene.New(1, ViewManager.GetContext('Login'), false))

		TaskManager.AddTask(Task_ActiveScene.New(0.1))

        TaskManager.AddTask(Task_Exec.New(1, function ()
            if postLoaded and type(postLoaded) == 'function' then
                postLoaded()
            end
        end))

		TaskManager.Start()
	end)
end