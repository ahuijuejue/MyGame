
local VipScene = class("VipScene", base.Scene)

function VipScene:initData()
    self.vipArr = VipData:getArray()
end

function VipScene:initView()
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

	local vipButton = display.newSprite("Word_Recharge.png"):addTo(layer_)
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

	cc.ui.UIPushButton.new({normal="Vip_Button.png"}):addTo(layer_):pos(783, 475)
	:onButtonClicked(function()
			app:pushToScene("RechargeScene")
		end)

    self.vipDesLayer_ = display.newNode():addTo(layer_):pos(505,230)

    local image_ = {normal = "Page_Left.png"}
    self.rightSpr = CommonButton.yellow3("",{image = image_}):addTo(layer_):pos(850,260):zorder(10)
    self.rightSpr:rotation(180)
    self.rightSpr:onButtonClicked(function(event)
            CommonSound.click() -- 音效

            if self.count > (#self.vipArr) then
            else
            	self:updateListView(self.count)
            	self.count = self.count+1
            	self:updateButton()
            end

        end)

    self.leftSpr = CommonButton.yellow3("",{image = image_}):addTo(layer_):pos(118,260):zorder(10)
    self.leftSpr:onButtonClicked(function(event)
            CommonSound.click() -- 音效
            if self.count <= 3 then
            else
            	self:updateListView(self.count-2)
            	self.count = self.count-1
            	self:updateButton()
            end
        end)

    self.vipTip = createOutlineLabel({text = "",size = 30,color = cc.c3b(255,255,0)})
    self.vipTip:pos(-30,166)
    self.vipTip:addTo(self.vipDesLayer_)

    self.listView_ = base.ListView.new({
		viewRect = cc.rect(0, 0, 785, 180),
		itemSize = cc.size(785, 180),
	}):addTo(self.vipDesLayer_)
	:pos(-412, -32)

	self.grid = base.Grid.new()
    self.grid:addTo(self.vipDesLayer_):pos(0,-65)

end
-------------------------------

function VipScene:updateData(index)
    self.vipExp = UserData:getVipExp()
    self.isBuyGift = UserData:getIsBuy()
    if index then
	    self.count = index+2
    else
    	if UserData:getVip() > 0  then
			self.count = UserData:getVip()+2
		else
			self.count = 3
		end
    end

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

function VipScene:updateView()
	self:updateVip()
	self:updateListView()
	self:updateButton()
end

function VipScene:updateButton()
	if self.count == 3 then
    	self.leftSpr:setVisible(false)
    	self.rightSpr:setVisible(true)
    elseif self.count == #self.vipArr+1 then
    	self.leftSpr:setVisible(true)
    	self.rightSpr:setVisible(false)
    else
    	self.leftSpr:setVisible(true)
    	self.rightSpr:setVisible(true)
    end
end

function VipScene:updateVip()

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

function VipScene:updateListView(index)

    if not index and UserData:getVip() == 0 then
    	index = 2
    elseif not index and UserData:getVip() > 0 then
    	index = UserData:getVip() + 1
    end

	self.listView_
	:removeAllItems()
	:addItems(1, function(event)
		local grid = base.Grid.new()
		self:setGridShow(grid, self.vipArr[index])
		return grid
	end)
	:reload()

    local data = self.vipArr[index]

    self.vipTip:setString("VIP"..data.level.."特权")

	self.grid:removeItems()
	:addItems({
		display.newSprite("Vip_Line.png"):pos(0, 7),
		base.Label.new({text="V"..data.level.."超值礼包包含以下内容：", color=cc.c3b(255,255,0),size = 18}):pos(-300, 7),

	    base.Label.new({text="原价:", size = 18}):pos(0, 7),
	    display.newSprite("Word_Delete.png"):pos(110, 7):zorder(2),
		display.newSprite("Diamond.png"):pos(70, 7):scale(0.7),
		base.Label.new({text=data.price, size = 18}):pos(90, 7),

		base.Label.new({text="现价:",   color=cc.c3b(255,255,0),size = 18}):pos(180, 7),
		display.newSprite("Diamond.png"):pos(250, 7):scale(0.7),
		base.Label.new({text=data.sale, color=cc.c3b(255,255,0),size = 18}):pos(270, 7),

		})

    --礼包奖励物品
	self:setVipGift(data,index)

end

function VipScene:setVipGift(data,index)
	--礼包奖励物品
	local posX = -255
    local addX = 0
    for i=1,#data.giftItem do
    	addX = (i-1) * 95

    	local item = UserData:createItemView(data.giftItem[i], {
            scale = 0.7,
        })
	    self.grid:addItem(item:pos(posX+addX, -55))

        local str = data.giftItemNum[i]
	    if string.len(str)>=5 then
	    	local str_ = string.sub(str, 1, string.len(str)-4)
	    	str = string.format(str_.."%s", "w")
	    end
        item = base.Label.new({text=str, size=20})
        :align(display.CENTER_RIGHT)
        self.grid:addItem(item:pos(posX+addX + 40, -85))
    end

    image_ = {
        normal ="Button_Buy.png",
	    pressed = "Button_Buy.png",
	    disabled = "Button_Gray.png",
	    }
    local buyButton = CommonButton.yellow3("购买",{size = 26,image = image_,border = 1})
    buyButton:onButtonClicked(function(event)
            CommonSound.click() -- 音效
            if UserData.diamond >= data.sale then
            	NetHandler.request("VipBuyGift",{
			    	data = {param1 = tostring(index-1) },

			    	onsuccess = function(params)
						showToast({text="领取成功"})
						UserData:showReward(params.items)
					end,
					onerror = function()
					end

				}, self)
			else
				showToast({text = "资金不够啦！"})
            end

        end)

    if tonumber(data.level) <= UserData:getVip() then
    	if self.isBuyGift[tostring(data.level)] == 1 then
    		buyButton:setButtonEnabled(false)
    	else
    		buyButton:setButtonEnabled(true)
    	end
    else
    	buyButton:setButtonEnabled(false)
    end
    self.grid:addItem(buyButton:pos(210, -55))
end

function VipScene:setGridShow(grid, data)
	grid:removeItems()
	local posY = 80
    local addY = 0
    local des = base.TalkLabel.new({
	    		text  = data.desc,
				size  = 22,
				numOffset = cc.p(0,0),
				height = 6,
	    	})
    des:pos(-235, 90-32*des:getLines()/2)
    grid:addItem(des)
    for i=1,des:getLines() do  -- 每行对应的黄点
    	addY = (i-1) * 32
    	grid:addItem(display.newSprite("Word_Vip_Point.png"):pos(-253,posY-addY-4))
    end

end

function VipScene:onEnter()
	self:updateData()
	self:updateView()
	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function VipScene:netCallback(event)
	local data = event.data
    local order = data.order
	if order == OperationCode.VipBuyGiftProcess then
		self:updateData(tonumber(data.param1))
	    self:updateListView(tonumber(data.param1)+1)
	end
end

function VipScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return VipScene
