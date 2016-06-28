--[[
庐山五老峰
]]
local HolyLandSubScene = import(".HolyLandSubScene")
local TrialMountScene = class("TrialMountScene", HolyLandSubScene)

function TrialMountScene:initData()	
	self.data = TrialData:getTrial("mount") 
	self.items_ = TrialData.mountList  	-- 难度解锁信息
end

function TrialMountScene:initView()
	TrialMountScene.super.initView(self)

	display.newSprite("word_mountain.png"):addTo(self.layer_)
	:pos(430, 540)
end 

function TrialMountScene:toInfoScene(index)
	app:pushScene("TrialMountInfoScene", {{grade=index}})
end 

function TrialMountScene:getDiffImgName()
	return "Trainning_Difficulty3.png"
end 

return TrialMountScene



