
--[[
爱恩格朗特背景
]]

local AincradBackground = class("AincradBackground", function()
	return display.newSprite()
end)

function AincradBackground:ctor()
	self:initView()
end

function AincradBackground:initView()
	-- 背景图
	display.newSprite("Aincrad_Background2.jpg")
	:addTo(self)
	:center()

	self:addTower()
	self:addFrontCloud1()
	self:addFrontCloud2()
	self:addFrontCloud3()

	self:addMidCloud1()

	self:addUpCloud1()
	self:addUpCloud2()
end

-- 塔 
function AincradBackground:addTower()
	local node = display.newSprite("Aincrad_Tower.png")
	:addTo(self)
	:pos(display.cx+15, display.cy)
	:zorder(3)

	local action = transition.sequence({
		cc.MoveBy:create(20, cc.p(0, 40)),
		cc.MoveBy:create(20, cc.p(0, -40)),
	})

	action = cc.RepeatForever:create(action)

	node:runAction(action)
end 

-- 前层云1
function AincradBackground:addFrontCloud1()
	local node = display.newSprite("Cloud_front1.png")
	:addTo(self)
	:align(display.CENTER_BOTTOM)
	-- :pos(display.right * 0.25, display.bottom + 100)
	:scale(1.5)
	:zorder(4)

	self:setRandPosX(node, display.bottom+50, -display.cx, display.cx*3)
	self:showCloudMove(node, 10, 10)
end 

-- 前层云2
function AincradBackground:addFrontCloud2()
	local node = display.newSprite("Cloud_front2.png")
	:addTo(self)
	:align(display.CENTER_BOTTOM)
	-- :pos(display.right * 0.5, display.bottom + 100)
	:scale(1.5)
	:zorder(4)

	self:setRandPosX(node, display.bottom+50, -display.cx, display.cx*3)
	self:showCloudMove(node, 10, 10)
end 

-- 前层云3
function AincradBackground:addFrontCloud3()
	local node = display.newSprite("Cloud_front3.png")
	:addTo(self)
	:align(display.CENTER_BOTTOM)
	-- :pos(display.right * 0.75, display.bottom + 100)
	:scale(1.5)
	:zorder(4)

	self:setRandPosX(node, display.bottom+50, -display.cx, display.cx*3)
	self:showCloudMove(node, 10, 10)
end 

-- 中层云1
function AincradBackground:addMidCloud1()
	local node = display.newSprite("Cloud_mid1.png")
	:addTo(self)
	:align(display.CENTER_BOTTOM)
	-- :pos(display.right * 0.75, display.cy)
	:zorder(4)

	self:setRandPosX(node, display.cy-150, 0, display.cx*2)
	self:showCloudMove(node, 20, 20)
	
end

-- 上层云1
function AincradBackground:addUpCloud1()
	local node = display.newSprite("Cloud_up1.png")
	:addTo(self)
	-- :pos(display.right * 0.35, display.cy + 200)
	:zorder(4)

	self:setRandPosX(node, display.top-150, 0, display.cx*2)
	self:showCloudMove(node, 40, 50)
	
end

-- 上层云2
function AincradBackground:addUpCloud2()
	local node = display.newSprite("Cloud_up2.png")
	:addTo(self)
	-- :pos(display.right * 0.65, display.cy + 200)
	:zorder(2)

	self:setRandPosX(node, display.cy, 0, display.cx*2)
	self:showCloudMove(node, 40, 50)
	
end

function AincradBackground:setRandPosX(target, posY, baseX, offX)
	local posX = randFloat(baseX, baseX+offX)
	target:pos(posX, posY)
end

function AincradBackground:showCloudMove(target, basedur, offdur)
	self:showMoveToLeft(target, randFloat(basedur, basedur + offdur), function()
		self:showMoveR2L(target, randFloat(basedur, basedur + offdur), function()
			self:showCloudMove(target, basedur, offdur)
		end)
	end)
end 

function AincradBackground:showMoveToLeft(target, dur, callback)
	-- print("dur1:", dur)
	local posX, posY = target:getPosition()	
	local pos1 = cc.p(-display.cx, posY)

	local per = (posX + display.cx) / display.cx * 0.25 -- 第一行程 占总行程百分比 
	local useTime = per * dur * 2 -- 第一行程耗时 

	local action = transition.sequence({
		cc.MoveTo:create(useTime, pos1),
		cc.CallFunc:create(function()
			callback()			
		end)
	})

	target:runAction(action)
end 

function AincradBackground:showMoveR2L(target, dur, callback)
	-- print("dur2:", dur)
	local posX, posY = target:getPosition()	
	local pos1 = cc.p(-display.cx, posY)
	local pos2 = cc.p(display.cx * 3, posY)
	dur = dur * 2

	local sequence = transition.sequence({
		cc.DelayTime:create(0.1),
		cc.MoveTo:create(0, pos2),
		cc.MoveTo:create(dur, pos1),
		cc.CallFunc:create(function()			
			callback()
		end)
	})

	target:runAction(sequence)
end 

return AincradBackground







