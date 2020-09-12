local state={}
require "game/util"

function state:update (ai,world,entity,dt)

	local pos=entity:get("Position")
	col=entity:get("Collide")
	local speed=gl.player.speed + 400
	pos.x = pos.x + ai.dir * speed * dt

	-- cut off at screen edge
	if math.abs(ai.len) < gl.ww then
		ai.len = ai.len + ai.dir * speed * 2 * dt
	end
	if ai.len < 0 then 
		col.box = { ai.len, 0, 0, 2 }
	else
		col.box = { 0, 0, ai.len, 2 }
	end
end

return state
