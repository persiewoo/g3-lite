--[[
客户端的连接信息
]]

ConnectionManager = {}

-- 心跳间隔
local heartbeatInterval = 3
local heartbeatDisabled = false

local function genMessage(command, args)
	local info = PacketTypes.id2infos[tostring(command)]
	if not info then
		return nil
	end

	local msg = {}

	msg.path = info.name
	msg.query = args and rapidjson.encode(args) or '{}'
	msg.id = command

	local str = rapidjson.encode(msg)

	--print('[ConnectionManager] genMessage ' .. str)

	return str
end

function ConnectionManager.Initialize(disableHeartbeat)
	print('[ConnectionManager] initialize')
	heartbeatDisabled = disableHeartbeat
end

function ConnectionManager.Shutdown()
end

-- 创建连接
function ConnectionManager.Create(name, ip, port, onConnected, onDisconnect, onError, authKey)
	if ConnectionManager[name] then
		warn('[ConnectionManager] connection ' .. name .. ' existed, confirm pls')
		return
	end

	local link = {}
	ConnectionManager[name] = link

	link.valid = function(this)
		return this.conn
	end

	link.callbacks = {}
	link.lastMessages = {}

	-- 有新消息
	link.onMessage = function(msg)
		local callback = link.callbacks[msg.id]
		local content = msg.content and rapidjson.decode(msg.content) or {error = -1, reason = 'empty content'}
		local data = content[1]

		print('[ConnectionManager] response ' .. msg.id .. ', msg ' .. msg.content)
		
		if not data then
			data = content
		end

		if data and data.error then
			local handlered = false

			if type(callback) == 'table' and callback.failHandler then
				handlered = callback.failHandler(data)
			end

			if not handlered then
				EventManager:Broadcast(EventTypes.System_ResponseError, msg.id, data)
			end
		elseif data and data.fatal then
			EventManager:Broadcast(EventTypes.System_ResponseFatal, msg.id, data)
		elseif data and callback then
			if type(callback) == 'table' and callback.handler then
				callback.handler(data.detail)
			elseif type(callback) == 'function' then
				callback(data.detail)
			end

			EventManager:Broadcast(EventTypes.System_ResponseSuccess, msg.id)
		end

		-- 清理重发信息
		if link.lastMessages[msg.id] then
			link.lastMessages[msg.id] = nil
		end
	end

	-- 连接状态下的更新周期
	link.onConnectedCycle = function ()
		local dirty = false
		local messageList = {}
		for k, v in pairs(link.lastMessages) do
			dirty = false
			if v and TimeManager.seconds - v.time >= Constants.maxPacketResponseDelay then
				if v.resendCount >= Constants.maxPacketResendCount then
					dirty = true

					local callback = link.callbacks[v.command]
					local handlered = false
					local data = {error = 'resend fail'}

					if typeof(callback) == 'table' and callback.failHandler then
						handlered = callback.failHandler(data)
					end

					if not handlered then
						EventManager:Broadcast(EventTypes.System_ResendError, v.command, data)
					end

					print('resend ' .. v.command .. ' end')
				else
					v.resendCount = v.resendCount + 1
					v.time = TimeManager.seconds
					link.conn:Send(v.msg, true)
					print('message ' .. v.command .. ' resend, count ' .. v.resendCount)
				end
			elseif v and TimeManager.seconds - v.time >= Constants.maxPacketWaitingDelay and not v.showWaiting then
				v.showWaiting = true
				EventManager:Broadcast(EventTypes.System_ResponseDelay, v.command)
			end

			if not dirty then
				messageList[k] = v
			end
		end

		link.lastMessages = messageList
	end

	-- 发送信息
	link.send = function(this, command, args, handler, failHandler, taskMode)
		if not this:valid() then
			print('[ConnectionManager] connection is invalid')
			return
		end

		this.callbacks[command] = {handler = handler, failHandler = failHandler}
		
		local msg = genMessage(command, args)
		if not msg then
			warn('[ConnectionManager] send invalid command ' .. command)
			return
		end

		print('[ConnectionManager] request ' .. command .. ', content ' .. msg)

		if taskMode then
			TaskManager.RegisterSignal(command)
		end

		this.conn:Send(msg, true)

		if PacketTypes.id2infos[tostring(command)].resend then
			this.lastMessages[command] = {command = command, msg = msg, time = TimeManager.seconds, resendCount = 0, showWaiting = false}
		end
	end

	-- 启动一个连接等待
	link.connectingCo = Coroutine.Start(function()
		Coroutine.Wait(Constants.maxConnectWaitingDelay)
		EventManager:Broadcast(EventTypes.System_ResponseDelay, 0)
	end)

	link.conn = NetworkManager:CreateConnection(name, ip, port, 
		function(conn)
			conn.onMessage =  link.onMessage
			conn.onConnectedCycle = link.onConnectedCycle

			link:send(PacketTypes.commonHandler.identify, {token = authKey}, function (message)
				EventManager:Broadcast(EventTypes.System_IdentifySuccess)

				if onConnected then
					onConnected()
				end

				-- 校验成功后，开始心跳包
				if not heartbeatDisabled then
					link.co = Coroutine.Start(function()
						local counter = 1
						while true do
							Coroutine.Wait(heartbeatInterval)
							if link.conn and link.conn.isConnected then
								counter = counter + 1
								--print('heartbeat start ------------------------------- ' .. counter)
								link:send(PacketTypes.commonHandler.heartbeat, {counter = counter}, function (message)
									--print('heartbeat end ------------------------------- ' .. message.counter)
								end, nil, false)
							end
						end
					end)
				end
			end, 
			function (message)
				print('------------------------- auth failed')
			end)

			if link.connectingCo then
				Coroutine.Stop(link.connectingCo)
				link.connectingCo = nil
			end
		end,

		function(code)
			EventManager:Broadcast(EventTypes.System_Disconnect, code)
			if onDisconnect then
				onDisconnect(code)
			end
		end,

		function(code)
			EventManager:Broadcast(EventTypes.System_ConnectError, code)
			if onError and type(onError) == 'function' then
				onError(code)
			end
		end
	)

	link.addListener = function (this, command, handler)
		this.callbacks[command] = handler
	end

	return link
end
