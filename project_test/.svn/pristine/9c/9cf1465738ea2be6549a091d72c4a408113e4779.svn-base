local CityUpStarProcess = class("CityUpStarProcess")

function CityUpStarProcess:ctor()
	--请求消息号
	self.order = 10047
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--建筑类型：（1，主建筑,2 攻击，3 防御）
	self.param1 =  ""	
end


function CityUpStarProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		
	}
	return data
end

return CityUpStarProcess