luaunit = require '3rd.luaunit'

-- require 测试模块
require 'UnitTest.TestConfig'
require 'UnitTest.TestCron'
require 'UnitTest.TestLua'

-- run
luaunit.LuaUnit.run()