--[[
扩展 Component 支持 CellPool 功能
]]

IPlugins.HasCellPoolPlugin = function (comp)
	comp.pluginCellPool = {}

	-- 绑定数据源
	comp.CP_Bind = function (self, tag, cell, num, dynamic)
		local cp = self.pluginCellPool[tag]

		if not cp then
			cp = {}
			self.pluginCellPool[tag] = cp
		end

		cp.cell = cell
		cp.num = num
		cp.used = {}
		cp.free = {}
		cp.bulks = {}
		cp.dynamic = dynamic
	end

	-- 分配资源组
	comp.CP_Alloc = function (self, tag)
		local cp = self.pluginCellPool[tag]
		
		if not cp then
			warn('do not have cell pool ' .. tag)
			return
		end

		-- 动态分配不支持
		if cp.dynamic then
			warn('dynamic style alloc fail')
			return
		end

		local cells = {}
		local resId = nil

		if #cp.free == 0 then
			resId = tostring(cells)
			cp.cell:Add(cp.num, function (item, idx)
				cells[#cells + 1] = item 
			end)
		else
			local unit = cp.free[1]

			table.remove(cp.free, 1)

			resId = unit.id
			cells = unit.val
		end

		if resId then
			cp.used[#cp.used + 1] = {id = resId, val = cells}
		end

		return resId, cells
	end

	-- 动态分配数量
	comp.CP_AllocDyn = function (self, tag, num)
		local cp = self.pluginCellPool[tag]
		
		if not cp then
			warn('do not have cell pool ' .. tag)
			return
		end

		-- 动态分配不支持
		if not cp.dynamic then
			warn('fix style alloc fail')
			return
		end

		local cells = {}
		local resId = nil

		if #cp.free == 0 then
			resId = tostring(cells)
			cp.cell:Add(num, function (item, idx)
				cells[#cells + 1] = item 
			end)
		else
			local unit = cp.free[1]

			table.remove(cp.free, 1)

			resId = unit.id
			cells = unit.val

			-- 缓冲里的数据先使用
			for i = 1, num do
				if #cp.bulks > 0 then
					cells[#cells+1] = cp.bulks[1]
					table.remove(cp.bulks, 1)
				else
					break
				end
			end

			-- 不够就补上
			if #cells < num then
				cp.cell:Add(num-#cells, function (item, idx)
					cells[#cells + 1] = item
				end)
			end
		end

		if resId then
			cp.used[#cp.used + 1] = {id = resId, val = cells}
		end

		return resId, cells
	end

	-- 释放资源组
	comp.CP_Free = function (self, tag, resId)
		if not resId then
			return
		end

		local cp = self.pluginCellPool[tag]

		if not cp then
			warn('do not have cell pool ' .. tag)
			return
		end

		for i = 1, #cp.used do
			if cp.used[i].id == resId then
				local unit = cp.used[i]
				cp.free[#cp.free + 1] = cp.used[i]
				table.remove(cp.used, i)

				-- 如果是动态pool，将val全部放到bulks
				if cp.dynamic then
					while #unit.val > 0 do
						cp.bulks[#cp.bulks + 1] = unit.val[1]
						table.remove(unit.val, 1)
					end
				end

				break
			end
		end
	end

	local plugin = {
		init = function (self)
		end,

		delayInit = function (self)
		end,

		destroy = function (self)
			for k, v in pairs(comp.pluginCellPool) do
				for i = 1, #v.used do
					while #v.used[i].val > 0 do
						table.remove(v.used[i].val, 1)
					end
				end

				for i = 1, #v.free do
					while #v.free[i].val > 0 do
						table.remove(v.free[i].val, 1)
					end
				end

				v.bulks = {}
				v.cell:Clear()
			end

			comp.pluginCellPool = {}
		end
	}

	comp:addPlugin(plugin)
end