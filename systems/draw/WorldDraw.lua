require "game/util"

local WorldDrawSystem = class("WorldDrawSystem", System)

function WorldDrawSystem:initialize() 

	System.initialize(self)
end

local dys = { -2,-1,0,1,2 } 

function WorldDrawSystem:draw(dt)

	for index, value in pairs(self.targets) do

		local world=value:get("World")
		local camera=value:get("Camera")

		if gl.worldstatus == WORLD_EXPLODING then 
			for i=1,500 do
				local ind=math.random(1,world.worldwidth)
				local wp=world.points
				wp[ind]=wp[ind]+dys[(ind%5)+1]*love.timer.getDelta()*300
				if coin(0.02) then world.points[ind]=-1000 end
			end	
		end

		self:DoDraw(world.points, camera.x )
		self:DoDrawRadar(world.points, camera.x  )
	end
end

function WorldDrawSystem:DoDraw(points,offset)

	local s=4
	if gl.worldstatus == WORLD_EXPLODING then
		s=8
	end

	for i = 1, gl.ww,4 do

		local ind=math.floor(i+offset-((i+offset)%4))

		if ind > gl.worldwidth then ind = ind - gl.worldwidth end
		if ind <= 0 then ind = ind + gl.worldwidth end

		local y=points[ind]
		if y < gl.wh then 
			local x=i
			love.graphics.setColor(1,0.5,0)
			love.graphics.rectangle("fill",x,y,s,s)
			love.graphics.setColor(1,0.5,0,0.05)
			love.graphics.rectangle("fill",x-s,y-s,s*2,s*2)
			love.graphics.rectangle("fill",x-s*2,y-s*2,s*4,s*4)
		end
	end
end

function WorldDrawSystem:DoDrawRadar(points,offset)

	local rr=gl.radar_rect

	for i = 1, gl.worldwidth,20 do

		local ind=math.floor(i-offset)+gl.worldwidth/2.25

		if ind > gl.worldwidth then ind = ind - gl.worldwidth end
		if ind <= 0 then ind = ind + gl.worldwidth end


		local x=rr.x1+(ind/gl.worldwidth)*(rr.x2-rr.x1)
		local y=rr.y1+(points[i]/gl.wh)*rr.y2

		if y < rr.y2  then
			love.graphics.setColor(1,0.5,0)
			love.graphics.rectangle("fill",x,y,1,1)
		end
	end

end

function WorldDrawSystem:requires()
	return {"World","WorldDraw", "Camera"}
end

return WorldDrawSystem
