HooECS = require('lib/HooECS')
HooECS.initialize({ debug=true,gl=true })

require "game/initgame"
require "game/intro"
require "game/initeffect"

dbg=require("lib/debugger")
dbg.auto_where=15
gl={}

local engine
local state
local effect
---------------------------------------------------------------------------
function love.load()

	io.stdout:setvbuf('no')
	math.randomseed(os.time())
	intro=Intro()
	engine=init_game(gl)
	effect=init_effect()
	states={intro,engine}
	gl.state=1
	timer=0
	framecount=0
	up_accum=0
	dr_accum=0
	up_max=0
	dr_max=0
	up_min=100
	dr_min=100
	disps=""
end	
---------------------------------------------------------------------------
function love.update(dt)

	framecount=framecount+1
	if framecount > 200 then
		timer=love.timer.getTime()
	end
	states[gl.state]:update(dt)
	if framecount > 200 then
		local td=love.timer.getTime()-timer
		up_accum=up_accum+td
		if td > up_max then up_max = td end
		if td < up_min then up_min = td end
		if framecount%60==0 then

			local avu=up_accum/framecount
			local avd=dr_accum/framecount
			local hd=0.016-(avu+avd)
			disps=sf("up %f %f %f dr %f %f %f (%f)",up_min,avu,up_max,dr_min, avd,dr_max,hd)
		end
	end

end
---------------------------------------------------------------------------
function love.draw()

	if framecount > 200 then
		timer=love.timer.getTime()
	end
	love.graphics.setCanvas(gl.canvas)
	local col=gl.clearcol
	effect(function()
		love.graphics.clear(col.r,col.g,col.b)
		states[gl.state]:draw()	
	end)
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(gl.canvas,0,0)
	if framecount > 200 then
		local td=love.timer.getTime()-timer
		dr_accum=dr_accum+td
		if td > dr_max then dr_max = td end
		if td < dr_min then dr_min = td end
	end

	love.graphics.print(disps,600,100)
	debug_draw()
end
---------------------------------------------------------------------------
function love.keypressed(key, scancode, isrepeat)

   if key == "escape" then love.event.quit() end
   if key == "space" and gl.state==1 then gl.state=2 end
   if key == "6" then
	   if gl.freeze==false then gl.freeze=true else gl.freeze=false end
   end
   if key == "7" then
	   if gl.npc_debug==false then gl.npc_debug=true else gl.npc_debug=false end
   end
   if key == "8" then
	   if gl.nodie==false then gl.nodie=true else gl.nodie=false end
   end
end
---------------------------------------------------------------------------
function debug_draw()

	love.graphics.print(sf("%4.1f",love.timer.getFPS()),100,100)

	if gl.db1 then 
		love.graphics.print(sf("%s",gl.db1),100,150)
	end
	if gl.db2 then 
		love.graphics.print(sf("%s",gl.db2),100,170)
	end
	if gl.db3 then 
		love.graphics.print(sf("%s",gl.db3),100,190)
	end
	if gl.db4 then 
		love.graphics.print(sf("%s",gl.db4),100,210)
	end
end
