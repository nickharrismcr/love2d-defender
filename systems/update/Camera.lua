require "game/util"

local Camera = class("Camera", System)

function Camera:initialize()

	self.x=0
end

function Camera:update(dt)

	self.x = gl.cam_pos
	if self.x > gl.worldwidth then self.x = 0 end
	if self.x < -gl.ww then self.x = gl.worldwidth-gl.ww end
end

return Camera
