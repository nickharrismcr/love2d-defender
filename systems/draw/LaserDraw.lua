
log=require "lib/log"
require "game/util"

local LaserDrawSystem = class("LaserDrawSystem", System)

function LaserDrawSystem:draw(dt)

	for index, value in pairs(self.targets) do
		local ai=value:get("Laser")
		if ai.active then 
			local pos=value:get("Position")
			local draw=value:get("LaserDraw")
			local g=draw.graphic
			local camera=gl.engine.camera
			local translate=pos.x-camera.x
			if pos.x < (camera.x + gl.ww - gl.worldwidth) then
				translate=translate+gl.worldwidth
			end
			if pos.x > (gl.worldwidth + camera.x ) then
				translate=translate-gl.worldwidth
			end
			local c=ai.color
			love.graphics.setColor(c.r,c.g,c.b,1)
			love.graphics.rectangle("fill",translate,pos.y,ai.len,2)

			love.graphics.setColor(0,0,0,1)
			for i=1,20,2 do
				local xs=ai.gaps[i]
				local xw=ai.gaps[i+1]
				love.graphics.rectangle("fill",translate+xs,pos.y,xw,2)
				if (math.floor(ai.alive*100))%10 == 0 then
					ai.gaps[i]=randf(0,ai.len)
					ai.gaps[i+1]=randf(2,15)
				end
			end
			love.graphics.setColor(c.r,c.g,c.b,1)

		end
	end
end

function LaserDrawSystem:requires()
	return {"Laser","LaserDraw"}
end

return LaserDrawSystem
