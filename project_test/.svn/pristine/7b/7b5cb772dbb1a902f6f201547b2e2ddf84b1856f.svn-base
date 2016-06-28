local OpenBeiBaoResponse = class("OpenBeiBaoResponse")
function OpenBeiBaoResponse:OpenBeiBaoResponse(data)
	if data.result == 1 then 		
		-- 获取背包列表 成功		
		return PlayerData.updateBagData(data)
	end

end
function OpenBeiBaoResponse:ctor()
	--响应消息号
	self.order = 10014
	--返回结果,如果成功才会返回下面的参数：1 成功,
	self.result =  ""
	--背包中的物品
	self.beibao =  ""	
end

return OpenBeiBaoResponse