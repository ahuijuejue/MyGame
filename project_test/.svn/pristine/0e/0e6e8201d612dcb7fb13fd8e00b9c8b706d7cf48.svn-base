local OpenAincradBoxResponse = class("OpenAincradBoxResponse")
function OpenAincradBoxResponse:OpenAincradBoxResponse(data)
	if data.result == 1 then 
		local s_items = data.a_param1 or {} 
		local diamond = checknumber(data.param1) 
		UserData:addDiamond(-diamond)

		UserData:rewardItems(s_items) 
		AincradData:addAwardTimes()

		-- 活动数据			
		ActivityUtil.addParams("openMaoTimes", 1)

		local items = UserData:parseItems(s_items) 
		return items 

	elseif data.result == -1 then -- 钻石不足
		ResponseEvent.lackGems()
	end 

end
function OpenAincradBoxResponse:ctor()
	--响应消息号
	self.order = 20013
	--返回结果,1 成功;-1 钻石不足
	self.result =  ""
	--抽到的物品id
	self.a_param1 =  ""	
end

return OpenAincradBoxResponse