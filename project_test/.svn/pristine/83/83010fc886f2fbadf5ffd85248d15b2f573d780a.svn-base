local OpenAincradResponse = class("OpenAincradResponse")
function OpenAincradResponse:OpenAincradResponse(data)
	if data.result == 1 then 
		AincradData.floor = checknumber(data.param2) 	-- 当前层级 
		if AincradData.floor == 0 then 
			AincradData:setFloor(1)
		end 

		-- buff 
		AincradBuffData:resetBuffProcess() 
		local buffId = string.split(data.param3 or "", ",")
		local buffValue = string.split(data.param4 or "", ",")
		for i,v in ipairs(buffId) do
			local buff = AincradBuffData:getBuff(v)
			if buff then 
				buff:addProcess(checknumber(buffValue[i]))
			end 
		end

		-- 刷新次数 
		AincradData.useRestarTimes = checknumber(data.param5)

		-- 挑战结果 
		AincradData.isBattleOk = checknumber(data.param1) == 1 
		
		-- 是否领取过奖励  
		AincradData.isGetReward = checknumber(data.param6) == 1 

		-- "拥有的星星数量"
		AincradData:setCurrentStar(checknumber(data.param7))

		-- 当前积分
		AincradData:setCurrentScore(checknumber(data.param8))

		-- 最高积分
		AincradData.maxScore = checknumber(data.param9)

	elseif data.result == -1 then 
		showToast({text="等级不足"})
	end 

end
function OpenAincradResponse:ctor()
	--响应消息号
	self.order = 20017
	--返回结果,1 成功;
	self.result =  ""
	--是否挑战成功:1 成功，0 失败
	self.param1 =  ""
	--当前达到的层级
	self.param2 =  ""
	--当前拥有的buff,多个以逗号分开
	self.param3 =  ""
	--当前拥有的buff的效果，对应上面的buff
	self.param4 =  ""
	--已重置的次数
	self.param5 =  ""	
end

return OpenAincradResponse