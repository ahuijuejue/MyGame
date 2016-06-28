--[[
艾恩葛朗特 选择buff界面
]]
local AincradSelectBuffScene = class("AincradSelectBuffScene", base.Scene)

function AincradSelectBuffScene:initData()
	self.buff = AincradData:getWillBuff()
	self.isSelected = false
	-- self.selectedBuffs = {}
	self.costStar = 0

	self.selectedIndices = {}
	for i=1,#self.buff do
		self.selectedIndices[i] = false
	end

end

function AincradSelectBuffScene:initView()
	-- 背景
	CommonView.background_aincrad()
	:addTo(self)
	:center()

	-- 按钮层
	app:createView("widget.MenuLayer", {menu=false, wealth="castle"}):addTo(self)
	:onBack(function(layer)
		if not self:checkOutScene() then
			-- 数据处理中
		elseif self:canSelectBuff() then
			AlertShow.show2("提示", "还有未选择的buff，是否离开", "确定", function(event)
				self:netToSelected(self.selectedIndices)
			end, function()

			end)
		else
			self:netToSelected(self.selectedIndices)
		end
	end)

	CommonView.blackLayer3()
	:addTo(self)

	display.newSprite("main_bottom_bg.png")
	:addTo(self)
	:pos(display.cx, display.top - 30)

	display.newSprite("main_bottom_bg.png")
	:flipY(true)
	:addTo(self)
	:pos(display.cx, display.bottom + 30)

---------------------------------------------------------------------
	-- 背景框
	CommonView.titleLinesFrame2()
	:addTo(self.layer_)
	:pos(480, 520)

	display.newSprite("word_select_buff.png"):addTo(self.layer_)
	:pos(480, 520)

---------------------------------------------------------------------

---------------------------------------------------------------------

	-- buff层
	self.buffBar = app:createView("aincrad.AincradBar"):addTo(self)
	:pos(display.cx + 170, display.bottom + 30)

	-- 星星数
	self.starLayer = app:createView("aincrad.AincradStarWidgetLayer"):addTo(self)
	:pos(display.cx - 350, display.bottom + 30)

---------------------------------------------------------------------
-- 选择buff层
	self.bufNodes = {}
	local nBuff = table.nums(self.buff)
	local addX = 250
	local posX = 480 - (nBuff - 1) * addX / 2
	local posY = 300
	for i,v in ipairs(self.buff) do
		local node = self:createBuffView(v, i)
		:addTo(self.layer_)
		:pos(posX + (i-1) * addX, posY)
		table.insert(self.bufNodes, node)
	end

end

function AincradSelectBuffScene:createBuffView(data, index)
	local grid = base.Grid.new()

	grid:setSelectedImage(display.newSprite("Buyed.png"):pos(30, -20),10)
	grid:setBackgroundImage(display.newSprite("Aincrad_Buff_Frame.png"))
	grid:addItem(display.newSprite(data.image):pos(-35, 140))
	grid:addItem(display.newSprite(data.icon):pos(0, 30))

	grid:addItem(base.Label.new({
			text=string.format("%d%%", data.process),
			size=24,
			color=cc.c3b(250,250,250)
		})
		:align(display.CENTER)
		:pos(4, -67)
	)

	grid:addItem(base.Label.new({
			text=string.format("%s%d%%", data.desc, data.process),
			size=15,
			color=cc.c3b(36,122,255),
			border=false,
		})
		:align(display.CENTER)
		:pos(4, -110)
	)

	grid:onClicked(function()
		CommonSound.click() -- 音效

		-- self:onButtonSelected(data.id)
		self:onButtonSelectedIndex(index)
	end)

	grid:addItem(display.newSprite("star.png"):pos(0,-147):scale(0.25))

	grid:addItem(base.Label.new({
			text=tonumber(data:getCostStar()),
			size=22,
			color=CommonView.color_orange(),
			x=20,
			y=-147
		})
	)

	return grid
end

function AincradSelectBuffScene:onButtonSelectedIndex(index)
	if not self:checkOutScene() then
		return
	end

	local isSelected = self:isSelectedIndex(index)
	if isSelected then -- 已经选择
		self:setSelectedIndex(index, false)
		print("取消选择", index)
	else
		if self:canSelectIndex(index) then
			self:setSelectedIndex(index, true)
			print("选择", index)
		else
			-- 星星不足
			print("不能选择")
			showToast({text="星星不足", time=0.5})
			return
		end
	end
	self:updateCostStarData()
	self:updateStar()
	self:updateBuffSelectedView()

	self.buffBar:setWillBuff(self:getSelectedBuffValue())
	self.buffBar:showChange(true)

	if self:isSelectedAll() then
		self:netToSelected(self.selectedIndices)
	end
end

function AincradSelectBuffScene:netToSelected(selectedInfo)
	local buffIds = {}
	local buffUids = {}
	for i,v in ipairs(selectedInfo) do
		if v then
			table.insert(buffUids, self.buff[i]:getBuffUID())
			table.insert(buffIds, self.buff[i].id)
		end
	end

	if #buffIds == 0 then
		self:outScene()
	else
		self.isSelected = true
		NetHandler.request("SelectAincradBuff", {
			data = {
				param1=table.concat(buffIds, ","),
				param2=table.concat(buffUids, ","),
				},
			onsuccess = function(event)
				self:outScene()
			end,
			onerror = function()
				self.isSelected = false
			end
		}, self)
	end
end

function AincradSelectBuffScene:checkOutScene()
	if self.isSelected then
		showToast({text="数据处理中"})
		return false
	end
	return true
end

function AincradSelectBuffScene:outScene()
	AincradData.isGetReward = true
	app:popScene()
end

-- 是否选择了第index个buff
function AincradSelectBuffScene:isSelectedIndex(index)
	return self.selectedIndices[index]
end

function AincradSelectBuffScene:setSelectedIndex(index, b)
	self.selectedIndices[index] = b
end

-- 是否可以继续选择buff
function AincradSelectBuffScene:canSelectBuff()
	if self:isSelectedAll() then
		return false
	end

	local haveStar = self:getCurrentStar()
	for i,v in ipairs(self.buff) do
		if haveStar >= v:getCostStar() and (not self:isSelectedIndex(i)) then
			return true
		end
	end

	return false
end

-- 是否可以选择第index个buff
function AincradSelectBuffScene:canSelectIndex(index)
	local haveStar = self:getCurrentStar()
	local buffData = self.buff[index]
	if haveStar >= buffData:getCostStar() then
		return true
	end
	return false
end

-- 是否选择了所有buff
function AincradSelectBuffScene:isSelectedAll()
	for i,v in ipairs(self.selectedIndices) do
		if not v then
			return false
		end
	end
	return true
end

-- 更新显示 buff是否已经选择
function AincradSelectBuffScene:updateBuffSelectedView()
	for i,v in ipairs(self.buff) do
		local node = self.bufNodes[i]
		node:setSelected(self:isSelectedIndex(i))
	end
end

function AincradSelectBuffScene:getCurrentStar()
	return AincradData:getCurrentStar() - self:getCostStar()
end

function AincradSelectBuffScene:updateStar()
	local star = self:getCurrentStar()
	self.starLayer:setStar(star)
end

-- 获取当前选择 消耗的星星
function AincradSelectBuffScene:getCostStar()
	return self.costStar
end

function AincradSelectBuffScene:updateCostStarData()
	local cost = 0
	for i,v in ipairs(self.buff) do
		if self:isSelectedIndex(i) then
			cost = cost + v:getCostStar()
		end
	end
	self.costStar = cost
end

-- 获取当前选择的buff数据 的数值
function AincradSelectBuffScene:getSelectedBuffValue()
	local dict = {}
	for i,v in ipairs(self.buff) do
		if self:isSelectedIndex(i) then
			dict[v.id] = v.process
		end
	end
	return dict
end

function AincradSelectBuffScene:updateView()
	self:updateStar()
end

return AincradSelectBuffScene
