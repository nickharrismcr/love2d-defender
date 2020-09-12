LaserMgr = class("LaserMgr")
log=require("lib/log")
require "game/util"

local Laser = require ('components/update/Laser')
local Collide = require ('components/update/Collide')
local Position = require ('components/update/Position')
local LaserDraw = require ('components/draw/LaserDraw')

-------------------------------------------------------------------------------------------
function LaserMgr:initialize(engine)


	self.engine=engine
	self.colors={yellow,yellow,yellow,cyan,cyan,cyan,green,green,green,blue,blue,blue}
	self.color=1

	for i = 1, gl.lasers do

		ent = Entity(nil,"Laser")
		ent:add(Laser())
		ent:add(Collide())
		ent:add(Position(-1000,-1000))
		ent:add(LaserDraw())
		engine:addEntity(ent)
	end
end
-------------------------------------------------------------------------------------------
function LaserMgr:fireEvent(event)

	for k,v in pairs(self.engine:getEntitiesWithComponent("Laser")) do
		ai=v:get("Laser")
		pos=v:get("Position")
		if not ai.active then
			self.color=self.color+1
			ai.active=true
			pos.x=event.x+70*event.dir
			pos.y=event.y + 7
			ai.dir=event.dir
			ai.len=20
			ai.alive=0
			ai.color=self.colors[self.color%12+1]
			break
		end
	end
end

-------------------------------------------------------------------------------------------
return LaserMgr 
