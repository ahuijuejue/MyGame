--[[
aincrad排行榜条
]]

local AincradRankingGrid = class("AincradRankingGrid", base.TableNode)

function AincradRankingGrid:ctor(params)
	params = params or {}
	AincradRankingGrid.super.ctor(self, params)	
	-- print("\n\nnew flag:", params.flag)
	self:initView(params)
end

function AincradRankingGrid:initView(params)
	self:initBackground()
	self:initIcon()
	self:initRank()
	self:initLevel()
	self:initName()
	self:initScore()
	self:initSelfMark()
end

function AincradRankingGrid:initBackground()
	self.backName = ""
	self.backIcon = nil
end 

function AincradRankingGrid:initIcon()
	self.iconWidget = display.newNode()
	:addTo(self, 2)
	:pos(-195, 0)
	

	self.iconName = ""
	self.icon = nil

	self.iconBorderName = ""
	self.iconBorder = nil
end 

-- 排名
function AincradRankingGrid:initRank()
	self.rankLabel = base.Label.new({
		size=50
	})
	:align(display.CENTER)
	:pos(-305, 0)
	:addTo(self, 2)
end 

-- 等级
function AincradRankingGrid:initLevel()
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
function AincradRankingGrid:initName()
	self.nameLabel = base.Label.new({
		size=22
	})
	:pos(-50, 0)
	:addTo(self, 2)
end 

-- 积分
function AincradRankingGrid:initScore()
	base.Label.new({
		text="积分：",
		size=20, 
		color=cc.c3b(255,178,55)
	})
	:pos(150, 0)
	:addTo(self, 2)

	self.scoreLabel = base.Label.new({
		size=20, 
		color=cc.c3b(255,178,55)
	})
	:pos(210, 0)
	:addTo(self, 2)
end 

-- 标记自己的图标
function AincradRankingGrid:initSelfMark()
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

function AincradRankingGrid:setBackground(name)
	if self:checkName(name, "backName", "backIcon") then 
		self.backIcon = display.newSprite(name)
		:addTo(self)
	end 

	return self
end

function AincradRankingGrid:setRank(level)
	if level <= 3 then 
		self.rankLabel:hide()
	else 
		self.rankLabel:show()
		:setString(tostring(level))
	end 
end 

function AincradRankingGrid:setIcon(name)
	if self:checkName(name, "iconName", "icon") then 
		self.icon = display.newSprite(name)
		:addTo(self.iconWidget, 2)
		:scale(0.7)
	end 
	return self
end 

function AincradRankingGrid:setIconBorder(name)
	if self:checkName(name, "iconBorderName", "iconBorder") then 
		self.iconBorder = display.newSprite(name)
		:addTo(self.iconWidget)
		:scale(0.7)
	end 
	return self
end 

function AincradRankingGrid:setLevel(level)
	self.levelLabel:setString(tostring(level))

	return self
end

function AincradRankingGrid:setName(txt)
	self.nameLabel:setString(txt)

	return self
end

function AincradRankingGrid:setScore(value)
	self.scoreLabel:setString(tostring(value))

	return self
end

-- 标记自己的图标
function AincradRankingGrid:showSelfMark(b)
	self.selfMark:setVisible(b)

	return self
end 

return AincradRankingGrid














