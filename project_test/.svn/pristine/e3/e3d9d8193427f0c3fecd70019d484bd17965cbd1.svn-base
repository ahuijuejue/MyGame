local SelectZoneResponse = class("SelectZoneResponse")

function SelectZoneResponse:ctor()
	--响应消息号
	self.order = 10001
	--返回结果,如果成功才会返回下面的参数：1 成功，2 此战队已禁封，请联系管理员
	self.result =  ""
	--验证token值
	self.param1 =  ""	
end

function SelectZoneResponse:SelectZoneResponse(data)
	if data.result == 1 then
		UserData.token = data.param1
		UserData.ip = data.param2
        UserData.port = data.param3
        UserData.userId = data.param4
	elseif data.result == 2 then
		showToast({text="此战队已禁封，请联系管理员"})
	end
end

return SelectZoneResponse