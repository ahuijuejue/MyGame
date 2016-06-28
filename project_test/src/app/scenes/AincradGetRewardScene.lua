--[[
艾恩葛朗特 获得奖励界面 
]]
local AincradGetRewardScene = class("AincradGetRewardScene", base.Scene)

function AincradGetRewardScene:initData() 
	self.items = AincradData:getWillReward() 
end

function AincradGetRewardScene:initView()	
	-- 背景
	CommonView.background_aincrad()
	:addTo(self)
	:center()

	-- 按钮层
	app:createView("widget.MenuLayer", {back=false, menu=false, wealth="castle"}):addTo(self)
	:zorder(0)
	:onBack(function(layer)
		
	end)

	CommonView.blackLayer3()
	:addTo(self)


end 

function AincradGetRewardScene:onButtonOk()
	print("确定")
	app:pushScene("AincradMaoScene")
end 

function AincradGetRewardScene:updateView()
	-- CommonSound.award() -- 音效

	-- 显示奖励物品层 

	UserData:showReward(self.items, function()
		self:onButtonOk()
	end)
end 

return AincradGetRewardScene
