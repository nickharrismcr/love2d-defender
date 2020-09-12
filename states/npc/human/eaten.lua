local state={}
require "game/util"
require "events/NPCKill"

function state:enter(comp,world,entity,dt)

	entity:deactivate()	
end
function state:update(comp,world,entity,dt)
	entity.eventManager:fireEvent(NPCKill(entity))
end

return state
