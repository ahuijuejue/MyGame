--[[
选择出战英雄层
]]
local SelectLayer = class("SelectLayer", function()
	return display.newNode()
end)

function SelectLayer:setSuperCount(count)	
	for i,v in ipairs(self.getViewList_) do
		if i <= self.limitGet_ then 
			local grid = self.getViewList_[i]
			if i <= count then 
				grid:setBackgroundImage(display.newSprite("PlatformLight2.png"):pos(0, -55), 3)
				:setSelectedImage(display.newSprite("PlatformLight_Effect2.png"):pos(0, -10), 6)
			else 
				grid:setBackgroundImage(display.newSprite("PlatformLight.png"):pos(0, -55), 3)
				:setSelectedImage(display.newSprite("PlatformLight_Effect.png"):pos(0, -10), 6)
			end 
		end 
	end	
end 

function SelectLayer:ctor(options)		
	self:initData(options)
	self:initView()
	self:setNodeEventEnabled(true)
end

function SelectLayer:initData(options)
	options=options or {}
	-- 位置上限
	self.maxGet_ = self.maxGet_ or 7
	-- 可以选取英雄上限
	self.limitGet_ = options.limitnum or self.maxGet_
	self.limitGet_ = math.min(self.maxGet_, self.limitGet_)
	self.getDataList_ = {}
	self.data_ = {} -- 所有英雄数据
	print("limit:", self.limitGet_)
	self.getViewList_ = {}
	self.canUnseleted = true
end 

function SelectLayer:initView()	
	local layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self):center()
	self.layer_ = layer_

	-- 背景框
	self.back = display.newSprite("Herolist_Board.png"):addTo(self):pos(display.cx, 75)
	:zorder(2)

	-- 战斗力
	local posY = display.top - 40
	display.newSprite("Effective_Banner.png"):addTo(self):pos(130, posY)	

	self.battleLabel_ = base.Grid.new():setNormalImage(NumberData:font2(0))
	:addTo(self)
	:zorder(1)	
	:pos(110, posY)

	-- 英雄列表	
	self.listView_ = base.ListView.new({
		viewRect = cc.rect(0, 0, 938, 180),	
		direction = "horizontal",
		itemSize = cc.size(185, 180),
		page = true,
	})
	:addTo(self.back)	
	:pos(12, 25)	
	-- :setBounceable(false)
	:onTouch(function(event)		
		if event.name == "clicked" and event.itemPos then		
			CommonSound.click() -- 音效

			self:selectedList(event)
		end
	end)
		
	-- 侧边 按钮
	self.btnGroup_ = base.ButtonGroup.new({
		zorder1 = 1, 
		zorder2 = 5,		
	})		
	:addButtons({
		base.Grid.new({normal = "Ready_Label_Normal.png", selected = "Ready_Label_Selected.png"}):addLabel({text="全部", size=22}),
		base.Grid.new({normal = "Ready_Label_Normal.png", selected = "Ready_Label_Selected.png"}):addLabel({text="前排", size=22}),
		base.Grid.new({normal = "Ready_Label_Normal.png", selected = "Ready_Label_Selected.png"}):addLabel({text="中排", size=22}),
		base.Grid.new({normal = "Ready_Label_Normal.png", selected = "Ready_Label_Selected.png"}):addLabel({text="后排", size=22}),
	})
	:walk(function(index, button)
		button:pos(80 + (index-1) * 124, 240):addTo(self.back)
	end)
	:onEvent(function(event)
		if self.btnGroup_ then 
			CommonSound.click() -- 音效
		end 

		self:updateListView()
	end)
	:selectedButtonAtIndex(1)

	self:zorder(2)
end 

local heroLabel = {"Word_Leader","Word_Member1","Word_Member2","Word_Member3","Word_Member4","Word_Bench1","Word_Bench2","Word_Bench3"}
SelectLayer.heroIndexes = {
	leader = 1,
	member1 = 2,
	member2 = 3,
	member3 = 4,
	member4 = 5,
	bench1 = 6,
	bench2 = 7,
	bench3 = 8,
}

function SelectLayer:getCanUnselected()
	return self.canUnseleted
end 

function SelectLayer:setCanUnselected(b)
	self.canUnseleted = b
end 

function SelectLayer:selectedList(event)
	local item = event.item:getContent()
	local index = event.itemPos
	print(index)
	local data = self:getCurrentList()[index]
	if item:isSelected() then		
		if self:getCanUnselected() then 			
			self:unselectedGetList(data)
			item:setSelected(false)			
		end 						
	else 
		if self:canSelected() then 
		 	self:selectedGetList(data, item)
			item:setSelected(true)
		end 
	end 
end 

function SelectLayer:addHeroPos(heroIndex, x, y, zorder)	
	local index = #self.getViewList_ + 1
	local grid 
	if index > self.limitGet_ then 
		grid = self:createDisHeroPos(index)
	else 
		grid = self:createHeroPos(index, heroLabel[heroIndex]..".png")
	end 
	grid:addTo(self.layer_)
	:zorder(zorder)
	:pos(x, y)

	table.insert(self.getViewList_, grid)
end

function SelectLayer:createHeroPos(index, heroTitleImgName)		
	local grid = base.Grid.new()	
	:setIndex(index)				
	:onTouch(function(event)
		if event.name == "clicked" then 
			if index <= #self.getDataList_ then 
				if self:getCanUnselected() then 
					CommonSound.click() -- 音效
							
					local data = self.getDataList_[index]
					self:unselectedCacheList(data)
					self:unselectedGetList(data)
				end 
			elseif index > self.limitGet_ then 
				showToast({text = "本关锁定"})					
			end 
		elseif event.name == "moved" then 
			self:movedGetGrid(index, event.x, event.y)
		elseif event.name == "ended" then 
			self:endedGetGrid(index, event.x, event.y)				
		end 	
	end, cc.size(120, 130))
	 
	grid:addBase(display.newSprite(heroTitleImgName):pos(40, -65))	

	return grid
end 

function SelectLayer:createDisHeroPos(index)
	local grid = base.Grid.new()	
	:setIndex(index)

	grid:addItems({
		display.newSprite("Platform.png"):pos(0, -55),
		display.newSprite("Platform_Lock.png"):pos(0, 20),				
	})
	return grid
end

-- 点击选中的 图像 移动
function SelectLayer:movedGetGrid(index, x, y)
	if index > #self.getDataList_ then 		
		return 
	end 

	if self.selectGetIndex_ and self.selectGetIndex_ ~= index then 
		if self.selectGetIndex_ then 
			self:notExchangeGet(index)
			self.showSprite_:removeSelf()
			self.showSprite_ = nil 
			self.selectGetIndex_ = nil 
		end 
	end 
	if not self.showSprite_ then 
		local data = self.getDataList_[index]
		self.showSprite_ = display.newSprite(UserData:getHeroIcon(data.roleId)):addTo(self.layer_):zorder(5)	
		self.getViewList_[index]:removeItems()
	end 
	
	self.selectGetIndex_ = index
	self.showSprite_:pos(x, y)	
end 
-- 点击选中的 图像 移动结束
function SelectLayer:endedGetGrid(index, x, y)
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
function SelectLayer:didExchangeGet(idx1, idx2)
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
function SelectLayer:notExchangeGet(idx)
	local show = self.getViewList_[idx]
	local data = self.getDataList_[idx]
	self:showGridGet(show, data)
end 

function SelectLayer:didUnlock(index)
	if not index then 
		index = self.limitGet_ + 1
	end 
	if index > self.limitGet_ and index <= self.maxGet_ then 
		self.limitGet_ = self.limitGet_ + 1
		local view = self.getViewList_[index]
		view:removeItems()
		showToast({text="解锁成功"})
	end 
end 

function SelectLayer:sortHeroData(index)
	local types = {0,1,2,3}	
	local _type = types[index]
	if _type == 0 then return self.data_ end 

	local heros = {}
	for i,v in ipairs(self.data_) do
		if v.type_ == _type then 
			table.insert(heros, v)
		end 
	end
	return heros
end 

function SelectLayer:canSelected()
	local getCount = #self.getDataList_
	return getCount < self.limitGet_ and getCount < #self.data_[1]
end 

function SelectLayer:selectedCacheList(data)
	local index = table.indexof(self:getCurrentList(), data)
	if index then 
		local item = self.listView_.items_[index]:getContent()
		item:setSelected(true)		
	end 
end

function SelectLayer:unselectedCacheList(data)
	local index = table.indexof(self:getCurrentList(), data)
	print("unselectedCacheList", index)
	if index then 
		local item = self.listView_.items_[index]:getContent()
		item:setSelected(false)		
	end 
end

function SelectLayer:selectedGetListIndex(index)
	local data = self:getCurrentList()[index]
	local item = self.listView_.items_[index]:getContent()					
 	self:selectedGetList(data, item)
	item:setSelected(true) 
end

function SelectLayer:selectedGetList(data, fromGrid)
	table.insert(self.getDataList_, data)
	local show = self.getViewList_[#self.getDataList_]:removeItems()
	if fromGrid then 
		showMask()
		self:showMoving(UserData:getHeroIcon(data.roleId), convertPosition(fromGrid, self), convertPosition(show, self), function( ... )
			hideMask()
			if table.indexof(self.getDataList_, data) then 
				self:showGridGet(show, data)
			end
		end)
	else
		self:showGridGet(show, data)
	end 

	self:updateBattle()
	self:listenerEvent_{name="selected"}
end

function SelectLayer:unselectedGetList(data)
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

		self:updateBattle()
		self:listenerEvent_{name="unselected"}
	end 
end

function SelectLayer:showMoving(imgName, fromPos, toPos, callback)
	local showSpr = display.newSprite(imgName):addTo(self):zorder(5)
	showSpr:pos(fromPos.x, fromPos.y)
	
	local action = transition.sequence({
    	cc.EaseBackInOut:create(cc.MoveTo:create(0.4, toPos)),	    	
    	cc.CallFunc:create(function()
    		if callback then 
    			callback()
    		end 
    	end),
    	cc.RemoveSelf:create()
    })

    showSpr:runAction(action)
end 

function SelectLayer:showGrid(grid, data)	
	local typeImg = self:getHeroTypeImage(data.roleId)	
	grid:addItemsWithKey({
		icon_ = display.newSprite(UserData:getHeroIcon(data.roleId)):pos(0, 20):zorder(2),
		border_ = display.newSprite(UserData:getHeroBorder(data)):pos(0, 20),
		lvbk_ = display.newSprite("Name_Banner.png"):pos(40, -25):zorder(4),
		lvLabel_ = base.Label.new({text=tostring(data.level), color=cc.c3b(250,250,250), size=18}):align(display.CENTER):pos(40, -25):zorder(5),
		typeIcon_ = display.newSprite(typeImg):pos(-45, 55):zorder(6),
		typeIconBoarder_ = display.newSprite("Job_Circle.png"):pos(-45, 55):zorder(5),
		starLv_ = createStarIcon(data.starLv):pos(-50, -20):zorder(5),
	})

	self:showGridEx(grid, data)
	
	return self
end	

function SelectLayer:showGridEx(grid, data)
	--
end 

function SelectLayer:gridAddName(grid, data)
	local nameLayer = display.newNode():zorder(2)
		
	display.newSprite("Ready_Name_Banner.png"):addTo(nameLayer)
	base.Label.new({text=data.name, size=18}):align(display.CENTER):addTo(nameLayer)	
	grid:addItemsWithKey({		
		name_ = nameLayer:zorder(3):pos(0, -60),		
	})
end 

function SelectLayer:showGridGet(grid, data)
	local typeImg = self:getHeroTypeImage(data.roleId)
	grid:addItemsWithKey({
		icon = display.newSprite(UserData:getHeroIcon(data.roleId)):zorder(2):pos(0, 20),
		back = display.newSprite(UserData:getHeroBorder(data)):pos(0, 20),
		lvbk_ = display.newSprite("Name_Banner.png"):pos(40, -25):zorder(4),
		lvLabel_ = base.Label.new({text=tostring(data.level), color=cc.c3b(250,250,250), size=18}):align(display.CENTER):pos(40, -25):zorder(5),
		typeIcon_ = display.newSprite(typeImg):pos(-45, 55):zorder(6),
		typeIconBoarder_ = display.newSprite("Job_Circle.png"):pos(-45, 55):zorder(5),
		starLv_ = createStarIcon(data.starLv):pos(-50, -20):zorder(5),
	})
	:setSelected(true)
	
	return self
end	

function SelectLayer:updateBattle()
	local battle = 0
	for i,v in ipairs(self.getDataList_) do
		battle = battle + v:getHeroTotalPower()
	end
	-- print(battle)
	self.battleLabel_:setNormalImage(NumberData:font2(battle))
end

function SelectLayer:setHeroList(list)
	assert(type(list) == "table", "hero id list")
	while #list > self.limitGet_ do
		table.remove(list)
	end 
	self.heroList_ = list 
	return self 
end 

function SelectLayer:getHeroList()
	local list = {}
	local listData = {
		team1 = {},
		team2 = {},
	}
	for i,v in ipairs(self.getDataList_) do
		if i > 4 then 
			table.insert(listData.team2, v)
		else 
			table.insert(listData.team1, v)
		end 
		table.insert(list, v.roleId)
	end
	return list, listData
end

function SelectLayer:getHeroCount()	
	return #self.getDataList_ 
end 

function SelectLayer:onTouch(listener)
	self.listener_ = listener 
	return self 
end

function SelectLayer:listenerEvent_(event)
	if not self.listener_ then 	return 	end 	

	event.target = self 
	event.count = #self.getDataList_ 
	self.listener_(event)
end

function SelectLayer:updateData()
	self:updateHeroData()
	self:updateHeroGetData()
end 

function SelectLayer:sortHeroList(list)
	for i,v in ipairs(list or {}) do
		table.sort(v, function(x, y)
			if x.level > y.level then 
				return true
			elseif x.level == y.level then 
				if x.starLv > y.starLv then 
					return true
				elseif x.starLv == y.starLv then 
					if x.strongLv > y.strongLv then 
						return true
					elseif x.strongLv == y.strongLv then 
						return checknumber(x.roleId) < checknumber(y.roleId)
					end 
				end 
			end
			return false
		end)
	end
end 

function SelectLayer:updateHeroData()
	self.data_ = {}	
	local list = {LIST_TYPE.HERO_ALL, LIST_TYPE.HERO_TANK, LIST_TYPE.HERO_DPS, LIST_TYPE.HERO_AID}
	for i,v in ipairs(list) do
		local heros = HeroListData:getListWithType(v)
		table.insert(self.data_, heros)
	end

	self:sortHeroList(self.data_)
	
end 

function SelectLayer:updateHeroGetData()
	local heroList_ = self.heroList_ or {}
	self.getDataList_ = {}
	for i,v in ipairs(heroList_) do
		local data = table.item(self.data_[1], function(a)
			return a.roleId == v
		end)
		if data then 
			table.insert(self.getDataList_, data)
		end 
	end
end 

function SelectLayer:getCurrentList()
	if not self.btnGroup_ or not self.data_ then return {} end 
	local index = self.btnGroup_:getSelectedIndex()
	return self.data_[index]
end 

function SelectLayer:updateView()
	self:updateListView()
	for i,v in ipairs(self.getDataList_) do
		local grid = self.getViewList_[i]
		self:showGridGet(grid, v)		
	end

	for i=#self.getDataList_ + 1, self.limitGet_ do
		self.getViewList_[i]:removeItems()		
	end

	self:updateBattle()
	if #self.getDataList_ > 0 then 
		self:listenerEvent_{name="selected"}
	end 

end 

function SelectLayer:updateListView()
	self.listView_
	:removeAllItems()
	:addItems(#self:getCurrentList(), function(event)
		local index = event.index 
		local data = self:getCurrentList()
		data = data[index]
		local grid = base.Grid.new({type=1})
			-- :setBackgroundImage(display.newSprite("AwakeStone0.png"):pos(0, 20))
			:setSelectedImage(display.newSprite("Select_Chart.png"):pos(0, 20), 6)
		self:showGrid(grid, data)
		if table.indexof(self.getDataList_, data) then 
			grid:setSelected(true)				
		end 
		return grid			
	end)
	:reload()

	-- if self.offset_ then 
	-- 	self.listView_:getScrollNode():pos(self.offset_.x, self.offset_.y)
	-- end 
end 

function SelectLayer:onEnterTransitionFinish()	
	self:updateData()
	self:updateView()

end 

function SelectLayer:onExit()	
	self.heroList_ = self:getHeroList()
end 

function SelectLayer:getHeroTypeImage(id)
	local cfg = GameConfig.Hero[id]
	return cfg.HeroJob
end

return SelectLayer