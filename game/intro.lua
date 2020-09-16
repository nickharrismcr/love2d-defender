require "game/graphics"
require "systems/helpers/pixeldraw"
require "lib/log"
require "game/util"

Intro = class("Intro")

function Intro:initialize(dt)
	self.t=0
	self.wcols={{1,0,0,1},{1,1,0,1}}
	self.iwcol=1
	self.twcol=0
	self.gfx=Graphics()
	self.will=self.gfx.williams
	self.willx=self.will:getWidth()
	self.presents=self.gfx.presents
	self.presentsx=self.presents:getWidth()
	self.def=self.gfx.title
	self.defx=self.def:getWidth()
	self.hidef=self.gfx.hititle
	self.hidefx=self.hidef:getWidth()
	self.disperse=2
	self.pcycle=getColorCycleFactory(300)
	self.pcol=nil
	self.dcycle=getColorCycleFactory(50)
	self.dcol=nil

	self.defy=self.hidef:getHeight()
	self.quad=love.graphics.newQuad(0,0,self.defx,self.defy/8,self.defx,self.defy)

	local s1=love.audio.newSource("assets/start.wav","static")
	s1:play()
	self.s2=love.audio.newSource("assets/background.wav","static")
	self.s2:setLooping(true)
	self.s2:play()

	self.txt="+++ Q=UP  A=DOWN  SPACE=REVERSE  ]=THRUST  RETURN=FIRE  BACKSPACE=BOMB +++  PRESS SPACE TO PLAY +++"
end

function Intro:update(dt)

	self.t=self.t+dt
	self.twcol=self.twcol+dt
	if self.twcol > 0.2  then
		self.twcol=0
		self.iwcol=self.iwcol+1
	end
	self.pcol=self.pcycle(dt)
	self.dcol=self.dcycle(dt)
	if self.t>4 then
		self.disperse=math.max(0,self.disperse-dt)
	end
end

function Intro:draw(dt)

	love.graphics.setColor(self.wcols[(self.iwcol%2)+1])
	love.graphics.draw(self.will,gl.ww/2-self.willx/2,100)
	local c=self.pcol
	if self.t > 2 then
		love.graphics.setColor(c.r,c.g,c.b,1)
		love.graphics.draw(self.presents,gl.ww/2-self.presentsx/2,0)
	end
	if self.t > 4 then
		c=self.dcol
		love.graphics.setColor(1,0,0,1)
		self:disp_draw(self.def,gl.ww/2-self.defx/2,400,self.disperse)
		love.graphics.setColor(c.r,c.g,c.b,1)
		self:disp_draw(self.hidef,gl.ww/2-self.hidefx/2,400,self.disperse)
	end
	if self.t > 6 then
		love.graphics.setColor(0,0,1,1)
		love.graphics.print(self.txt,gl.ww/2-550,gl.wh-100,0,1.5,1.5)
	end
	
end

function Intro:disp_draw(graphic, x, y , disperse )

	for i=0,7 do
		self.quad:setViewport(0,i*(self.defy/8),self.defx,self.defy/8,self.defx,self.defy)
		love.graphics.draw(graphic,self.quad,x-8*disperse*200,y+(i*self.defy/8)+(disperse*200*(i-4)),0,1+(8*disperse),1)
	end
end

