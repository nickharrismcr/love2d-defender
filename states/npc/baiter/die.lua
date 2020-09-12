local state={}

function state:enter(component,world,entity,dt)

	entity:remove("Shootable")
	entity:remove("NPCRadarDraw")
	gl.baiters=gl.baiters-1
end

function state:update (component,world,entity,dt)

	local draw=entity:get("NPCDraw")
	draw.disperse = draw.disperse + 80 * dt 
	if draw.disperse >= 60 then
		gl.engine:removeEntity(entity)
	end
end

return state
