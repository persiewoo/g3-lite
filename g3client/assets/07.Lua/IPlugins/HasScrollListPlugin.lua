--[[
扩展 Component 支持 Scrolllist 功能
]]

IPlugins.HasScrollListPlugin = function (comp)
	comp.pluginScrollLists = {}

	-- 源改变时触发
	comp.SL_OnSourceChanged = function (self, tag)
		local sl = self.pluginScrollLists[tag]
		if sl and sl.target then
			sl.target:Rebuild()
		end
	end

	-- 绑定源
	comp.SL_Bind = function (self, tag, source, size)
		local sl = self.pluginScrollLists[tag]

		if not sl then
			sl = {}
			self.pluginScrollLists[tag] = sl
		end

		sl.source = source
		sl.size = size

		if sl.target then
			self:SL_OnSourceChanged(tag)
		end
	end

	local plugin = {
		init = function (self)
		end,

		delayInit = function (self)
			local sourceComp = comp.view.gameObject:GetComponent(typeof(CS.ScrollListSource))

			if sourceComp then
				sourceComp.implRegister = self.registerComp
				sourceComp.implElementNum = self.elementNum
				sourceComp.implElementSize = self.elementSize
			else
				error('ScrollListSource invalid, confirm pls')
			end
		end,

		registerComp = function (tag, go)
			local sl = comp.pluginScrollLists[tag]

			if not sl then
				sl = {}
				comp.pluginScrollLists[tag] = sl
			end 

			sl.target = go:GetComponent(typeof(CS.ScrollList))
			if sl.target then
				sl.target.onItemRender = function (tag, idx, go)
					-- 内部计数时从0开始，lua从1开始，因此这里做转化
					idx = idx + 1
					
					local lt = go:GetComponent(typeof(LuaTarget))
					if not lt then
						return
					elseif not lt.Valid then
						go:SetActive(true)
					end

					if not lt.Valid then
						return
					end

					if comp.sl_ItemOnRendered then
						-- 支持view.controller的写法
						lt.Table.controller = comp.pluginScrollLists[tag].source[idx]
						comp:sl_ItemOnRendered(tag, idx, lt.Table)
					end
				end
			end
		end,

		elementNum = function (tag)
			local sl = comp.pluginScrollLists[tag]
			return (sl and sl.source) and #sl.source or 0
		end,

		elementSize = function (tag, idx)
			local sl = comp.pluginScrollLists[tag]
			return sl and sl.size or Vector2.zero
		end
	}

	comp:addPlugin(plugin)
end