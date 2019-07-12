--[[
扩展 Component 支持 PageView 功能
]]

IPlugins.HasPageViewPlugin = function (comp)
	comp.pluginPageViews = {}

	-- 源改变时触发
	comp.PV_OnSourceChanged = function (self, tag)
		local pv = self.pluginPageViews[tag]
		if pv and pv.target then
			pv.target:Rebuild()
		end
	end

	-- 绑定源
	comp.PV_Bind = function (self, tag, source, size, center)
		local pv = self.pluginPageViews[tag]

		if not pv then
			pv = {}
			self.pluginPageViews[tag] = pv
		end

		pv.source = source
		pv.size = size
		pv.center = (center and center - 1 > 0) and (center - 1) or 0 

		source.__pv_tag__ = tag

		if source then
			source.PV_PageTo = function (self, page, arg)
				if not self.__pv_tag__ then
					return
				end

				-- 内部转换
				local idx = page - 1
				local pv = comp.pluginPageViews[self.__pv_tag__]
				if not pv or not pv.target then
					return
				end

				pv.target:PageTo(idx, arg)
			end
		end

		if pv.target then
			self:PV_OnSourceChanged(tag, handler)
		end
	end

	local plugin = {
		init = function (self)
		end,

		destroy = function (self)
			for k, v in pairs(comp.pluginPageViews) do
				v.target = nil
			end
		end,

		delayInit = function (self)
			local sourceComp = comp.view.gameObject:GetComponent(typeof(CS.PageViewSource))

			if sourceComp then
				sourceComp.implRegister = self.registerComp
				sourceComp.implElementNum = self.elementNum
				sourceComp.implElementSize = self.elementSize
				sourceComp.implCenterIndex = self.centerIndex
				sourceComp.implElements = self.elements
			else
				error('PageViewSource invalid, confirm pls')
			end
		end,

		registerComp = function (tag, go)
			local pv = comp.pluginPageViews[tag]

			if not pv then
				pv = {}
				comp.pluginPageViews[tag] = pv
			end 

			pv.target = go:GetComponent(typeof(CS.PageView))
			if pv.target then
				pv.target.onItemInFocus = function (tag, page, go, arg)
					-- 内部计数时从0开始，lua从1开始，因此这里做转化
					page = page + 1
					
					local lt = go:GetComponent(typeof(LuaTarget))
					if not lt then
						return
					elseif not lt.Valid then
						go:SetActive(true)
					end

					if not lt.Valid then
						return
					end

					if comp.pv_ItemInFocus then
						comp:pv_ItemInFocus(tag, page, lt.Table, arg)
					end
				end

				pv.target.onItemOutFocus = function (tag, page, go, arg)
					-- 内部计数时从0开始，lua从1开始，因此这里做转化
					page = page + 1
					
					local lt = go:GetComponent(typeof(LuaTarget))
					if not lt then
						return
					elseif not lt.Valid then
						go:SetActive(true)
					end

					if not lt.Valid then
						return
					end

					if comp.pv_ItemOutFocus then
						comp:pv_ItemOutFocus(tag, page, lt.Table, arg)
					end
				end
			end
		end,

		elements = function (tag)
			local pv = comp.pluginPageViews[tag]
			local v = {}
			if pv and pv.source then
				for i = 1, #pv.source do
					if not pv.source[i].view then
						pv.source[i]:StartRendered(true)
					end

					v[i] = pv.source[i].view.gameObject
				end
			end

			return v
		end,

		elementNum = function (tag)
			local pv = comp.pluginPageViews[tag]
			return (pv and pv.source) and #pv.source or 0
		end,

		elementSize = function (tag, idx)
			local pv = comp.pluginPageViews[tag]
			return pv and pv.size or Vector2.zero
		end,

		centerIndex = function (tag)
			local pv = comp.pluginPageViews[tag]
			return (pv and pv.center) and pv.center or 0
		end
	}

	comp:addPlugin(plugin)
end