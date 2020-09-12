require "game/util"
log=require "lib/log"

local Queue = class("Queue", System)

function Queue:update(dt)

	if gl.engine._queue then
		for i,entry in ipairs(gl.engine._queue) do
			if not entry.t then 
				entry.t=0
				entry.ticks=0
			end
			entry.t=entry.t+dt
			entry.ticks=entry.ticks+1
			if (entry.delay_type == "ticks" and entry.ticks > entry.delay)
			or (entry.delay_type == "time" and entry.t > entry.delay) then
				entry.func()
				table.remove(gl.engine._queue,i)
			end
		end
	end
end

function Queue:requires()
	return {"Queue"}
end

return Queue
