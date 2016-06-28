local UnionIconListLayer = class("UnionIconListLayer",function ()
	return display.newNode()
end)
local backBoard = "Union_List.png"

function UnionIconListLayer:ctor()
    self:initData()
	self:initView()
end

function UnionIconListLayer:initData()
	self.data = {}
	local num = table.nums(GameConfig.union_icon)
	for i=1,num do
		local iconItem = self:createItem(i)
		table.insert(self.data,iconItem)
	end
end

function UnionIconListLayer:createItem(index)
	local cfg = GameConfig.union_icon[tostring(index)].union_image
	return cfg
end

function UnionIconListLayer:initView()
	CommonView.blackLayer2()
	:addTo(self)

	local listBoard = display.newSprite(backBoard):pos(480,330):addTo(self)

	-- 关闭按钮
	CommonButton.close()
	:addTo(listBoard,3)
	:pos(625, 395)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeUnionIconLayer()
	end)

	self.iconListView = base.ListView.new({
		viewRect = cc.rect(0, 0, 631, 375),
		itemSize = cc.size(110, 110),
	}):addTo(listBoard)
	:pos(15, 18)

	for i=1,math.ceil(#self.data/5) do
		local item = self.iconListView:newItem()
		local content  = display.newNode()
		for count = 1, 5 do
			local idx  = (i-1)*5 + count
			cc.ui.UIPushButton.new(self.data[idx])
		    :setButtonSize(110, 110)
		    :onButtonClicked(function (event)
		    	self.delegate.unionLayer.createLayer:updateUnionIcon(idx)
		    	self.delegate:removeUnionIconLayer()
		    end)
		    :align(display.CENTER, 110*count-55, 40)
		    :addTo(content)
		    :setTouchSwallowEnabled(true)
		end
		content:setContentSize(560,110)
		item:addContent(content)
		item:setItemSize(631,110)

		self.iconListView:addItem(item)

	end
	self.iconListView:reload()

end

return UnionIconListLayer