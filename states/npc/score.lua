local state={}
require "game/util"

function state:update (comp,world,entity,dt)

	pos=entity:get("Position")
	pos.x = pos.x + pos.dx * dt
end

return state
