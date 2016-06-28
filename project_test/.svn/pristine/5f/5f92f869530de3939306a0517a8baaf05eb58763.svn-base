
local GuideData = class("GuideData") 

function GuideData:ctor() 
	-- 完成情况
	self.dict = {}

	-- 引导信息列表
	self.guideList = {}
	for k,v in pairs(GameConfig["Beginnersguide"] or {}) do
		table.insert(self.guideList, {
			name = k,
			desc = v.s,
			sort = checknumber(v.sortId),
			enter = checknumber(v.enter),
			itemId = v.itemid,
			itemNum = v.num,
		})
	end

	table.sort(self.guideList, function(a, b)
		return a.sort < b.sort 
	end)
end

function GuideData:getGuideList()
	return self.guideList
end 

function GuideData:setCompleted(key, callback, errorback) 	
	showLoading() 
	NetHandler.request("NewComerGuide", {
		data = {param1 = key}, 
		onsuccess 	= function()
			hideLoading()			
			NetHandler.removeTarget(self)
			if callback then 
				callback()
			end 
		end,
		onerror = function()
			hideLoading()
			NetHandler.removeTarget(self)
			showToast({text="引导数据出错"})
			if errorback then 
				errorback()
			end 
		end
	}, self)
end 

function GuideData:setCompleted_(key) 
	if key and string.len(key) > 0 then 
		self.dict[key] = true 
	end 
end 

function GuideData:isCompleted(key) 
	return self.dict[key] 
end 

function GuideData:isNotCompleted(key) 
	local keys = key 
	if type(key) == "string" then 
		keys = {key}
	end  
	for i,v in ipairs(keys) do
		if not self.dict[v] then 
			return true 
		end 
	end
	return false 
end 


return GuideData 
