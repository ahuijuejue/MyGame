--[[
竞技场排行榜条
]]

local RankGrid = class("RankGrid", base.TableNode)

function RankGrid:ctor(params)
	params = params or {}
	RankGrid.super.ctor(self, params)	
	-- print("\n\nnew flag:", params.flag)
	self:initView(params)
end

function RankGrid:initView(params)
	self:initBackground()
	self:initIcon()
	self:initRank()
	self:initLevel()
	self:initName()
	self:initBattle()
	self:initSelfMark()
end

function RankGrid:initBackground()
	self.backName = ""
	self.backIcon = nil
end 

function RankGrid:initIcon()
	self.iconWidget = display.newNode()
	:addTo(self, 2)
	:pos(-195, 0)
	

	self.iconName = ""
	self.icon = nil

	self.iconBorderName = ""
	self.iconBorder = nil
end 

-- 排名
function RankGrid:initRank()
	self.rankLabel = base.Label.new({
		size=50
	})
	:align(display.CENTER)
	:pos(-305, 0)
	:addTo(self, 2)
end 

-- 等级
function RankGrid:initLevel()
	base.Label.new({
		text="Lv",
		size=26
	})
	:pos(-135, 0)
	:addTo(self, 2)

	self.levelLabel = base.Label.new({
		size=26
	})
	:pos(-105, 0)
	:addTo(self, 2)
	
end 

-- 昵称
function RankGrid:initName()
	self.nameLabel = base.Label.new({
		size=22
	})
	:pos(-50, 0)
	:addTo(self, 2)
end 

-- 战斗力
function RankGrid:initBattle()
	base.Label.new({
		text="战力：",
		size=20, 
		color=cc.c3b(255,178,55)
	})
	:pos(150, 0)
	:addTo(self, 2)

	self.battleLabel = base.Label.new({
		size=20, 
		color=cc.c3b(255,178,55)
	})
	:pos(210, 0)
	:addTo(self, 2)
end 

-- 标记自己的图标
function RankGrid:initSelfMark()
	self.selfMark = display.newSprite("Flag_Self.png")
	:addTo(self)
	:pos(-267, 25)
	:zorder(10)
	:hide()
end 

-----------------------------------------------
-----------------------------------------------
--[[

]]

function RankGrid:setBackground(name)
	if self:checkName(name, "backName", "backIcon") then 
		self.backIcon = display.newSprite(name)
		:addTo(self)
	end 

	return self
end

function RankGrid:setRank(level)
	if level <= 3 then 
		self.rankLabel:hide()
	else 
		self.rankLabel:show()
		:setString(tostring(level))
	end 
end 

function RankGrid:setIcon(name)
	if self:checkName(name, "iconName", "icon") then 
		self.icon = display.newSprite(name)
		:addTo(self.iconWidget, 2)
		:scale(0.7)
	end 
	return self
end 

function RankGrid:setIconBorder(name)
	if self:checkName(name, "iconBorderName", "iconBorder") then 
		self.iconBorder = display.newSprite(name)
		:addTo(self.iconWidget)
		:scale(0.7)
	end 
	return self
end 

function RankGrid:setLevel(level)
	self.levelLabel:setString(tostring(level))

	return self
end

function RankGrid:setName(txt)
	self.nameLabel:setString(txt)

	return self
end

function RankGrid:setBattle(level)
	self.battleLabel:setString(tostring(level))

	return self
end

-- 标记自己的图标
function RankGrid:showSelfMark(b)
	self.selfMark:setVisible(b)

	return self
end 

return RankGrid














