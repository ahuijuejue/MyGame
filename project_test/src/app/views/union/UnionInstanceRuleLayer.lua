--[[
    公会副本规则
]]

local UnionInstanceRuleLayer = class("UnionInstanceRuleLayer", function()
	return display.newColorLayer(cc.c4f(0, 0, 0, 200))
end)
local BgImg = "union_rule.png"

function UnionInstanceRuleLayer:ctor()
	self:initData()
	self:initView()
end

function UnionInstanceRuleLayer:initData()
	self.infoData = GameConfig["Consortiaexplaininfo"]["2"].Description
end

function UnionInstanceRuleLayer:initView()
	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy-20):addTo(self)

	-- 关闭按钮
	CommonButton.close()
	:addTo(self.spriteBg,3)
	:pos(360, 445)
	:scale(0.7)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeRuleLayer()
	end)

    createOutlineLabel({text = GameConfig["Consortiaexplaininfo"]["2"].Name}):pos(165, 415):addTo(self.spriteBg)

    -- 规则说明
	local width = 360
	local layer, height = self:initView_(width)

	base.GridViewOne.new({
		viewRect = cc.rect(0, 0, width, 370),
		itemSize = cc.size(width, height)
	})
	:addTo(self.spriteBg)
	:pos(15, 10)
	:addSection({
		count = 1,
		getItem = function()
			return layer
		end
	})
	:reload()
end

function UnionInstanceRuleLayer:initView_(width)
	local node = display.newNode()

	-- 规则说明
	local descLabel = base.Label.new({
		text = self.infoData,
		size = 18,
		dimensions = cc.size(width - 30, 0),
		align 	= 	cc.TEXT_ALIGNMENT_LEFT,
	})
	:align(display.LEFT_BOTTOM)
	:addTo(node)
	:pos(0, 0)

	local height = descLabel:getCascadeBoundingBox().height
	node:size(width, height)
	:align(display.CENTER)

	return node, height
end

function UnionInstanceRuleLayer:updateData()

end

function UnionInstanceRuleLayer:updateView()

end

return UnionInstanceRuleLayer
