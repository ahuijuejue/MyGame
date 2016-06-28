local ModifyUserInfoProcess = class("ModifyUserInfoProcess")

function ModifyUserInfoProcess:ctor()
	--响应消息号
	self.order = 12002
	--用户名
	self.param1 =  ""
	--当前密码
	self.param2 =  ""
	--新密码
	self.param3 =  ""
	--sdk类型 
	self.param4 =  ""	
end


function ModifyUserInfoProcess:serialization()
	local data = {
		order = self.order,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		param4 = self.param4,
		
	}
	return data
end

return ModifyUserInfoProcess