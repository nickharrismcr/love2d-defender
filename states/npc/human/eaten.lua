local state={}
require "game/util"
require "events/NPCKill"
require "events/HumanDie"

function state:enter(comp,world,entity,dt)

	entity.eventManager:fireEvent(HumanDie())
	entity:deactivate()	
end
function state:update(comp,world,entity,dt)
	entity.eventManager:fireEvent(NPCKill(entity))
end

return state
