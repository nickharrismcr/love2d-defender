local PlayerDraw = class("PlayerDraw")

function PlayerDraw:initialize(graphic,tgraphic,bgraphic,ticks,tticks)

	self.graphic = graphic
	self.tgraphic = tgraphic
	self.bgraphic = bgraphic
	self.ticks = ticks
	self.tticks = tticks
	self.t1=0
	self.t2=0
	self.hide=false
	self.disperse=1
	self.flashtime=15
	self.flashcounter=0
	self.flash=0
end

return PlayerDraw
