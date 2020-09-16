require "game/util"

local Life = require("components/update/Life")
local AI = require ('components/update/AI')
local Collide = require ('components/update/Collide')
local Position = require ('components/update/Position')
local NPCDraw  = require ('components/draw/NPCDraw')
local FSM = require ('game/fsm')
local StateTree = require ('game/statetree')

local BulletMgr = class("BulletMgr", System)

function BulletMgr:initialize(engine,graphic,mini_graphic,bomb_graphic)

	assert (graphic)
	assert (mini_graphic)

	self.engine=engine
	self.graphic=graphic
	self.mini_graphic=mini_graphic
	self.bomb_graphic=bomb_graphic
	self.bullet_states=StateTree()
	self.bullet_states:addStates("states/npc/bullet",{"fire","die"})
	self.bullet_states:addTransition("fire","die")
end

function BulletMgr:fireEvent(event)

	local entity=Entity(nil,"Bullet")
	local p=gl.player
	local ppos=gl.player_pos
	local ps=p.speed*p.dir
	local time=randf(gl.bullet_time/2,gl.bullet_time)
	time=time/event.speedmult
	local g=self.graphic
	if event.type_=="mini" then g=self.mini_graphic end
	local life=3

	if math.abs(event.x-ppos.x) < gl.ww or event.type_ == "bomb" then
		if not (event.type_ == "bomb" or event.type_== "mini") then
			gl.sound:play("bullet")
		end
		local dx,dy = calc_fire(ppos.x,ppos.y, ps, event.x, event.y, event.accuracy, time, love.timer.getDelta() ) 
		local npcd=NPCDraw(g,60)
		if event.type_=="bomb" then
			dx=0
			dy=0
			life=5
			npcd.cycle=true
			log.trace("bomb fired")
		end

		local bullet_fsm=FSM("Bullet",self.bullet_states,"fire")

		entity:add(AI(bullet_fsm))
		entity:add(Position(event.x,event.y,dx,dy))
		entity:add(npcd)
		entity:add(Collide(g))
		entity:addMultipleTags({"Bullet","Deadly","CollidePlayer"})
		entity:add(gl.world)
		entity:add(Life(life))
		entity:add(self.engine.camera)
		self.engine:addEntity(entity)
	end
end

function BulletMgr:stopAllEvent(event)

	for k,v in pairs(self.engine:getEntitiesWithComponent("Bullet")) do
		self.engine:removeEntity(v)
	end 
end


return BulletMgr
