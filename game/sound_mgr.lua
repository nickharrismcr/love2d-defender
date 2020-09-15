local SoundMgr = class("SoundMgr")
    
function SoundMgr:initialize()

   self.sounds={}
   self.groups={}
   self.mute=false

end
    
function SoundMgr:load(name, filename, looping, group)
        
    local s={love.audio.newSource(filename,"static"),0}
	if looping then
		s[1]:setLooping(true)
	end
	if group then
		s[2]=group
		if not self.groups[group] then
			self.groups[group]={}
		end
		table.insert(self.groups[group],s)
	end
	self.sounds[name]=s
end

function SoundMgr:isPlaying(name)

	if self.sounds[name] then
		return self.sounds[name]:isPlaying()
	end
	return false
end

function SoundMgr:play_func(name)

	log.trace(sf("soundmanager : return play func %s ",name))
	local f = function(self,event)
		log.trace(sf("soundmanager : play func %s %s %s",name,self,event))
		self:play(name)
	end
	return f

end
    
function SoundMgr:setPitch(name,pitch)
	local s=self.sounds[name]
    if s then
		s[1]:setPitch(pitch)
	end
end
function SoundMgr:setVolume(name,volume)
	local s=self.sounds[name]
    if s then
		s[1]:setVolume(volume)
	end
end

-- play if not playing
function SoundMgr:playIfNot(name)

	local s=self.sounds[name]
    if s then
		if not s[1]:isPlaying() then
			self:play(name)
		end
	end
end

-- force play 
function SoundMgr:playMultiple(name)

	local s=self.sounds[name]
    if s then
		s[1]:play()
	end
end

-- restart if already playing
function SoundMgr:play(name)
        
    if self.mute then return end

	local s=self.sounds[name]
    if s then
		s[1]:stop()
		if s[2] > 0 then
			for i,v in ipairs(self.groups[s[2]]) do
				v[1]:stop()
			end
		end
        s[1]:play()
	end   
end           

function SoundMgr:stop(name)
        
	local s=self.sounds[name]
    if s then
		if s[1]:isPlaying() then
			s[1]:stop()
   		end 
	end
end

function SoundMgr:stopall()
    
	for k,v in pairs(self.sounds) do
        v[1]:stop()
	end
end

            
return SoundMgr            
    
       

