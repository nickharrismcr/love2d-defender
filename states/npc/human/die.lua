local state={}

function state:enter(component,world,entity,dt)
	assert(entity)
	entity:remove("Shootable")
	if entity.parent:has("AI") then
		entity.parent:get("AI").human=nil
	end

end
function state:update (component,world,entity,dt)

	local d=entity:get("NPCDraw")
	d.disperse = d.disperse + 80 * dt 
	if d.disperse >= 60 then
		entity:deactivate()
	end
end

return state
