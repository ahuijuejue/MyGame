local RoleLayer = class("RoleLayer",function()
    return display.newLayer()
end)

local scheduler = require("framework.scheduler")

local scale = 1
local offsetX = 40
local roleWidth = 80*scale
local roleHeight = 160*scale
local roleAct = {"skill1","skill2","skill3","cheer"}
local rangeX = 5
local rangeY = 15

function RoleLayer:ctor(gafName)
	self.isTouchInRole = false

	local zipPath = gafName..".zip"
	local gafPath = gafName.."/"..gafName..".gaf"
	local asset = gaf.GAFAsset:createWithBundle(zipPath,gafPath)
	self.role = asset:createObject()
	self.roleX = asset:getSceneWidth()*-0.5*scale
	self.roleY = (asset:getSceneHeight()-440)*scale
	self.role:setPosition(self.roleX, self.roleY)
	self.role:start()
	self.role:playSequence("idle",true)
	self:addChild(self.role)

	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.roleOnTouch))
	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
	self.originBox = self:getCascadeBoundingBox()
end

function RoleLayer:setRoleScaleX(scale)
	self.role:setPosition(self.roleX*scale, self.roleY)
	self.role:setScaleX(scale)
end

function RoleLayer:roleOnTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		if self:touchInRole(point) then
			self.isTouchInRole = true
		end
		return self.isTouchInRole
	elseif event.name == "ended" then
		if self.isTouchInRole and self:touchInRole(point) then
			self:palyRoleAction()
		end
		self.isTouchInRole = false
	end
end

function RoleLayer:touchInRole(point)
	point = self:convertToNodeSpace(point)
	local roleRect = {x = -offsetX, y = 0, width = roleWidth, height = roleHeight}
	return cc.rectContainsPoint(roleRect,point)
end

function RoleLayer:palyRoleAction()
	newrandomseed()
	local x = math.random(1,#roleAct)
	self.role:playSequence(roleAct[x],false)

	if self.actionHandle then
		scheduler.unscheduleGlobal(self.actionHandle)
		self.actionHandle = nil
	end
end

function RoleLayer:actFinish(frame,finish)
	if finish then
		self.role:playSequence("idle",true)
		if self.actionHandle == nil then
			newrandomseed()
			local interval = math.random(rangeX,rangeY)
			self:startTimer(interval)
		end		
	end
end

function RoleLayer:startTimer(interval)
	self.actionHandle = scheduler.scheduleGlobal(handler(self,self.palyRoleAction),interval)
end

function RoleLayer:onEnter()
	newrandomseed()
	local interval = math.random(rangeX,rangeY)
	self:startTimer(interval)
	self.role:enableTick(true)
	self.role:setFramePlayedDelegate(handler(self,self.actFinish))
end

function RoleLayer:onExit()
	if self.actionHandle then
		scheduler.unscheduleGlobal(self.actionHandle)
		self.actionHandle = nil
	end
	self.role:enableTick(false)
	self.role:setFramePlayedDelegate(nil)
end

return RoleLayer