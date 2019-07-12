--[[
游戏常量定义
]]

Constants = {}

Constants.game = 'G3'

-- 验证码
Constants.authKey = 'x5GYJ6tTDd4hgniSRihOD7DQ5QPi81W3BN4841e3T51b8JCE4KqXbJOiYqfmRP6D'

-- 帧数
Constants.fps = 30

-- 登录服务器列表
Constants.loginServers = {
	{ip = '192.168.1.225', port = 8080},
}

-- 战斗队伍
Constants.team = {
	up = 1,
	down = 2
}

-- 战斗阶段
Constants.battleState = {
	idle = 0,
	enter = 1,
	fighting = 2,
	result = 3
}

-- 角色状态
Constants.charState = {
	idle = 0,
	enter = 1,
	fighting = 2,
	dead = 3,
	win = 4,
	lose = 5
}

-- 攻击状态
Constants.attackState = {
	idle = 0,
	sel = 1,
	prepare = 2,
	start = 3,
	attacking = 4,
	finish = 5
}

-- 角色动画
Constants.charAnimation = {
	idle = 1,
	run = 2,
	attacked = 3,
	prepare = 4,
	startAttack = 5,
	attacking = 6,
	endAttack = 7
}

-- 状态映射动画
Constants.state2AtkAnim = {
	[Constants.attackState.prepare] 	= Constants.charAnimation.prepare,
	[Constants.attackState.start] 		= Constants.charAnimation.startAttack,
	[Constants.attackState.attacking] 	= Constants.charAnimation.attacking,
	[Constants.attackState.finish] 		= Constants.charAnimation.endAttack,
}

-- 动作切入下一个状态
Constants.anim2NextState = {
	[Constants.charAnimation.prepare] 		= Constants.attackState.start,
	[Constants.charAnimation.startAttack] 	= Constants.attackState.attacking,
	[Constants.charAnimation.attacking] 	= Constants.attackState.finish,
}

-- 对象池名字
Constants.emitter = {
	bow = 'bow'
}

-- 角色行为状态（用于操作时的状态机）
Constants.behavior = {
	idle = 1,
	run = 2
}

require 'Game.Constants.GameEvents'
require 'Game.Constants.GamePackets'
require 'Game.Constants.Misc'
require 'Game.Constants.Version'