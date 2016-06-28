
local RechargeScene = class("RechargeScene", base.Scene)

function RechargeScene:initData()
	self.items_ = RechargeData:getArray()
end

function RechargeScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer", {menu=false}):addTo(self)
	:onBack(function(layer)
		self:pop()
	end)

	local layer_ = self.layer_

	display.newSprite("HeroBoard.png"):addTo(layer_)
	:align(display.BOTTOM_LEFT):pos(45, 20)

	display.newSprite("bg_001.png"):addTo(layer_)
	:align(display.BOTTOM_LEFT):pos(82, 51)

	local vipButton = display.newSprite("Word_Vip.png"):addTo(layer_)
	:align(display.BOTTOM_LEFT):pos(735, 452):zorder(2)

    display.newSprite("Vip_Banner.png"):addTo(layer_)
	:align(display.BOTTOM_LEFT):pos(75, 423)

	display.newSprite("Vip_Large.png"):addTo(layer_)
	:align(display.BOTTOM_LEFT):pos(325, 460)

	self.vipLabel = cc.Label:createWithCharMap("word1.png",38,52,48)
	self.vipLabel:setPosition(450, 485)
	self.vipLabel:addTo(layer_)

	self.vipLabel_ = cc.Label:createWithCharMap("word2.png",15,20,48)
	self.vipLabel_:setPosition(655,470)
	self.vipLabel_:addTo(layer_)

	-- vip经验条
	local spr = display.newSprite("Vip_ExpSlip.png"):addTo(layer_):align(display.CENTER_LEFT):pos(205, 463)
	self.vipSlider_ = display.newSprite("Vip_Exp.png"):addTo(spr):align(display.CENTER_LEFT):pos(135, 18)
	self.vipExpLabel_ = base.Label.new({text = ""}):addTo(layer_):align(display.CENTER):pos(520, 440)

	self.vipInfoLayer_ = display.newNode():addTo(layer_):pos(505, 470)

	-- 充值列表
	self.listView_ = base.ListView.new({
		direction = "horizontal",
		viewRect = cc.rect(0, 0, 785, 370),
		itemSize = cc.size(240, 405),
	}):addTo(layer_)
	:pos(92, 52)
	:onTouch(handler(self, self.touchListener))

	cc.ui.UIPushButton.new({normal="Vip_Button.png"}):addTo(layer_):pos(783, 475)
	:onButtonClicked(function()
		app:pushToScene("VipScene")
		end)
end
function RechargeScene:touchListener(event)
    if "clicked" == event.name then

        local column = math.ceil(event.point.y/185)
        if column == 1 then
        	column = 2
        elseif column == 2 then
        	column = 1
        end
        local idx = (event.itemPos - 1)*2 + column

        -- 充值
        if self.items_[idx].limit ~= "1" then  -- 月卡
        	if UserData:getEndTime(tostring(idx)) and UserData:getCardDay(tostring(idx))>0 then
		    	showToast({text="月卡将在"..UserData:getCardDay(tostring(idx)).."天后结束"})
        	else
				self:selectRecharge(idx)
        	end
	    else  -- 非月卡
    		self:selectRecharge(idx)
	    end

    end
end

function RechargeScene:selectRecharge(index)
	print("充值ID: "..self.items_[index].id)
    NetHandler.gameRequest("GenerateOrderId",{param1 = self.items_[index].id})
end
-------------------------------------
function RechargeScene:updateVipExp()

	if self.vipExp < VipData:getVipExpMax() then

		self.vipExp = UserData:getVipExp()
		self:updateData()

	else
		showToast({text="已是最高VIP等级了哦！"})
	end

end

function RechargeScene:updateData()
	self.vipExp = UserData:getVipExp()
    self.firstBuy = UserData:getFirstBuy()
    self.nowTime = UserData:getServerSecond()

    self.vip_ = {
			vip = VipData:getLevel(self.vipExp),  -- 当前VIP经验下的VIP等级
			vipMax = VipData:getVipLevelMax(),   -- 最大VIP等级
			exp = self.vipExp,
			expMax = VipData:getExpMax(self.vipExp), --下一级对应的经验
			lvup = VipData:getNextDia(self.vipExp),  -- 与下一等级相差的钻石数
		}

    if UserData:getVipExp() > VipData:getVipExpMax() then
    	self.vip_.expMax = VipData:getVipExpMax()  --下一级对应的经验
    end

end

function RechargeScene:updateView()
	self:updateVip()
	self:updateListView()
end

function RechargeScene:updateVip()

	self.vipLabel:setString(self.vip_.vip)

	self.vipInfoLayer_:removeAllChildren()
	if self.vip_.vip < self.vip_.vipMax then
		local scale = self.vip_.exp / self.vip_.expMax
		self.vipSlider_:setScaleX(scale)
		self.vipExpLabel_:setString(string.format("%d/%d", self.vip_.exp, self.vip_.expMax))

		base.Label.new({text="再充值",size = 20}):addTo(self.vipInfoLayer_):pos(-10, 30)
		display.newSprite("Diamond.png"):addTo(self.vipInfoLayer_):pos(80, 30):setScale(0.6)
		base.Label.new({text=tostring(self.vip_.lvup),size = 20, color=cc.c3b(255,255,0)}):addTo(self.vipInfoLayer_):align(display.CENTER):pos(130, 30)

		base.Label.new({text="即可成为",size = 20}):addTo(self.vipInfoLayer_):pos(5, 0)
		display.newSprite("Vip_Small.png"):addTo(self.vipInfoLayer_):pos(120, 0)
		self.vipLabel_:show()
		self.vipLabel_:setString(self.vip_.vip+1)
	else
		self.vipSlider_:setScaleX(1)
		self.vipExpLabel_:setString(self.vip_.exp.."/"..self.vip_.expMax)
		base.Label.new({text="已经是最高VIP"}):addTo(self.vipInfoLayer_):align(display.CENTER):pos(85,15)
		self.vipLabel_:hide()
	end
end

function RechargeScene:updateListView()
	self.listView_
	:removeAllItems()
	:addItems(#self.items_/2, function(event)
		local index = event.index
		local data
		if index == 1 then
		    data = {self.items_[index],self.items_[index+1]}
		elseif index == 2 then
			data = {self.items_[index+1],self.items_[index+2]}
		elseif index == 3 then
			data = {self.items_[index+2],self.items_[index+3]}
		elseif index == 4 then
			data = {self.items_[index+3],self.items_[index+4]}
		end
		local grid = base.Grid.new()
		self:setGridShow(grid, data, index)

		return grid
	end)
	:reload()
end

function RechargeScene:setGridShow(grid, data, index)
	grid:removeItems()
	:addItems({
		display.newSprite("Rercharge_Banner.png"):pos(-5, 95):size(225,185),
		createOutlineLabel({text=tostring(data[1].gems).."钻石", color=cc.c3b(255,255,0),size = 24}):pos(0, 26), -- 钻石
		base.Label.new({text=string.format("￥%d", data[1].rmb), color=cc.c3b(255,255,0),size = 20}):pos(40, 155), -- 价钱data.rmb
		display.newSprite(data[1].mark):pos(-63,137),

		display.newSprite("Rercharge_Banner.png"):pos(-5, -89):size(225,185),
		createOutlineLabel({text=tostring(data[2].gems).."钻石", color=cc.c3b(255,255,0),size = 24}):pos(0, -158), -- 钻石
		base.Label.new({text=string.format("￥%d", data[2].rmb), color=cc.c3b(255,255,0),size = 20}):pos(40, -30), -- 价钱data.rmb
		display.newSprite(data[2].mark):pos(-63,-47),

		})
    if index == 1 then
    	grid:addItems({
    		createOutlineLabel({text=data[1].desc, color=cc.c3b(0,255,255),size = 18}):pos(0,55):zorder(2),
    		createOutlineLabel({text=data[2].desc, color=cc.c3b(0,255,255),size = 18}):pos(0,-130):zorder(2), --说明
		})
	else
		grid:addItemWithKey("desc"..data[1].id, createOutlineLabel({text=data[1].desc, color=cc.c3b(0,255,255),size = 18}):pos(0,55):zorder(2))
	    grid:addItemWithKey("desc"..data[2].id, createOutlineLabel({text=data[2].desc, color=cc.c3b(0,255,255),size = 18}):pos(0,-130):zorder(2))
    end

	if data[1].limit == "1" then
		if self.firstBuy[data[1].id] == 1 then
			grid:removeItem("desc"..data[1].id)   -- 不是第一次购买则移除赠送
		end
	end
	if data[2].limit == "1" then
		if self.firstBuy[data[2].id] == 1 then
			grid:removeItem("desc"..data[2].id)   -- 不是第一次购买则移除赠送
		end
	end

    if index == 1 then
    	grid:addItemWithKey("icon"..data[1].id, display.newSprite(data[1].icon):pos(-5, 100))
	    grid:addItemWithKey("icon"..data[2].id, display.newSprite(data[2].icon):pos(-5, -85))
	else
		grid:addItems({
    		display.newSprite(data[1].icon):pos(-5, 100),
    		display.newSprite(data[2].icon):pos(-5, -85),
		})
    end
	if data[1].limit ~= "1" then  -- 并且购买过 并且在有效期内 有效期内图片为灰色
		if UserData:getEndTime("1") and self.nowTime <= UserData:getEndTime("1") then  --在购买状态  当前时间小于结束时间
			grid:removeItem("icon"..data[1].id)
	        grid:addItem(display.newSprite("MonthCard_Gray.png"):pos(-5, 100))
		end
	end
	if data[2].limit ~= "1" then  -- 并且购买过 并且在有效期内 有效期内图片为灰色
		if UserData:getEndTime("2") and self.nowTime <= UserData:getEndTime("2") then  --在购买状态  当前时间小于结束时间
			grid:removeItem("icon"..data[2].id)
	        grid:addItem(display.newSprite("SuperMonthCard_Gray.png"):pos(-5, -85))
		end
	end

end

function RechargeScene:onEnter()
	self:updateData()
	self:updateView()

	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))

end

function RechargeScene:netCallback(event)
    local data = event.data
    local order = event.order
    if order == OperationCode.TeamRechargeInfoResponse then
    	hideLoading()
    	self:updateData()
	    self:updateView()
    end
end

function RechargeScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return RechargeScene
