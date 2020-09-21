require "game/util"
require "events/FireBullet"

local state={}

-- returns entity
local function pick_target(entity)

	return random_choice(gl.engine:getEntitiesWithComponent("Human"))
end

function state:enter(ai,world,entity,dt)

	entity:addMultipleTags({"Shootable","Deadly"})
	local pos=entity:get("Position")
	pos.dx=choice({-1,1})
	pos.dy=0.1
	ai.accuracy=0.9
	-- pick a random human to target
	ai.target=pick_target(entity)
end

function state:update (ai,world,entity,dt)

	if gl.freeze then return end 

	local pos=entity:get("Position")
	if math.floor(ai.t)%2 == 0 then 
		local newy = world:at(pos.x)-150
		pos.dy = math.min(0.3,( newy - pos.y ) / 200)
	end
	pos.y = pos.y + (pos.dy * dt * 240 )
	pos.x = pos.x + (pos.dx * dt * 240 ) 

	local draw=entity:get("NPCDraw")
	if coin(gl.bullet_rate*dt) and draw.on_screen then
		entity.eventManager:fireEvent(FireBullet(pos.x,pos.y,ai.accuracy))
	end

	if ai.target then 
		-- our human may have died, if so pick another
		if not ai.target:isActive() then
			ai.target=pick_target(entity)
		end
		local hum_pos=ai.target:get("Position")
		local hum_ai=ai.target:get("AI")
		if intersect(hum_pos.x,pos.x,10) and hum_ai.state == "walking" then
			ai.next_state="grabbing"
			hum_ai.next_state="picked" 
			ai.target.parent = entity
			ai.human = ai.target
			if draw.on_screen then
				entity.eventManager:fireEvent(FireBullet(pos.x,pos.y))
			end
		end
	end

end


return state
