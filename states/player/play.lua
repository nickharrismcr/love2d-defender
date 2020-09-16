local state={}
require "game/util"
require "events/PlayerStart"
require "events/PlayerFire"
require "events/SmartBomb"
log=require("lib/log")
keys=require("game/keys")

function state:enter(co,world,entity,dt)

	gl.freeze=false
	co.speed=0    
	co.dir=1
	co.offset=300
	d=entity:get("PlayerDraw")
	d.flash=0
	d.hide=false
	co.thrust=false
	entity.eventManager:fireEvent(PlayerStart())
	if keys:isDown("reverse") then
		co.reverse=true
	end
end

function state:update (co,world,entity,dt)

	local pos=entity:get("Position")
	if keys:isDown("up") then
		if pos.y > gl.top then 
			pos.y = pos.y - 300*dt
		end
	end 
	if keys:isDown("down") then
		if pos.y < gl.wh - 50 then 
			pos.y = pos.y + 300*dt
		end
	end 
	if keys:isDown("thrust") then 
		if co.thrust == false then
			gl.sound:play("thruster")
		end
		co.thrust=true
		if co.speed < co.maxspeed then
			co.speed=co.speed+600*dt
		end
	else
		co.thrust=false
		gl.sound:stop("thruster")
		if co.speed > 0 then
			co.speed=co.speed-400*dt
		end
	end

	if keys:isDown("fire") then
		if not co.fire then
			entity.eventManager:fireEvent(PlayerFire(pos.x,pos.y,co.dir,co.speed))
			co.fire = true
		end
	else
		co.fire=false
	end

	if keys:isDown("reverse") then
		if not co.reverse then
			co.dir = - co.dir
			co.speed = 0
			co.reverse=true
		end
	else
		co.reverse=false
	end
	if keys:isDown("smartbomb") then
		if not co.bomb then
			entity.eventManager:fireEvent(SmartBomb())
			co.bomb=true
		end
	else
		co.bomb=false
	end

	if co.dir == 1 then
		if co.offset > co.leftoffset then
			co.offset = co.offset - 2
		end
	end
	if co.dir == -1 then
		if co.offset < co.rightoffset then
			co.offset = co.offset + 2
		end
	end

	pos.dx = co.speed * co.dir 
	pos.x = pos.x + pos.dx * dt

	gl.cam_pos = pos.x - co.offset

end

return state
