local NPCDraw = class("NPCDraw")

function NPCDraw:initialize(graphic,ticks,pixsize)

	self.visible=true
	self.graphic = graphic
	self.ticks = ticks
	self.t = 0
	self.frames = graphic.frames
	self.currframe = 1
	self.pixsize=pixsize or 5
	self.disperse=1
	self.on_screen=false
	self.cycle=false
end

return NPCDraw
