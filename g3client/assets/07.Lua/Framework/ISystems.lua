--[[
游戏系统组
]]

function ISystems (systems)
    local sys = { systems = systems or {}, inited = false}
    local sysMetatable = {}

    sysMetatable.Initialize = function ()
        if sys.inited then
            return
        end

        sys.inited = true

        for i = 1, #sys.systems do
            if sys.systems[i] and sys.systems[i].Initialize then
                sys.systems[i].Initialize()
            end
        end
    end

    sysMetatable.Shutdown = function ()
        if not sys.inited then
            return
        end

        sys.inited = false

        for i = #sys.systems, 1, -1 do
            if sys.systems[i] and sys.systems[i].Shutdown then
                sys.systems[i].Shutdown()
            end
        end
    end

    setmetatable(sys, {
        __index = sysMetatable
    })

    return sys
end