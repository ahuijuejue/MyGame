local OpenRiYueZhuiResponse = class("OpenRiYueZhuiResponse")
function OpenRiYueZhuiResponse:OpenRiYueZhuiResponse(data)
	if data.result == 1 then 
		ArenaLookingForData.okTimes = checknumber(data.param5) 		-- 成功次数
		ArenaLookingForData.haveTimes = checknumber(data.param1) 	-- 拥有次数
		ArenaLookingForData.recoverTime = checknumber(data.param6) 	-- 开始倒计时时间点
		if ArenaLookingForData.recoverTime == 0 then 
			ArenaLookingForData.recoverTime = UserData:getServerSecond()
		end 

		ArenaLookingForData.buyTimes = checknumber(data.param2) 	-- 购买了的次数
		UserData:setSunBattleList(string.split(data.param3, ",")) 	-- 日追击阵形
		UserData:setMoonBattleList(string.split(data.param4, ","))	-- 月追击阵形

		-- 被挑战者
		local team = PlayerData.parseArenaTeam(data.a_param1)
		ArenaLookingForData:setEnermyTeam(team)

	end 

end
function OpenRiYueZhuiResponse:ctor()
	--响应消息号
	self.order = 20026
	--返回结果
	self.result =  ""
	--当前挑战点次数
	self.param1 =  ""
	--已购买的次数
	self.param2 =  ""
	--日追击阵形
	self.param3 =  ""
	--月追击阵形
	self.param4 =  ""
	--已胜利的次数
	self.param5 =  ""
	--挑战点恢复开始时间
	self.param6 =  ""
	--挑战对手
	self.a_param1 =  ""	
end

return OpenRiYueZhuiResponse