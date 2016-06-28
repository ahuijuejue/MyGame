local SaveJingjiDefenseResponse = class("SaveJingjiDefenseResponse")
function SaveJingjiDefenseResponse:SaveJingjiDefenseResponse(data)
	if data.result == 1 then 
		local idstr = data.param1 or ""	-- 对应阵型，多个以逗号分开
		local arrid = string.split(idstr, ",") 
		local battle = checknumber(data.param2)

		-- 保存防守阵型 
		UserData:setArenaDefenseList(arrid)
		-- 保存新手战斗力
		ArenaData.battle = battle

		-- 保存新手引导 字段 
		GuideData:setCompleted_(data.param100) 

	end 

end
function SaveJingjiDefenseResponse:ctor()
	--响应消息号
	self.order = 10060
	--返回结果,1 成功;
	self.result =  ""	
end

return SaveJingjiDefenseResponse