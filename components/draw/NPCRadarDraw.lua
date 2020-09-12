local NPCRadarDraw = class("NPCRadarDraw")

function NPCRadarDraw:initialize(graphic,ticks,pixsize)

	self.graphic = graphic
	self.ticks = ticks
	self.currframe = 1
	self.pixsize=pixsize or 5
	self.t=0
end

return NPCRadarDraw
