require "game/util"
require "systems/helpers/pixeldraw"
local cols={blue,purple,red,orange,yellow,green,cyan}

local TextDrawSystem = class("TextDrawSystem", System)

function TextDrawSystem:initialize()

	System.initialize(self)
	self.rr=gl.radar_rect
	self.radar_width=self.rr.x2-self.rr.x1
	self.radar_win_start=(gl.ww/2)-(gl.ww/2)*self.radar_width/gl.worldwidth
	self.radar_win_width=gl.ww*self.radar_width/gl.worldwidth
end

function TextDrawSystem:draw()

	for index, value in pairs(self.targets) do

		local move=value:get("Text")
		local draw=value:get("TextDraw")
		self:Do(move,draw)
	end

	local col=cols[(gl.level-1)%7+1]
	love.graphics.setColor(col.r,col.g,col.b,1)
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line",self.rr.x1,self.rr.y1+5,self.rr.x2-self.rr.x1,self.rr.y2-self.rr.y1)
	love.graphics.line(0,self.rr.y2+5,gl.ww,self.rr.y2+5)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.line(self.radar_win_start,3,self.radar_win_start+self.radar_win_width,3)
	love.graphics.line(self.radar_win_start,self.rr.y2+5,self.radar_win_start+self.radar_win_width,self.rr.y2+5)
	love.graphics.setLineWidth(1)

end
function TextDrawSystem:Do(move,draw)

	col=draw.color_func(love.timer.getDelta())
	love.graphics.setColor(col.r,col.g,col.b,1)
	love.graphics.draw(draw.texture,draw.quad,move.x,move.y,0,0.75,0.75)
end

function TextDrawSystem:requires()
	return {"Text"}
end

return TextDrawSystem
