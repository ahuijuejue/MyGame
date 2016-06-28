
local IntergralLayer = class("IntergralLayer", function()
	return display.newNode()
end)

function IntergralLayer:ctor()
	self:initData()
	self:initView()
	self:setNodeEventEnabled(true)
end

function IntergralLayer:initData()
	self.mult = 1 	-- 倍数
end

function IntergralLayer:initView()

--------------------------------------------------------
-- 背景框
	local posX = 435

	CommonView.backgroundFrame1()
	:addTo(self)
	:pos(posX, 280)

	CommonView.titleLinesFrame2()
	:addTo(self)
	:pos(posX, 535)

	display.newSprite("Word_Arena_Score.png"):addTo(self)
	:pos(posX, 535)

--------------------------------------------------------
-- 列表
	self.listView_ = base.GridView.new({
		rows=1,
		direction = "horizontal",
		viewRect = cc.rect(0, 0, 758, 453),
		itemSize = cc.size(160, 453),
	}):addTo(self)
	:pos(28, 55)
	:setBounceable(false)

end

function IntergralLayer:setSliderBarIndex(index)
	self.sliderIndex_ = index

	return self
end

function IntergralLayer:onEnter()
	self:updateData()
	self:updateView()
end

function IntergralLayer:updateData()
	self.items = ArenaScoreData:getScoreList()
	self.mult = UserData:getUserLevel()
end

function IntergralLayer:updateView()
	-- body
	self:updateList()
	self:updateSliderBar()
end

function IntergralLayer:updateList()
	self.listView_
	:removeAllItems()
	:addItems(table.nums(self.items) + 1, function(event)
		local index = event.index
		local grid = base.Grid.new()
			:addItems({
				display.newSprite("Score_Bar.png"):pos(0, -10),
				-- display.newSprite("IconScore.png"):pos(0, 175)
				})
		if index == 1 then
			grid:addItem(NumberData:font3("0"):pos(0, 175):align(display.CENTER))
			grid:addItem(display.newSprite("Word_Arena_Score_Rule.png"))
		else
			local data = self.items[index - 1]
			self:setGridShow(grid, data)
		end

		return grid
	end)
	:reload()

	self.sliderBar_ = nil
end

function IntergralLayer:updateSliderBar()
	if not self.sliderBar_ then
		local node = self.listView_:getScrollNode()
		self.sliderBar_ =  display.newScale9Sprite("Score_Slip.png")
			:addTo(node)
			:align(display.LEFT_CENTER)
			:pos(85,365)
		-- self.scoreLabel_ = base.Label.new({size=18}):addTo(node):align(display.CENTER)
		self.flagSpr_ = display.newSprite("Pointer.png"):addTo(node):zorder(5)
	end
	local score = UserData.arenaScore 	-- 竞技场积分
	local length = 80 * score
	local size = cc.size(length, self.sliderBar_:getContentSize().height)
	self.sliderBar_:size(size)

	local posX = length + 80
	-- self.scoreLabel_:setString(tostring(score))
	-- self.scoreLabel_:pos(posX, 385)

	self.flagSpr_:pos(posX, 440)

end

function IntergralLayer:setGridStatus(grid, data)
	local status
	if data:isCompleted() then
		status = display.newSprite("Got_Mark.png")
	elseif ArenaScoreData:isOk(data.id) then
		status = CommonButton.green("领取")
			:onButtonClicked(function()
				CommonSound.click() -- 音效

				print("领取", data.id)
				self:toGetReward(data.id)
			end)
	else
		status = display.newSprite("Below_Mark.png")
	end

	grid:addItemsWithKey({
		status_ = status:pos(0, -185):zorder(2)
	})
end

function IntergralLayer:setGridShow(grid, data)
	self:setGridStatus(grid, data)
	-- 积分
	grid:addItem(NumberData:font3(data.score):pos(0, 165):align(display.CENTER))

	-- 奖品
	local top = 80
	for k,v in pairs(data.items) do -- 奖励物品
		grid:addItem(UserData:createItemView(k):scale(0.7):pos(0, top))

		local count = v
		local itemCfg = ItemData:getItemConfig(k)
		if itemCfg.type == 8 or itemCfg.type == 11 then
		 	count = math.floor(count * self.mult)
		end

		if count > 1 then
			local countLabel_ = base.Label.new({text=tostring(count), color=cc.c3b(250, 250, 250), size=18})
			grid:addItems({
				countLabel_:pos(50-countLabel_:getContentSize().width/2, top - 30):align(display.CENTER)
				})
		end
		top = top - 90
	end
end

function IntergralLayer:toGetReward(rewardId)
	NetHandler.request("ExchangeArenaScore", {
		data = {param1=checknumber(rewardId)},
		onsuccess = function(params)
			self:updateView()
			UserData:showReward(params.items)
			self:onEvent_({name="update"})
		end
	}, self)
end

function IntergralLayer:onExit()
	NetHandler.removeTarget(self)
end

function IntergralLayer:onEvent(listener)
	self.eventListener_ = listener
	return self
end

function IntergralLayer:onEvent_(event)
	if not self.eventListener_ then return end
	event.target = self
	self.eventListener_(event)
end

return IntergralLayer