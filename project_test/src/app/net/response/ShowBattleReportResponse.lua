local ShowBattleReportResponse = class("ShowBattleReportResponse")
function ShowBattleReportResponse:ShowBattleReportResponse(data)
	if data.result == 1 then 
		ArenaReport:reset() 
		for i,v in ipairs(data.a_param1) do 	-- 竞技场战报
			local arr = string.split(v, ",") 
			local report = ArenaReport:createReport({
				type 	= checknumber(arr[1]) + 1, 	-- 战报类型 
				name 	= arr[2], 					-- 对手名字
				win 	= arr[3] == "1", 			-- 战斗结果 
				time 	= arr[4], 					-- 挑战时间 
				offset 	= arr[5], 					-- 变化的名次 
				icon 	= arr[6], 					-- 头像 
				level 	= arr[7], 					-- 等级 
			}) 
			ArenaReport:add(report)
		end 
	end 

end
function ShowBattleReportResponse:ctor()
	--响应消息号
	self.order = 10056
	--返回结果,1 成功;-1 积分不足
	self.result =  ""
	--战报信息，格式：战报类型（0，我挑战别人，1 别人挑战我）,对手的名字,我的结果(0 我输了，1 我赢了),挑战时间（秒数）,变化的名次（正升，负降，0 没有变化）,头像
	self.a_param1 =  ""	
end

return ShowBattleReportResponse