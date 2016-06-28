--[[
七天打折活动
]]

local SevenDiscountLayer = class("sevenDiscountLayer",function ( )
		return display.newNode()
end)

local scheduler = require("framework.scheduler")
local sevenSignImage = "Button_Discount_Common.png" 
local sevenSelectImage = "Button_Discount_Select.png"
local sevenDisableImage = "Button_Discount_Disable.png"
local sevenDeleteImage = "Word_Delete.png"

function SevenDiscountLayer:ctor()
    self.layer_ = display.newNode():size(960, 640):pos(display.cx, display.cy):zorder(1):align(display.CENTER)
    self.layer_:addTo(self)
	CommonView.animation_show_out(self.layer_)

	self:initData()
    self:initView()

    self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function SevenDiscountLayer:initData()
	self.sectionIndex = 1
	self.closeFunc = nil
	self.arr = DiscountShopModel.data
	self.days = DiscountShopModel:getDays()
end

function SevenDiscountLayer:initView()
	CommonView.blackLayer2()
	:addTo(self)

    -- 关闭按钮
    CommonButton.close():addTo(self.layer_,1):pos(900, 495)
    :onButtonClicked(function()
        CommonSound.close()
        self.closeFunc()
    end)
	--背景板
    display.newSprite("SevenDiscountScene.png")
    :addTo(self.layer_)
    :pos(480,405)

	--添加线
	display.newSprite("Line_Discout.png")
	:addTo(self.layer_)
	:pos(480,329)
	:zorder(20)

	-- 剩余购买时间
	base.Label.new({text = "剩余购买时间:",color = CommonView.color_white(),size = 20})
	:addTo(self.layer_)
	:pos(210,85)
	:zorder(5)

	--添加时间
	self.timeLabel = base.Label.new({text = "",color=CommonView.color_green(), size=20})	
	:addTo(self.layer_)
	:pos(410, 85)
	:zorder(5)

	-- 添加主分区按钮
	self:addSectionButtons()

	--添加现价
	self.saleLabel = base.Label.new({text = self.arr[self.days].sale,color=CommonView.color_white(), size=34,border = false,shadow = 1})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(342, 155)
	:zorder(5)

	--原价
	self.priceLabel = base.Label.new({text = self.arr[self.days].price,color=CommonView.color_white(), size=34,border = false,shadow = 1})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(722, 155)
	:zorder(5)
	display.newSprite("Word_Delete.png"):pos(692, 155):addTo(self.layer_):zorder(5)

	--添加商品layer1
	self.layer1 = display.newLayer()
	:addTo(self.layer_)
	:pos(480,220)
end


--显示商品列表
function SevenDiscountLayer:createItem(itemId, count)
	local grid = UserData:createItemView(itemId, {scale=0.7})

	local label = base.Label.new({
		text = tostring(count),
		size = 18,
		color = CommonView.color_white(),
	})
	:align(display.BOTTOM_RIGHT)
	:pos(50, -50)

	grid:addItem(label)

	return grid
end

--更新时间
function SevenDiscountLayer:updateTimeShow()
	self.leftTime = self.leftTime - 1
	if self.leftTime <= 0 then
		self.closeFunc()
	end
	local date = convertSecToDate(self.leftTime)
	local labelstr = ""
	self.day = date.day
	if date.day > 0 then 
		labelstr = labelstr..tostring(date.day).."天"
	end 
	labelstr = labelstr..string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
	self.timeLabel:setString(labelstr)
end 

-- 主分区按钮
function SevenDiscountLayer:addSectionButtons()	
	-- 侧边 按钮	列表
	local addLeft = 15
	self.listView2_ = base.GridViewOne.new({
		viewRect = cc.rect(0, 0, 819, 60),
		itemSize = cc.size(117, 60),
		-- page = true,
		direction = "horizontal"
	})
	:addTo(self.layer_)
	:zorder(5)
	:pos(68, 335)  ----七日按钮++
	:setBounceable(false)
	:onTouch(function(event)
		if event.name == "selected" then
			CommonSound.click()	 			
			local index = event.index
			if index <= self.days then
				self:selectedIndex(index)	
				self:showItemsView(index)
			else
				showToast({text="第"..index.."天开放"})	
			end	
		end 

	end)	
end

function SevenDiscountLayer:showItemsView(index)
	self.layer1:removeAllChildren()
	local itemDes = self.arr[index]
	local posX = 0-(#(itemDes.GiftItemID) - 1)*50
	local addX = 100
	for j=1,#(itemDes.GiftItemID) do
    	self:createItem(itemDes.GiftItemID[j], tonumber(itemDes.GiftItemNum[j]))
    	:addTo(self.layer1)
    	:pos(posX+(j-1)*addX,30)
    	:zorder(10)
    end


	self.buyBtn = CommonButton.yellow("购买")
	:onButtonClicked(function ()
		if UserData.diamond < self.arr[index].sale then
			showToast({text="钻石不足"})
		else
			NetHandler.gameRequest("BuyShopGoods",{param1  = tostring(index), param2 = 0, param3  = 8})
		end
	end)
	self.buyBtn:setPosition(0,-175)
	self.layer1:addChild(self.buyBtn)

	self:updateBuyBtn(index)
end

function SevenDiscountLayer:updateBuyBtn(index)
	local isBuy = self.arr[index].isBuy
	self.buyBtn:setButtonEnabled(not isBuy)
	if isBuy then
		self.buyBtn:setButtonLabelString("已购买")
	end
end

function SevenDiscountLayer:updateListView( )
	-- 重置侧栏按钮
	self.listView2_
	:resetData()
	:addSection({
		count = 7,
		getItem = function(event)
			local index = event.index
			local enable = false
			if index <= self.days then
				enable = true
			end
			local btn = base.Grid.new()
			:setNormalImage(display.newSprite(sevenSignImage):pos(0, 0))
			:setSelectedImage(display.newSprite(sevenSelectImage):pos(0, 1), 2)
			:addItem(base.Label.new({text="第"..index.."天", size=24, color=CommonView.color_white()}):align(display.CENTER))
			:setDisabledImage(sevenDisableImage)
			:setEnabled(enable)
			return btn
		end	
	})
	:reload()
end

function SevenDiscountLayer:selectedIndex(index)
		local grid = self.listView2_:getItemAtIndex(self.sectionIndex)
		if grid then 
			grid:setSelected(false)			
		end 
		
		grid = self.listView2_:getItemAtIndex(index)
		grid:setSelected(true)
		self:selectedSection(index)
end

-- 点击了第index个主分区
function SevenDiscountLayer:selectedSection(index)
	self.sectionIndex = index  --切换select和normol的关键
	self.saleLabel:setString(self.arr[index].sale)
	self.priceLabel:setString(self.arr[index].price)
end 

function SevenDiscountLayer:startTimer()
    if self.timeHandle then
        return
    end
    self.timeHandle = scheduler.scheduleGlobal(handler(self,self.updateTimeShow),1)
end

function SevenDiscountLayer:stopTimer()
    if self.timeHandle then
        scheduler.unscheduleGlobal(self.timeHandle)
        self.timeHandle = nil
    end
end


function SevenDiscountLayer:onEnter()
	self.leftTime = DiscountShopModel.closeTime - UserData:getServerSecond()
	self:updateTimeShow()
	self:updateListView()
	self:selectedIndex(self.days)	
	self:showItemsView(self.days)
	self:startTimer()
end 

function SevenDiscountLayer:onExit()
	self:stopTimer()
end

return SevenDiscountLayer
