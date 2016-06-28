--[[
gaf封装
]]

--[[
--加载gaf文件
	local asset = gaf.GAFAsset:create(gafPath,callback)
	--创建gaf动画
	self.role = asset:createObject()
	--获取动画场景width height
	local width = asset:getSceneWidth()
	local height = asset:getSceneHeight()
	--开始播放动画
	self.role:start()
	self.role:playSequence("idle",true)
	--添加到场景
	self:addChild(self.role)
	--设置动画回调
	self.role:setFramePlayedDelegate(callback)
	--移除回调
	self.role:setFramePlayedDelegate(nil)
]]
local GameGaf = class("GameGaf") 

function GameGaf:ctor(params)
	self.name 		= params.name  	-- 文件名 	
	self.x 			= params.x or 0
	self.y 			= params.y or 0 
	self.scale 		= params.scale or 1
	self.aniName 	= ""
	
	self.anim = nil 
end

function GameGaf:onEvent(listener)
	self.eventListener_ = listener
	dump(self.eventListener_, "liste")
	return self 
end

function GameGaf:onEvent_(event)	
	if not self.eventListener_ then return end 

	event.target = self 
	self.eventListener_(event)
end

function GameGaf:start()
	local zipPath = self.name..".zip"
	local gafPath = self.name.."/"..self.name..".gaf"
	local asset = gaf.GAFAsset:createWithBundle(zipPath,gafPath)
	local width = asset:getSceneWidth()
	local height = asset:getSceneHeight()
	
	local anim = asset:createObject()
	self.anim = anim 
	anim:scale(self.scale)
	
	anim:setFrame(1)
	anim:setFps(30)	
	anim:pos((width * -0.5) * self.scale + self.x, (height - 440) * self.scale  + self.y)

	anim:setFramePlayedDelegate(function(frame, finish)	
		if finish then 			
			self:onEvent_({name="finish", aniName=self.aniName, anim=self.anim})
			anim:unregisterScriptHandler()
		end 			
	end)	

	anim:start()

	return self 
end

function GameGaf:play(name, loop)
	self.aniName = name 
	self.anim:playSequence(name,loop)
	return self 
end 

function GameGaf:addTo(target, zorder, tag)
	self.anim:addTo(target, zorder, tag)
	return self 
end 

return GameGaf
