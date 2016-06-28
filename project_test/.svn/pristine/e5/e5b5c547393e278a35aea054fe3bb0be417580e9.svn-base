local UpTailsStarResponse = class("UpTailsStarResponse")
function UpTailsStarResponse:UpTailsStarResponse(data)
	if data.result == 1 then 
		local param1 = tostring(data.param1) 	-- 尾兽id 
		local tails = TailsData:getTails(param1) 

		-- 减少尾兽币数量 
		ItemData:reduceMultipleItem(tails.chipsId, tails:getChipsMax())
		-- 增加尾兽星级
		tails.star = tails.star + 1

		return {id=param1}
		
	elseif data.result == -1 then 	-- 数量错误
		showToast({text="数量错误"})
	elseif data.result == -2 then 	-- 数量不足 
		showToast({text="数量不足"}) 
	elseif data.result == -3 then 	-- 已达最大等级
		showToast({text="已达最大等级"}) 
	end 
end
function UpTailsStarResponse:ctor()
	--响应消息号
	self.order = 10051
	--返回结果,1 成功;-1 数量错误; -2 数量不足
	self.result =  ""
	--尾兽id
	self.param1 =  ""	
end

return UpTailsStarResponse