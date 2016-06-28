local UserRegistResponse = class("UserRegistResponse")
function UserRegistResponse:UserRegistResponse(data)


end
function UserRegistResponse:ctor()
	--响应消息号
	self.order = 12001
	--返回结果,1:成功,2:用户名或密码为null,3:用户名已使用,4:超长(20)
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

return UserRegistResponse