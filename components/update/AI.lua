log=require("lib/log")
require "game/util"

local AI = class("AI")

function AI:initialize(fsm,init_state,delay)

	self.wait=delay 
	self.fsm=fsm    
	self.state=nil
	self.next_state=init_state
	self.t=0        -- tick counter
	self.accuracy=1 -- bullet accuracy 0 to 1
end

return AI
