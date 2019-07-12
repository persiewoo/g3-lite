--[[
Cell是指可复制的单元组件，比如一个物品，尽量不要对Cell加入过度复杂的子节点
]]

function SignatureForCell()
	return '__cell_signature__'
end

-- 生成一个cell
function Cell(name, linkRes, tag, renderAlways)
	local tbl = {}

	tbl.__name__ = name and name or '__undefined_cell__'
	tbl.__signature__ = SignatureForCell()
	tbl.linkRes = linkRes and linkRes or ''
	tbl.tag = tag and tag or ''
	tbl.renderAlways = renderAlways

	tbl.__index = function (t, k)
		if k == 'view' then
			local v = rawget(t, '__view__')
			if not v then
				return nil
			end

			return v.__lua_table__
		elseif k == 'model' then
			local m = rawget(t, '__model__')
			if not m then
				local dirs = Split(t.up.baseDir, "([^'.']+)")
				local path = t.up.baseDir .. '.' .. dirs[#dirs] .. 'Model' 
			
				m = require(path).New()
				if m then
					rawset(t, '__model__', m)
				end
			end

			return m
		end

		return rawget(tbl, k)
	end

	tbl.viewValid = function (self)
		return self.__view__ ~= nil
	end

	tbl.New = function (up, pool, ...)
		local cell = {}

		cell.up = up
		cell.pool = pool

		setmetatable(cell, tbl)

		if tbl.ctor then
			tbl.ctor(cell, ...)
		end

		return cell
	end

	-- 激活
	tbl.active = function (self)
		local onEnable = rawget(tbl, 'OnEnable')
		if onEnable and type(onEnable) == 'function' then
			tbl.OnEnable(self)
		end
	end

	-- 取消激活
	tbl.deactive = function(self)
		self:StopRendered()

		local onDisable = rawget(tbl, 'OnDisable')
		if onDisable and type(onDisable) == 'function' then
			tbl.OnDisable(self)
		end
	end

	-- 删除
	tbl.destroy = function(self)
		self:StopRendered(true)

		local onDestroy = rawget(tbl, 'OnDestroy')
		if onDestroy and type(onDestroy) == 'function' then
			tbl.OnDestroy(self)
		end
	end

	-- 开始渲染
	tbl.StartRendered = function(self, sync, handler)
		local funcOnViewLoaded = function()
			local onViewLoaded = rawget(tbl, 'OnViewLoaded')
			if onViewLoaded and type(onViewLoaded) == 'function' then
				tbl.OnViewLoaded(self)
			end
		end

		if self:viewValid() then
			self.__view__.__internal__.go:SetActive(true)

			if handler then
				handler()
			end

			funcOnViewLoaded()
		else
			if not self.up or not self.up:viewValid() then
				warn('[Cell] cell ' .. self.__name__ .. ' active but up view invalid' )
				return
			end

			self.pool:allocView(sync, self, function(view)
				self.__view__ = {}
				self.__view__.__internal__ = view

				if self.up and self.up:viewValid() then
					view.go.transform:SetParent(self.up.__view__.__internal__.go.transform:Find(self.tag), false)
				end

				if not view.go.activeSelf then
					view.go:SetActive(true)
				end

				if view.__lua_target__ then
					self.__view__.__lua_table__ = view.__lua_target__.Table
				end

				if handler then
					handler()
				end

				funcOnViewLoaded()
			end)
		end
	end

	-- 停止渲染
	tbl.StopRendered = function(self, force)
		if not self:viewValid() then
			return
		end

		-- 如果是持续渲染的，只会简单设置隐藏，否则则回收这个view
		if not force and self.renderAlways then
			self.__view__.__internal__.go:SetActive(false)
		else
			self.pool:freeView(self.__view__.__internal__)
			self.__view__.__internal__ = nil
			self.__view__ = nil
		end
	end

	return tbl
end

