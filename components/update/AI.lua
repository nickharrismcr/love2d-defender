log=require("lib/log")
require "game/util"

local AI = class("AI")

function AI:initialize(fsm,delay)

	self.wait=delay 
	self.fsm=fsm    
	self.t=0        -- tick counter
	self.accuracy=1 -- bullet accuracy 0 to 1
end

return AI
