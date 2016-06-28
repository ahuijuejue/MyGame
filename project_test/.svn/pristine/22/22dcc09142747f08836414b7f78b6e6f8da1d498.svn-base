local UpdateZhuijiEnemyResponse = class("UpdateZhuijiEnemyResponse")
function UpdateZhuijiEnemyResponse:UpdateZhuijiEnemyResponse(data)
	if data.result == 1 then 
		-- 被挑战者
		local team = PlayerData.parseArenaTeam(data.a_param1)
		ArenaLookingForData:setEnermyTeam(team)
	end 
end
function UpdateZhuijiEnemyResponse:ctor()
	--响应消息号
	self.order = 20027
	--返回结果
	self.result =  ""
	--挑战对手
	self.a_param1 =  ""	
end

return UpdateZhuijiEnemyResponse