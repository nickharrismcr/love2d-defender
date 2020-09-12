require "game/util"
require "game/fsm"

local PositionSystem = class("PositionSystem", System)

function PositionSystem:update(dt)

	for index, value in pairs(self.targets) do
		--dbg()
		local pos=value:get("Position") 
		if pos.x > gl.worldwidth then pos.x = 1 end
        if pos.x < 1 then pos.x = gl.worldwidth  end
		if pos.y < gl.top then pos.y = gl.top end
		if pos.y > gl.wh then pos.y = gl.wh end
	end
end

function PositionSystem:requires()
	return {"Position"} 
end

return PositionSystem
