log=require("lib/log")
require "game/util"

local Game = class("Game")

function Game:initialize()

	self.state=nil
	self.next_state="level_start"
	self.level=1
	self.lives=5
	self.score=0
	self.t=0
end

return Game
