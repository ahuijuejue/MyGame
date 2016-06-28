local OpenChapterBoxResponse = class("OpenChapterBoxResponse")
function OpenChapterBoxResponse:OpenChapterBoxResponse(data)
	if data.result == 1 then 
		local items = data.a_param1 or {}
		local chapterId = data.param1
		
		-- 增加领取星级奖励次数
		ChapterData:setAwardNum(chapterId, ChapterData:getAwardNum(chapterId)+1)

		-- 增加奖励物品
		UserData:rewardItems(items) 
		local showItems = UserData:parseItems(items)

		return {items=showItems}

	elseif data.result == -1 then 
		showToast({text="章节不存在"})
	elseif data.result == -2 then 
		showToast({text="星星数不足或已全部领取"})
	end 

end
function OpenChapterBoxResponse:ctor()
	--响应消息号
	self.order = 20020
	--返回结果,1 成功;-1 钻石不足
	self.result =  ""
	--宝箱中的物品
	self.a_param1 =  ""	
end

return OpenChapterBoxResponse