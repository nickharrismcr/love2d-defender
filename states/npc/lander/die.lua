local state={}

function state:enter(component,world,entity,dt)

	if entity.name=="Lander" then
		gl.landers_killed = gl.landers_killed + 1
	end

	entity:remove("Shootable")
	entity:remove("NPCRadarDraw")
	local ai= entity:get("AI")
	if ai.human then
		local hai=ai.human:get("AI")
		if hai.state == "grabbed" then
			hai.next_state="falling"
		end
		ai.human=nil
	end
end

function state:update (component,world,entity,dt)

	local draw=entity:get("NPCDraw")
	draw.disperse = draw.disperse + 80 * dt 
	if draw.disperse >= 60 then
		gl.engine:removeEntity(entity)
	end
end

return state
