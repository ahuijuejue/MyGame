local OpenTrialsResponse = class("OpenTrialsResponse")
function OpenTrialsResponse:OpenTrialsResponse(data) 
	if data.result == 1 then 
		-- 修炼圣地
		local arrLight = data.a_param1 	-- 山多拉的灯关卡 
		local arrHouse = data.a_param2 	-- 精神时光屋关卡 
		local arrMount = data.a_param3 	-- 庐山五老峰关卡 

--------------------------------------------------
-- 关卡数据 
		-- 山多拉的灯关卡 
		TrialData:resetLight() 
		if arrLight then 
			for i,v in ipairs(arrLight) do 
				local dict = json.decode(v)
				TrialData:addLight({
					id 		= dict.trialid, 
					type 	= dict.type, 
					formation = string.split(dict.formation, ","), 
				})
			end
		end 
		TrialData:sortLight() 

		-- 精神时光屋关卡 
		TrialData:resetHouse() 
		if arrHouse then 
			for i,v in ipairs(arrHouse) do 
				local dict = json.decode(v)
				TrialData:addHouse({
					id 		= dict.trialid, 
					type 	= dict.type, 
					formation = string.split(dict.formation, ","), 
				})
			end
		end 
		TrialData:sortHouse() 

		-- 庐山五老峰关卡 
		TrialData:resetMount() 
		if arrMount then 
			for i,v in ipairs(arrMount) do 
				local dict = json.decode(v)
				TrialData:addMount({
					id 		= dict.trialid, 
					-- type 	= dict.type, 
					formation = string.split(dict.formation, ","), 
				})
			end
		end 
		TrialData:sortMount() 

--------------------------------------------------
-- 通关次数 
		-- 山多拉的灯
		local light = TrialData:getTrial("light") 
		light:setTimes(checknumber(data.param1)) 

		-- 精神时光屋
		local timeHouse = TrialData:getTrial("time") 
		timeHouse:setTimes(checknumber(data.param2)) 

		-- 庐山五老峰
		local mount = TrialData:getTrial("mount") 
		mount:setTimes(checknumber(data.param3)) 
-----------------------------------------------------

	end 

end
function OpenTrialsResponse:ctor()
	--响应消息号
	self.order = 20008
	--返回结果,1 成功;
	self.result =  ""
	--山多拉之灯关卡，
	self.a_param1 =  ""
	--精神屋关卡，
	self.a_param2 =  ""
	--精神屋关卡，
	self.a_param3 =  ""	
end

return OpenTrialsResponse