--[[
山多拉的灯
]]
local HolyLandSubScene = import(".HolyLandSubScene")
local TrialLightScene = class("TrialLightScene", HolyLandSubScene)

function TrialLightScene:initData() 		
	self.data = TrialData:getTrial("light") 
	self.items_ = TrialData.lightList
end

function TrialLightScene:initView()
	TrialLightScene.super.initView(self)

	display.newSprite("word_light.png"):addTo(self.layer_)
	:pos(430, 540)
end 

function TrialLightScene:toInfoScene(index)
	app:pushScene("TrialLightInfoScene", {{grade=index}})
end 

function TrialLightScene:getDiffImgName()
	return "Trainning_Difficulty1.png"
end 

return TrialLightScene



