local state={}
require "game/util"
require "events/FireBullet"

function state:update (comp,world,entity,dt)

	if gl.freeze then return end 
	local pos=entity:get("Position")
	pos.y = pos.y + gl.grabspeed * dt * 60
	if not comp.human then
		comp.fsm:setState("search" )
		return
	end
	if pos.y > comp.human:get("Position").y - 50 then
		comp.fsm:setState("grabbed" )
		comp.human:get("AI").fsm:setState("grabbed" )
	end
end

return state
