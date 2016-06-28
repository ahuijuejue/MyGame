--[[
竞技场列表 单元
]]

local ArenaInfoWidget = class("ArenaInfoWidget", function()
	return display.newNode()
end)

function ArenaInfoWidget:ctor(params)
	
	self.eventListener_ = nil

	self:initView(params)	

end

function ArenaInfoWidget:initView(params)
	self.grid = base.Grid.new()
	:addTo(self)
	:pos(0, -40)

	-- 背景框
	display.newSprite()
	:addTo(self)

	-- 图标
	self.icon = display.newSprite(params.icon)
	:addTo(self, 2)
	-- :pos(0, 80)

	-- 锁 图标
	-- self.lock = display.newSprite("Training_Lock.png")
	-- :addTo(self, 5)
	-- :pos(0, 80)

	-- 说明 标签
	self.discLabel = base.Label.new({
		text = params.desc,
		size = 20,
		dimensions = cc.size(250, 200),
		align = cc.TEXT_ALIGNMENT_LEFT,
		valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
	})
	:align(display.CENTER_TOP)
	:addTo(self, 5)
	:pos(0, -90)

	-- 开启等级 标签
	self.lvLabel = base.Label.new({
		text = params.openLv,
		size = 20,
		color=CommonView.color_red(),
	})
	:align(display.CENTER)
	:addTo(self, 5)
	:pos(0, -150)


	-- 名字
	-- base.Label.new({text=params.name, size = 20})
	-- :align(display.CENTER)
	-- :addTo(self, 5)
	-- :pos(0, 0)

	if params.nameIcon then 
		self.nameIcon = display.newSprite(params.nameIcon)
		:align(display.CENTER_TOP)
		:addTo(self)
		:pos(0, -80)
	end 

	base.Grid.new()
	:addTo(self)
	:pos(0, 0)
	:onTouch(function(event)
		if event.name == "began" then 			
			self:onEvent_({name="down"})
		elseif event.name == "ended" then 
			self:onEvent_({name="up"})
		elseif event.name == "clicked" and event.comb == 1 then 
			self:onEvent_({name="enter"})
		end 
	end, cc.size(200, 250))
end 

function ArenaInfoWidget:onEvent_(event)
	if not self.eventListener_ then return end 

	event.target = self 
	self.eventListener_(event)
end 

-- 点击按钮回调
function ArenaInfoWidget:onButtonEnterCallback(callback)
	self.eventListener_ = callback

	return self
end 

-- 设置开启等级显示的字符串
function ArenaInfoWidget:setOpenLvLabel(txt)
	self.lvLabel:setString(txt)
	return self
end 

-- 显示开启等级 标签
function ArenaInfoWidget:showOpenLvLabel(b)
	self.lvLabel:setVisible(b)
	return self
end 

-- 显示说明
function ArenaInfoWidget:showDescLabel(b)
	self.discLabel:setVisible(b)
	return self
end 

-- 显示 名字
function ArenaInfoWidget:showNameIcon(b)
	if self.nameIcon then 
		self.nameIcon:setVisible(b)
	end 
	return self
end 



return ArenaInfoWidget
