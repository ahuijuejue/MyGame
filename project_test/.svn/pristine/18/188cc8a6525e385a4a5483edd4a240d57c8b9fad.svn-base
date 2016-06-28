module("AudioManage", package.seeall)

music_status = true
sound_status = true
current_file = ""

function playMusic(fileName,isLoop)
	if music_status then
		if fileName ~= current_file then
			stopMusic(true)
			current_file = fileName
			audio.preloadMusic(fileName)
			audio.playMusic(fileName,isLoop)
		end
	end
end

function setMusicStatus(isOn)
	music_status = isOn
	if music_status then
		resumeMusic()
	else
		pauseMusic()
	end
end

function setSoundStatus(isOn)
	sound_status = isOn
end

function stopMusic(isReleaseData)
	current_file = ""
	audio.stopMusic(isReleaseData)
end

function pauseMusic()
	audio.pauseMusic()
end

function resumeMusic()
	audio.resumeMusic()
end

function playSound(fileName,isLoop)
	if sound_status then
		return audio.playSound(fileName,isLoop)
	end
	return nil
end

function stopSound(handle)
	if handle and sound_status then
		audio.stopSound(handle)
	end
end

function pauseSound(handle)
	if handle and sound_status then
		audio.pauseSound(handle)
	end
end

function resumeSound(handle)
	if handle and sound_status then
		audio.resumeSound(handle)
	end
end