require "game/graphics"
require ('game/sound_mgr')
require "lib/log"

WORLD_ACTIVE=0
WORLD_EXPLODING=1
WORLD_INACTIVE=2


--TODO
--hyperspace
--level end human count/score
--attract mode
--fix freeze on player die

function init_game()

	log.outfile=sf("logs/defender.%s.log",os.date("%d%m%y%H%M%S"))
	log.level="error"

	-- debug
	gl.debug = false 
	gl.nodie= false
	gl.npc_debug=false
	gl.freeze=false 
	-- displays
	gl.db1=nil
	gl.db2=nil
	gl.db3=nil
	gl.db4=nil

	if gl.debug then
		love.window.setMode(1000,500,{vsync=0,fullscreen=false})
	else
		love.window.setMode(0,0,{vsync=1,fullscreen=true})
	end
    love.mouse.setVisible(false)
	gl.canvas=love.graphics.newCanvas(gl.ww,gl.wh)

	-- constants
	gl.pixsize=3
	gl.wh=love.graphics.getPixelHeight()
	gl.ww=love.graphics.getPixelWidth()
	gl.radar_rect={x1=gl.ww/4,y1=0,x2=gl.ww*0.75,y2=gl.wh/8}
	gl.worldwidth = 12000
	gl.top = gl.radar_rect.y2 + 30

	-- set per level
	gl.grabspeed = 2
	gl.landers=10
	gl.humans=10
	gl.lasers=10
	gl.pods=0
	gl.swarmers=15
	gl.bombers=3
	gl.bullet_time=3
	gl.bullet_rate=0.2  -- per second
	gl.level_waves=3
	gl.wave_delay=10
	gl.max_baiters=1

	gl.levels=require("game/levels")

	-- dynamic
	gl.level=0
	gl.lives=3
	gl.bombs=5
	gl.score=0
	gl.worldstatus=WORLD_ACTIVE
	gl.player_pos=nil
	gl.player=nil
	gl.clearcol={r=0,g=0,b=0}
	gl.flash=0
	gl.landers_killed=0
	gl.gamestate=""

	if gl.debug then 
		gl.landers=2
		gl.humans=2
		gl.pods=2
		gl.level_waves=1
		gl.lives=1
		log.level="trace"
		--gl.nodie=true
	end


	local AISystem = require ('systems/update/AI')
	local PositionSystem = require ('systems/update/Position')
	local BulletMgr = require ('systems/update/BulletMgr')
	local LaserMgr = require ('systems/update/LaserMgr')
	local Camera = require('systems/update/Camera')
	local LaserSystem = require ('systems/update/Laser')
	local PlayerSystem = require ('systems/update/Player')
	local ParticleSystem = require ('systems/update/Particle')
	local TextSystem = require ('systems/update/Text')
	local StarSystem = require ('systems/update/Star')
	local LifeSystem = require ('systems/update/Life')
	local CollideSystem = require ('systems/update/Collide')
	local GameSystem = require ('systems/update/Game')
	local ScheduleSystem = require ('systems/update/Schedule')

	local WorldDrawSystem = require ('systems/draw/WorldDraw')
	local NPCDrawSystem = require ('systems/draw/NPCDraw')
	local NPCRadarDrawSystem = require ('systems/draw/NPCRadarDraw')
	local LaserDrawSystem = require ('systems/draw/LaserDraw')
	local PlayerDrawSystem = require ('systems/draw/PlayerDraw')
	local ParticleDrawSystem = require ('systems/draw/ParticleDraw')
	local TextDrawSystem = require ('systems/draw/TextDraw')
	local StarDrawSystem = require ('systems/draw/StarDraw')

	gl.graphics=Graphics()
	gl.sound = SoundMgr()
	gl.sound:load("background","assets/background.wav",true)
	gl.sound:load("baiterdie","assets/baiterdie.wav",false,1)
	gl.sound:load("bomberdie","assets/bomberdie.wav",false,1)
	gl.sound:load("bullet","assets/bullet.wav",false)
	gl.sound:load("caughthuman","assets/caughthuman.wav",false)
	gl.sound:load("die","assets/die.wav",false)
	gl.sound:load("dropping","assets/dropping.wav",false)
	gl.sound:load("grabbed","assets/grabbed.wav",false)
	gl.sound:load("humandie","assets/humandie.wav",false)
	gl.sound:load("landerdie","assets/landerdie.wav",false,1)
	gl.sound:load("laser","assets/laser.wav",false,1)
	gl.sound:load("levelstart","assets/levelstart.wav",false)
	gl.sound:load("materialize","assets/materialise.wav",false)
	gl.sound:load("mutant","assets/mutant.wav",false)
	gl.sound:load("placehuman","assets/placehuman.wav",false)
	gl.sound:load("extralife","assets/start.wav",false)
	gl.sound:load("thruster","assets/thruster.wav",true)
	gl.sound:load("poddie","assets/poddie.wav",false)
	gl.sound:load("swarmer","assets/swarmer.wav",false,1)
	gl.sound:setVolume("thruster",0.3)

	Engine:include(require ("game/engine_mixins"))
	local engine = Engine()

	local ai_sys=AISystem()
	local player_sys=PlayerSystem()
	local star_sys=StarSystem()
	local particle_sys=ParticleSystem()
	local g_bullet = gl.graphics:get("bullet")
	local g_mini = gl.graphics:get("mini_bullet")
	local g_bomb = gl.graphics:get("bomb")
	local bulletmgr = BulletMgr(engine,g_bullet,g_mini,g_bomb)
	local lasermgr = LaserMgr(engine)
	local game_sys = GameSystem()

	-- system.engine set by addSystem!
	engine:addSystem(player_sys,"update")
	engine:addSystem(game_sys,"update")
	engine:addSystem(ai_sys,"update")
	engine:addSystem(PositionSystem(),"update")
	engine:addSystem(star_sys,"update")
	engine:addSystem(LaserSystem(),"update")
	engine:addSystem(TextSystem(),"update")
	engine:addSystem(particle_sys,"update")
	engine:addSystem(LifeSystem(),"update")
	engine:addSystem(CollideSystem(),"update")
	engine:addSystem(ScheduleSystem(),"update")

	engine:addSystem(PlayerDrawSystem(),"draw")
	engine:addSystem(NPCDrawSystem(),"draw")
	engine:addSystem(NPCRadarDrawSystem(),"draw")
	engine:addSystem(WorldDrawSystem(),"draw")
	engine:addSystem(LaserDrawSystem(),"draw")
	engine:addSystem(StarDrawSystem(),"draw")
	engine:addSystem(TextDrawSystem(),"draw")
	engine:addSystem(ParticleDrawSystem(),"draw")

	engine.camera=Camera()

	-- logger listener for engine events
	logger={}
	function logger:event(ev) 
		log.trace(ev.class.name)
		log.trace(tt(ev))
	end

	------------------------------------------------------------------------
	-- EVENT LISTENERS
	------------------------------------------------------------------------
	-- from player state
	engine.eventManager:addListener("PlayerStart",engine,engine.startAI)
	engine.eventManager:addListener("PlayerStart",game_sys,game_sys.playerStartEvent)
	engine.eventManager:addListener("LevelStart",gl.sound,gl.sound.play_func(gl.sound,"levelstart"))
	engine.eventManager:addListener("LevelStart",gl.sound,gl.sound.play_func(gl.sound,"background"))
	engine.eventManager:addListener("Materialize",gl.sound,gl.sound.play_func(gl.sound,"materialize"))
	engine.eventManager:addListener("PlayerFire",lasermgr, lasermgr.fireEvent)
	engine.eventManager:addListener("PlayerFire",gl.sound,gl.sound.play_func(gl.sound,"laser"))
	engine.eventManager:addListener("PlayerExplode",engine,engine.stopAI)
	engine.eventManager:addListener("PlayerExplode",ai_sys,ai_sys.resetEvent)
	engine.eventManager:addListener("PlayerExplode",particle_sys,particle_sys.fireEvent)
	engine.eventManager:addListener("PlayerExplode",gl.sound,gl.sound.play_func(gl.sound,"die"))
	engine.eventManager:addListener("PlayerDie",bulletmgr,bulletmgr.stopAllEvent)
	engine.eventManager:addListener("SmartBomb",ai_sys, ai_sys.smartBombEvent)
	engine.eventManager:addListener("SmartBomb",gl.sound,gl.sound.play_func(gl.sound,"die"))
	-- from collision
	engine.eventManager:addListener("PlayerHit",player_sys, player_sys.killEvent)
	engine.eventManager:addListener("PlayerCollide",player_sys, player_sys.playerCollide)
	engine.eventManager:addListener("NPCCollide",ai_sys, ai_sys.collideEvent)
	engine.eventManager:addListener("NPCKill",game_sys, game_sys.updateScoreEvent)
	engine.eventManager:addListener("NPCKill",game_sys, game_sys.forwardSoundEvent)
	engine.eventManager:addListener("NPCKill",game_sys, game_sys.checkCountsEvent)
	engine.eventManager:addListener("HumanRescued",engine, engine.addScoreEvent)
	engine.eventManager:addListener("HumanRescued",game_sys,game_sys.updateScoreEvent)
	engine.eventManager:addListener("HumanRescued",gl.sound,gl.sound.play_func(gl.sound,"caughthuman"))
	-- ???
	engine.eventManager:addListener("WorldExplode",ai_sys, ai_sys.mutateAll)
	-- from ai state
	engine.eventManager:addListener("FireBullet",bulletmgr,bulletmgr.fireEvent)
	engine.eventManager:addListener("HumanGrabbed",gl.sound,gl.sound.play_func(gl.sound,"grabbed"))
	engine.eventManager:addListener("HumanDropped",gl.sound,gl.sound.play_func(gl.sound,"dropping"))
	engine.eventManager:addListener("HumanDie",gl.sound,gl.sound.play_func(gl.sound,"humandie"))
	engine.eventManager:addListener("PodKill",engine,engine.addSwarmersEvent)
	engine.eventManager:addListener("PodKill", gl.sound,gl.sound.play_func(gl.sound,"poddie"))
	-- from human state
	engine.eventManager:addListener("HumanSaved",engine, engine.addScoreEvent)
	engine.eventManager:addListener("HumanSaved",game_sys,game_sys.updateScoreEvent)
	engine.eventManager:addListener("HumanSaved",gl.sound,gl.sound.play_func(gl.sound,"placehuman"))
	engine.eventManager:addListener("HumanLanded",game_sys,game_sys.updateScoreEvent)
	engine.eventManager:addListener("HumanLanded",engine, engine.addScoreEvent)
	engine.eventManager:addListener("HumanLanded",gl.sound,gl.sound.play_func(gl.sound,"caughthuman"))
	-- from engine
	--engine.eventManager:addListener("ComponentRemoved",logger,logger.event)
	--engine.eventManager:addListener("EntityDeactivated",logger,logger.event)
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	
	-- (debug) hook for collide system component remove
	local cs=engine:getSystem("CollideSystem")
	--function cs:onRemoveEntity (entity,index)
		--log.trace(sf("system removed ent %s",tt(entity)))
	--end

	engine:addParticles()
	engine:addWorld()
	engine:addPlayer()
	engine:addGame()

	star_sys:create()

	-- score text
	local sys=engine:getSystem("TextSystem")
	gl.score_id=sys:addString(10,10,1,sf("%07d",gl.score))

	gl.engine=engine
	return engine
end
