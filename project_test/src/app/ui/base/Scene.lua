
local Scene = class("Scene", function() 	
	return display.newScene("Scene")
end)

local sharedDirector = cc.Director:getInstance()

function Scene:ctor(options)	
	self.name = self.__cname
	self.layer_ = display.newLayer()
	:addTo(self)
	:size(960, 640)
	:pos(display.cx, display.cy)
	:align(display.CENTER)
	:zorder(1)

	options = options or {}
	self:initData(options)
	self:initView(options)
end

function Scene:initData()	
end 

function Scene:initView()
end

function Scene:onEnter()
	self:updateData()
	self:updateView()
	self:updateOthers()
	self:onGuide()
end 

function Scene:updateData()	
end 

function Scene:updateView()
end 

function Scene:onGuide()
end 

function Scene:updateOthers()
end 

function Scene:onExit()
	NetHandler.removeTarget(self) 
end 

return Scene