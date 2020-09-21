local state={}

require "events/PlayerExplode"

function state:enter(co,world,entity,dt)

	local pos=entity:get("Position")
	returns=entity.eventManager:fireEvent(PlayerExplode(pos.x,pos.y))
	if returns then log.trace("PE returns " .. tt(returns)) end
	co.timer=3
	entity:get("PlayerDraw").hide=true 
end

function state:update (co,world,entity,dt)

	co.timer=co.timer-dt
	if co.timer < 0 then
		co.next_state="play"
	end
end

return state
