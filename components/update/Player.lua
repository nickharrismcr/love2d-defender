local Player = class("Player")
require "game/util"

function Player:initialize(fsm)
	
	self.state=nil
	self.next_state=nil
	self.speed=0
	self.maxspeed=1500
	self.dir=1
	self.fsm=fsm
	self.t=0
	self.disperse=1
	self.offset=100
	self.leftoffset=300
	self.rightoffset=gl.ww-300
end

return Player
