local state={}
require "game/util"

function state:update (comp,world,entity,dt)

	local pos=entity:get("Position")
	pos.y = entity.parent:get("Position").y + 30
end

return state
