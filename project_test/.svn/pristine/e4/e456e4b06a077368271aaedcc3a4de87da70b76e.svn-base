local LoginResponse = class("LoginResponse")
function LoginResponse:LoginResponse(data)
	if data.result == 1 then
		PlayerData.updateAccountData(data)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == 2 then
		showToast({text="用户名或密码错误"})
	elseif data.result == 3 then
		showAlert("","账号被封停，请联系客服",{sure = function (alert)
			os.exit()
		end})
	end
end
function LoginResponse:ctor()
	--响应消息号
	self.order = 10001
	--返回结果,如果成功才会返回下面的参数：1 成功，2 用户名或密码错误,3 读取超时, -1 服务器维护中，-2 开服时间未到
	self.result =  ""
	--用户id
	self.param1 =  ""
	--上次登陆ip
	self.param2 =  ""
	--上次登陆时间
	self.param3 =  ""
	--上次选择的大区号
	self.param4 =  ""
	--上次登陆的区名
	self.param5 =  ""
	--上次登陆的区的ip
	self.param6 =  ""
	--上次登陆的区的端口
	self.param7 =  ""
	--token
	self.param8 =  ""
	--sdk的用户名,即username
	self.param9 =  ""
	--sdk的唯一id，即guid,uuid
	self.param10 =  ""
	--系统公告
	self.param11 =  ""
	--上次登陆的服务器状态；0 正常，-1 服务器维护中,-2 定时开服，开服时间见param13
	self.param12 =  ""
	--开服时间戳,单位秒,如果服务器状态正常，则这个字段为0
	self.param13 =  ""
end

return LoginResponse