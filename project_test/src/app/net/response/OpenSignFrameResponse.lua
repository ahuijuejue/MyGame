local OpenSignFrameResponse = class("OpenSignFrameResponse")
function OpenSignFrameResponse:OpenSignFrameResponse(data)
	if data.result == 1 then 
		local info = data.param1 	-- 签到信息 

		SignInData.totalSignIn 		= checknumber(info.signTotal) 	-- 总的签到次数 
		SignInData.latestId 		= tostring(info.signId) 		-- 最近的签到id 
		SignInData.latestDate 		= checknumber(info.lastSignDay) -- 最后一次签到的时间 
		SignInData.signVip 			= checknumber(info.vipSign) == 1 -- 是否进行了vip签到  
		SignInData.latestReward 	= tostring(info.lastreward) 	-- 最后一次领取的累积奖励id 

	end 
end
function OpenSignFrameResponse:ctor()
	--响应消息号
	self.order = 10043
	--返回结果,1 成功;
	self.result =  ""
	--null
	self.param1 =  ""
	--今天的日期
	self.param2 =  ""	
end

return OpenSignFrameResponse