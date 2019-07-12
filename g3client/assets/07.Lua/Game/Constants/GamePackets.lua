--[[
定义游戏消息包类型
]]

--------------------------- 客户端请求消息定义 (2000以上) ---------------------------------
packet('accountHandler.login',                      2000, true,     '账号登录')
packet('accountHandler.createUser',                 2001, true,     '创建新用户')

packet('lobbyHandler.register',                     2020, true,     '账号验证通过，先到大厅服务器进行登记验证')
packet('lobbyHandler.enter',                        2021, true,     '进入大厅')

packet('characterHandler.get',                      2100, true,     '获取球员信息')

packet('teamHandler.get',                           2120, true,     '获取队伍信息')
packet('teamHandler.set',                           2121, true,     '更新队伍信息')

packet('bagHandler.get',                            2140, true,     '获取背包信息')

packet('shopHandler.get',                           2160, true,     '获取商店信息')

packet('levelHandler.get',                          2180, true,     '获取关卡信息')
packet('levelHandler.startLevel',                   2181, true,     '开始PVE')
packet('levelHandler.endLevel',                     2182, true,     '结束PVE')
packet('levelHandler.cleanLevel',                   2183, true,     '扫荡关卡')
packet('levelHandler.getLevelReward',               2184, true,     '获取星星奖励')
packet('levelHandler.getChapter',                   2185, true,     '获取指定章信息')

packet('trainHandler.trainExp',                     2220, true,     '训练球员')

packet('cardHandler.basicCard',                     2240, false,    '基础抽卡')
packet('cardHandler.midCard',                       2241, false,    '中等抽卡')
packet('cardHandler.highCard',                      2242, false,    '高等抽卡')
packet('cardHandler.get',                           2243, false,    '基础信息')

packet('matching1v1Handler.request',                3000, true,     '请求匹配1v1')

packet('matchingHandler.cancel',                    3020, true,     '取消匹配')

packet('room1v1Handler.ready',                      3030, true,     '玩家点击准备')

packet('matchHandler.result',                       3050, true,     '玩家请求比赛结果')

packet('tutorialHandler.get',                       3100, true,     '获取新手引导数据')
packet('tutorialHandler.begin',                     3101, true,     '开始一个新手引导数据')
packet('tutorialHandler.finish',                    3102, true,     '结束一个新手引导数据')

-------------------------- 服务器主动推送消息定义 (1000-1998) ------------------------------
packet('lobbyRoom1v1Created',                       1000, true,     '1v1房间创建成功')
packet('lobbyRoom1v1UserReady',                     1001, true,     '1v1匹配玩家在房间里点击准备')
packet('lobbyRoom1v1StateReady',                    1002, true,     '所有玩家已经准备好，房间状态更改为准备状态，并进入倒计时')
packet('lobbyRoom1v1StateMatch',                    1003, true,     '倒计时结束，通知玩家连接进入比赛')
packet('lobbyMatchingCancel',                       1004, true,     '取消匹配')
packet('lobbyRoomDeleted',                          1005, true,     '房间被删除')
packet('lobbyRoomTimeout',                          1006, true,     '房间超时被删除')
packet('matchRoomResult',                           1007, true,     '比赛结果推送')