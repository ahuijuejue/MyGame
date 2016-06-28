local SignInDailyLayer = class("SignInDailyLayer",function ()
	return display.newNode()
end)
local GafNode = import("app.ui.GafNode")

function SignInDailyLayer:ctor()
	self:createView()
end

function SignInDailyLayer:createView()
	-- 底板
	CommonView.mFrame6()
	:addTo(self)
	:pos(518, 275)

	-- 标题
	display.newSprite("Register_Title2.png")
	:addTo(self)
	:pos(520, 508)

	-- 签到状态
	self.labelAchieve = base.Label.new({size=24, color=cc.c3b(255,250,200)})
	:addTo(self)
	:align(display.CENTER)
	:pos(520, 45)

	-- 列表 每日
	self.listView_ = base.GridViewOne.new({
		ver = 5,
		viewRect = cc.rect(-20, 0, 680, 390),
		itemSize = cc.size(128, 128),
	}):addTo(self)
	:pos(200, 70)
	:onTouch(function(event)
		if event.name == "selected" then
			self:selectedIndex(event.index)
		end
	end)
end

-- 可以签到的动画
function SignInDailyLayer:getSignAni()

	local param = {gaf = "quan_gaf"}
    local effectNode = GafNode.new(param)
    effectNode:playAction("1",true)
    effectNode:setGafPosition(0,-85)
    effectNode:setTouchEnabled(false)
    return effectNode
end

function SignInDailyLayer:updateListView()
	self.listView_
	:resetData()
	:addSection({
		count = table.nums(self.items),
		getItem = handler(self, self.createItemGrid),
	})
	:reload()

end

function SignInDailyLayer:updateData()
	-- 日期
	local date = SignInData:getServerDate()
	self.month = date.month  								-- 月份
	self.signCount = SignInData:getMonthSignCount() 		-- 当月签到次数
	self.isTodaySign = SignInData:isSigned() 				-- 今天是否签到
	self.isVipSign = SignInData.signVip 					-- 今天是否签到vip

	print("签到次数：", self.signCount)
	print("今天进行了签到：", self.isTodaySign)
	print("今天是否签到vip:", self.isVipSign)

-------------------------------------
-- 签到数据
	-- 每日签到
	self.items = SignInData:getDailyList()
	if self.isTodaySign then
		self.todayItem = self.items[self.signCount]
	else
		self.todayItem = self.items[self.signCount + 1]
	end

	-- 累计签到
	self.totalSignIn = SignInData.totalSignIn -- 累计签到次数

end

function SignInDailyLayer:updateView()
	self:updateListView()
	self:updateAchieve()
end

function SignInDailyLayer:createItemGrid(event)
	local index = event.index
	local data = self.items[index]
	local info = SignInData:getShowInfo(data)
	local aniSpr = UserData:createAniEffect({heroId = info.heroId})

	local grid = base.Grid.new()
	grid:addItem(display.newSprite("Register_item_back.png"))

	-- 特效
	if aniSpr then
		if self.totalSignIn < index then
			grid:addItem(aniSpr)
		end
	end

	-- icon
	local icon = nil
	if info.heroId then
		icon = UserData:createHeroView(info.heroId, {border=8})
		grid:addItem(icon)
	else
		icon = UserData:createItemView(info.itemId)
		grid:addItem(icon)
		grid:addItem(base.Label.new({text=string.format("X%d", info.count), size=22}):pos(58, -65):align(display.RIGHT_BOTTOM))
	end

	-- 位置
	grid:addItem(base.Label.new({
		text = string.format("%d", index),
		size = 22,
		x = 58,
		y = 62,
		color = cc.c3b(35, 24, 20),
		border = false,
	}):align(display.RIGHT_TOP))

	if info.vip > 0 then
		grid:addItem(display.newSprite("Register_Vip.png"):pos(-13, 31))
		grid:addItem(display.newSprite(string.format("V%d.png", info.vip)):pos(-50, 25))
	end

	local function setIsAlreadySelected()
		icon:getItem("border"):setColor(cc.c3b(100,100,100))
		icon:getItem("icon"):setColor(cc.c3b(100,100,100))

		grid:addItem(display.newSprite("Register_flag_sign1.png"))
	end

	local signInTouch = false
	if self.isTodaySign then  			-- 今天进行了签到
		if index < self.signCount then 		-- 已经签到过的
			setIsAlreadySelected()
		elseif index == self.signCount then
			if self.isVipSign or not data:haveVip() then 	-- 今天进行了vip签到 或者 没有vip奖励
				setIsAlreadySelected()
			else 				 			-- 今天未进行vip签到
				grid:addItem(display.newSprite("Register_flag_sign2.png"))
				signInTouch = true
			end
		end
	else 						-- 今天没有签到
		if index <= self.signCount then 			-- 已经签到过的
			setIsAlreadySelected()
		elseif index == self.signCount + 1 then 	-- 需要签到
			signInTouch = true
			local sSpr = self:getSignAni()
			grid:addItem(sSpr)
		end
	end

	if signInTouch then
		local itemSize = event.target.itemSize
		grid:onClicked(function()
			self:netToSignIn(data.id)

			CommonSound.click() -- 音效
		end, cc.size(itemSize.width, itemSize.height))
	end

	return grid
end

--------------------------------------------
-- 向服务器申请 领取每日签到
function SignInDailyLayer:netToSignIn(signId)
	print("签到id:", signId)
	NetHandler.request("EveryDaySign", {
		data = {
			param1 = signId,
			param2 = 1,
		},
		onsuccess = function(params)
			self:updateData()
			self:updateView()
			showToast({text="领取成功"})
			UserData:showReward(params.items)
		end
	}, self)
end

-- 更新显示 今日签到情况
function SignInDailyLayer:updateAchieve()
	local str = ""
	if self.isTodaySign then  	-- 今天进行了签到
		if self.isVipSign or not self.todayItem:haveVip() then 	-- 今天进行了vip签到 或者 没有vip奖励
			str = string.format("今日已领取")
		else 				 	-- 今天未进行vip签到
			str = string.format("vip未领取")
		end
	else 						-- 今天没有签到
		str = string.format("今日未领取")
	end

	self.labelAchieve:setString(str)
end

-- 选择第几个
function SignInDailyLayer:selectedIndex(index)
	-- 没用
end

return SignInDailyLayer