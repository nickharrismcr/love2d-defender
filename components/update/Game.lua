log=require("lib/log")
require "game/util"

local Game = class("Game")

function Game:initialize(fsm,ai_system)

	self.level=1
	self.lives=5
	self.score=0
	self.fsm=fsm
	self.ai_system=ai_system
	self.t=0
end

return Game
