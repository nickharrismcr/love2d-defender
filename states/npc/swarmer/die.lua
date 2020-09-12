
local state={}

function state:enter(component,world,entity,dt)

	entity:remove("Shootable")
	entity:remove("NPCRadarDraw")
	component.ddisp=randf(10,50)
end

function state:update (component,world,entity,dt)

	local draw=entity:get("NPCDraw")
	draw.disperse = draw.disperse + component.ddisp * dt 
	if draw.disperse >= component.ddisp * 3 then
		gl.engine:removeEntity(entity)
	end
end

return state
