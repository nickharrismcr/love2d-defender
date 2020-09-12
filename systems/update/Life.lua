require "game/util"
log=require "lib/log"

local Life = class("Life", System)

local fn=require("states/player/laser")

function Life:update(dt)

	for index, entity in pairs(self.targets) do
		local life=entity:get("Life") 
		life.alive=life.alive+dt
		if life.alive > life.life then 
			log.trace(sf("Life system removed entity %s %s after %s seconds",entity.name,entity.id,life.life))
			gl.engine:removeEntity(entity)
		end
	end
end

function Life:requires()
	return {"Life"}
end

return Life
