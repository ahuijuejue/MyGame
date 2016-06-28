local UpdateTeamNameResponse = class("UpdateTeamNameResponse")
function UpdateTeamNameResponse:UpdateTeamNameResponse(data)
	if data.result == 1 then 
		local takeType = checknumber(data.param1)  -- 类型： 1 起名，2 更新名字 
		local name = data.param2 	-- 名字 
		local guideKey = data.param100 	-- 新手引导字段

		if takeType == 2 then 
			UserData:addDiamond(-100)
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		end 
		UserData:setName(name)
		GuideData:setCompleted_(guideKey) 

	elseif data.result == -1 then 	-- 名字已存在，不能重复
		showToast({text="名字已存在"})
	elseif data.result == -2 then 	-- 钻石不足
		ResponseEvent.lackGems()
	elseif data.result == -11 then 
		showToast({text="名字带有非法字符"})
	elseif data.result == -12 then 
		showToast({text="名字太长"})
	end 
end
function UpdateTeamNameResponse:ctor()
	--响应消息号
	self.order = 10065
	--返回结果,1 成功;-1 名字已存在，不能重复；-2 钻石不足
	self.result =  ""
	--类型： 1 起名，2 更新名字
	self.param1 =  ""
	--名字
	self.param2 =  ""
	--新手引导字段
	self.param100 =  ""	
end

return UpdateTeamNameResponse