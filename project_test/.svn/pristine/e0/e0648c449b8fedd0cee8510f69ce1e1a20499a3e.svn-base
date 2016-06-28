--[[
节点
]]
local TableNode = class("TableNode", function()
	return display.newNode()
end)
--[[
--@param params 
-- flag -- 标记
]]
function TableNode:ctor(params)	
	self.idx = 0
	self.flag = params.flag or "default"
	self.data = {}
end

function TableNode:getIndex()
	return self.idx
end

function TableNode:setIndex(idx)
	self.idx = idx
end

function TableNode:getFreeFlag()
	return self.flag
end

function TableNode:setData(key, data)
	self.data[key] = data 
	return self
end

function TableNode:getData(key)
	return self.data[key]
end

function TableNode:checkName(name, selfname, selfgridname)
	if self[selfname] ~= name then 
		if self[selfgridname] then 
			self[selfgridname]:removeSelf()
			self[selfgridname] = nil 
		end 
		self[selfname] = name
		return true 
	end 
	return false
end

return TableNode
