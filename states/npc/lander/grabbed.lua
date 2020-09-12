local state={}
require "game/util"
require "events/FireBullet"

function state:update (comp,world,entity,dt)

	if gl.freeze then return end 
	local pos=entity:get("Position")
	pos.y = pos.y - gl.grabspeed * dt * 30
	if not comp.human then
		comp.fsm:setState("search")
		return
	end
	if pos.y < gl.top then 
		comp.fsm:setState("mutant" )
	end
end

return state
