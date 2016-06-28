--[[
金币引导
]]
local GemsAlert = import(".GemsAlert")
local GoldAlert = class("GoldAlert")

function GoldAlert:ctor()
	self.times 	=	0 	-- 购买次数
	self.gems 	= 	0 	-- 花费宝石
	self.gold 	= 	0 	-- 获得金币
	self.timesMax 	= 	0 	-- 最大购买次数

	self.alert = nil 
	self.isRequesting = false 
	self.isShowing = false 
	self.callbacks = {}
end

function GoldAlert:addCallback(callback, flag)
	table.insert(self.callbacks, {
		callback = flag,
		flag = flag,
	})
end 

function GoldAlert:removeCallback(flag)
	local index = 0 
	for i,v in ipairs(self.callbacks) do
		if v.flag == flag then 
			index = i 
			break 
		end 
	end
	if index > 0 then 
		table.remove(self.callbacks, index)
	end 
end 

----------------------------------------------------
function GoldAlert:getTimesMax() 		-- 购买次数 上限
	return self.timesMax
end 

function GoldAlert:isBuyMax() 			-- 是否已达到购买最大次数
	return self.times >= self:getTimesMax() 
end
--------------------------------------------------

function GoldAlert:show()		
	if self.isShowing or self.isRequesting then return end 
	self.isShowing = true 
	AlertShow.show2("提示", "金币不足是否进行点金", "确定", function(event)
		self.isShowing = false 
		self:info()
	end, function()
		self.isShowing = false 
	end)
end

function GoldAlert:info()	
	if self.isShowing or self.isRequesting then return end 

	self.isRequesting = true
	NetHandler.request("DianJinRequest", {
		onsuccess = function(params)	
			self.isRequesting = false	
			self:check()
		end,
		onerror = function()
			self.isRequesting = false
		end
	}, self)
end
-- 检测金币购买次数
function GoldAlert:check()	
	if self.isShowing or self.isRequesting then return end 
			
	local max  = self:getTimesMax()
	if self:isBuyMax() then 
		-- 达上限
		self:disable(self.times, max)			
	else 
		-- 可以买
		self:enable(self.times, max, self.gems, self.gold)
	end 	
end 

function GoldAlert:disable(num, numMax)
	if self.isShowing or self.isRequesting then return end 

	local str = string.format("今日点金次数已经用完了！\n（今日已购买%d/%d次）", num, num)
	local msg = {
		base.Label.new({text=str}):align(display.CENTER):pos(200, 130),
		base.Label.new({text="提升VIP等级可获得更多次数", color=cc.c3b(255,255,0)}):align(display.CENTER):pos(200, 60)
	}	
	
	self.isShowing = true 
	AlertShow.show3("点金", msg, "VIP特权", function()
		self.isShowing = false 
		GemsAlert:enterVip()		
	end, {backgroundType=2}, function()
		self.isShowing = false 
	end)
end

function GoldAlert:enable(num, maxNum, nGems, nGold)
	if self.isShowing or self.isRequesting then return end 

	local str = string.format("（今日已购买%d/%d次）", num, maxNum)
	local msg = {
		display.newSprite("Diamond.png"):pos(30, 150),
		display.newSprite("PointRight.png"):pos(170, 150),
		display.newSprite("Gold.png"):pos(270, 150),		
		base.Label.new({text=tostring(nGems)}):align(display.CENTER):pos(90, 150),
		base.Label.new({text=tostring(nGold)}):pos(300, 150),
		base.Label.new({text=str}):align(display.CENTER):pos(200, 100),
		base.Label.new({text="VIP等级越高暴击倍率越高", color=cc.c3b(255,255,0)})
			:align(display.CENTER):pos(200, 60),
	}
	
	self.isShowing = true 
	AlertShow.show2("点金", msg, "确定", function(event)				
		if not self.isRequesting then 
			if self.gems > UserData.diamond then 
				if self.isShowing then 					
					event.target:removeSelf()
					self.isShowing = false 					
				end 
				GemsAlert:show()
			else 
				self.isRequesting = true 
				NetHandler.request("DianJinStart", {
					onsuccess = function(crit, gold) 
						self.isRequesting = false 
						if self.isShowing then 					
							event.target:removeSelf()
							self.isShowing = false 
							self:didBuy(crit, gold)
						end 
					end,
					onerror = function()
						self.isRequesting = false 
					end
				}, self)
			end
		end 
					
	end, {opening=true, backgroundType=2}, function()
		self.isShowing = false
	end)
	:onEvent(function(event)
		if event.name == "exit" then 
			self.isShowing = false 
		end 
	end)
	
end

function GoldAlert:didBuy(crit, nGold)	
	self:check()

	local text = string.format("点金获得%d", crit * nGold)
	if crit > 1 then 
		text = string.format("暴击x%d ", crit) .. text
	end 

	AlertShow.showBar(text)	

	for i,v in ipairs(self.callbacks) do
		v.callback()
	end

	UserData:dispatchEvent({name = EVENT_CONSTANT.BUY_GOLD_SUCCESS}) 		-- 分发 点金变动
	
end 

return GoldAlert

