--[[
艾恩葛朗特 星星数
]]

local AincradStarWidgetLayer = class("AincradStarWidgetLayer", function()
	return display.newNode()
end)

function AincradStarWidgetLayer:ctor()
	self:initView()
end

function AincradStarWidgetLayer:initView()

	base.Label.new({text="剩余:", size=22})
	:addTo(self)

	display.newSprite("star.png"):pos(85,0):scale(0.3):addTo(self)

	self.starLabel = base.Label.new({text="0", size=22})
	:addTo(self)
	:pos(115, 0)


end

function AincradStarWidgetLayer:setStar(value)
	self.starLabel:setString(tostring(value))
end



return AincradStarWidgetLayer
