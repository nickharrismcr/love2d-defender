require "game/util"
require "systems/helpers/pixeldraw"

local NPCRadarDrawSystem = class("NPCRadarDrawSystem", System)

function NPCRadarDrawSystem:draw(dt)

	for index, value in pairs(self.targets) do
		local ai=value:get("AI")
		local pos=value:get("Position")
		local maindraw=value:get("NPCDraw")
		if maindraw.visible then 

			local draw=value:get("NPCRadarDraw")
			local g=draw.graphic
			local camera=gl.engine.camera
			local translate=pos.x-camera.x
			if pos.x < (camera.x + gl.ww - gl.worldwidth) then
				translate=translate+gl.worldwidth
			end
			if pos.x > (gl.worldwidth + camera.x ) then
				translate=translate-gl.worldwidth
			end
			if pos.y < gl.wh and g then
				self:DoRadarDrawRadar(pos.x,pos.y,g,draw.currframe)
			end

			draw.t = draw.t + 1
			if draw.t > draw.ticks and draw.graphic.frames > 1 then
				draw.t = 0
				if draw.currframe == draw.graphic.frames then
					draw.currframe = 1
				else
					draw.currframe = draw.currframe + 1
				end
			end
		end
	end
end


function NPCRadarDrawSystem:DoRadarDrawRadar(x,y,graphic,frame)

	local rr=gl.radar_rect
	local radar_width=rr.x2-rr.x1
	local screen_x = x - gl.cam_pos
	local radar_win_start=(gl.ww/2)-(gl.ww/2)*radar_width/gl.worldwidth
	local xp=radar_win_start+(screen_x * radar_width/gl.worldwidth)
	if xp < rr.x1 then xp = xp + radar_width end
	if xp > rr.x2 then xp = xp - radar_width end
	local yp=y/8

	pixeldraw(xp,yp,graphic,frame,3)
end

function NPCRadarDrawSystem:requires()
	return {"NPCRadarDraw", "Camera"}
end

return NPCRadarDrawSystem
