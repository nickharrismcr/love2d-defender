
require "game/util"
require "events/FireBullet"

local state={}

function state:enter(ai,world,entity,dt)

	entity:addMultipleTags({"Shootable","Deadly"})
	ai.nextthink=1
end

function state:update (ai,world,entity,dt)

	if gl.freeze then return end 

	local pos=entity:get("Position")
	ai.nextthink=ai.nextthink-dt

	if ai.nextthink < 0 then
		local p = gl.player
		local pp = gl.player_pos
		local xoff=math.random(-200,0)
		local yoff=math.random(-100,100)
		pos.dx,pos.dy=calc_fire(pp.x+xoff,pp.y+yoff,p.dir*p.speed,pos.x,pos.y,1,1,dt)
		pos.dx=clamp(pos.dx,-2000,2000)
		ai.nextthink=0.5
	end

	pos.x = pos.x + pos.dx * dt
	pos.y = pos.y + pos.dy * dt 

	local draw=entity:get("NPCDraw")
	if coin(4*gl.bullet_rate*dt) and draw.on_screen then
		entity.eventManager:fireEvent(FireBullet(pos.x,pos.y,1,2))
	end
end


return state
