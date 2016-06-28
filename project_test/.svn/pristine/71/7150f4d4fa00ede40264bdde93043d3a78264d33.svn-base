--[[
新手引导

GuideNode
]]

---------------------------------------------------------------------
----------------************ 新手引导控制 ***********------------------
local GuideManager = class("GuideManager")

function GuideManager:ctor()
	self.list = base.LinkList.new() -- 触发引导
	self.openList = base.LinkList.new() -- 开场引导
	self.readyList = base.LinkList.new() -- 强制引导

	self:loadGuide()
end

function GuideManager:createNode(name, params)	
	local cls = require("app.util.guide.node.Guide" .. name)
	
	return cls.new(params)	
end

function GuideManager:resetGuide()
	self.list:reset()
	self.openList:reset()
	self.readyList:reset()
	return self 
end

function GuideManager:addGuide(linklist, node)
	linklist:addNode(node)
	return self 
end

function GuideManager:removeGuide(linklist, node)
	linklist:removeNode(node)
	return self 
end 

-------------------------------------
--///////////////////////////////////
-- 开始引导
--@return true 有引导 false 没有引导

-- 触发条件引导
function GuideManager:makeGuide(targetScene, params, outparams)
	if self.list:isEmpty() then return false end 
	return self.list.firstNode:makeGuide(targetScene, params, outparams)
end 

-- 开场引导
function GuideManager:makeOpenGuide(targetScene, params, outparams)
	if self.openList:isEmpty() then return false end 
	return self.openList.firstNode:makeGuide(targetScene, params, outparams)
end 

-- 出战引导
function GuideManager:makeReadyGuide(targetScene, params, outparams)
	if self.openList:isEmpty() then return false end 
	return self.readyList.firstNode:makeGuide(targetScene, params, outparams)
end 

--//////////////////////////////////
----------------------------------

function GuideManager:loadGuide()
	local list = GuideData:getGuideList()
	for i,v in ipairs(list) do
		local name = string.gsub(v.name, "-", "_")
		local firstLitter = string.sub(name, 1, 1)
		local uplitter = string.upper(firstLitter)
		if uplitter ~= firstLitter then 
			name = uplitter..string.sub(name, 2)
		end 
		if v.enter == 0 then 
			-- print("0不做引导")
		else 
			local params = {
				name=v.name,
				itemId = v.itemId,
				itemNum = v.itemNum,
			}
			if v.enter == 1 then 
				self:addGuide(self.openList, self:createNode(name, params))
			elseif v.enter == 6 then 
				self:addGuide(self.readyList, self:createNode(name, params))
			else
				self:addGuide(self.list, self:createNode(name, params))
				if v.enter == 5 then 
					self:addGuide(self.readyList, self:createNode(name, params))
				end 
			end 
		end 
	end
end

return GuideManager
