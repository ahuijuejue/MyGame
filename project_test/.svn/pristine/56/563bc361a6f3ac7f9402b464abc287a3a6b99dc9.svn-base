--[[
精神时间屋
]]
local HolyLandSubScene = import(".HolyLandSubScene")
local TrialHouseScene = class("TrialHouseScene", HolyLandSubScene)

function TrialHouseScene:initData()		
	self.data = TrialData:getTrial("time") 
	self.items_ = TrialData.houseList
end

function TrialHouseScene:initView()
	TrialHouseScene.super.initView(self)

	display.newSprite("word_time_room.png"):addTo(self.layer_)
	:pos(430, 540)
end 

function TrialHouseScene:toInfoScene(index)
	app:pushScene("TrialHouseInfoScene", {{grade=index}})
end 

function TrialHouseScene:getDiffImgName()
	return "Trainning_Difficulty2.png"
end 


return TrialHouseScene



