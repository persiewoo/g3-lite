--[[
测试lua写法的用例
]]

function testIterator()
    local tbl = {}

    tbl.a = 1
    tbl.b = 2
    tbl.c = 4

    print('------------------- tbl num' .. #tbl)

    for k, v in pairs(tbl) do
        if k == 'a' then
            tbl[k] = nil
        end
    end

    dump(tbl)
end