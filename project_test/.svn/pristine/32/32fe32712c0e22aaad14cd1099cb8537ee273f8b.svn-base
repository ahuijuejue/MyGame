local SaveBattleResultProcess = class("SaveBattleResultProcess")

function SaveBattleResultProcess:ctor()
	--请求消息号
	self.order = 20004
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--关卡id
	self.param1 =  ""
	--上阵的英雄id,多个以逗号结束
	self.param2 =  ""
	--关卡类型：1 普通关卡；2 精英关卡
	self.param3 =  ""
	--获得的星星数
	self.param4 =  ""
	--新手引导字段
	self.param100 =  ""	
end


function SaveBattleResultProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		param4 = self.param4,
		param100 = self.param100,
		
	}
	return data
end

return SaveBattleResultProcess