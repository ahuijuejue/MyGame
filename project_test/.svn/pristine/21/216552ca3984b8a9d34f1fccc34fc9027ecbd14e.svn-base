local ResetAincradResponse = class("ResetAincradResponse")
function ResetAincradResponse:ResetAincradResponse(data)
	if data.result == 1 then 
		AincradData:restartData()

		-- 活动数据			
		ActivityUtil.addParams("aincradBattle", 1)
		

	elseif data.result == -1 then 
		showToast({text="已达最大次数"})
	end 
end
function ResetAincradResponse:ctor()
	--响应消息号
	self.order = 20014
	--返回结果,1 成功;-1 已达最大次数
	self.result =  ""	
end

return ResetAincradResponse