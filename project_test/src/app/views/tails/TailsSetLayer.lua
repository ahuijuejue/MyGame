
local TailsSetLayer = class("TailsSetLayer", function()
	return display.newNode()
end)

local openLv = {1,50,60}

function TailsSetLayer:ctor(options)	
	
	self:initData(options)
	self:initView()
	self:setNodeEventEnabled(true)
end

function TailsSetLayer:initData(options)
	-- 位置上限
	self.maxGet_ = 3

	self.lv = UserData:getUserLevel()
	-- 可以选取英雄上限
	self.limitGet_ = 0
	for i,v in ipairs(openLv) do
		if self.lv >= v then 
			self.limitGet_ = i
		end 
	end	

	self.getDataList_ = {}
	self.data_ = {} -- 所有英雄数据
	print("limit:", self.limitGet_)

	if options.list then 
		self:setList(options.list)
	end 
	
end 

function TailsSetLayer:initView()	
	CommonView.blackLayer2()
	:addTo(self)
	:onTouch(function(event)
		-- body
	end)

	local layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self):center()
	self.layer_ = layer_
	
----------------------------------------------------------
	-- 背景框	
	display.newSprite("Tails_Info.png"):addTo(self.layer_)
    :pos(480, 300)

	base.Label.new({text="召唤设置", size=26}):addTo(self.layer_):pos(480, 438):align(display.CENTER)
	base.Label.new({text="选择尾兽", size=26}):addTo(self.layer_):pos(480, 267):align(display.CENTER)
----------------------------------------------------------
	-- 列表	
	self.listView_ = base.ListView.new({
		viewRect = cc.rect(0, 0, 360, 150),	
		direction = "horizontal",
		itemSize = cc.size(120, 150),
	})
	:addTo(layer_)	
	:pos(300, 100)	
	:onTouch(function(event)
		if event.name == "clicked" and event.itemPos then			
			CommonSound.click() -- 音效

			local item = event.item:getContent()
			local index = event.itemPos
			print(index)
			local data = self.list_[index]
			if item:isSelected() then					
				self:unselectedGetList(data)
				item:setSelected(false)									
			else 
				if self:canSelected() then 
				 	self:selectedGetList(data)
					item:setSelected(true)
				-- else 
			-- 		showToast({text = "需要解锁"})
				end 
			end 			
		end
	end)
	-- 已选取区域
		
	local createPos = function(zorder, pos)	
		local index = #self.getViewList_ + 1
		local lv = openLv[index]
		local grid = base.Grid.new():addTo(layer_, zorder):pos(pos.x, pos.y)
		:setIndex(index)
		:scale(0.7)

		if self.lv >= lv then 
			grid:setBackgroundImage(display.newSprite("AwakeStone4.png"))
			:onTouch(function(event)
				if event.name == "clicked" then 
					if index <= #self.getDataList_ then 
						CommonSound.click() -- 音效

						local data = self.getDataList_[index]
						self:unselectedCacheList(data)
						self:unselectedGetList(data)					
					end 
				elseif event.name == "moved" then 
					self:movedGetGrid(index, event.x, event.y)
				elseif event.name == "ended" then 
					self:endedGetGrid(index, event.x, event.y)				
				end 	
			end, cc.size(130, 130))
		else 
			grid:addItems({
				display.newSprite("AwakeStone0.png"),
				display.newSprite("Tails_Lock.png"),
				base.Label.new({text=string.format("需要战队\n等级%d级", lv), size=20, color=cc.c3b(255,0,0)}):align(display.CENTER),
			})

		end 	
		

		return grid
	end 
	
	self.getViewList_ = {}
	table.insert(self.getViewList_, createPos(2, cc.p(360, 350)))
	table.insert(self.getViewList_, createPos(2, cc.p(480, 350)))
	table.insert(self.getViewList_, createPos(1, cc.p(600, 350)))
	
	-- 关闭按钮
	self.closeBtn = base.Grid.new():addTo(self.layer_)
	:pos(675, 475)
	:setNormalImage("Close.png")
	:onTouch(function(event)
		if event.name == "clicked" and self.closedListener_ then 
			CommonSound.close() -- 音效

			self.closedListener_({target=self})
		end 
	end)
	
end 

function TailsSetLayer:onClosed(listener)
	self.closedListener_ = listener 
	return self 
end 

-- 点击选中的 图像 移动
function TailsSetLayer:movedGetGrid(index, x, y)
	if index > #self.getDataList_ then 		
		return 
	end 

	if not self.showSprite_ then 
		local data = self.getDataList_[index]
		self.showSprite_ = display.newSprite(data.icon):addTo(self.layer_):zorder(5)	
		self.getViewList_[index]:removeItems()
	end 
	
	self.selectGetIndex_ = index
	self.showSprite_:pos(x, y)	
end 
-- 点击选中的 图像 移动结束
function TailsSetLayer:endedGetGrid(index, x, y)
	if self.showSprite_ then 		
		local grid = table.item(self.getViewList_, function(a) 
			return a:hiteTest(x, y)
		end)
		
		if grid then 
			local idx = grid:getIndex()
			if idx ~= index and idx <= #self.getDataList_ then 
				self:didExchangeGet(idx, index)
			else 
				self:notExchangeGet(index)
			end 
		else 
			self:notExchangeGet(index)
		end 
		self.showSprite_:removeSelf()
		self.showSprite_ = nil 
		self.selectGetIndex_ = nil 
	end 
end 
-- 选中区 交换英雄
function TailsSetLayer:didExchangeGet(idx1, idx2)
	local view1 = self.getViewList_[idx1]
	local view2 = self.getViewList_[idx2]
	local data1 = self.getDataList_[idx1]
	local data2 = self.getDataList_[idx2]	
	self.getDataList_[idx1] = data2 
	self.getDataList_[idx2] = data1 
	
	self:showGridGet(view1, self.getDataList_[idx1])
	self:showGridGet(view2, self.getDataList_[idx2])
end 
-- 选中区 交换英雄 没成功
function TailsSetLayer:notExchangeGet(idx)
	local show = self.getViewList_[idx]
	local data = self.getDataList_[idx]
	self:showGridGet(show, data)
end 

function TailsSetLayer:canSelected()
	return #self.getDataList_ < self.limitGet_
end 

function TailsSetLayer:selectedCacheList(data)
	local index = table.indexof(self.list_, data)
	if index then 
		local item = self.listView_.items_[index]:getContent()
		item:setSelected(true)		
	end 
end

function TailsSetLayer:unselectedCacheList(data)
	local index = table.indexof(self.list_, data)
	print("unselectedCacheList", index)
	if index then 
		local item = self.listView_.items_[index]:getContent()
		item:setSelected(false)		
	end 
end

function TailsSetLayer:selectedGetList(data)
	table.insert(self.getDataList_, data)
	local show = self.getViewList_[#self.getDataList_]:removeItems()
	self:showGridGet(show, data)
	
	self:listenerEvent_{name="selected"}
end

function TailsSetLayer:unselectedGetList(data)
	local index = table.indexof(self.getDataList_, data)	
	if index then 
		print("remove:", index)
		table.remove(self.getDataList_, index)
		for i=index,#self.getDataList_ do
			local show = self.getViewList_[i]:removeItems()
			local gridData = self.getDataList_[i]
			self:showGridGet(show, gridData)
		end

		for i=#self.getDataList_ + 1, self.limitGet_ do
			self.getViewList_[i]:removeItems():setSelected(false)	
		end
		
		self:listenerEvent_{name="unselected"}
	end 
end

function TailsSetLayer:showGrid(grid, data)	
	
	grid:addItemWithKey("icon", display.newSprite(data.icon):pos(0, 0):zorder(2))
	if data.star > 0 then 
		grid:addItemWithKey("labelLvBk", display.newSprite("Idolum_Star_Light.png"):pos(40, -40):scale(1.3):zorder(2))
		grid:addItemWithKey("labelLv", base.Label.new({text=tostring(data.star), size=20, color=cc.c3b(0,0,0)}):pos(40, -43):align(display.CENTER):zorder(2))
	else 
		grid:addItemWithKey("labelLvBk", nil)
		grid:addItemWithKey("labelLv", nil)
	end 
			
	return self
end	

function TailsSetLayer:showGridGet(grid, data)
	grid:addItemWithKey("icon", display.newSprite(data.icon):pos(0, 0):zorder(2))
	:setSelected(true)

	if data.star > 0 then 
		grid:addItemWithKey("labelLvBk", display.newSprite("Idolum_Star_Light.png"):pos(40, -40):scale(1.3):zorder(2))
		grid:addItemWithKey("labelLv", base.Label.new({text=tostring(data.star), size=20, color=cc.c3b(0,0,0)}):pos(40, -43):align(display.CENTER):zorder(2))
	else 
		grid:addItemWithKey("labelLvBk", nil)
		grid:addItemWithKey("labelLv", nil)
	end 	
	
	return self
end	

function TailsSetLayer:setList(list)	
	assert(type(list) == "table", "id list")
	while #list > self.limitGet_ do
		table.remove(list)
	end 
	self.storeList_ = list 
	return self 
end 

function TailsSetLayer:getList()
	local list = {}
	for i,v in ipairs(self.getDataList_) do
		list[#list + 1] = v.id 
	end
	return list 
end

function TailsSetLayer:getCount()	
	return #self.getDataList_ 
end 

function TailsSetLayer:onTouch(listener)
	self.listener_ = listener 
	return self 
end

function TailsSetLayer:listenerEvent_(event)
	if not self.listener_ then 	return 	end 	

	event.target = self 
	event.count = #self.getDataList_ 
	self.listener_(event)
end


function TailsSetLayer:onEnter()	
	self:updateData()
	self:updateView()

	CommonView.animation_show_out(self.layer_)
end

function TailsSetLayer:updateData()
	self.lv = UserData:getUserLevel()
	self.list_ = TailsData:getOpenTails()
	
	local list = self.storeList_ or {}
	
	self.getDataList_ = {}
	for i,v in ipairs(list) do
		local data = table.item(self.list_, function(a)
			return a.id == v
		end)
		if data then 
			table.insert(self.getDataList_, data)
		end 
	end

end  

function TailsSetLayer:updateView()
	self:updateListView()

	for i,v in ipairs(self.getDataList_) do
		local grid = self.getViewList_[i]
		self:showGridGet(grid, v)		
	end

	for i=#self.getDataList_ + 1, self.limitGet_ do
		self.getViewList_[i]:removeItems()		
	end
	
	if #self.getDataList_ > 0 then 
		self:listenerEvent_{name="selected"}
	end 

end 

function TailsSetLayer:updateListView()
	local items = self.list_ 

	self.listView_
	:removeAllItems()
	:addItems(#items, function(event)
		local index = event.index 
		local data = items[index]
		local grid = base.Grid.new({type=1})
			:setBackgroundImage(display.newSprite("AwakeStone4.png"):pos(0, 0))
			:setSelectedImage(display.newSprite("Select_Chart.png"):pos(0, 0), 10)
		self:showGrid(grid, data)
		if table.indexof(self.getDataList_, data) then 
			grid:setSelected(true)				
		end 
		grid:scale(0.7)
		return grid			
	end)
	:reload()
	
end 

function TailsSetLayer:onExit()	
	self.storeList_ = self:getList()
end 


return TailsSetLayer