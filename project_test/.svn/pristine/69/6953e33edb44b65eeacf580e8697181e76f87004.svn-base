local SelectAincradBuffResponse = class("SelectAincradBuffResponse")

function SelectAincradBuffResponse:SelectAincradBuffResponse(data)
	if data.result == 1 then 
		local buffId = data.param1 or ""
		local values = string.split(data.param3,",")

		for i,v in ipairs(string.split(buffId, ",")) do
			local buff = AincradBuffData:getBuff(v)
			buff:addProcess(checknumber(values[i])) 
		end
		AincradData:setCurrentStar(checknumber(data.param4))
		AincradData.isGetReward = true 
	elseif data.result == -1 then 
		showToast({text="星星不够"})
	end 
end

function SelectAincradBuffResponse:ctor()
	--响应消息号
	self.order = 20016
	--返回结果,1 成功;-1 buff不存在
	self.result =  ""	
end

return SelectAincradBuffResponse