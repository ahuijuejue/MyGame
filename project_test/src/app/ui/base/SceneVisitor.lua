
local SceneVisitor = class("SceneVisitor")

function SceneVisitor:ctor(params)
	params = params or {}

	self.isFirst = params.isFirst 
	self.params = params.params 
	self.target = params.target 
	
	self.eventListener = params.callback 
end

function SceneVisitor:pushScene()
	self:toScene("push")
end

function SceneVisitor:enterScene()	
	self:toScene("enter")	
end

function SceneVisitor:netPushScene()	
	self:netToScene("push")
end

function SceneVisitor:netEnterScene()	
	self:netToScene("enter")	
end


function SceneVisitor:toScene(totype)

end

function SceneVisitor:netToScene(totype)

end

--[[
用于记录
]]
function SceneVisitor:getNetOrder()
	return "visitor"
end 

----------------

----------------
function SceneVisitor:toScene_(scenename, params, totype)
	if type(params) == "string" then 
		totype = params 
		params = {}
	end 

	if totype == "push" then 
		app:pushScene(scenename, {params})
	elseif totype == "enter" then 
		app:enterScene(scenename, {params})
	end 	
end

function SceneVisitor:sendData(order, params, success_callback, error_callback)
	NetHandler.request(order, {
		data = params, 
		onsuccess = function(params1)
			self:onEvent_({name="success", data=params1, save=self:getNetOrder()})
			if success_callback then 
				success_callback({name="success", data=params1, save=self:getNetOrder()})
			end 
		end,
		onerror = function()
			self:onEvent_({name="error"})
			if error_callback then 
				error_callback()
			end 
		end,
	}, self.target)
end

function SceneVisitor:onEvent_(event)
	if not self.eventListener then return end 
	event.target = self
	self.eventListener(event)
end

return SceneVisitor
