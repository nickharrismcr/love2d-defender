require "game/util"
require "events/FireBullet"

local state={}

function state:enter(ai,world,entity,dt)

	entity:addMultipleTags({"Shootable","Deadly"})
	ai.nextthink=0
	ai.maxsp=math.random(800,1000)
	local pos=entity:get("Position")
	if coin(0.05) then pos.x = pos.x - randf(gl.worldwidth/2,gl.worldwidth) end
	
end

function state:update (ai,world,entity,dt)

	if gl.freeze then return end 

	local pos=entity:get("Position")

	ai.nextthink=ai.nextthink -dt

	if ai.nextthink < 0 then
		local p = gl.player
		local pp = gl.player_pos
		local xoff=math.random(-500,500)
		local yoff=math.random(-300,300)
		pos.dx,pos.dy=calc_fire(pp.x+xoff,pp.y+yoff,p.dir*p.speed,pos.x,pos.y,1,1,dt)
		pos.dx=clamp(pos.dx,-ai.maxsp,ai.maxsp)
		ai.nextthink=0.2
	end

	pos.x = pos.x + pos.dx * dt
	pos.y = pos.y + pos.dy * dt 

	local draw=entity:get("NPCDraw")
	if coin(4*gl.bullet_rate*dt) and draw.on_screen then
		entity.eventManager:fireEvent(FireBullet(pos.x,pos.y,1,2,"mini"))
	end
	if draw.on_screen then
		gl.sound:playIfNot("swarmer")
	end
end


return state
