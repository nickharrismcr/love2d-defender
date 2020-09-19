require "game/util"
require "systems/helpers/pixeldraw"

local NPCDrawSystem = class("NPCDrawSystem", System)

local cycle=getColorCycleFactory(0.2)

function NPCDrawSystem:draw(dt)

	local cycle_col=cycle(love.timer.getDelta())

	for index, value in pairs(self.targets) do

		local ai=value:get("AI")
		local pos=value:get("Position")
		local draw=value:get("NPCDraw")
		if draw.visible then 

			draw.on_screen=false
			local g=draw.graphic
			local rg=draw.r_graphic
			local camera=gl.engine.camera
			local translate=pos.x-camera.x
			if pos.x < (camera.x + gl.ww - gl.worldwidth) then
				translate=translate+gl.worldwidth
			end
			if pos.x > (gl.worldwidth + camera.x ) then
				translate=translate-gl.worldwidth
			end
			if translate > - 100 and translate < gl.ww + 100 then
				if gl.npc_debug then 
					self:debugDraw(value,ai,translate,pos)
				end
				draw.on_screen=true
				local col
				if draw.cycle then 
					col=cycle_col
				end
				pixeldraw_disperse(translate ,pos.y,g,draw.currframe, draw.disperse,draw.pixsize,col)
			end

			draw.t=draw.t+600*love.timer.getDelta()
			if draw.t > draw.ticks and draw.frames > 1 and draw.disperse == 1 then
				draw.t = 0
				if draw.currframe == draw.frames then
					draw.currframe = 1
				else
					draw.currframe = draw.currframe + 1
				end
			end
		end
	end
end

function NPCDrawSystem:debugDraw(value,ai,translate,pos)

	love.graphics.setColor(1,1,1,1)
	if ai.fsm.state then
		love.graphics.print(ai.fsm.state,translate+30,pos.y-20,0,1,1)
		love.graphics.print(sf("%s %s",math.floor(pos.x),math.floor(pos.y)),translate+30,pos.y,0,1,1)
		love.graphics.print(value.id,translate+30,pos.y+20,0,1,1)
		if ai.target then
			love.graphics.print(sf("t=%s",ai.target.id),translate+30,pos.y+40,0,1,1)
		end
	end
	local coll=value:get("Collide")
	if coll then
		love.graphics.rectangle("line",translate+coll.box[1],pos.y+coll.box[2],2*coll.box[3],2*coll.box[4])
	end
end

function NPCDrawSystem:requires()
	return {"NPCDraw", "Camera"}
end

return NPCDrawSystem
