--[[
艾恩葛朗特 积分
]]

local AincradScoreWidgetLayer = class("AincradScoreWidgetLayer", function()
	return display.newNode()
end)

function AincradScoreWidgetLayer:ctor()		
	self:initData()
	self:initView()
	self:setNodeEventEnabled(true)
end

function AincradScoreWidgetLayer:initData()	
	self.score = 0
end 

function AincradScoreWidgetLayer:initView()	
	local posX = 0
	local posY = 0

	-- display.newSprite("Aincrad_Buff_Banner.png"):addTo(self)
	-- :pos(posX, posY)
	base.Label.new({text="当前积分:", size=22})
	:addTo(self)

	self.scoreLabel = base.Label.new({text="0", size=22})
	:addTo(self)
	:pos(115, 0)
	
	
end 

function AincradScoreWidgetLayer:onEnterTransitionFinish()	
	self:updateData()
	self:updateView()

end 

function AincradScoreWidgetLayer:updateData() 
	self.score = AincradData:getCurrentScore()
	-- self.score = 888888
end 

function AincradScoreWidgetLayer:updateView()
	self.scoreLabel:setString(tostring(self.score))
end 

function AincradScoreWidgetLayer:onExit()

end 


return AincradScoreWidgetLayer
