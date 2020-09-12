local state={}
require "game/util"
Collide=require "components/update/Collide"

function state:enter(comp,world,entity,dt)

	if not entity:has("Collide") then
		dr=entity:get("NPCDraw")
		entity:add(Collide(dr.graphic))
	end
end

function state:update (comp,world,entity,dt)

	local pos=entity:get("Position")
	pos.y = world:at(pos.x)
	pos.x = pos.x + (pos.dx * dt * 10) 

end

return state
