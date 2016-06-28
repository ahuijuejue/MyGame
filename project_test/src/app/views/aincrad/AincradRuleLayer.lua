--[[
艾恩葛朗特规则层
]]

local AincradRuleLayer = class("AincradRuleLayer", function( ... )
	return display.newNode()
end)

local function createRewardIcon(items)
	local node = display.newNode()
	for i,v in ipairs(items) do
		UserData:createItemView(v.itemId, {scale=0.7})
		:pos((i-1)*120, 0)
		:addTo(node)
		:addItem(base.Label.new({text=tostring(v.count),
			size=18,
			}):align(display.CENTER_RIGHT):pos(40, -35))
	end
	return node
end

function AincradRuleLayer:ctor()
	self:initData()
	self:initView()

end

function AincradRuleLayer:initData()
	self.rank = 0
	self.awards = nil
end

function AincradRuleLayer:initView(data)

	-- 灰层背景
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    self.layer_ = display.newNode():size(960, 640):align(display.CENTER)
    :addTo(self)
    :center()

-----------------------------------------------------
-- 背景框
    CommonView.backgroundFrame3()
    :addTo(self.layer_)
	:pos(480, 280)

	-- 标题
	CommonView.titleLinesFrame2()
	:addTo(self.layer_)
	:pos(480, 540)

	base.Label.new({text="规则", color=CommonView.color_white(), size=32})
	:align(display.CENTER)
	-- display.newSprite("Word_Arena_Rank.png")
	:addTo(self.layer_)
	:pos(480, 540)

------------------------------------------------------

	-- 列表
	self.listView_ = base.GridViewOne.new({
		viewRect = cc.rect(0, 0, 680, 430),
	}):addTo(self.layer_)
	:pos(140, 50)

	-- 关闭按钮
	CommonButton.close():addTo(self.layer_):pos(850, 530)
	:onButtonClicked(function()
		CommonSound.close() -- 音效

		self:onEvent_{name="close"}
	end)

end

function AincradRuleLayer:setRank(value)
	self.rank = value
	self.awards = AincradData:getAwardData(value)

	return self
end

function AincradRuleLayer:updateShow()
	----------
	local descStr = ""
	if not self.awards then
		descStr = "当前无排名"
	elseif #self.awards.lv == 1 then
		descStr = string.format("保持当前排名(第%d名)，即可获得以下奖励：", self.awards.lv[1])
	else
		descStr = string.format("保持当前排名(%d-%d名)，即可获得以下奖励：", self.awards.lv[1], self.awards.lv[2])
	end
	self.descLabel:setString(descStr)

	----------
	if self.awards then
		self.awardNode:removeAllChildren()
		createRewardIcon(self.awards.items)
		:addTo(self.awardNode)
	end
	---------- 当前排名

	local label1 = self.rankLabel:getItem("rank1")
	local size1 = label1:getContentSize()

	local label2 = self.rankLabel:getItem("rank2")
	label2:setString(tostring(self.rank))
	local size2 = label2:getContentSize()

	local posX1 = -(size1.width + size2.width) * 0.5
	label1:pos(posX1, 0)
	label2:pos(posX1 + size1.width, 0)
end

function AincradRuleLayer:onEvent(listener)
	self.eventListener = listener

	return self
end

function AincradRuleLayer:onEvent_(event)
	if not self.eventListener then return end

	event.target = self
	self.eventListener(event)
end

function AincradRuleLayer:updateListView()
	local width = self.listView_:getViewRect().width
	local height = 0
	local starX = 0
	local node = display.newNode()
	local node1 = self:createFrontAwardView(starX, height, width)
	:addTo(node)
	height = height + node1:getContentSize().height

	local node2 = self:createRuleView(starX, height, width)
	:addTo(node)
	height = height + node2:getContentSize().height

	local node3 = self:createAwardView(starX, height, width)
	:addTo(node)
	height = height + node3:getContentSize().height

	node:size(width, height)
	:align(display.CENTER)


	self.listView_
	:resetData()
	:addSection(
		{
			count = 1,
			itemSize = cc.size(width, height),
			getItem = function()
				local grid = base.Grid.new()

				grid:addItem(node)

				return grid
			end,
		})
	:reload()

	return self

end



-- 当前排名
function AincradRuleLayer:createAwardView(baseX, baseY, baseW)
	local cw = baseW * 0.5
	local totalH = 0
	local tmpH = 0

	local node = display.newNode()
	node:pos(baseX, baseY)

	------------------------

	-- 奖品
	tmpH = 50
	totalH = totalH + tmpH
	self.awardNode = display.newNode()
	:addTo(node)
	:pos(50, totalH)

	totalH = totalH + tmpH

	-- 描述
	self.descLabel = base.Label.new({text="", size=20, color=CommonView.color_gray1()})
	:addTo(node)
	tmpH = 15

	totalH = totalH + tmpH
	self.descLabel:pos(0, totalH)
	totalH = totalH + tmpH


	-- label
	self.rankLabel = base.Grid.new()
	:addTo(node)
	local label1 = base.Label.new({text="当前排名：", size=24, color=CommonView.color_orange()})
	local size1 = label1:getContentSize()
	local label2 = base.Label.new({text="", size=24, color=CommonView.color_white()})

	tmpH = size1.height * 0.5
	totalH = totalH + tmpH

	label1:pos(-size1.width*0.5, 0)

	self.rankLabel:pos(cw, totalH)
	self.rankLabel:addItemWithKey("rank1", label1)
	self.rankLabel:addItemWithKey("rank2", label2)

	totalH = totalH + tmpH

	------
	node:size(baseW, totalH)
	return node
end

-- 战斗规则
function AincradRuleLayer:createRuleView(baseX, baseY, baseW)
	local totalH = 0
	local node = display.newNode()
	node:pos(baseX, baseY)

	-- 规则label
	local ruleStr = AincradData.ruleDesc
	local ruleLabel = base.Label.new({text=ruleStr, size=18,
		color=CommonView.color_gray1(),
		dimensions = cc.size(baseW-20, 0),
		align = cc.TEXT_ALIGNMENT_LEFT,
		})
	:align(display.LEFT_BOTTOM)
	:addTo(node)
	:pos(10, 0)

	totalH = totalH + ruleLabel:getContentSize().height + 10

	-- label
	local label = base.Label.new({text="战斗规则", size=24, color=CommonView.color_orange()})
	:align(display.CENTER)
	:addTo(node)

	local labelH = label:getContentSize().height

	totalH = totalH + labelH * 0.5
	label:pos(baseW * 0.5, totalH)
	totalH = totalH + labelH * 0.5
	------

	node:size(baseW, totalH)
	return node
end

-- 排名奖励
function AincradRuleLayer:createFrontAwardView(baseX, baseY, baseW)
	local totalH = 0
	local node = display.newNode()
	node:pos(baseX, baseY)
	local height = 120
	local startX = 20
	local starY = height * 0.5

	for i=1,10 do
		local rank = 11-i
		local str = string.format("第%d名:", rank)
		base.Label.new({text=str, size=24, color=CommonView.color_orange()})
		:addTo(node)
		:pos(startX, starY + (i-1)*height)

		local data = AincradData:getAwardDatas()[rank]
		if data then
			createRewardIcon(data.items)
			:addTo(node)
			:pos(startX + 130, starY + height*(i-1))
		end
	end

	totalH = totalH + height * 10

	-- label
	local label = base.Label.new({text="排名奖励", size=24, color=CommonView.color_orange()})
	:align(display.CENTER)
	:addTo(node)

	local labelH = label:getContentSize().height

	totalH = totalH + labelH * 0.5
	label:pos(baseW * 0.5, totalH)
	totalH = totalH + labelH * 0.5
	------

	node:size(baseW, totalH)
	return node
end

return AincradRuleLayer

