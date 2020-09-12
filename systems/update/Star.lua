require "game/util"
local Star=require "components/update/Star"

local StarSystem = class("StarSystem", System)


function StarSystem:initialize()

	System.initialize(self)
end

function StarSystem:create()
	
	for i = 1,30 do
		local ent = Entity()
		local star=Star()
		star.col=colors(math.random(1,8))
		star.x=randf(1,gl.ww)
		star.y=randf(gl.top,gl.wh-200)
		star.life=randf(0.5,3)
		ent:add(star)
		self.engine:addEntity(ent)
	end
end

function StarSystem:update(dt)

	local sp=gl.player
	local dx=sp.speed*dt/20*sp.dir
	for index, value in pairs(self.targets) do

		local comp=value:get("Star")
		comp.alive = comp.alive + dt
		comp.x=comp.x-dx
		if comp.alive > comp.life then
			comp.col=colors(math.random(1,8))
			comp.x=randf(1,gl.ww)
			comp.y=randf(gl.top,gl.wh-200)
			comp.alive=0
		end

	end
end


function StarSystem:requires()
	return {"Star"}
end

return StarSystem
