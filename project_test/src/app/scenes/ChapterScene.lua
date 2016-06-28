--[[
章节场景
]]
local ChapterScene = class("ChapterScene", base.Scene)


--[[
@param options table 参数表
- id 章节id 
- elite 是否是精英 
]]
function ChapterScene:initData(options) 

	self.items_ = {ChapterData:getNormalChapters(), ChapterData:getEliteChapters()} 	
	
	self.index_ = {0, 0} -- 选择的章节位置 
	
	if options.elite then 
		self.toIndex_ = 2
	else
		self.toIndex_ = 1 -- 普通和精英章节 
	end 
	 
	if options.id then 
		local data = ChapterData:getChapter(options.id) 
		if data:isElite() then 
			self.toIndex_ = 2 
			self.index_[2] = table.indexof(self.items_[2], data)
		else 
			self.toIndex_ = 1
			self.index_[1] = table.indexof(self.items_[1], data)
		end 		 
	end 

	self.level = 0
	self.chestData = {
		id = "",
		index = 0,
	}
	
end

function ChapterScene:initView()	
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	self.menuLayer = app:createView("widget.MenuLayer", {autoOpen=true}):addTo(self)	
	:onBack(function(layer)
		app:popScene()
	end)

	-- 描述
	display.newSprite("Chapter_Info.png"):addTo(self.layer_)	
	:pos(435, 15)

	display.newSprite("word_chapter_desc.png"):addTo(self.layer_)	
	:pos(140, 110)	

	self.descLabel_ = base.Label.new({
		size=20,
		dimensions = cc.size(720, 80),
		align = cc.TEXT_ALIGNMENT_LEFT,		
		color = cc.c3b(55,30,16),	
		border = false,
	}):addTo(self.layer_)
	:align(display.TOP_LEFT)
	:pos(80, 90)

	-- 箭头
	self.arrowLayer1 = display.newNode():addTo(self.layer_)
	local arrow1 = display.newSprite("Chapter_Arrow.png"):pos(40, 330):addTo(self.arrowLayer1):hide()
	local arrow2 = display.newSprite("Chapter_Arrow.png"):pos(890, 330):addTo(self.arrowLayer1):flipX(true):hide()
	self.arrow_ = {arrow1, arrow2}

	self.arrowLayer2 = display.newNode():addTo(self.layer_)
	local arrow1 = display.newSprite("Chapter_Arrow2.png"):pos(40, 330):addTo(self.arrowLayer2):hide()
	local arrow2 = display.newSprite("Chapter_Arrow2.png"):pos(890, 330):addTo(self.arrowLayer2):flipX(true):hide()
	self.arrow2_ = {arrow1, arrow2}

	-- 列表
	self.listView_ = base.PageView.new({
		viewRect = cc.rect(0, 0, 780, 400),
		itemSize = cc.size(255, 340),
		anchorY = 0.2,
		baseScale = 0.88,
		scale = 1.1,
	}):addTo(self.layer_)
	:pos(75, 125)
	:onTouch(function(event)
		if event.name == "change" then 			
			if event.preItem then 
				event.preItem:setSelected(false)
				event.preItem:grayIcon(true)
			end 
			if event.item then 
				event.item:setSelected(true)
				event.item:grayIcon(false)
				local items = self:getItemsData()
				if items then 
					self.descLabel_:setString(items[event.index].desc)
				end 
				self.index_[self:getIndex()] = event.index -- 记录选择
			end
			if event.index > 0 then 
				if event.index <= 1 then 
					self.arrow_[1]:hide()
					self.arrow2_[1]:hide()
				else 
					self.arrow_[1]:show()
					self.arrow2_[1]:show()
				end 
				if event.index >= event.target.maxIndex_ then 
					self.arrow_[2]:hide()
					self.arrow2_[2]:hide()
				else 
					self.arrow_[2]:show()
					self.arrow2_[2]:show()
				end 
			end 
		elseif event.name == "selected" then 	
			-- print("s:", event.index)
			local items = self:getItemsData()
			if items then 				
				CommonSound.click() -- 音效

				local data = items[event.index]
				local isOpen = ChapterData:isChapterOpen(data.id)
				if isOpen then 
					print("已解锁")
					app:pushScene("MissionScene", {{chapterId=data.id}})
				else 
					print("未解锁")
					showToast({text="未解锁"})
				end		
			end 	
		end 
	end)

-------------------------------------------------
-- 侧边栏
	self.btnGroup_ = base.ButtonGroup.new({
		zorder1 = 1, 
		zorder2 = 5,		
	})		
	:addButtons({
		base.Grid.new({normal = "Label_Normal_A.png", selected = "Label_Normal_Select.png"}),
		base.Grid.new({normal = "Label_Hard.png", selected = "Label_Hard_Select.png", disabled="Label_Hard_Gray.png"}),		
	})
	:walk(function(index, button)
		button:pos(80 + (index-1) * 135, 543):addTo(self.layer_)
	end)
	:onEvent(function(event)
		local index = self:getIndex()
		if index then 
			self.index_[index] = 0
			self:updateListView()
			self:updateArrowView()

			CommonSound.click() -- 音效
		end 
	end)
	:selectedButtonAtIndex(self.toIndex_)
---------------------------------------------------
-- 宝箱包含物品层
	self.chestItemLayer = app:createView("chapter.ChestItemLayer")
	:addTo(self, 10)
	:center()
	:hide()
---------------------------------------------------

end
-- 对应的 数据列表
function ChapterScene:getItemsData()
	local index = self:getIndex()
	if index then 
		return self.items_[index]
	end
	return nil 
end 
-- 选择第几个数据列表 
function ChapterScene:getIndex()
	if not self.btnGroup_ then return nil end 
	return self.btnGroup_:getSelectedIndex()
end 

---------------------------------------

function ChapterScene:updateData()
	-- print("进入章节。。。。。。。。。。。。。。。。。。。")
	print("新进入章节。。。。。。。。。。。。。。。。。。。")
	self.level = UserData:getUserLevel()	
end 

function ChapterScene:updateView()
	self:updateListView()
	self:updateButtonView()
	self:updateArrowView()
end

function ChapterScene:showChestItems(data)
	if self.chestData.id ~= data.id or self.chestData.index ~= data.index then 
		self.chestItemLayer:removeItems()
		self.chestData.id = data.id
		self.chestData.index = data.index
		self.chestItemLayer:setNameWithIndex(data.index)
		local items = ChapterData:getAwardData(data.id, data.index)	
		for k,v in pairs(items) do
			local item = UserData:createItemView(v.id)
			self.chestItemLayer:addItem(item, v.count)
		end
	end 

	self.chestItemLayer:show()
end

function ChapterScene:hideChestItems()
	self.chestItemLayer:hide()
end

function ChapterScene:createGrid(flag)	
	local grid = app:createView("chapter.ChapterGrid", {
		flag = flag
	})
	if flag == "normalFlag" then 
		grid:initNormalSelectIf()
	else 
		grid:initEliteSelectIf()
	end
	grid:onChestTouch(function(event)		
		if event.name == "began" then 
			local chestData = event.target:getData("chest")
			if chestData then
				self:showChestItems(chestData)
			end
		elseif event.name == "ended" then 
			self:hideChestItems()
		end 

		if event.name == "clicked" then	
			local chestData = event.target:getData("chest")
			if chestData then			
				self:toGetAward(chestData.id, chestData.index)
			end 
		end
	end)

	return grid
end 

-- 宝箱显示信息
function ChapterScene:setChestShow(grid, data, index)	
	grid:showChestIconIndex(index)

	grid:setData("chest", {
		id = data.id,
		index = index
	})
	:showChestIcon(true)

	local starcount = ChapterData:getAchieveAwardStar(data.id, index)
	grid:setChestStarNum(starcount)

	if ChapterData:checkAchieveAward(data.id, index) then -- 加红点 和 放光特效
		grid:showChestBack(true)
		grid:showChestAni(true)
	else 
		grid:showChestBack(false)
		grid:showChestAni(false)
	end 
	grid:showChestOk(false)
end 

-- 解锁信息显示
function ChapterScene:setOpenLabelShow(grid, data)
	local preChapter = data.preChapter
	if data:isElite() then 				
		if preChapter and (not ChapterData:isChapterOver(preChapter.id)) then 
			grid:setOpen1(string.format("通过%s精英后开启", preChapter.preName))
		else 
			grid:setOpen2(string.format("通过普通章节开启"))
		end 						
	else 		
		if not preChapter or ChapterData:isChapterOver(preChapter.id) then 
			grid:setOpen3(string.format("%d级开启", data.openLevel))
		else 
			grid:setOpen1(string.format("通过%s后开启", preChapter.preName))	
		end 
	end 
end

function ChapterScene:updateListView()	
	local items = self:getItemsData()
	if not items then return end 

	local idx = self.index_[self:getIndex()]	
	if not (idx > 0) then 
		idx = ChapterData:getChapterOpenCount(self:getIndex() == 2)
	end 
	
	self.listView_ 
	:reloadData()
	:addItems(#items, function(view, index)
		local data = items[index]
		local star, starMax = ChapterData:getChapterStar(data.id)
		local flag = "normalFlag"
		if self:getIndex() > 1 then -- 精英
			flag = "eliteFlag"
		end 

		local grid = view:getFreeItem(flag)
		if not grid then 
			grid = self:createGrid(flag)
		end 
		
		grid:setChapterName(data.name)
		grid:setPreName(data.preName)
		grid:setStarNum(star, starMax)
		grid:setIcon(data.icon)

		grid:showOpen1(false)
		grid:showOpen2(false)
		grid:showOpen3(false)

		grid:setData("chest", nil)

		if ChapterData:isChapterOpen(data.id) then 
			local received = ChapterData:getAwardNum(data.id)
			if received < 3 then				
				self:setChestShow(grid, data, received+1)	
			else 
				grid:showChestOk(true)
				grid:showChestIcon(false)
				grid:showChestBack(false)
			end 

		else 
			grid:showChestOk(false)
			grid:showChestIcon(false)
			grid:showChestBack(false)

			self:setOpenLabelShow(grid, data)
		end 

		grid:setSelected(false)

		return grid 
	end)

	self:scrollIndex(math.max(idx, 1), false)
end

function ChapterScene:scrollIndex(index, animate)
	self.listView_:scrollIndex(index, animate)
	self.index_[self:getIndex()] = index
end

-- 创建 星级奖励 按钮
function ChapterScene:createAwardButton()
	-- local img = string.format("Chapter_Chest%d.png", index)
	
	local grid = base.Grid.new()
	-- :addItemWithKey("icon", display.newSprite(img)) 
	:addItem(display.newSprite("Star_Yellow.png"):pos(30, -25):scale(1.5))
	:addItemWithKey("starcount", base.Label.new({size=22, color=cc.c3b(220, 0, 30), x=30, y=-25}))

	return grid
end 

-- 放光特效 
function ChapterScene:getAni()	
	local sSpr = display.newSprite("Chapter_Chest_Bg.png")
    local action = cc.RepeatForever:create(cc.RotateBy:create(4, 360))   
    sSpr:runAction(action)
	return sSpr
end

-- 获取星级奖励
function ChapterScene:toGetAward(chapterId, index)
	if ChapterData:checkAchieveAward(chapterId, index) then			
		NetHandler.request("OpenChapterBox", {
			data = {
				param1 = chapterId,
			},
			onsuccess = function(params)				
				UserData:showReward(params.items)
				self:updateListView()
			end,
			onerror = function()
				
			end
		}, self)
	end 
end 

function ChapterScene:updateArrowView()
	local idx = self:getIndex()
	if idx then 
		if idx == 1 then 
			self.arrowLayer1:show()
			self.arrowLayer2:hide()
		else 
			self.arrowLayer1:hide()
			self.arrowLayer2:show()
		end 
	end 
end 

function ChapterScene:updateButtonView()
	local btn = self.btnGroup_:getButtonAtIndex(2)
	if self.level >= OpenLvData.elite.openLv then 
		if not btn:isEnabled() then 
			btn:setEnabled(true)
		end 
	else 
		if btn:isEnabled() then 
			btn:setEnabled(false)
		end 
	end 
end

----------------------------------------------
-- 新手引导 
function ChapterScene:onGuide()
	GuideManager:makeGuide(self)
end

return ChapterScene