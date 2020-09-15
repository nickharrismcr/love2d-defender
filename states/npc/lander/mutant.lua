local state={}
require "game/util"
require "events/FireBullet"

function state:enter(comp,world,entity,dt)

	local draw=entity:get("NPCDraw")
	draw.graphic=gl.graphics:get("mutant")
	local rdraw=entity:get("NPCRadarDraw")
	rdraw.graphic=gl.graphics:get("r_mutant")
	if comp.human then 
		local hai=comp.human:get("AI")
		hai.fsm:setState("eaten")
	end
	comp.think=0.2

end
function state:update (comp,world,entity,dt)

	if gl.freeze then return end 
	local pos=entity:get("Position")
	comp.think=comp.think-dt
	if comp.think < 0 then 
		comp.think=0.2
		pos.dx = math.random(-1,1) + sign(gl.player_pos.x-pos.x)
		pos.dy = math.random(-1,1) + sign(150+gl.player_pos.y-pos.y)
	end
	pos.x = pos.x + pos.dx * dt * 240
	pos.y = pos.y + pos.dy * dt * 240

	if pos.y > gl.wh-100 then pos.dy = -1 end
		
	local draw=entity:get("NPCDraw")
	if coin(0.006) and draw.on_screen then 
		entity.eventManager:fireEvent(FireBullet(pos.x,pos.y))
	end
	if draw.on_screen then
		gl.sound:playIfNot("mutant")
	end
end

return state
