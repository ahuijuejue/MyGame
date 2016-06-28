
local SetHeadLayer = class("SetHeadLayer", function()
	return display.newNode()
end)

function SetHeadLayer:ctor()
	self:initView()

	self:updateData()
	self:updateView()

end

function SetHeadLayer:initView()
	-- 灰层背景
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    local layer_ = display.newNode():size(960, 640):align(display.CENTER)
    layer_:setScale(0.3)
    local seq = transition.sequence({
    	cc.ScaleTo:create(0.15, 1.15),
    	cc.ScaleTo:create(0.05, 1)
    	})
    layer_:runAction(seq)
    layer_:addTo(self):center()
	self.layer_ = layer_

	-----------------------
	-- 背景框
	CommonView.mFrame2()
	:addTo(self.layer_)
	:pos(480, 320)
	---------------------

	-- 列表
	self.listView_ = base.GridViewOne.new({
		ver = 4,
		viewRect = cc.rect(0, 0, 600, 430),
		-- viewRect = cc.rect(0, 0, 430, 600),
		itemSize = cc.size(150, 150),
		-- direction = "hor",
	}):addTo(self.layer_)
	:pos(180, 100)
	:onTouch(function(event)
		if event.name == "selected" then 
			local index = event.index
			local sectionIndex = event.sectionIndex
			local item = event.item

			if item ~= self.preItem then 	
				if self.preItem then 
					self.preItem:setSelected(false)
				end 
				item:setSelected(true)
				self.preItem = item

				local imgName = self.list_[sectionIndex][index]
				self:onEvent_({name="change", text=imgName})
			end 

			CommonSound.click() -- 音效
		end 
	end)


	-- 按钮
	cc.ui.UIPushButton.new({
		normal = "Close.png",
        
	}):addTo(self.layer_)    
    :pos(800, 540)    
    :onButtonClicked(function(event)
        self:onEvent_({name="close"})

        CommonSound.close() -- 音效
    end)

	----------------------

end 

function SetHeadLayer:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end

function SetHeadLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end 

function SetHeadLayer:updateData()
	self.list_ = {}

	self:addIconsIf(PlayerSetData:getSystemIcons())
	self:addIconsIf(PlayerSetData:getTailsIcons())
	self:addIconsIf(PlayerSetData:getHeroIcons())

end 

function SetHeadLayer:addIconsIf(icons)
	-- if icons and #icons>0 then 
		table.insert(self.list_, icons)
	-- end 
end 

function SetHeadLayer:updateView()
	self:updateListView()
end 

function SetHeadLayer:updateListView()
	self.listView_
	:resetData()
	:addSection(
		{	
			count = #self.list_[1],
			headSize = cc.size(100, 100),
			head =  base.Grid.new()
				:addItem(CommonView.titleFrame1())
				:addItem(base.Label.new({text="系统头像", size=20})				
				:align(display.CENTER)),
				-- :rotation(-90),
			getBackground = handler(self, self.getItemsBackground),
			getItem = handler(self, self.getItemGrid),
		})
	:addSection(
		{	
			count = #self.list_[2],
			headSize = cc.size(100, 100),
			head =  base.Grid.new()
				:addItem(CommonView.titleFrame1():pos(0, 18))
				:addItem(display.newSprite("Word_Tails_Icon.png"):pos(0, 18))			
				:addItem(base.Label.new({text="解锁尾兽后获得", size=20, color=cc.c3b(255,255,0)})
				:align(display.CENTER)				
				:pos(0, -18)),
				-- :rotation(-90),
			getBackground = handler(self, self.getItemsBackground),
			getItem = handler(self, self.getItemGrid),

		})
	:addSection(
		{	
			count = #self.list_[3],
			headSize = cc.size(100, 100),
			head =  base.Grid.new()
				:addItem(CommonView.titleFrame1():pos(0, 18))
				:addItem(display.newSprite("Word_Heroes_Icon.png"):pos(0, 18))
				:addItem(base.Label.new({text="解锁英雄后获得", size=20, color=cc.c3b(255,255,0)})
				:align(display.CENTER)				
				:pos(0, -18)),
				-- :rotation(-90),
			getBackground = handler(self, self.getItemsBackground),
			getItem = handler(self, self.getItemGrid),
		})	
	:reload()

end 

function SetHeadLayer:getItemsBackground(event)
	local node = display.newScale9Sprite("Scale9_1.png")
	local _size = event.size 
	node:size(_size)

	return node 
end

function SetHeadLayer:getItemGrid(event)
	local data = self.list_[event.sectionIndex][event.index]
	local grid = base.Grid.new()
	:setBackgroundImage("Mail_Circle.png")
	:addItemWithKey("icon", data)
	:setSelectedImage(display.newSprite("Select_Chart.png"), 8)

	return grid 		
end 

return SetHeadLayer


