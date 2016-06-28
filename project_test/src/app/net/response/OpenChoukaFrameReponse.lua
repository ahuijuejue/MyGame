local OpenChoukaFrameReponse = class("OpenChoukaFrameReponse")
function OpenChoukaFrameReponse:OpenChoukaFrameReponse(data)
	if data.result == 1 then
		SummonData.mainHeroId = data.param6
		SummonData.otherHeroId = data.a_param1
		PlayerData.updateSummonData(data)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end
function OpenChoukaFrameReponse:ctor()
	--响应消息号
	self.order = 10037
	--返回结果,1 成功;
	self.result =  ""
	--金币已使用的免费次数
	self.param1 =  ""
	--如果有cd的话，金币抽卡的cd剩余时间，没有cd为0
	self.param2 =  ""
	--钻石免费的cd时间，没有的话cd为0
	self.param3 =  ""
	--金币抽奖总次数
	self.param4 =  ""
	--钻石抽奖总次数
	self.param5 =  ""
	--主要热点英雄的ID
	self.param6 =  ""
	--次要热点英雄列表
	self.a_param1 =  ""
end

return OpenChoukaFrameReponse