
local AudioData = class("AudioData") 

function AudioData:ctor()
	self.music_ = nil 
    self.willMusic_ = nil 
	self.sounds_ = {}
	self.isMusicOpen_ = true 
	self.isSoundOpen_ = true 
end

--------------------------------------------
-- 音乐开关
function AudioData:isMusicOpen()	
	return self.isMusicOpen_
end

function AudioData:openMusic(b)
	self.isMusicOpen_ = b 
    if b then 
        if self.willMusic_ == self.music_ then 
            self:resumeMusic()
        end 
    else 
        if self:isMusicPlaying() then 
            self:pauseMusic()
        end 
    end 
end

-- 音效开关
function AudioData:isSoundOpen()
	return self.isSoundOpen_
end

function AudioData:openSound(b)
	self.isSoundOpen_ = b 
end
-------------------------------------------

-- start --

--------------------------------
-- 预载入一个音乐文件
-- @function [parent=#audio] preloadMusic
-- @param string filename 音乐文件名

-- end --

function AudioData:preloadMusic(filename)
    audio.preloadMusic(filename)
end

-- start --

--------------------------------
-- 播放音乐
-- @function [parent=#audio] playMusic
-- @param string filename 音乐文件名
-- @param boolean isLoop 是否循环播放，默认为 true

-- end --

function AudioData:playMusic(filename, isLoop)
    self.willMusic_ = filename 
    if self.isMusicOpen_ then 
    	self.music_ = filename 
    	audio.playMusic(filename, isLoop)
    end 
end

-- start --

--------------------------------
-- 停止播放音乐
-- @function [parent=#audio] stopMusic
-- @param boolean isReleaseData 是否释放音乐数据，默认为 true

-- end --

function AudioData:stopMusic(isReleaseData)
    if isReleaseData == nil then 
    	isReleaseData = true 
    end 
    audio.stopMusic(isReleaseData)
end

-- start --

--------------------------------
-- 暂停音乐的播放
-- @function [parent=#audio] pauseMusic

-- end --

function AudioData:pauseMusic()
    audio.pauseMusic()
end

-- start --

--------------------------------
-- 恢复暂停的音乐
-- @function [parent=#audio] resumeMusic

-- end --

function AudioData:resumeMusic()
    if self.isMusicOpen_ then 
    	audio.resumeMusic()
    end 
end

-- start --

--------------------------------
-- 从头开始重新播放当前音乐
-- @function [parent=#audio] rewindMusic

-- end --

function AudioData:rewindMusic()
    if self.isMusicOpen_ then 
    	audio.rewindMusic()
    end 
end

-- start --

--------------------------------
-- 检查是否可以开始播放音乐
-- 如果可以则返回 true。
-- 如果尚未载入音乐，或者载入的音乐格式不被设备所支持，该方法将返回 false。
-- @function [parent=#audio] willPlayMusic
-- @return boolean#boolean ret (return value: bool) 

-- end --

function AudioData:willPlayMusic()
    return audio.willPlayMusic()
end

-- start --

--------------------------------
-- 检查当前是否正在播放音乐
-- @function [parent=#audio] isMusicPlaying
-- @return boolean#boolean ret (return value: bool) 

-- end --

function AudioData:isMusicPlaying()
    return audio.isMusicPlaying()
end

----------------------------------------------------------
----------------------------------------------------------
-- 音效 
--------------------------------
-- 播放音效，并返回音效句柄
-- 如果音效尚未载入，则会载入后开始播放。
-- 该方法返回的音效句柄用于 audio.stopSound()、audio.pauseSound() 等方法。
-- @function [parent=#audio] playSound
-- @param string filename 音效文件名
-- @param boolean isLoop 是否重复播放，默认为 false
-- @return integer#integer ret (return value: int)  音效句柄

-- end --

function AudioData:playSound(filename, isLoop)
	if self.isSoundOpen_ then 
		return audio.playSound(filename, isLoop)
	end     
    return nil 
end

-- start --

--------------------------------
-- 暂停指定的音效
-- @function [parent=#audio] pauseSound
-- @param integer 音效句柄

-- end --

function AudioData:pauseSound(handle)
	if handle then 
    	audio.pauseSound(handle)
    end 
end

-- start --

--------------------------------
-- 暂停所有音效
-- @function [parent=#audio] pauseAllSounds

-- end --

function AudioData:pauseAllSounds()
	audio.pauseAllSounds()    
end

-- start --

--------------------------------
-- 恢复暂停的音效
-- @function [parent=#audio] resumeSound
-- @param integer 音效句柄

-- end --

function AudioData:resumeSound(handle)
    if self.isSoundOpen_ and handle then 
		audio.resumeSound(handle)
	end 
end

-- start --

--------------------------------
-- 恢复所有的音效
-- @function [parent=#audio] resumeAllSounds

-- end --

function AudioData:resumeAllSounds()
    if self.isSoundOpen_ then 
		audio.resumeAllSounds()
	end 
end

-- start --

--------------------------------
-- 停止指定的音效
-- @function [parent=#audio] stopSound
-- @param integer 音效句柄

-- end --

function AudioData:stopSound(handle)
    if handle then 
		audio.stopSound(handle)
	end 
end

-- start --

--------------------------------
-- 停止所有音效
-- @function [parent=#audio] stopAllSounds

-- end --

function AudioData:stopAllSounds()
    audio.stopAllSounds()
end

-- start --

--------------------------------
-- 预载入一个音效文件
-- @function [parent=#audio] preloadSound
-- @param string 音效文件名

-- end --

function AudioData:preloadSound(filename)
    audio.preloadSound(filename)
end

-- start --

--------------------------------
-- 从内存卸载一个音效
-- @function [parent=#audio] unloadSound
-- @param string 音效文件名

-- end --

function AudioData:unloadSound(filename)
    audio.unloadSound(filename)
end

---------------------------------
--
function AudioData:preloadSounds(arrFileName)
	self.sounds_ = {}
	for i,v in ipairs(arrFileName) do
		self:preloadSound(v)
		table.insert(self.sounds_, v)
	end    
end

-- 只unload preloadSounds 的
function AudioData:unloadSounds()
    for i,v in ipairs(self.sounds_) do
    	self:unloadSound(v)
    end
end
---------------------------------

return AudioData 
