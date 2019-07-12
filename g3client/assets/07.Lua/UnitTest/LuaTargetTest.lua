local LuaTargetTest = {}

LuaTargetTest.args = {
	test1 = 1,
	test2 = Types.GameObject,
	test3 = Types.GameObjects,
	test4 = 1.1,
	test5 = { "Number", min=4, max = 10},
	test6 = "abc",
	test7 = Types.Component,
	test8 = Types.Components,
	test9 = Types.Color,
	test10 = Types.Colors,
	test11 = Types.Transform,
	test12 = Types.Transforms,
	test13 = Types.Vector3,
	test14 = Types.Vector3s,
	test15 = Types.Vector2,
	test16 = Types.Vector2s,
	test17 = Types.Button,
	test18 = Types.Buttons,
	test19 = Types.Text,
	test20 = Types.Texts,
	test21 = Types.Image,
	test22 = Types.Images,
	test23 = Types.Sprite,
	test24 = Types.Sprites,
	test25 = Types.LuaTarget,
	test26 = Types.LuaTargets,
}

local args = LuaTargetTest.args

function LuaTargetTest:Start()
	print("self " .. tostring(self) )
	print("button " .. tostring(args.button) .. " " .. args.test5)
	args.button.onClick:AddListener(function() 
		print("Hello World " .. args.test1)
	end)
end

return LuaTargetTest