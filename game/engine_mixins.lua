-- helper functions engine mixin

local World = require ('components/update/World')
local WorldDraw = require ('components/draw/WorldDraw')
local Particle = require ('components/update/Particle')
local ParticleDraw = require ('components/draw/ParticleDraw')
local Text = require ('components/update/Text')
local TextDraw = require ('components/draw/TextDraw')
local Game = require ('components/update/Game')
local AI=require("components/update/AI")
local Collide=require("components/update/Collide")
local Life=require("components/update/Life")
local Position=require("components/update/Position")
local NPCDraw=require("components/draw/NPCDraw")
local NPCRadarDraw=require("components/draw/NPCRadarDraw")

local lander_g=gl.graphics:get("lander")
local lander_rg=gl.graphics:get("r_lander")   --radar
local swarmer_g=gl.graphics:get("swarmer")
local swarmer_rg=gl.graphics:get("r_swarmer")   --radar
local pod_g=gl.graphics:get("pod")
local pod_rg=gl.graphics:get("r_pod")   --radar
local bomber_g=gl.graphics:get("bomber")
local bomber_rg=gl.graphics:get("r_bomber")   --radar
local baiter_g=gl.graphics:get("baiter")
local baiter_rg=gl.graphics:get("r_baiter")   --radar
local human_g=gl.graphics:get("human")
local human_rg=gl.graphics:get("r_human")

-----------------------------------------------------------------------------
local mixins = {

	levelSet = function(self)
		
		if not gl.debug then
			
			leveldata=gl.levels[gl.level] 
			gl.grabspeed  = leveldata.grabspeed 
			gl.landers = leveldata.landers
			gl.humans = leveldata.humans
			gl.lasers = leveldata.lasers
			gl.pods = leveldata.pods
			gl.swarmers = leveldata.swarmers
			gl.bombers = leveldata.bombers
			gl.bullet_time = leveldata.bullet_time
			gl.bullet_rate = leveldata.bullet_rate
			gl.level_waves = leveldata.level_waves
			gl.wave_delay = leveldata.wave_delay
			gl.max_baiters = leveldata.max_baiters
		end
	end,

	-- entry = function, delay, delay type
	schedule = function(self,entry)

		if not self._queue then self._queue={} end
		local ent={
			func=entry[1],
			delay=entry[2],
			delay_type=entry[3]
		}
		table.insert(self._queue,ent)
	end,

	addSwarmersEvent = function(self,event)

		for i = 1,gl.swarmers do
			local entity=Entity(nil,"Swarmer")
			entity:add(Position(event.x,event.y))
			entity:add(AI("swarmer","chase"))
			entity:add(NPCDraw(swarmer_g,300))
			entity:add(NPCRadarDraw(swarmer_rg,100))
			entity:add(self.camera)
			entity:add(gl.world)
			entity:add(Collide(swarmer_g))
			entity:addMultipleTags({"CollidePlayer","CollideLaser"})
			self:addEntity(entity)
			log.trace("Added Swarmer")

		end
	end,
	
	--TODO multiple from level def
	addPods = function(self) 

		for i = 1,gl.pods do

			local entity=Entity(nil,"Pod")
			local x=gl.player_pos.x+randf(0,1000)
			local y=randf(gl.top,gl.wh-400)
			entity:add(Position(x,y))
			entity:add(AI("pod","drift"))
			entity:add(NPCDraw(pod_g,300))
			entity:add(NPCRadarDraw(pod_rg,100))
			entity:add(self.camera)
			entity:add(gl.world)
			entity:add(Collide(pod_g))
			entity:addMultipleTags({"CollidePlayer","CollideLaser"})
			self:addEntity(entity)
			log.trace("Added Pod")
		end
	end,

	addBombers = function(self)

		for i = 1,gl.bombers do
			local entity=Entity(nil,"Bomber")
			entity:add(Position(0,0))
			entity:add(AI("bomber","bomb",4),2)
			local npcd=NPCDraw(bomber_g,50)
			entity:add(npcd)
			entity:add(NPCRadarDraw(bomber_rg,30))
			entity:add(self.camera)
			entity:add(gl.world)
			entity:add(Collide(bomber_g))
			entity:addMultipleTags({"CollidePlayer","CollideLaser"})
			self:addEntity(entity)
			log.trace("Added Bomber")
		end
	end,

	addBaiter = function(self) 

		local entity=Entity(nil,"Baiter")
		entity:add(Position(0,0))
		entity:add(AI("baiter","wait",4),2)
		entity:add(NPCDraw(baiter_g,170))
		entity:add(NPCRadarDraw(baiter_rg,30))
		entity:add(self.camera)
		entity:add(gl.world)
		entity:add(Collide(baiter_g))
		entity:addMultipleTags({"CollidePlayer","CollideLaser"})
		self:addEntity(entity)
		log.trace("Added Baiter")

	end,

	addLanders = function (self,number)

		local function addit(x)
			local entity=Entity(nil,"Lander")
			local y =math.random(10,600)
			entity:add(Position(x,y))
			local initstate="wait"
			if gl.worldstatus == WORLD_EXPLODING then 
				initstate="mutant"	
			end
			entity:add(AI("lander",initstate,2))
			entity:add(NPCDraw(lander_g,130))
			entity:add(NPCRadarDraw(lander_rg,130))
			entity:add(self.camera)
			entity:add(gl.world)
			entity:add(Collide(lander_g))
			entity:addMultipleTags({"CollidePlayer","CollideLaser"})
			self:addEntity(entity)
			log.trace(sf("added Lander "))
		end
		-- add one near player
		addit(math.random(gl.player_pos.x,gl.player_pos.x+gl.ww/2))
		-- add rest
		for i = 1, number - 1 do
			x = math.random(10,gl.worldwidth)
			addit(x)
		end
	end,

	addHumans = function (self,number)


		for i = 1, number do
			local entity=Entity(nil,"Human")
			local x=math.random(10,gl.worldwidth)
			local y=700
			entity:add(AI("human","walking"),2)
			entity:add(Position(x,y))
			entity:add(NPCDraw(human_g,1))
			entity:add(NPCRadarDraw(human_rg,1))
			entity:add(self.camera)
			entity:add(gl.world)
			entity:addMultipleTags({"Human","Shootable"})
			entity:add(Collide(human_g))
			entity:addTag("CollideLaser")
			self:addEntity(entity)
		end
	end,

	addScoreEvent = function (self,event)

		local score_g
		if event.name=="HumanSaved" then score_g=gl.graphics:get("s500") end 
		if event.name=="HumanRescued" then score_g=gl.graphics:get("s500") end 
		if event.name=="HumanLanded" then score_g=gl.graphics:get("s250") end 
		local evpos=event.entity:get("Position")

		local entity=Entity(nil,"Score")
		local npc=AI("score","score")
		local pos=Position(evpos.x,evpos.y-50)
		pos.dx=gl.player_pos.dx
		entity:add(npc)
		entity:add(pos)
		entity:add(NPCDraw(score_g,20,2))
		entity:add(self.camera)
		entity:add(gl.world)
		entity:add(Life(2))
		self:addEntity(entity)
	end,

	stopAI =function (self) self:stopSystem("AISystem") end,
	startAI = function (self) self:startSystem("AISystem") end,

	addParticles= function(self)
		-- particle system
		local particles=Particle()
		local ent=Entity()
		ent:add(particles)
		ent:add(ParticleDraw())
		ent:add(self.camera)
		self:addEntity(ent)
	end,

	addWorld= function(self)
		-- world mountains
		local world=World()
		entity=Entity(nil,"World")
		entity:add(WorldDraw())
		entity:add(world)
		entity:add(self.camera)
		self:addEntity(entity)
		gl.world=world
	end,

	addPlayer = function(self)

		local pg=gl.graphics:get("player")
		local ptg=gl.graphics:get("thrust")
		local pbg=gl.graphics:get("smartbomb")
		local Player=require("components/update/Player")
		local Position=require("components/update/Position")
		local Collide=require("components/update/Collide")
		local PlayerDraw=require("components/draw/Player")
		local player=Player("play")
		local entity=Entity(nil,"Player")
		entity:add(player)
		local pos=Position(gl.worldwidth/2,400)
		entity:add(pos)
		entity:add(PlayerDraw(pg,ptg,pbg,50,220))
		entity:add(Collide(pg))
		entity:add(self.camera)
		gl.player=player
		gl.player_pos=pos
		self:addEntity(entity)
	end,

	addGame = function(self)
		-- game state
		local game=Game()
		entity=Entity(nil,"Game")
		entity:add(game)
		self:addEntity(entity)
	end,

}

return mixins
