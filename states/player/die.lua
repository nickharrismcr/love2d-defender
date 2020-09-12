log=require "lib/log"
require "events/PlayerDie"

local state={}
function state:enter(co,world,entity,dt)

	local d=entity:get("PlayerDraw")
	d.flash=1
	co.timer=2
	co.thrust=false
	gl.freeze=true
	entity.eventManager:fireEvent(PlayerDie())
	gl.lives=gl.lives-1
end

function state:update (co,world,entity,dt)

	co.timer=co.timer-dt
	if co.timer < 0 then
		co.fsm:setState("explode")
	end
	local d=entity:get("PlayerDraw")
	d.flash=(math.floor(co.timer*100))%2+1	

end

return state
