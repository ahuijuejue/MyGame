
local SweepDisplayLayer = class("SweepDisplayLayer", function()
	return display.newNode()
end)

function SweepDisplayLayer:ctor(options)	
	self:initData(options)
	self:initView()
end

function SweepDisplayLayer:initData(options)	
	self.drops = options.drops or {}
	self.drugs = options.drugs or {}
	self.showIdx = 0 			-- 扫荡波次
	self.showHeight = 0 		-- 已经显示的部分占据的高度
	self.showHeight2 = 0 		-- 大块移动 高度
	self.data = {
		name = options.name, 		--	关卡名		
		gold = options.gold, 		--	数组 获得金币
		soul = options.soul, 		--	数组 获得灵能值
		exp  = options.exp, 		--  一次 获得战队经验
		uCoin = options.uCoin,		-- 工会币
		count= table.nums(self.drops),		--	扫荡次数
	} 
	
	self:resetShowTime()
end

function SweepDisplayLayer:initView()
	-- 灰层背景	
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    local layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self):center()
	self.layer_ = layer_

	local canDouble = true
	base.Grid.new()
	:addTo(self.layer_)
	:pos(480, 320)
	:onClicked(function(event)
		if event.comb == 1 then 
			if canDouble then 
				self:setShowOver()
				canDouble = false
			end 
		end 
	end, cc.size(display.width, display.height))

-- 主层

    --------背景框
    display.newSprite("Sweep_Board.png"):addTo(self.layer_)
    :pos(480, 290)
    :onTouch(function()
    	-- body
    end)

    -------------------------------
    -- 列表
    self.listView_ = base.ListView.new({
    	viewRect = cc.rect(0, 0, 430, 430),
    }):addTo(self.layer_)
    :pos(263, 75)

    --------------------------------
    -- 按钮
    self.btnClose = cc.ui.UIPushButton.new({
    	normal="Close.png"
    }):addTo(self.layer_)
    :pos(715, 530)
    :onButtonClicked(function()
    	CommonSound.close() -- 音效

    	self:onEvent_{name="close"}
    end)
    :hide()


end

function SweepDisplayLayer:onEvent(listener)
	self.listener_ = listener 

	return self 
end

function SweepDisplayLayer:onEvent_(event)
	if not self.listener_ then return end 

	event.target = self 
	self.listener_(event)
end

function SweepDisplayLayer:start()
	if self.showIdx < self.data.count then 
		self.showIdx = self.showIdx + 1
		self:showIndex(self.showIdx)
	else 
		self:onEvent_{name="completed", count=self.data.count}
		self.btnClose:show()
	end 
end

function SweepDisplayLayer:showIndex(index)
	local item, size = self:createItem(index, function()
		self:start()
	end)
	self.listView_:addSizeItem(size, function()
		return item 
	end)
	 
	self.listView_:reload()
	
	self:addShowHeight(0)
end
-- 滚动listView
function SweepDisplayLayer:updateScrollPos(animated)	
	self.listView_:setScrollPosition(self.showHeight, 0, animated)
end
-- 增加显示
function SweepDisplayLayer:addShowHeight(length)	
	self.showHeight = self.showHeight + length 
	self:updateScrollPos(length > 0)	
end

-- 滚动listView
function SweepDisplayLayer:updateScrollPos2(animated)	
	self.listView_:setScrollPosition2(self.showHeight2, animated)
end
-- 增加显示
function SweepDisplayLayer:addShowHeight2(length)	
	self.showHeight2 = self.showHeight2 + length 
	self:updateScrollPos2(length > 0)	
end

function SweepDisplayLayer:resetShowTime()
	self.showDur = {
		head = 0.3,
		itemBg = 0.05,
		item1 = 0.01,
		item2 = 0.1,
		sweepOk = 0.1,
		okLine = 0.1,
		drugsBg = 0.1,
		drugs = 0.03,
	}
end 

function SweepDisplayLayer:setShowOver()
	transition.stopTarget(self)
	transition.stopTarget(self.listView_.container)
	self.listView_:removeAllItems()

	for i=1,self.data.count do
		local item, size = self:createItem2(i)
		self.listView_:addSizeItem(size, function()
			return item 
		end)
	end
	 
	self.listView_:reload()

	self:performWithDelay(function()
		self.listView_.scrollNode:setPositionY(0)
		self.listView_:elasticScroll()

		self:onEvent_{name="completed", count=self.data.count}
		self.btnClose:show()
	end, 0)	
end 
--[[
-@return node, 尺寸
]]
function SweepDisplayLayer:createItem(index, showEndFunc)
	local data = self.data 
	local drops = self.drops[index]
	local drugs = self.drugs[index] or {}
	local gold 	= data.gold[index] or 0 
	local soul 	= data.soul[index] or 0
	local width = 430 -- 视窗宽度
	local cw = width * 0.5
	local w = 106 -- 掉落物品图像的宽度
	local h = 100 -- 掉落物品图像的高度
	local rowNum = 4 -- 一行有几个
	local itemLayer, size, dropViews, row = self:createDropItem(drops, w, h, rowNum)

	local frontH = 10  -- 附加头
	local headH = 100 -- 头部 高度
	local okH 	= 70  -- 扫荡完成字 高度
	local exLH 	= 50  -- 额外奖励分割线 高度 
	local exH 	= h -- 额外奖励物品 高度 
	local footH = 21  -- 附加尾
	local height = frontH + headH + footH + okH + exLH + exH + size.height 
	local node = display.newNode()
	:size(width, height)

	itemLayer:addTo(node):hide()
	:zorder(2)

---------------------------------------------
	
	local function addDrugs()
		local count = table.nums(drugs)		
		if count > 0 then 
			local idx = 1 
			for k,v in pairs(drugs) do				
				local item = base.Grid.new():addTo(node):scale(0)
				:addItem(UserData:createView(v):scale(0.7))								
				:pos((idx-0.5) * w, footH + h * 0.5)
				if v.count > 1 then 
					item:addItems({
						display.newSprite("Banner_Level.png"):pos(25, -25),
						base.Label.new({text=tostring(v.count), size=18, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(25, -25),
					})
				end 
				self:performWithDelay(function()			
					item:scale(1.3)
					transition.scaleTo(item, {time=0.1, scale=1, easing="backout"})
				end, self.showDur.drugs * idx)

				idx = idx + 1
			end
		else 
			base.Label.new({text="无", size=22, color=cc.c3b(255,255,255)}):addTo(node)
			:align(display.CENTER)
			:pos(cw, footH + h * 0.5)
		end 

		self:performWithDelay(function()			
			self:start()
		end, 0.3)
	end

	local function addDrugsBg()
		self:addShowHeight(exH + footH)
		display.newSprite("Sweep_Banner.png"):addTo(node)
		:pos(cw, footH + 50)

		self:performWithDelay(function()			
			addDrugs()
		end, self.showDur.drugsBg)
	end


	local function addExLine()
		self:addShowHeight(exLH)
		base.Label.new({text="额外奖励", size=18, color=CommonView.color_red()}):addTo(node)
		:align(display.CENTER)
		:pos(cw, exH + footH + 33)

		display.newSprite("Sweep_Slip.png"):addTo(node)
		:pos(cw, exH + footH + 15)

		self:performWithDelay(function()			
			addDrugsBg()
		end, self.showDur.okLine)
	end

	local function sweepOk()
		self:addShowHeight(okH)			
		self:performWithDelay(function()	
			local okWord = display.newSprite("Word_Sweep_Complete.png"):addTo(node)
			:pos(cw, exH + footH + exLH + 33)
			:scale(0.7)
			transition.scaleTo(okWord, {time=0.5, scale=1, easing="elasticOut"})	
			self:performWithDelay(function()	
				addExLine()	
			end, self.showDur.sweepOk)
		end, self.showDur.sweepOk)
	end 

	local function addItem()		
		itemLayer:show()
		:align(display.TOP_CENTER)
		:pos(cw, height - headH - frontH)
		for i,v in ipairs(dropViews) do
			v:scale(0)
			self:performWithDelay(function()
				v:scale(2)
				transition.scaleTo(v, {time=0.1, scale=1, easing="backout"})
				if i == #dropViews then 
					self:performWithDelay(function()
						sweepOk()
					end, self.showDur.item2)						
				end 
			end, self.showDur.item1 * i)
		end
	end

	local function addItemBg()
		self:addShowHeight(size.height)	
		for i=1,row do
			display.newSprite("Sweep_Banner.png"):addTo(node)
			:pos(cw, height - headH - frontH + (0.5 - i) * h)
		end	
		self:performWithDelay(function()	
			addItem()		
		end, self.showDur.itemBg)			
	end

	local function addHead()
		self:createHead(index, cw):addTo(node)
		:pos(0, height - frontH)
		
		if index > 1 then 
			self:performWithDelay(function()	
				self:addShowHeight2(self.lastHeight)
				self:performWithDelay(function()	
					self:addShowHeight(headH + frontH) 						
				end, 0.1)	 		
			end, 0)			
		else 
			self:performWithDelay(function()	
				self:addShowHeight(headH + frontH) 						
			end, 0)

		end 		

		self:performWithDelay(function()	
			self.lastHeight = height			
			if row > 0 then 
				addItemBg()
			else 
				sweepOk()
			end 
		end, self.showDur.head)
	end

	addHead()	

	return node, cc.size(width, height)
end

function SweepDisplayLayer:createItem2(index)
	local data = self.data 
	local drops = self.drops[index]
	local drugs = self.drugs[index] or {}
	local gold 	= data.gold[index] or 0 
	local soul 	= data.soul[index] or 0
	local width = 430 -- 视窗宽度
	local cw = width * 0.5
	local w = 106 -- 掉落物品图像的宽度
	local h = 100 -- 掉落物品图像的高度
	local rowNum = 4 -- 一行有几个
	local itemLayer, size, dropViews, row = self:createDropItem(drops, w, h, rowNum)

	local frontH = 10  -- 附加头
	local headH = 100 -- 头部 高度
	local okH 	= 70  -- 扫荡完成字 高度
	local exLH 	= 50  -- 额外奖励分割线 高度 
	local exH 	= h -- 额外奖励物品 高度 
	local footH = 21  -- 附加尾
	local height = frontH + headH + footH + okH + exLH + exH + size.height 
	local node = display.newNode()
	:size(width, height)

	itemLayer:addTo(node)
	:zorder(2)
	
	local function addDrugs()		
		local count = table.nums(drugs)		
		if count > 0 then 
			local idx = 1 
			for k,v in pairs(drugs) do				
				local item = base.Grid.new():addTo(node)
				:addItem(UserData:createView(v):scale(0.7))								
				:pos((idx-0.5) * w, footH + h * 0.5)
				if v.count > 1 then 
					item:addItems({
						display.newSprite("Banner_Level.png"):pos(25, -25),
						base.Label.new({text=tostring(v.count), size=18, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(25, -25),
					})
				end 
				
				idx = idx + 1
			end
		else 
			base.Label.new({text="无", size=22, color=cc.c3b(255,255,255)}):addTo(node)
			:align(display.CENTER)
			:pos(cw, footH + h * 0.5)
		end 
	end

	local function addDrugsBg()		
		display.newSprite("Sweep_Banner.png"):addTo(node)
		:pos(cw, footH + 50)
				
		addDrugs()		
	end


	local function addExLine()		
		base.Label.new({text="额外奖励", size=18, color=CommonView.color_red()}):addTo(node)
		:align(display.CENTER)
		:pos(cw, exH + footH + 33)

		display.newSprite("Sweep_Slip.png"):addTo(node)
		:pos(cw, exH + footH + 15)
		
		addDrugsBg()		
	end

	local function sweepOk()
		local okWord = display.newSprite("Word_Sweep_Complete.png"):addTo(node)
		:pos(cw, exH + footH + exLH + 33)
				
		addExLine()	
	end 

	local function addItem()		
		itemLayer
		:align(display.TOP_CENTER)
		:pos(cw, height - headH - frontH)
		
		sweepOk()
	end

	local function addItemBg()		
		for i=1,row do
			display.newSprite("Sweep_Banner.png"):addTo(node)
			:pos(cw, height - headH - frontH + (0.5 - i) * h)
		end	
		
		addItem()			
	end

	local function addHead()
		self:createHead(index, cw):addTo(node)
		:pos(0, height - frontH)
					
		if row > 0 then 
			addItemBg()
		else 
			sweepOk()
		end 		
	end


	addHead()	

	return node, cc.size(width, height)
end 

function SweepDisplayLayer:createHead(index, cw)
	local data = self.data 	
	local gold 	= data.gold[index] or 0 
	local soul 	= data.soul[index] or 0

	local node = display.newNode()
	
	-- 关卡名
	base.Label.new({text=data.name, size=18}):addTo(node)
	:align(display.CENTER)
	:pos(125, -15)
	-- 波次
	base.Label.new({text=string.format("第%d次", index), size=18}):addTo(node)
	:align(display.CENTER)
	:pos(320, -15)
	-- 分割线
	display.newSprite("Sweep_Slip.png"):addTo(node)
	:pos(cw, -40)
	-- 战队经验
	base.Label.new({text="战队Exp", size=18, color=cc.c3b(0, 255, 0)}):addTo(node)	
	:pos(5, -66)
	base.Label.new({text=tostring(data.exp), size=18}):addTo(node)	
	:pos(95, -66)
	-- 金币
	display.newSprite("Gold.png"):addTo(node)
	:pos(170, -66)
	base.Label.new({text=tostring(gold), size=18, color=cc.c3b(255, 255, 0)}):addTo(node)	
	:pos(210, -66)

	if data.uCoin then
		local uCoin = data.uCoin[index] or 0
		--工会币
		display.newSprite("UnionGold.png"):addTo(node)
		:pos(330,-66)
		base.Label.new({text=tostring(uCoin), size = 18}):addTo(node)	
		:pos(365, -66)
	else
		-- 灵能
		display.newSprite("Skill.png"):addTo(node)
		:pos(330, -66)
		base.Label.new({text=tostring(soul), size=18, color=CommonView.color_blue()}):addTo(node)	
		:pos(365, -66)
	end

	return node
end 

--[[
width 	单个图像宽度
height 	单个图片高度 
rowNum 	一行有几个

-@return 图像层，尺寸，图像集合，行数
]]
function SweepDisplayLayer:createDropItem(drops, width, height, rowNum)
	local count = table.nums(drops) 
	local row = math.ceil(count/rowNum) -- 行数
	local node = display.newNode()
	:size(width * rowNum, height * row)
	local items = {}
	for i,v in ipairs(drops) do
		-- local itemData = ItemData:getItemConfig(v.itemId)
		local hIdx = math.ceil(i/rowNum) -- 第几行
		local wIdx = math.mod(i - 1, rowNum) + 1 -- 第几列
		print("行列", hIdx, wIdx)
		local item = base.Grid.new():addTo(node)
		:addItem(UserData:createView(v):scale(0.7))		
		:pos((wIdx-0.5) * width, (row - hIdx + 0.5) * height)
		table.insert(items, item)

		if v.count > 1 then 
			item:addItems({
				display.newSprite("Banner_Level.png"):pos(25, -25),
				base.Label.new({text=tostring(v.count), size=18, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(25, -25),
			})
		end 
	end

	return node, cc.size(width * rowNum, height * row), items, row 
end 


return SweepDisplayLayer 