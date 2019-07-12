--[[
定时器测试
]]

function testCron ()
    local cron = require '3rd.cron'

    local function printMessage()
      print('Hello world')
    end

    -- the following calls are equivalent:
    CronManager.After('test1', 2, printMessage)
    CronManager.After('test2', 4, print, 'Hello')

    -- Create a periodical clock:
    CronManager.Every('test3', 3, printMessage)
    CronManager.Every('test4', 5, print, 'world')

    CronManager.After('test5', 10, function ()
        print('------ remove cron')
        CronManager.Remove('test3')
    end)
end
