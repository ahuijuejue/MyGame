--[[
重新开始按钮 
]]
local AincradButton = class("AincradButton", function()
	return display.newNode()
end)

function AincradButton:ctor()		
	self:initData()
	self:initView()
	self:setNodeEventEnabled(true)
end

function AincradButton:initData()
	
end 

function AincradButton:initView()
	-- 按钮 
	local posY = 0 
	
	self.restartButton = CommonButton.yellow("重新开始"):addTo(self)
	:pos(0, posY)	
	:onButtonClicked(function()
		CommonSound.click() -- 音效
		
		self:onButtonRestart()
	end) 

	self.timesLabel = base.Label.new({size=18, color=cc.c3b(250, 10, 0)})
	:addTo(self)
	-- :align(display.CENTER)
	:pos(-60, posY + 50)

	
end 

function AincradButton:onButtonRestart()	
	if AincradData:haveRestarTimes() > 0 then 
		AlertShow.show2("提示", "确认刷新艾恩葛朗特？", "确定", function(event)
			self:onRestart()
		end)
	else 
		showToast({text="剩余刷新次数不足"})
	end 
end 

function AincradButton:onRestart()	
	AincradData:restart(function() 
		self:updateData()	
		self:updateView()
		self:onEvent_({name="restart"})
	end, self)	
end 

function AincradButton:onEnterTransitionFinish()	
	self:updateData()
	self:updateView()

end 

function AincradButton:updateData()	
	self.haveTimes = AincradData:haveRestarTimes()
	self.maxTimes = AincradData:getRestartMax()
	
end 

function AincradButton:updateView()
	self:updateLabelTimes()
end 

function AincradButton:updateLabelTimes()	
	local str = string.format("剩余次数（%d/%d）次", self.haveTimes, self.maxTimes)
	self.timesLabel:setString(str)	
end 

function AincradButton:onExit()
	NetHandler.removeTarget(self)
end 

function AincradButton:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end 

function AincradButton:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end 

return AincradButton
