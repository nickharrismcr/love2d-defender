local StateTree=require("game/statetree")

-----------------------------------------------------------------------------
local lander_states = StateTree()
lander_states:addStates( "states/npc/lander",{"wait","materialize", "search", "grabbing", "grabbed", "mutant","die" })
lander_states:addTransition( "wait","materialize")
lander_states:addTransition( "materialize", "search")
lander_states:addTransition( "search", "grabbing")
lander_states:addTransition( "search", "mutant")
lander_states:addTransition( "search", "die")
lander_states:addTransition( "grabbing", "grabbed")
lander_states:addTransition( "grabbing", "die" )
lander_states:addTransition( "grabbing", "search" ) 
lander_states:addTransition( "grabbing", "mutant" ) 
lander_states:addTransition( "grabbed", "die" )
lander_states:addTransition( "grabbed", "mutant" )
lander_states:addTransition( "grabbed", "search")
lander_states:addTransition( "mutant", "die")

-----------------------------------------------------------------------------
local swarmer_states = StateTree()
swarmer_states:addStates( "states/npc/swarmer",{"chase", "die" })
swarmer_states:addTransition( "chase", "die")

-----------------------------------------------------------------------------
local pod_states = StateTree()
pod_states:addStates( "states/npc/pod",{"drift", "die" })
pod_states:addTransition( "drift", "die")

-----------------------------------------------------------------------------
local bomber_states = StateTree()
bomber_states:addStates( "states/npc/bomber",{"bomb", "die" })
bomber_states:addTransition( "bomb", "die")

-----------------------------------------------------------------------------
local baiter_states = StateTree()
baiter_states:addStates( "states/npc/baiter",{"wait","materialize", "chase", "die" })
baiter_states:addTransition( "wait","materialize")
baiter_states:addTransition( "materialize", "chase")
baiter_states:addTransition( "chase", "die")

-----------------------------------------------------------------------------
local human_states = StateTree()
human_states:addStates( "states/npc/human",{ "walking", "picked", "grabbed", "falling","eaten","rescued", "die" })
human_states:addTransition( "walking", "picked")
human_states:addTransition( "walking", "die")
human_states:addTransition( "picked", "grabbed")
human_states:addTransition( "picked", "walking")
human_states:addTransition( "picked", "die")
human_states:addTransition( "grabbed", "falling")
human_states:addTransition( "grabbed", "die")
human_states:addTransition( "grabbed", "eaten")
human_states:addTransition( "grabbed", "walking")
human_states:addTransition( "falling", "walking")
human_states:addTransition( "falling", "rescued")
human_states:addTransition( "falling", "die")
human_states:addTransition( "rescued", "walking")

local bullet_states=StateTree()
bullet_states:addStates("states/npc/bullet",{"fire","die"})
bullet_states:addTransition("fire","die")

local score_states = StateTree()
score_states:addStates( "states/npc",{ "score" })

local ret={
	human=human_states,
	lander=lander_states,
	baiter=baiter_states,
	pod=pod_states,
	swarmer=swarmer_states,
	bullet=bullet_states,
	score=score_states,
	bomber=bomber_states
}
return ret
