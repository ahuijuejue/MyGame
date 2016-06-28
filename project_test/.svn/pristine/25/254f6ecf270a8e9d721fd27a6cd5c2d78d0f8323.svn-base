local LoginProcess = class("LoginProcess")

function LoginProcess:ctor()
	--请求消息号
	self.order = 10001
	--用户名,sdk登陆时，是sdk的token,如果是小米的sdk，session
	self.param1 =  ""
	--密码,如果是小米的sdk,此处是uid
	self.param2 =  ""
	--sdk的类型，用于区分不同的平台；1 快用
	self.param3 =  ""
	--手机设备ID
	self.param4 =  ""
	--广告平台类型： 
	self.param5 =  ""
	--小米sdk玩家的用户名
	self.param6 =  ""
	self.param8 =  ""	
end


function LoginProcess:serialization()
	local data = {
		order = self.order,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		param4 = self.param4,
		param5 = self.param5,
		param6 = self.param6,
		param8 = self.param8,
	}
	return data
end

return LoginProcess