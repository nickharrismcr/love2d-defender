require "game/graphics"
require "lib/log"

Intro = class("Intro")

function Intro:initialize(dt)
	self.t=0
end

function Intro:update(dt)
	self.t=self.t+dt
	if self.t > 3 then
		gl.state=2
	end
end
function Intro:draw(dt)

end

