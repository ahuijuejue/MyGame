local GetServerListProcess = class("GetServerListProcess")

function GetServerListProcess:ctor()
	--请求消息号
	self.order = 10013	
	self.param1 = 0
	self.param2 = ""
end


function GetServerListProcess:serialization()
	local data = {
		order = self.order,
		param1 = self.param1,
		param2 = self.param2
	}
	return data
end

return GetServerListProcess