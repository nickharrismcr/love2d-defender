local state={}

require "game/util"
require "events/HumanLanded"
require "events/HumanDropped"

function state:enter(ai,world,entity,dt)

	local pos=entity:get("Position")
	pos.dy = 0
	ai.sy = pos.y
	entity:addTag("CollidePlayer")
	entity.eventManager:fireEvent(HumanDropped())
end
function state:update (ai,world,entity,dt)

	local pos=entity:get("Position")
	pos.dy = pos.dy + dt * 60
	pos.y = pos.y + pos.dy * dt
	if pos.y >  world:at(pos.x) then
		if ai.sy < gl.wh/2 then
			ai.fsm:setState("die")
		else
			entity.eventManager:fireEvent(HumanLanded(entity))
			entity:remove("CollidePlayer")
			ai.fsm:setState("walking")
		end
	end
end

return state
