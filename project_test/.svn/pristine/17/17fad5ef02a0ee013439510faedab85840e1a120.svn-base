--[[
体力引导
]]
local GemsAlert = import(".GemsAlert")
local PowerAlert = class("PowerAlert")

function PowerAlert:ctor()
	self.times 	= 	0 		-- 购买次数
	self.gems 	= 	0 		-- 花费宝石
	self.power 	= 	0 		-- 获得体力
	self.timesMax 	= 	0 	-- 最大购买次数

	self.isRequesting = false 
	self.isShowing = false 
end

--------------------------------------

function PowerAlert:getTimesMax() 			-- 购买次数 上限
	return self.timesMax 
end 

function PowerAlert:isBuyMax() 			-- 是否已达到购买最大次数
	return self.times >= self:getTimesMax()
end


--------------------------------------

function PowerAlert:show(callback)	
	self:info(callback)
end 

function PowerAlert:info(callback)	
	if self.isShowing or self.isRequesting then return end 
	
	self.target_ = nil 
	if callback then 
		self.callback_ = callback 
		self.target_ = display.getRunningScene()  
	end 

	self.times = UserData.powerData.buyTimes 
	self.timesMax = VipData:getPowerMax()
	self.power = GlobalData.buyPower
	self.gems = CostDiamondData:getBuyPower(self.times+1)

	self:check()
end 

function PowerAlert:check()		
	if self.isShowing or self.isRequesting then return end 

	local max = self:getTimesMax()	
	if self:isBuyMax() then 
		--不可以购买，购买次数达到上限
		self:disable(self.times, max)			
	else 
		--可以购买			
		self:enable(self.times, max, self.gems, self.power)
	end  
end

function PowerAlert:disable(num, numMax)
	if self.isShowing or self.isRequesting then return end 

	local str = string.format("今日购买次数已经用完了！\n（今日已购买%d/%d次）", num, numMax)
	local msg = {
		base.Label.new({text=str}):align(display.CENTER):pos(200, 130),
		base.Label.new({text="提升VIP等级可获得更多次数", color=cc.c3b(255,255,0)}):align(display.CENTER):pos(200, 60)
	}	

	self.isShowing = true 
	AlertShow.show3("购买体力", msg, "VIP特权", function()
		if self.isShowing then 
			self.isShowing = false 
			GemsAlert:enterVip()
		end 
	end, function()
		self.isShowing = false 
	end)
	:onEvent(function(event)
		if event.name == "exit" then 
			self.isShowing = false
		end 
	end)
end

function PowerAlert:enable(num, maxNum, nGems, nPower)	
	if self.isShowing or self.isRequesting then return end 

	local str = string.format("（今日已购买%d/%d次）", num, maxNum)
	local msg = {
		base.Label.new({text="是否花费"}):pos(30, 150),
		base.Label.new({text=string.format("x%d购买", nGems)}):pos(350, 150):align(display.RIGHT_CENTER),
		base.Label.new({text=string.format("%d体力", nPower)}):pos(30, 120),
		display.newSprite("Diamond.png"):pos(180, 150),		
		base.Label.new({text=str}):align(display.CENTER):pos(200, 60),		
	}

	self.isShowing = true 
	AlertShow.show2("友情提示", msg, "确定", function()
		if self.isShowing then 
			self.isShowing = false 
			if not self.isRequesting then 
				if self.gems > UserData.diamond then 
					-- 宝石不足
					GemsAlert:show()
				else
					self.isRequesting = true
					NetHandler.request("BuyPowerStart", {
						onsuccess = function(params)
							self.isRequesting = false
							self:didBuy()
						end,
						onerror = function()
							self.isRequesting = false
						end
					}, self)
				end 
			end 
		end 	
	end, function()
		self.isShowing = false 
	end)	
	:onEvent(function(event)
		if event.name == "exit" then 
			self.isShowing = false
		end 
	end)
end

-- 最终购买体力
function PowerAlert:didBuy()	
	showToast({text="购买体力成功"})		
	if self.target_ and self.target_ == display.getRunningScene() then 
		if self.callback_ then 
			self.callback_()
		end 
	end 

	UserData:dispatchEvent({name = EVENT_CONSTANT.BUY_POWER_SUCCESS}) 		-- 分发 购买体力
end 

return PowerAlert
