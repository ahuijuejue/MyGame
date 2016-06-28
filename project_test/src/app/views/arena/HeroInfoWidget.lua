--[[
追缉的 敌人 控件
]]

local HeroInfoWidget = class("HeroInfoWidget", function()
	return display.newNode()
end)

function HeroInfoWidget:ctor()
	
	self:initView()
end

function HeroInfoWidget:initView()

	display.newSprite("Wanted_Hero.png")
	:addTo(self)
	
	self.widget = base.Grid.new()
	:addTo(self)
	:pos(-5, 20)

	self.widget:addItem(display.newSprite("Banner_Level.png"):pos(-45, 40):zorder(4))

	self.widget:addItemWithKey("lv", base.Label.new({
		size = 20,
		color = CommonView.color_yellow(),
	}):pos(-45, 40):zorder(5)
	:align(display.CENTER))

	
	-- 名字
	self.nameLabel = base.Label.new({
		size = 24,
		color = CommonView.color_black(),
		border = false,
		-- borderColor = cc.c4b(255,0,0,255),
	})
	:align(display.CENTER)
	:pos(0, -88)
	:addTo(self)

	-- 战力

	self.battleLabel = base.Label.new({		
		size = 24,
		color = CommonView.color_black(),
		border = false,
	})
	:pos(-15, -120)
	:addTo(self)

	-- 点击层
	base.TouchNode.new()
	:addTo(self)
	:pos(self.widget:getPosition())
	:onEvent(function(event)
		if "began" == event.name then 			
			self:showList(true)
		elseif "moved" == event.name then
			self:showList(false)
		elseif "ended" == event.name then
			self:showList(false)
		end 
	end, cc.size(150, 150))


	-- 队员列表层
	self.listLayer = display.newNode()
	:addTo(self)
	:pos(0, 130)
	:zorder(5)
	:hide()

end

-- 事件回调
function HeroInfoWidget:onEvent(listener)
	self.eventListener = listener 
	return self
end

function HeroInfoWidget:onEvent_(event)
	if not self.eventListener then return end 
	event.target = self 
	self.eventListener(event)
end


-- 名字
function HeroInfoWidget:setName(txt)
	self.nameLabel:setString(txt)
	return self
end

-- 等级
function HeroInfoWidget:setLevel(value)
	self.widget:getItem("lv"):setString(tostring(value))
	return self
end

-- 图像
function HeroInfoWidget:setIcon(filename)
	self.widget:addItemWithKey("icon", display.newSprite(filename):zorder(2))
	return self
end

-- 图像
function HeroInfoWidget:setBorder(filename)
	self.widget:addItemWithKey("border", display.newSprite(filename))
	return self
end

-- 战斗力
function HeroInfoWidget:setBattle(value)
	self.battleLabel:setString(tostring(value))
	return self
end

-- 设置队员
function HeroInfoWidget:setList(list)
	self.listLayer:removeAllChildren()

	display.newSprite("Defence_Show.png")
	:addTo(self.listLayer)

	for i,v in ipairs(list or {}) do
		local grid = base.Grid.new()
		:addTo(self.listLayer)
		:pos(i * 95 - 285, 0)
		:scale(0.6)

		if i == 1 then grid:scale(0.8) end 

		grid:addItems({
			display.newSprite(v:getIcon()):zorder(2), 	-- 队员头像
			display.newSprite(v:getBorder()), 			-- 头像边框 
			display.newSprite("Banner_Level.png"):pos(-40, 40):zorder(3),
			base.Label.new({text=tostring(v.level), size=24, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(-40, 40):zorder(4),
			createStarIcon(v.starLv):pos(-50, -30):zorder(5),
		})


	end
	return self
end

-- 显示队员列表
function HeroInfoWidget:showList(b)
	print("show list:", b)
	self.listLayer:setVisible(b)
end

return HeroInfoWidget
