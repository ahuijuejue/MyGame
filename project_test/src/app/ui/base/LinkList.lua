--[[
链表
]]

local LinkList = class("LinkList")

function LinkList:ctor()	
	self.nodeCount = 0 
	self.firstNode = nil 
	self.lastNode = nil 
end

function LinkList:reset()	
	self.nodeCount = 0 
	self.firstNode = nil 
	self.lastNode = nil 
end

function LinkList:addNode(node)
	node.preNode = nil 
	node.nextNode = nil 
	if not self.firstNode then 
		self.firstNode = node 
		self.lastNode = node 
	end 
	if self.nodeCount > 0 then 
		self.lastNode.nextNode = node
		node.preNode = self.lastNode
		self.lastNode = node
	end 

	self.nodeCount = self.nodeCount + 1
end

function LinkList:removeNode(node)
	if self.nodeCount == 0 then return end 

	if self.firstNode == node then 
		self.firstNode = node.nextNode		
	end 

	if self.lastNode == node then 
		self.lastNode = node.preNode 		
	end 

	local node1 = node.preNode 
	local node2 = node.nextNode
	if node1 then 
		node1.nextNode = node2 
	end 
	if node2 then 
		node2.preNode = node1 
	end 
	node:reset()
	self.nodeCount = self.nodeCount - 1
end 

function LinkList:isEmpty()
	return self.nodeCount == 0
end 

return LinkList