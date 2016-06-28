--[[
活动规则层
]]

local ActivityRuleLayer = class("ActivityRuleLayer", function()
	return display.newNode()
end)

function ActivityRuleLayer:ctor()
	self:initData()
	self:initView()
end

function ActivityRuleLayer:initData()
	self.infoData = SwordActivityData:getInfo()
end

function ActivityRuleLayer:initView()
	-- 规则描述
	base.Label.new({
		text=self.infoData.rule,
		size = 20,
		dimensions = cc.size(730, 300),
		align = cc.TEXT_ALIGNMENT_LEFT,
	})
	:addTo(self)
	:pos(50, 300)
	:align(display.LEFT_TOP)
end

function ActivityRuleLayer:updateData()
	
end

function ActivityRuleLayer:updateView()
	
end

return ActivityRuleLayer