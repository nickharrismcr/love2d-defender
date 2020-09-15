require "game/util"
require "events/HumanGrabbed"

local state={}

function state:enter(comp,world,entity,dt)
	entity.eventManager:fireEvent(HumanGrabbed())
end
function state:update (comp,world,entity,dt)

	local pos=entity:get("Position")
	pos.y = entity.parent:get("Position").y + 30
end

return state
