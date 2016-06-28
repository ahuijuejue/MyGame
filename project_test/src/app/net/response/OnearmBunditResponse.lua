local OnearmBunditResponse = class("OnearmBunditResponse")

function OnearmBunditResponse:ctor()
	--响应消息号
	self.order = 31002
	--返回结果,1:成功,-1:钱不够
	self.result =  ""
	--活动类型,1:一次,2:5次
	self.param1 =  ""
	--老虎机奖励序号(0-12)
	self.param2 =  ""
	--物品信息
	self.a_param1 =  ""	
end

function OnearmBunditResponse:OnearmBunditResponse(data)
	if data.result == 1 then
		UserData:addDiamond(-SlotModel:getCost(data.param1))
		PlayerData.addItem(data.a_param1)
		SlotModel.itemsGet = data.a_param1
		SlotModel.pos = string.split(data.param2,",")
		if data.param1 == 1 then
			SlotModel.times = SlotModel.times + 1
		end
		UserData:addGold(SlotModel:getGold(data.param1))
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end

end

return OnearmBunditResponse