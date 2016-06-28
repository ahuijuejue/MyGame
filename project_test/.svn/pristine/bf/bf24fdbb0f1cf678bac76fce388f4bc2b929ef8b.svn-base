--[[
任务选择条
]]
local TaskGrid = class("TaskGrid", base.TableNode)
local GafNode = import("app.ui.GafNode")

function TaskGrid:ctor(params)
	params = params or {}
	TaskGrid.super.ctor(self, params)	
	-- print("\n\nnew flag:", params.flag)
	self:initView(params)
end 

function TaskGrid:initView(params)
	self:initBackground()
	self:initTaskName()
	self:initTaskDesc()
	self:initTaskIcon()
	self:initRewardLayer()
	self:initAchieveState()
end 



-- 初始化 固定ui
function TaskGrid:initBackground()	
	self.backgroundWidget = display.newNode()
	:addTo(self)

	-- 背景图片
	self.backbarname = ""
	self.backbar = nil

	return self
end

-- 初始化 任务 名
function TaskGrid:initTaskName()
	self.taskname = base.Label.new({
		size=25
	})
	:pos(-210, 10)
	:align(display.LEFT_BOTTOM)
	:addTo(self)

	return self
end

-- 初始化 任务 描述
function TaskGrid:initTaskDesc()
	self.taskdesc = base.Label.new({
		size=22, 
		color=CommonView.color_green()
	})
	:pos(-80, 10)
	:align(display.LEFT_BOTTOM)
	:addTo(self)

	return self
end

-- 初始化 任务 完成数量
function TaskGrid:initAchieveState()
	self.achievelabel = base.Label.new({
		size=25, 
		color=cc.c3b(250,250,250)
	})
	:align(display.CENTER)
	:pos(270, 33)
	:addTo(self)

	return self
end

-- 初始化 任务 icon
function TaskGrid:initTaskIcon()
	self.iconWidget = display.newNode()
	:addTo(self)
	:pos(-300, 0)

	-- icon背景框
	self.iconbordername = ""
	self.iconborder = nil

	-- icon图片
	self.iconname = ""
	self.icon = nil

	return self
end

-- 初始化 奖励层
function TaskGrid:initRewardLayer()
	-- 奖励字
	base.Label.new({
		text = "奖励", 
		color=cc.c3b(255, 255, 0),
		size = 25,
	})
	:pos(-200, -20)
	:addTo(self)

	self.rewardlayer = display.newNode()
	:addTo(self)
	:pos(-150, -20)

	return self
end

-- 初始化 完成按钮
function TaskGrid:initOkButton(callback)
	CommonButton.green("完成")
	:addTo(self)
	:pos(270, -15)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		if callback then 
			event.target = self
			callback(event)
		end 
	end)

    CommonView.animation_btn1()
    :addTo(self)
    :pos(270, -13)

	return self
end

-- 初始化 前往按钮
function TaskGrid:initGotoButton(callback)
	CommonButton.yellow("前往")
	:addTo(self)
	:pos(270, -15)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		if callback then 
			event.target = self
			callback(event)
		end 
	end)

	return self
end

-- 初始化 时间未到 状态
function TaskGrid:initTimeButton(callback)
	base.Label.new({
		text="时间未到", 
		size=22, 
		color=cc.c3b(250,250,0)
	})
	:align(display.CENTER)
	:addTo(self)
	:pos(270, -15)

	if callback then 
		callback()
	end 

	return self
end

---------------------------------------------------------
---------------------------------------------------------
--[[
设置应用部分
]]

-- 设置背景框
function TaskGrid:setBackground(name)
	if self.backbarname ~= name then 
		-- print("\n\nset background:", name)
		if self.backbar then 
			self.backbar:removeSelf()
			self.backbar = nil
		end 
		self.backbarname = name
		self.backbar = display.newSprite(name)
		:addTo(self.backgroundWidget)
	end
	return self
end 

-- 设置 图标 背景框
function TaskGrid:setIconBorder(name)
	if self.iconbordername ~= name then 
		if self.iconborder then 
			self.iconborder:removeSelf()
			self.iconborder = nil 
		end 
		self.iconbordername = name 
		self.iconborder = display.newSprite(name)
		:addTo(self.iconWidget)
		:zorder(2)
	end 

	return self
end 

-- 设置 图标
function TaskGrid:setIcon(name)
	if self.iconname ~= name then 
		if self.icon then 
			self.icon:removeSelf()
			self.icon = nil 
		end 
		self.iconname = name 
		self.icon = display.newSprite(name)
		:addTo(self.iconWidget)
		:zorder(3)
	end 

	return self
end 

-- 增加奖励 
function TaskGrid:addRewards(items)
	local width = 10 
	local addX = 15 -- 与下个icon的间距
	local addL = 15 -- icon 和 label 间距
	for i,v in ipairs(items) do		
		local rewardGrid = display.newNode():scale(0.8)		
		v.icon:addTo(rewardGrid)
		local sprW = v.icon:getCascadeBoundingBox().width 

		self:addReward(rewardGrid, width + sprW * 0.5, 0)
		if v.count > 1 then 
			local rewardLabel = base.Label.new({text=tostring(v.count), size=24, color=cc.c3b(250,250,250)}):align(display.CENTER_LEFT):pos(sprW * 0.5 + addL, 0)
			rewardLabel:addTo(rewardGrid)
			sprW = sprW + rewardLabel:getContentSize().width + addL
		end 
		width = width + sprW + addX
	end

	return self
end 

-- 增加奖励 
function TaskGrid:addReward(grid, x, y)
	grid
	:pos(x, y)
	:addTo(self.rewardlayer)
end 

-- 删除所有奖励 
function TaskGrid:removeRewards()
	self.rewardlayer:removeAllChildren()

	return self
end 

-- 设置完成状态 
function TaskGrid:setAchieve(txt)	
	self.achievelabel:setString(txt)

	return self
end 

-- 设置完成状态 
function TaskGrid:showAchieve(b)
	self.achievelabel:setVisible(b)

	return self
end 

-- 设置任务名
function TaskGrid:setTaskName(txt)
	self.taskname:setString(txt)
	return self
end 

-- 设置任务描述
function TaskGrid:setTaskDesc(txt)
	self.taskdesc:setString(txt)
	return self
end 

return TaskGrid












