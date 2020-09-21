
local state={}

function state:enter(ai,world,entity,dt)
	d=entity:get("NPCDraw")
	d.visible=true
	d.disperse=50
	local pos=entity:get("Position")
	ai.x_to_player = math.random(-500,500)
	pos.y=math.random( 200,700 ) 
	entity.eventManager:fireEvent(Materialize())
end

function state:update (ai,world,entity,dt)

	local pos=entity:get("Position")
	pos.x=gl.player_pos.x + ai.x_to_player
	d=entity:get("NPCDraw")
	d.disperse = d.disperse - 40 * dt
	if d.disperse <= 1 then
		d.disperse = 1
		ai.next_state="chase"
	end
end

return state
