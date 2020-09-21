local state={}
function state:update (comp,world,entity,dt)

	local pos=entity:get("Position")
	pos.x = pos.x + pos.dx * dt 
	pos.y = pos.y + pos.dy * dt 

	if pos.y > gl.wh or pos.y < gl.top then
		comp.next_state="die"
	end
end

return state
