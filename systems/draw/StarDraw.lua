require "game/util"

local StarDrawSystem = class("StarDrawSystem", System)


function StarDrawSystem:draw(dt)

	for index, value in pairs(self.targets) do

		local component=value:get("Star")
		self:Do(component)
	end
end

function StarDrawSystem:Do(component)

	local c=component.col
	love.graphics.setColor(c.r,c.g,c.b,1)
	love.graphics.circle("fill",component.x,component.y,2)
end

function StarDrawSystem:requires()
	return {"Star"}
end

return StarDrawSystem
