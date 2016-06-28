--[[
初音介绍层
]]

local MikuIntroductionLayer = class("MikuIntroductionLayer", function()
	return display.newNode()
end)

function MikuIntroductionLayer:ctor()
	self:initData()
	self:initView()
end

function MikuIntroductionLayer:initData()
	self.infoData = SwordActivityData:getInfo()
end

function MikuIntroductionLayer:initView()
	-- icon
	display.newSprite(self.infoData.icon)
	:addTo(self)
	:pos(150, 160)
	:scale(0.8)

	display.newSprite("border_card.png")
	:addTo(self)
	:pos(150, 160)
	:scale(0.8)

	self.listView_ = base.ListView.new({
		viewRect = cc.rect(0, 0, 510, 305),
		itemSize = cc.size(510, 305),
	}):addTo(self)
	:pos(290, 10)

end

function MikuIntroductionLayer:updateData()

end

function MikuIntroductionLayer:updateView()
    self.listView_
	:removeAllItems()
	:addItems(1, function(event)
		local grid = base.Grid.new()
		self:setGridShow(grid, self.infoData.desc)
		return grid
	end)
	:reload()
end

function MikuIntroductionLayer:setGridShow(grid, data)
	grid:removeItems()
    local des = base.TalkLabel.new({
	    		text  = self.infoData.desc,
				size  = 20,
				dimensions = cc.size(505, 0),
				numOffset = cc.p(0,0),
				height = 3,
	    	})
    des:pos(-255,-62-32*des:getLines()/2)
    grid:addItem(des)
end

function MikuIntroductionLayer:onEnter()
	self:updateView()
end

return MikuIntroductionLayer