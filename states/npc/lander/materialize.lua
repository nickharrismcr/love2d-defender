require "events/Materialize"

local state={}

function state:enter(component,world,entity,dt)
	d=entity:get("NPCDraw")
	d.visible=true
	d.disperse=50
	local pos=entity:get("Position")
	pos.y = pos.iy
	entity.eventManager:fireEvent(Materialize())
end

function state:update (component,world,entity,dt)

	d=entity:get("NPCDraw")
	d.disperse = d.disperse - dt *41
	if d.disperse <= 1 then
		d.disperse = 1
		component.fsm:setState("search")
	end
end

return state
