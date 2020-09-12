require "game/util"
require "events/NPCCollide"
require "events/PlayerHit"
require "events/WorldExplode"
require "events/PlayerCollide"

local CollideSystem = class("CollideSystem", System)

function CollideSystem:update(dt)

	for index, entity in pairs(self.targets) do

		if entity:has("CollidePlayer") then
			self:check_collision(entity,"Player")
		end
		if entity:has("CollideLaser") then
			self:check_collision(entity,"Laser")
			-- handle wraparound
			local pos=entity:get("Position")
			if pos.x > gl.worldwidth - gl.ww then
				self:check_collision(entity,"Laser",-gl.worldwidth)
			end
			if pos.x < gl.ww then
				self:check_collision(entity,"Laser",gl.worldwidth)
			end
		end
	end
end

function CollideSystem:check_collision(self_entity,target,offset)

	local offs= offset or 0
	local coll=self_entity:get("Collide")
	if not coll then return end

	local pos=self_entity:get("Position") 
	local worldbox=box_translate(coll.box,pos.x,pos.y) 
	for key,entity in pairs(gl.engine:getEntitiesWithComponent(target)) do
		if entity:isActive() then
			local ecol=entity:get("Collide")
			if ecol then
				local epos=entity:get("Position")
				local eworldbox=box_translate(ecol.box,epos.x,epos.y) 
				if box_collision(worldbox,eworldbox,offs) then
					if self_entity:has("Deadly") and entity.name == "Player" and not gl.nodie then
						entity.eventManager:fireEvent(NPCCollide(self_entity))
						entity.eventManager:fireEvent(PlayerHit(self_entity))
					end 
					if self_entity:has("Human") and entity.name == "Player" then
						returns=entity.eventManager:fireEvent(PlayerCollide(self_entity))
					end
					if self_entity:has("Shootable") and target == "Laser" and entity:get("Laser").active then
						entity.eventManager:fireEvent(NPCCollide(self_entity))
						entity:get("Laser").active=false
					end
				end
			end
		end
	end

end

function CollideSystem:requires()
	return {"Collide"}
end

return CollideSystem
