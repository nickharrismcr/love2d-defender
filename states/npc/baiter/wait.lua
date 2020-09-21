local state={}

function state:enter(ai,world,entity,dt)
	local d=entity:get("NPCDraw")
	d.visible=false
end

function state:update (ai,world,entity,dt)

	local e=entity:get("Position")
	if ai.wait and  ai.t > ai.wait then 
		ai.next_state="materialize"
	end
end

return state
