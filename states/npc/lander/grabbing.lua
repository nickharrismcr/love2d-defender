local state={}
require "game/util"
require "events/FireBullet"

function state:update (comp,world,entity,dt)

	if gl.freeze then return end 
	local pos=entity:get("Position")
	pos.y = pos.y + gl.grabspeed * dt * 60
	if not comp.human then
		comp.next_state="search" 
		return
	end
	if pos.y > comp.human:get("Position").y - 50 then
		comp.next_state="grabbed" 
		comp.human:get("AI").next_state="grabbed" 
	end
end

return state
