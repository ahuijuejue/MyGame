local GetAincradRewardResponse = class("GetAincradRewardResponse")
function GetAincradRewardResponse:GetAincradRewardResponse(data)
	if data.result == 1 then 
		if math.mod(AincradData.floor, 2) == 1 then 	-- 奇数关卡 
			-- 选buff
			AincradData:resetWillBuff()
			for i,v in ipairs(data.a_param1) do		
				local buffId 	= v.param1 	-- buff id
				if buffId then 	
					buffId = tostring(buffId) 
					local bufdata = AincradData:addWillBuff(buffId, checknumber(v.param3))
					bufdata:setCostStar(checknumber(v.param5)) -- 消耗星星数
					bufdata:setBuffUID(v.param2)
				end 
			end
			
		else 	-- 偶数关卡 
			-- 领奖 
			UserData:rewardItems(data.a_param1)
			AincradData:setWillReward(UserData:parseItems(data.a_param1))
			AincradData.isGetReward = true 
		end 

	elseif data.result == -1 then 
		showToast({text="物品错误"})
	end 

end
function GetAincradRewardResponse:ctor()
	--响应消息号
	self.order = 20015
	--返回结果,1 成功;-1 物品错误
	self.result =  ""
	--抽到的物品id
	self.a_param1 =  ""	
end

return GetAincradRewardResponse