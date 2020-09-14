local SoundMgr = class("SoundMgr")
    
function SoundMgr:initialize()

   self.sounds={}
   self.mute=false

end
    
function SoundMgr:load(name, filename, looping)
        
    local s=love.audio.newSource(filename,"static")
	if looping then
		s:setLooping(true)
	end
	self.sounds[name]=s
end

function SoundMgr:get(name)

    return self.sounds[name]
    
end

function SoundMgr:play_func(name)

	log.trace(sf("soundmanager : return play func %s ",name))
	local f = function(self,event)
		log.trace(sf("soundmanager : play func %s %s %s",name,self,event))
		self:play(name)
	end
	return f

end
    
function SoundMgr:play(name)
        
    if self.mute then return end

    if self.sounds[name] then
		if self.sounds[name]:isPlaying() then
			self.sounds[name]:stop()
		end
        self.sounds[name]:play()
		log.trace(sf("soundmanager : play %s ",name))
	end   
end           

function SoundMgr:stop(name)
        
    if self.sounds[name] then
		if self.sounds[name]:isPlaying() then
			self.sounds[name]:stop()
   		end 
	end
end

function SoundMgr:stopall()
    
	for k,v in pairs(self.sounds) do
        self:stop()
	end
end

            
return SoundMgr            
    
       

