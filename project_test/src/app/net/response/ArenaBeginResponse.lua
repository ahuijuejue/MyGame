local ArenaBeginResponse = class("ArenaBeginResponse")
function ArenaBeginResponse:ArenaBeginResponse(data)
	if data.result == 1 then 
		-- 开始竞技场战队 
		local coolTime = checknumber(data.param1) 
		ArenaData:setCoolTime(coolTime) 
		ArenaData:reduceBattleNum()

---------------------------------------
-- 任务数据变动 
		TaskData:addTaskParams("arena", 1)
---------------------------------------

	elseif data.result == -1 then -- 挑战次数不足 
		showToast({text="挑战次数不足"})
	elseif data.result == -2 then -- 挑战在冷却时间内 
		showToast({text="挑战在冷却时间内"})
	end 

end
function ArenaBeginResponse:ctor()
	--响应消息号
	self.order = 10053
	--返回结果,1 成功;-1 挑点次数已用完; -2 在冷却中，
	self.result =  ""
	--冷却结束时间
	self.param1 =  ""	
end

return ArenaBeginResponse