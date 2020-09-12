require "game/util"
require "events/FireBullet"

local state={}

function state:enter(ai,world,entity,dt)
	entity:addMultipleTags({"Shootable","Deadly"})
	local pos=entity:get("Position")
	pos.x=randf(500,1500)
	pos.y=randf(gl.top,gl.wh-300)
	pos.dx=100
	pos.dy=100
end

function state:update (ai,world,entity,dt)

	if gl.freeze then return end 

	local pos=entity:get("Position")
	pos.x = pos.x + pos.dx * dt
	pos.y = pos.y + pos.dy * dt 

	if pos.y <gl.top or pos.y > (gl.wh-300) then
		pos.dy = - pos.dy
	end

	if coin(0.001) then
		entity.eventManager:fireEvent(FireBullet(pos.x,pos.y,1,2,"bomb"))
	end
end


return state
