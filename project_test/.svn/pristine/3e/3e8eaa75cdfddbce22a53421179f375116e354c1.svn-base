--[[
购买精英点数引导
]]
local GemsAlert = import(".GemsAlert")
local ElitAlert = class("ElitAlert")

function ElitAlert:ctor()
	self.id 	= 	"" 		-- 关卡id
	self.times 	= 	0 		-- 购买次数
	self.gems 	= 	0 		-- 花费宝石	
	self.elitTimes 	= 	0 	-- 获得关卡次数

	self.isRequesting = false 
	self.isShowing = false 
end

--------------------------------------



--------------------------------------

function ElitAlert:show(stageId, callback)	
	self:info(stageId, callback)
end 

function ElitAlert:info(stageId, callback)	
	if self.isShowing or self.isRequesting then return end 

	self.target_ = nil 
	if callback then 
		self.callback_ = callback 
		self.target_ = display.getRunningScene()  
	end 
	self.id = tostring(stageId)

	self.isRequesting = true 
	NetHandler.request("GetBuyBattleTimeCost", {
		data = {param1=self.id}, 
		onsuccess = function(params)
			self.isRequesting = false 
			self:check()
		end,
		onerror = function()
			self.isRequesting = false
		end
	}, self)	 
end 

function ElitAlert:check()
	if self.isShowing or self.isRequesting then return end 

	if self.gems > UserData.diamond then 
		-- 宝石不足
		GemsAlert:show()
	else
		self:enable(self.times, self.gems)
	end 
end

function ElitAlert:enable(num, gems)	
	if self.isShowing or self.isRequesting then return end 

	local str = string.format("（今日已购买%d次）", num)
	local msg = {
		base.Label.new({text="是否花费", size=22}):pos(30, 150),
		base.Label.new({text=string.format("x%d购买次数", gems), size=22}):pos(200, 150),		
		display.newSprite("Diamond.png"):pos(165, 150),		
		base.Label.new({text=str, size=22}):align(display.CENTER):pos(200, 80),		
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
					NetHandler.request("BuyBattleTimes", {
						data = {param1=self.id}, 
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
	end, {backgroundType=2}, function()
		self.isShowing = false 
	end)
	:onEvent(function(event)
		if event.name == "exit" then 
			self.isShowing = false
		end 
	end)
	
end

-- 最终购买体力
function ElitAlert:didBuy()	
	showToast({text="购买精英次数成功"})	
	if self.target_ and self.target_ == display.getRunningScene() then 
		if self.callback_ then 
			self.callback_()
		end 
	end 
end 

return ElitAlert



