
local PlayerSetData = class("PlayerSetData")

local mKey = "set_open_music"
local sKey = "set_open_sound" 

function PlayerSetData:ctor()
	
end 

function PlayerSetData:loadConfig()
	local isOpenMusic = StoreData:get(mKey, true) 
	local isOpenSount = StoreData:get(sKey, true) 
	AudioManage.music_status = isOpenMusic
	AudioManage.sound_status = isOpenSount

	return self 
end

-- 音乐开关
function PlayerSetData:isMusicOpen()	
	return AudioManage.music_status
end

function PlayerSetData:openMusic(b)	
	AudioManage.setMusicStatus(b)
	StoreData:save(b, mKey)
end

-- 音效开关
function PlayerSetData:isSoundOpen()
	return AudioManage.sound_status
end

function PlayerSetData:openSound(b)
	-- AudioData:openSound(b) 
	AudioManage.setSoundStatus(b)
	StoreData:save(b, sKey)
end

-- 通知 体力回满
function PlayerSetData:isNotiPowerMax()
	local key = "set_open_noti_power_max"
	local data = StoreData:get(key)
	if data == nil then 
		return true
	end 
	return data 
end

function PlayerSetData:openNotiPowerMax(b)
	local key = "set_open_noti_power_max"
	StoreData:save(b, key)
end

-- 通知 领取体力
function PlayerSetData:isNotiPowerGet()
	local key = "set_open_noti_power_get"
	local data = StoreData:get(key)
	if data == nil then 
		return true
	end 
	return data
end

function PlayerSetData:openNotiPowerGet(b)
	local key = "set_open_noti_power_get"
	StoreData:save(b, key)
end

-- 通知 商店刷新
function PlayerSetData:isNotiShopRefresh()
	local key = "set_open_noti_shop_refresh"
	local data = StoreData:get(key)
	if data == nil then 
		return true
	end 
	return data 
end

function PlayerSetData:openNotiShopRefresh(b)
	local key = "set_open_noti_shop_refresh"
	StoreData:save(b, key)
end

-- 通知 活动
function PlayerSetData:isNotiActivity()
	local key = "set_open_noti_activity"
	local data = StoreData:get(key)
	if data == nil then 
		return true
	end 
	return data
end

function PlayerSetData:openNotiActivity(b)
	local key = "set_open_noti_activity"
	StoreData:save(b, key)
end


------------------------------------------
-------- 获取icon ----------
-- 系统头像
function PlayerSetData:getSystemIcons()
	return {}
end
-- 尾兽头像
function PlayerSetData:getTailsIcons()
	local arr = {}
	local tails = TailsData:getOpenTails()
	for i,v in ipairs(tails) do
		table.insert(arr, v.icon)
	end
	return arr 
end
-- 英雄头像 
function PlayerSetData:getHeroIcons()
	local arr = {}
	for i,v in ipairs(HeroListData.heroList) do
		table.insert(arr, UserData:getHeroIcon(v))
	end	
	return arr 
end

------------------------------------------



return PlayerSetData




















