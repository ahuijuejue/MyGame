local SignInVipLayer = class("SignInVipLayer",function ()
	return display.newNode()
end)

function SignInVipLayer:ctor()
	self:createView()
end

function SignInVipLayer:createView()
    -- 底板
	CommonView.mFrame6()
	:addTo(self)
	:pos(518, 275)

	-- 标题
	display.newSprite("Register_Title_Vip.png")
	:addTo(self)
	:pos(520, 508)

	createOutlineLabel({text = "每日充值任意金额，获得超值奖励！",size = 20,color = cc.c3b(21, 231, 5)})
	:addTo(self)
	:pos(520, 453)

	-- 签到状态
	self.labelAchieve = base.Label.new({size=24, color=cc.c3b(255,250,200)})
	:addTo(self)
	:align(display.CENTER)
	:pos(520, 45)

    -- 列表
    self.listView_ = base.ListView.new({
    	viewRect = cc.rect(0, 0, 645, 370),
    	itemSize = cc.size(645, 120),
    }):addTo(self)
    :pos(195, 65)

end

function SignInVipLayer:updateData()
	self.items 	= SignInData:getVipList() 		-- 奖励
	self.isTodaySign 	= SignInData.vipIsReward		-- 今天是否领取
	self.signCount 		= SignInData:getVipCount() 		-- 领取过的次数
	self.indexItem      = 1
	if self.signCount>=1 then
		self.indexItem = self.signCount
	end
end

function SignInVipLayer:updateView()
	self:updateListView()
	self:updateAchieve()
end

function SignInVipLayer:updateListView()

	self.listView_:removeAllItems()
	:addItems(table.nums(self.items), function(event)
		local index = event.index
    	local data = self.items[index]
    	local grid = base.Grid.new()

	    grid:addItem(display.newSprite("day_bg.png"):pos(-235, 15))

    	local dayLabel = cc.Label:createWithCharMap("register_number.png",35,50,48)
    	dayLabel:setString(tostring(index))

    	grid:addItem(dayLabel:pos(-240, -10))

    	-- 奖励物品
    	local width = 110
    	local rewardLayer = display.newNode():pos(-220, 0)
    	grid:addItem(rewardLayer)
    	local items = data:getShowArr()
    	for i,v in ipairs(items) do
    		local itemGrid = UserData:createView(v, {border=8, scale=0.8})
    		:addTo(rewardLayer)
    		:pos((i-0.5) * width+55, 0)

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
    		if self.isTodaySign == 2 then 		-- 今日已经领取
	    		if index > self.signCount then
		    		btnAchieve = display.newSprite("Below_Mark.png")
		    	end
		    else 							-- 今日没有领取
		    	if index == self.signCount + 1 then
		    		cangetFlag = true
		    		if self.isTodaySign == 0 then
			    		btnAchieve = CommonButton.button({
			    			normal = "Register_Button2.png",
			    			pressed = "Register_Button_Selected2.png",
			    		})
		    		elseif self.isTodaySign == 1 then
		    			btnAchieve = CommonButton.button({
			    			normal = "Register_Button.png",
			    			pressed = "Register_Button_Selected.png",
			    		})
		    		end
		    		btnAchieve:onButtonClicked(function()
		    			self:netToSign(data.id)

		    			CommonSound.click() -- 音效
		    		end)
		    	else
		    		btnAchieve = display.newSprite("Below_Mark.png")
		    	end
	    	end
    	end
    	if btnAchieve then
    		grid:addItem(btnAchieve:pos(250, 0))
    	end

    	if cangetFlag then
    		grid:setBackgroundImage(display.newSprite("Register_Vip_Banner.png"):pos(0,0))
    	else
    		grid:setBackgroundImage(display.newSprite("Register_Vip_Banner.png"):pos(0,0))
    	end

    	return grid
	end)
	:reload()
	:setScrollPosition(370+120*(self.indexItem-1),370)
end

function SignInVipLayer:netToSign(signId)
	print("至尊签到", signId)
	if self.isTodaySign == 0 then
		app:pushScene("RechargeScene")
	elseif self.isTodaySign == 1 then
		NetHandler.request("EveryDaySign", {
			data = {
				param1 = signId,
				param2 = 2,
			},
			onsuccess = function(params)
				self:updateData()
				self:updateView()
				showToast({text="领取成功"})

				UserData:showReward(params.items)
			end
		}, self)
	end
end

-- 更新显示 今日签到情况
function SignInVipLayer:updateAchieve()
	local str = ""
	if self.isTodaySign == 2 then  	-- 今天进行了签到
		str = string.format("今日已领取")
	else
		str = string.format("今日未领取")
	end
	self.labelAchieve:setString(str)
end

return SignInVipLayer
