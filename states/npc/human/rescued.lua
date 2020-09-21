local state={}
require "events/HumanRescued"
require "events/HumanSaved"

require "game/util"

function state:enter(ai,world,entity,dt)

	entity:remove("Collide")
end

function state:update (ai,world,entity,dt)

	local pos=entity:get("Position")
	pos.x=gl.player_pos.x
	pos.y=gl.player_pos.y+50
	if pos.y > world:at(pos.x) then
		ai.next_state="walking"
		entity.eventManager:fireEvent(HumanSaved(entity))
	end
end

return state
