local GetCityInfoResponse = class("GetCityInfoResponse")
function GetCityInfoResponse:GetCityInfoResponse(data)


end
function GetCityInfoResponse:ctor()
	--响应消息号
	self.order = 10044
	--返回结果,1 成功; 
	self.result =  ""
	--城建信息：类型（1，主建筑,2 攻击，3 防御）_强化等级_星星数,类型（1，主建筑,2 攻击，3 防御）_强化等级_星星数
	self.param1 =  ""	
end

return GetCityInfoResponse