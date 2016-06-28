local UserRegistProcess = class("UserRegistProcess")

function UserRegistProcess:ctor()
	--响应消息号
	self.order = 12001
	--用户名
	self.param1 =  ""
	--密码
	self.param2 =  ""
	--确认密码
	self.param3 =  ""
	--手机设备ID
	self.param4 =  ""
	--sdk类型 
	self.param5 =  ""	
end


function UserRegistProcess:serialization()
	local data = {
		order = self.order,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		param4 = self.param4,
		param5 = self.param5,
		
	}
	return data
end

return UserRegistProcess