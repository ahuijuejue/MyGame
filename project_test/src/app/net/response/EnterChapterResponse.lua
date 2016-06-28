local EnterChapterResponse = class("EnterChapterResponse")
function EnterChapterResponse:EnterChapterResponse(data)
	if data.result == 1 then 
		function splitComma(str)
			return string.split(str, ",")
		end

		function split_(str)
			return string.split(str, "_")
		end

		function splitType1(str)
			local arr = {}
			local arr1 = splitComma(str) -- id_数量 的数组				
			for i,v in ipairs(arr1) do
			 	local arr2 = split_(v)
			 	if #arr2 == 2 then 				 	
			 		arr[tostring(arr2[1])] = tonumber(arr2[2])	
			 	end 			 		
			end 
			
			return arr 
		end

		function splitType2(str)			
			local arr1 =  string.split(str, "#")
			if #arr1 == 2 then 
				return splitType1(arr1[2]) -- id_数量 的数组	
			end 
			return {} 
		end

		for i,w in ipairs(data.a_param1) do
			local stars = splitType2(w) -- 普通关卡 星星数
			for k,v in pairs(stars) do
				ChapterData:getStage(k).passLevel = v
			end
		end
		
		for i,w in ipairs(data.a_param2) do
			local stars = splitType2(w) -- 精英关卡 星星数
			for k,v in pairs(stars) do
				print(k, v)
				ChapterData:getStage(k).passLevel = v
			end
		end
		
		for i,w in ipairs(data.a_param3) do
			local nBattleTimes = splitType2(w) -- 关卡挑战次数
			for k,v in pairs(nBattleTimes) do
				local stage = ChapterData:getStage(k)
				stage.passNum = v	
			end
		end
		
		-- 精英关卡购买次数
		local elitArr = splitType1(data.param4)
		for k,v in pairs(elitArr) do
			local stage = ChapterData:getStage(k)
			stage.buyElitNum = v	
		end


		ChapterData.sweepTimes = tonumber(data.param2) or 0 -- 剩余扫荡点数
		ChapterData.remainingTime = tonumber(data.param3) or 0 -- 已过的恢复时间，秒数	

				
	end 

end
function EnterChapterResponse:ctor()
	--响应消息号
	self.order = 20001
	--返回结果,1 成功;
	self.result =  ""
	--普通每章节的关卡信息：章节id#关卡id_星星数,关卡Id_星星数
	self.a_param1 =  ""
	--精英每章节的关卡信息：章节id#关卡id_星星数,关卡Id_星星数
	self.a_param2 =  ""
	--剩余扫荡点数
	self.param2 =  ""
	--已过的恢复时间，秒数,如果为-1,则没有恢复操作
	self.param3 =  ""
	--获取精英关卡的购买的的“挑点次数”,格式：guankaid_挑点次数,guankaid_挑点次数
	self.param4 =  ""
	--每章节关卡的挑战次数：章节id#关卡id_挑战次数,关卡id_挑战次数
	self.a_param3 =  ""	
end

return EnterChapterResponse