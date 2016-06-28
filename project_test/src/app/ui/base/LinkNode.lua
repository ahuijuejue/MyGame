--[[
链表节点
]]
local LinkNode = class("LinkNode")

function LinkNode:ctor()	
	self.data = nil 
	self.preNode = nil 
	self.nextNode = nil 
end

function LinkNode:reset()
	self.data = nil 
	self.preNode = nil 
	self.nextNode = nil 
end 

return LinkNode