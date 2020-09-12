require "game/util"
require "systems/helpers/pixeldraw"
local cols={blue,purple,red,orange,yellow,green,cyan}

local TextDrawSystem = class("TextDrawSystem", System)

function TextDrawSystem:draw(dt)

	for index, value in pairs(self.targets) do

		local move=value:get("Text")
		local draw=value:get("TextDraw")
		self:Do(move,draw)
	end
	local rr=gl.radar_rect
	local radar_width=rr.x2-rr.x1
	local radar_win_start=(gl.ww/2)-(gl.ww/2)*radar_width/gl.worldwidth
	local radar_win_width=gl.ww*radar_width/gl.worldwidth

	local col=cols[(gl.level-1)%7+1]
	love.graphics.setColor(col.r,col.g,col.b,1)
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line",rr.x1,rr.y1+5,rr.x2-rr.x1,rr.y2-rr.y1)
	love.graphics.line(0,rr.y2+5,gl.ww,rr.y2+5)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.line(radar_win_start,3,radar_win_start+radar_win_width,3)
	love.graphics.line(radar_win_start,rr.y2+5,radar_win_start+radar_win_width,rr.y2+5)
	love.graphics.setLineWidth(1)
end

function TextDrawSystem:Do(move,draw)

	col=draw.color_func()
	love.graphics.setColor(col.r,col.g,col.b,1)
	love.graphics.draw(draw.texture,draw.quad,move.x,move.y,0,0.75,0.75)
end

function TextDrawSystem:requires()
	return {"Text"}
end

return TextDrawSystem
