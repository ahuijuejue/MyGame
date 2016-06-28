local WealthLayer = class("WealthLayer",function()
	return display.newNode()
end)
local scheduler = require("framework.scheduler")
local boardImage = "wealthy_board.png"
local talkImage = "wealth_talk.png"
local btn1 = "wealth_btn11.png"
local btn2 = "wealth_btn22.png"
local vipImage = "wealth_V%d.png"

function WealthLayer:ctor()
	self.closeFunc = nil
	self:initView()	

	self:addNodeEventListener(cc.NODE_EVENT,function (event)
		if event.name == "enter" then
			self:onEnter()
		elseif event.name == "exit" then
			self:onExit()
		end
	end)

	CommonView.animation_show_out(self.board)
end

function WealthLayer:initView()
	CommonView.blackLayer2()
	:addTo(self)

	self.board = display.newSprite(boardImage)
	:addTo(self)
	:pos(display.cx,display.cy+20)

	-- 关闭按钮
	self.closeBtn = CommonButton.close():addTo(self.board):pos(870,525)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close()
		if self.closeFunc then
			self.closeFunc()
		end
	end)

	local talkSprite = display.newSprite(talkImage)
	talkSprite:setPosition(130,300)
	self.board:addChild(talkSprite)

    self.btn = cc.ui.UIPushButton.new({normal = btn1,pressed = btn2}, options)
    :addTo(self.board)
    :pos(770,125)
    :onButtonClicked(function ()
    	if GamblingModel.cost > UserData.diamond then
    		showToast({text = "钻石不足",color = display.COLOR_RED, size = 28})
    	elseif GamblingModel.times > 1 and UserData:getVip() < 3 then
    		showToast({text = "次数不足，提升VIP等级可获得更多次数",color = display.COLOR_RED, size = 28})
    	elseif GamblingModel.times > 2 and UserData:getVip() < 5 then
    		showToast({text = "次数不足，提升VIP等级可获得更多次数",color = display.COLOR_RED, size = 28})
    	elseif GamblingModel.times > 3 and UserData:getVip() < 7 then
    		showToast({text = "次数不足，提升VIP等级可获得更多次数",color = display.COLOR_RED, size = 28})
    	elseif GamblingModel.times > 4 and UserData:getVip() < 9 then
    		showToast({text = "次数不足，提升VIP等级可获得更多次数",color = display.COLOR_RED, size = 28})
    	elseif GamblingModel.times > 5 and UserData:getVip() < 11 then
    		showToast({text = "次数不足，提升VIP等级可获得更多次数",color = display.COLOR_RED, size = 28})
    	elseif GamblingModel.times > 6 and UserData:getVip() < 15 then
    		showToast({text = "次数不足，提升VIP等级可获得更多次数",color = display.COLOR_RED, size = 28})
    	elseif GamblingModel.times > 7 then
    		showToast({text = "次数不足",color = display.COLOR_RED, size = 28})
    	else
    		showLoading()
		    NetHandler.gameRequest("GodOfFortune")
    	end
    end)
	--按钮特效
	local btnAnimation = CommonView.animation_wealth_btn()
	:scale(1.6)
	:pos(5,15)
	:addTo(self.btn)
	--星星特效
	local starAnimation = CommonView.animation_wealth_star()
	:pos(150,215)
	:addTo(self.board)
	--数字框特效
	local ringAnimation = CommonView.animation_wealth_ring()
	:scale(3.1)
	:pos(628,315)
	:addTo(self.board)

    self:createTableView()
    self:createLabelView()
    self:createNumView()
	self:addTimeWidget()
end

function WealthLayer:createNumView()
	self.num1 = display.newSprite(string.format("wealth_%d.png",0))
	self.num1:setPosition(465,311)
	self.board:addChild(self.num1)

	self.num2 = display.newSprite(string.format("wealth_%d.png",0))
	self.num2:setPosition(547,311)
	self.board:addChild(self.num2)

	self.num3 = display.newSprite(string.format("wealth_%d.png",0))
	self.num3:setPosition(628,311)
	self.board:addChild(self.num3)

	self.num4 = display.newSprite(string.format("wealth_%d.png",0))
	self.num4:setPosition(710,311)
	self.board:addChild(self.num4)

	self.num5 = display.newSprite(string.format("wealth_%d.png",0))
	self.num5:setPosition(790,311)
	self.board:addChild(self.num5)
end

function WealthLayer:createTableView()
	self.listView = cc.TableView:create(cc.size(320,165))
	self.listView:setPosition(50,20)
	self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

	self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	self.board:addChild(self.listView)
end

function WealthLayer:updateTable()
	self.listView:reloadData()
    self.listView:setContentOffset(cc.p(0,0), false)
end

function WealthLayer:cellSizeForTable(table,idx)
	local label = createOutlineLabel({text = GamblingModel.info[idx+1],size = 24,dimensions = cc.size(320,0)})
	return label:getContentSize().height
end

function WealthLayer:tableCellAtIndex(table,idx)
	local label = createOutlineLabel({text = GamblingModel.info[idx+1],size = 24,dimensions = cc.size(320,0)})
	return label
end

function WealthLayer:numberOfCellsInTableView(table)
	return #GamblingModel.info
end

function WealthLayer:createLabelView()
	local iconSprite1 = display.newSprite("Diamond.png")
	iconSprite1:setPosition(600,105)
	self.board:addChild(iconSprite1)

	self.maxLabel = createOutlineLabel({text = "", size = 28})
	self.maxLabel:setPosition(520,102)
	self.board:addChild(self.maxLabel)

	self.needLabel = createOutlineLabel({text = "", size = 22})
	self.needLabel:setAnchorPoint(0,0.5)
	self.needLabel:setPosition(400,30)
	self.board:addChild(self.needLabel)

	self.iconSprite2 = display.newSprite("Diamond.png")
	self.iconSprite2:setAnchorPoint(0,0.5)
	self.board:addChild(self.iconSprite2)

	self.haveLabel = createOutlineLabel({text = "", size = 22})
	self.haveLabel:setAnchorPoint(0,0.5)
	self.haveLabel:setPosition(645,30)
	self.board:addChild(self.haveLabel)

	self.iconSprite3 = display.newSprite("Diamond.png")
	self.iconSprite3:setAnchorPoint(0,0.5)
	self.iconSprite3:setPosition(825,33)
	self.board:addChild(self.iconSprite3)
end

function WealthLayer:updateView()
	self.maxLabel:setString(tostring(GamblingModel.maxBonus))

	local str = string.format("本次需要 %d",GamblingModel.cost)
	self.needLabel:setString(str)

	local x = self.needLabel:getContentSize().width
	self.iconSprite2:setPosition(411+x,33)

	str = string.format("当前拥有 %d",UserData.diamond)
	self.haveLabel:setString(str)

	local x = self.haveLabel:getContentSize().width
	self.iconSprite3:setPosition(656+x,33)

	local vipLv = GamblingModel.times - 1
	local lvs = {3,5,7,9,11,15}
	if vipLv > 0 and vipLv < 7 then
	    self.vipSprite = display.newSprite(string.format(vipImage,lvs[vipLv]))
	    self.vipSprite:setPosition(0,-60)
	    self.btn:addChild(self.vipSprite)
	else
		if self.vipSprite then
			self.vipSprite:removeFromParent(true)
			self.vipSprite = nil
		end
	end
end

function WealthLayer:doGambling()
	local resultStr = string.format("%05d",GamblingModel.bonus)
	local nums = {1,1,1,1,1}
	for i=1,5 do
		local num = tonumber(string.sub(resultStr,i,i))
		nums[i] = num
	end

	self.btn:setButtonEnabled(false)
    self.closeBtn:setButtonEnabled(false)

    self:doNumEffect(2,nums[1],self.num1,0,function ()
    	self:updateView()
    	self.btn:setButtonEnabled(true)
   		self.closeBtn:setButtonEnabled(true)
    	UserData:showReward({{itemId = "2", count = GamblingModel.bonus, name = "钻石"}})
    end,0.08)
	self:doNumEffect(2,nums[2],self.num2,0,nil,0.06)
	self:doNumEffect(2,nums[3],self.num3,0,nil,0.04)
	self:doNumEffect(2,nums[4],self.num4,0,nil,0.02)
	self:doNumEffect(2,nums[5],self.num5,0,nil,0.01)
end

function WealthLayer:doNumEffect(times,result,sprite,pos,func,interval)
	if pos > (times-1) * 10 + result then
		local left = times * 10 + result - pos
		interval = math.pow(10 - left,2) * 0.01				
	end

	scheduler.performWithDelayGlobal(function ()
		if pos < times * 10 + result then
			pos = pos + 1
			local num = math.mod(pos,10)
			sprite:setTexture(string.format("wealth_%d.png",num))
			self:doNumEffect(times,result,sprite,pos,func,interval)
		else
			if func then
				func()
			end
		end
	end,interval)
end

--时间控件
function WealthLayer:addTimeWidget()
	self.sprite = display.newSprite()
    :align(display.CENTER)
    :addTo(self.board)
    :pos(670, 470)

    self.timeLabel = base.Label.new({text="", size=18, color=cc.c3b(255, 255, 255), border = false})
    :addTo(self.board)
    :pos(745, 447)
end

-- 更新时间显示
function WealthLayer:updateTimeShow()
	self.leftTime = self.leftTime - 1
	if self.leftTime <= 0 then
		self.closeFunc()
	end
	local date = convertSecToDate(self.leftTime)
    local timestring = string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
    if date.day < 8 then
        self.sprite:setTexture(string.format("font5_%d.png", date.day))
    end
    self.timeLabel:setString(timestring)
end

function WealthLayer:startTimer()
    if self.timeHandle then
        return
    end
    self.timeHandle = scheduler.scheduleGlobal(handler(self,self.updateTimeShow),1)
end

function WealthLayer:stopTimer()
    if self.timeHandle then
        scheduler.unscheduleGlobal(self.timeHandle)
        self.timeHandle = nil
    end
end

function WealthLayer:onEnter()
	self.leftTime = GamblingModel.closeTime - UserData:getServerSecond()
	self:updateTimeShow()
	self:updateView()
	self:updateTable()
	self:startTimer()
end

function WealthLayer:onExit()
	self:stopTimer()
end

return WealthLayer