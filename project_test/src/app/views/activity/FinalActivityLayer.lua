
--[[

]]

local FinalActivityLayer = class("FinalActivityLayer", function()
	return display.newNode()
end)

--[[
	activityCount 	-- 总活动数
	okActivity 		-- 已完成活动数量
	awardCount  	-- 10% 数励数
	icon = icon, 	-- 奖励物品显示
	remainingDate 	-- 时间
	desc 			-- 规则说明
	received 		-- 是否领取过 bool
]]

function FinalActivityLayer:ctor(params)
	self:initData(params)
	self:initView(params)
end

function FinalActivityLayer:initData(params)
	self.oknum = params.okActivity
	self.activityNum = params.activityCount
	self.awardNum = params.awardCount
	self.desc = params.desc or "" -- 规则说明
	self.icon = params.icon
	self.date = params.remainingDate

	self.nowPer = math.floor(self.oknum / self.activityNum * 10)  -- 有几个 10%
	self.nowAward = self.nowPer * self.awardNum -- 可领奖励数

	self.nextPer = self.nowPer + 1
	self.nexAward = self.nextPer * self.awardNum
	self.received = params.received
end

function FinalActivityLayer:initView()
	CommonView.blackLayer2()
	:addTo(self)

	display.newSprite("Carnival_all_board.png")
	:addTo(self)
	:pos(display.cx,320)

	local width = 580
	local layer, height = self:initView_(width)

	base.GridViewOne.new({
		viewRect = cc.rect(0, 0, width, 330),
		itemSize = cc.size(width, height)
	})
	:addTo(self)
	:pos(display.cx - width * 0.5, 150)
	:addSection({
		count = 1,
		getItem = function()
			return layer
		end
	})
	:reload()

	-- 关闭按钮
	CommonButton.close_()
	:addTo(self)
	:pos(display.cx+302, display.cy+208)
	:onButtonClicked(function()
		self:onEvent_({name="close"})
	end)
end

function FinalActivityLayer:initView_(width)
	local node = display.newNode()
	local cw = width * 0.5

	----------
	-- 规则说明
	local descLabel = base.Label.new({
		text = self.desc,
		size = 18,
		dimensions = cc.size(width - 40, 0),
		align 	= 	cc.TEXT_ALIGNMENT_LEFT,
	})
	:align(display.LEFT_BOTTOM)
	:addTo(node)
	:pos(20, 0)

	local height = descLabel:getCascadeBoundingBox().height

	base.Label.new({text="规则说明", size=22})
	:align(display.CENTER)
	:addTo(node)
	:pos(cw, height + 20)

	-- 规则说明
	----------

	----------------------------
	-- ///////////////////////
	local infoNode = display.newNode()
	:addTo(node)
	:pos(0, height + 165)


	base.Label.new({text="全目标最终大奖", size=22})
	:align(display.CENTER)
	:addTo(infoNode)
	:pos(cw, 120)

	if self.icon then
		self.icon:addTo(infoNode)
		:pos(80, 50)

		base.Label.new({text=tostring(self.awardNum * 10), size=22})
		:align(display.CENTER_RIGHT)
		:addTo(infoNode)
		:pos(130, 0)
	end

	base.Label.new({text="当前进度：", size=18})
	:addTo(infoNode)
	:pos(150, 80)

	-- 当前进度
	self.processLabel = base.Label.new({size=18, color=CommonView.color_yellow()})
	:addTo(infoNode)
	:pos(260, 80)

	base.Label.new({text="当前可领：", size=18})
	:addTo(infoNode)
	:pos(150, 50)

	-- 当前可领
	self.nowGetLabel = base.Label.new({size=18, color=CommonView.color_yellow()})
	:addTo(infoNode)
	:pos(260, 50)

	base.Label.new({text="下档可领：", size=18})
	:addTo(infoNode)
	:pos(150, 20)

	-- 下档可领
	self.nextGetLabel = base.Label.new({size=18, color=CommonView.color_yellow()})
	:addTo(infoNode)
	:pos(260, 20)

	base.Label.new({text="已达到进度：", size=18, color=CommonView.color_yellow()})
	:addTo(infoNode)
	:pos(320, 50)

	-- 已达到进度：
	self.nowAchievedLabel = base.Label.new({size=18, color=CommonView.color_yellow()})
	:addTo(infoNode)
	:pos(450, 50)

	base.Label.new({text="需进度达到：", size=18, color=CommonView.color_yellow()})
	:addTo(infoNode)
	:pos(320, 20)

	-- 需进度达到：
	self.nextAchievedLabel = base.Label.new({size=18, color=CommonView.color_yellow()})
	:addTo(infoNode)
	:pos(450, 20)

	-- 时间
	self.dateLabel = base.Label.new({size=18, color=CommonView.color_green()})
	:align(display.CENTER)
	:addTo(node)
	:pos(cw, height + 140)

	-- 领取按钮
	local image_ = {
		normal = "all_button.png",
		pressed = "all_button_light.png",
		disabled = "all_button_gray.png"
	}
	self.receivedBtn = CommonButton.yellow3("",{image = image_})
	:addTo(node)
	:pos(cw, height + 80)
	:onButtonClicked(function()
		self:onEvent_({name="reward"})
	end)

	height = height + 300
	node:size(width, height)
	:align(display.CENTER)
	return node, height
end

function FinalActivityLayer:createDateString(date)
	local str = ""
	if date.s <= 0 then
		str = string.format("已结束")
	elseif self.received then
		str = string.format("已领取过")
	elseif date.day < 1 then
		str = string.format("可领取")
	elseif date.day == 1 then
		if date.hour > 0 then
			str = string.format("%d小时%d分钟后可领取", date.hour, date.min)
		elseif date.min > 0 then
			str = string.format("%d分钟后可领取", date.min)
		else
			str = string.format("%d秒后可领取", date.sec)
		end
	else
		str = string.format("%d天%d小时%d分钟后可领取", date.day-1, date.hour, date.min)
	end
	return str
end

function FinalActivityLayer:onEvent(listener)
	self.eventListener_ = listener
	return self
end

function FinalActivityLayer:onEvent_(event)
	if not self.eventListener_ then return end
	event.target = self
	self.eventListener_(event)
end

function FinalActivityLayer:updateView()
	print("update view:", self.received)
	if self.received then
		self.processLabel:setString("")
		self.nowGetLabel:setString("")
		self.nowAchievedLabel:setString("")
		self.nextGetLabel:setString("")
		self.nextAchievedLabel:setString("")
		self.dateLabel:setString("已领取")

		self.receivedBtn:setButtonEnabled(false)
	else
		local flagstr = ""
		if self.nowPer > 0 then
			flagstr = "0"
		end

		self.processLabel:setString(string.format("%d/%d", self.oknum, self.activityNum))
		self.nowGetLabel:setString(tostring(self.nowAward))
		self.nowAchievedLabel:setString(string.format("%d%s%%", self.nowPer, flagstr))

		local numstr = ""
		local perstr = ""
		if self.nowPer < 10 then
			numstr = tostring(self.nexAward)
			perstr = string.format("%d0%%", self.nextPer)
		end

		self.nextGetLabel:setString(numstr)
		self.nextAchievedLabel:setString(perstr)
		self.dateLabel:setString(self:createDateString(self.date))
	end

	return self
end

return FinalActivityLayer
