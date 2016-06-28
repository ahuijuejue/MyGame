--[[
七日签到界面
]]

local SignInSevenLayer = class("SignInSevenLayer", function()
	return display.newNode()
end)

function SignInSevenLayer:ctor()
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

function SignInSevenLayer:initData()

end

function SignInSevenLayer:initView()

	-- 灰层背景
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    local layer_ = display.newNode():size(960, 640):align(display.CENTER)
    layer_:addTo(self):center()
	self.layer_ = layer_

-- 主层
---------------------------------------------------------
--------背景框
	-- 底板框
    display.newSprite("Register_Seven_Board.png"):addTo(self.layer_)
	:pos(480, 295)

	-- 标题
	-- CommonView.titleLinesFrame1()
	-- :addTo(self.layer_)
	-- :pos(480, 535)

	display.newSprite("Word_Register.png"):addTo(self.layer_)
	:pos(480, 530)

-----------------------------------------------------------------------
    -- 列表
    self.listView_ = base.ListView.new({
    	viewRect = cc.rect(0, 0, 800, 440),
    	itemSize = cc.size(800, 130),
    }):addTo(self.layer_)
    :setBounceable(false)
    :pos(77, 45)

	-- 关闭按钮
	CommonButton.close():addTo(self.layer_):pos(875, 545)
	:scale(0.8)
	:onButtonClicked(function()
		self:onEvent_{name="close", isCompleted=self.isCompleted}

		CommonSound.close() -- 音效
	end)
end


function SignInSevenLayer:onEvent(listener)
	self.eventListener = listener

	return self
end

function SignInSevenLayer:onEvent_(event)
	if not self.eventListener then return end

	event.target = self
	self.eventListener(event)
end

function SignInSevenLayer:onEnter()
	self:updateData()
	self:updateView()

	CommonView.animation_show_out(self.layer_)
end

function SignInSevenLayer:updateData()
	self.items 			= SignInData:getSevenList() 		-- 奖励
	self.isTodaySign 	= SignInData:isSevenSigned() 		-- 今天是否领取
	self.signCount 		= SignInData:getSevenCount() 		-- 领取过的次数
	self.isCompleted 	= SignInData:isSevenCompleted() 	-- 是否全部领完

	print("today sign:", self.isTodaySign)
	print("signCount:", self.signCount)
	print("isCompleted:", self.isCompleted)
end

function SignInSevenLayer:updateView()
	self:updateListView()
end

local days = {
	"Word_FirstDay.png",
	"Word_SecondDay.png",
	"Word_ThirdDay.png",
	"Word_Fouth.png",
	"Word_FifthDay.png",
	"Word_SixthDay.png",
	"Word_SeventhDay.png",
}

function SignInSevenLayer:updateListView()


	self.listView_:removeAllItems()
	:addItems(table.nums(self.items), function(event)
		local index = event.index
    	local data = self.items[index]
    	local grid = base.Grid.new()

    	grid:addItem(display.newSprite(days[index]):pos(-290, 0))

    	-- 奖励物品
    	local width = 110
    	local rewardLayer = display.newNode():pos(-220, 0)
    	grid:addItem(rewardLayer)
    	local items = data:getShowArr()
    	for i,v in ipairs(items) do
    		local itemGrid = UserData:createView(v, {border=8, scale=0.8})
    		:addTo(rewardLayer)
    		:pos((i-0.5) * width, 0)

    		-- 特效
    		local aniSpr = UserData:createAniEffect({heroId = v.heroId})
    		if aniSpr then
    			if self.signCount < index then
    				itemGrid:setBackgroundImage(aniSpr)
    			end
    		end

    		if v.count > 1 then
	    		itemGrid
	    		:addItem(base.Label.new({text=tostring(v.count), size=20}):pos(40, -35):align(display.CENTER))
	    	end
    	end

    	-- 领取按钮
    	local btnAchieve
    	local cangetFlag = false
    	if index <= self.signCount then
    		btnAchieve = display.newSprite("Got_Mark.png")
    	else
    		if self.isTodaySign then 		-- 今日已经领取
	    		if index > self.signCount then
		    		btnAchieve = display.newSprite("Below_Mark.png")
		    	end
		    else 							-- 今日没有领取
		    	if index == self.signCount + 1 then
		    		cangetFlag = true
		    		btnAchieve = CommonButton.button({
		    			normal = "Register_Button.png",
		    			pressed = "Register_Button_Selected.png",
		    		})
		    		:onButtonClicked(function()
		    			self:netToSign(data.id)

		    			CommonSound.click() -- 音效
		    		end)
		    	else
		    		btnAchieve = display.newSprite("Below_Mark.png")
		    	end
	    	end
    	end
    	if btnAchieve then
    		grid:addItem(btnAchieve:pos(310, 0))
    	end

    	if cangetFlag then
    		grid:setBackgroundImage(display.newSprite("Register_Seven_Banner_Selected.png"))
    	else
    		grid:setBackgroundImage(display.newSprite("Register_Seven_Banner.png"))
    	end

    	return grid
	end)
	:reload()
end

function SignInSevenLayer:netToSign(signId)
	print("七日签到", signId)
	NetHandler.request("GetSevenDayReward", {
		onsuccess = function(params)
			self:updateData()
			self:updateView()
			showToast({text="领取成功"})

			UserData:showReward(params.items)
		end
	}, self)

	-- showToast({text="暂未开放"})
end

function SignInSevenLayer:onExit()
	NetHandler.removeTarget(self)
end

return SignInSevenLayer


