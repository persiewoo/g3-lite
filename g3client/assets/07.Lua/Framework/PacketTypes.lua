--[[
定义消息包类型
]]

PacketTypes = {}
PacketTypes.id2infos = {}

-- 定义消息原型
function packet(name, id, resend, desc)
	if not name then
		error('[PacketTypes] packet define needs valid name')
	end

	if not id or not desc or #desc == 0 then
		error('[PacketTypes] packet ' .. name .. ' has invalid id or desc')
	end

	local nameset = Split(name, "([^'.']+)")
	local curr = PacketTypes

	-- 自动创建table名称空间
	for i = 1, #nameset - 1 do
		if not curr[nameset[i]] then
			curr[nameset[i]] = {}
		end

		curr = curr[nameset[i]]
	end

	if curr[nameset[#nameset]] then
		error('[PacketTypes] packet ' .. name .. ' has existed')
	end

	if PacketTypes.id2infos[tostring(id)] then
		error('[PacketTypes] packet id ' .. id .. ' has existed, name ' .. name)
	end

	-- 根据最后一个名称空间保存id
	curr[nameset[#nameset]] = id
	PacketTypes.id2infos[tostring(id)] = { name = '/' .. name, resend = resend, desc = desc }
end

packet('commonHandler.identify',                   	1998, false,    '身份验证')
packet('commonHandler.heartbeat',                   1999, true,     '心跳包')
