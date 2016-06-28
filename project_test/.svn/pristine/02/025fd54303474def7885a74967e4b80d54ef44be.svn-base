--[[
城建 面板 界面
]]

local CityInfoScene = class("CityInfoScene", base.Scene)

function CityInfoScene:initData(params)
	self.data = params.data
	self.towerModel = params.towerModel
end

function CityInfoScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer"):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

--------------------------------------------------------
-- 背景框
	CommonView.backgroundFrame1()
	:addTo(self.layer_)
	:pos(435, 280)

	-- 建筑标题
	CommonView.nameFrame2()
	:addTo(self.layer_)
	:pos(220, 485)
	:zorder(2)

	-- 材料标题
	CommonView.nameFrame1()
	:addTo(self.layer_)
	:pos(620, 485)

	display.newSprite("word_lvup_material.png")
	:addTo(self.layer_)
	:pos(620, 485)
--------------------------------------------------------

--------------------------------
-- 城堡
	local ani = GameGaf.new({
        name = self.data.icon,
        -- x = 0,
        y = -100,
        scale = 0.9,
    })
    :start()
    :play("idle", true)

    local icon = ani.anim

	local grid = base.Grid.new()
	:addItem(CommonView.lines1():pos(0, -60))
	:addItem(icon)
	:addItem(display.newSprite("Castle_Star.png"):pos(70, -77))
	:addTo(self.layer_)
	:pos(220, 360)

	-- 星级
	self.starLvLabel = base.Label.new({size=20, color=cc.c3b(0,0,0), border=false})
	:align(display.CENTER)
	:pos(70, -80)

	grid:addItem(self.starLvLabel)

	-- 名字
	self.nameLabel = base.Label.new({size=22})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(220, 485)
	:zorder(2)
--------------------------------
-- 强化
	display.newSprite("Gold.png")
	:addTo(self.layer_)
	:pos(70, 240)

	self.costLabel = base.Label.new({size=22, color=cc.c3b(250,250,0)})
	:addTo(self.layer_)
	:pos(110, 240)

-- 按钮
	-- 强化
	self.strongBtn = CommonButton.green("强化")
	:addTo(self.layer_)
	:pos(130, 195)
	:onButtonClicked(function()
		self:onButtonStrongUp()
	end)

	-- 属性
	CommonButton.green("属性")
	:addTo(self.layer_)
	:pos(300, 195)
	:onButtonClicked(function()
		self:onButtonInfo()
	end)

	-- 升阶
	self.starBtn = CommonButton.green("升阶")
	:addTo(self.layer_)
	:pos(730, 195)
	:onButtonClicked(function()
		self:onButtonStarUp()
	end)

	local function addStarItem(x, y, idx)
		local grid = base.Grid.new()
		:addTo(self.layer_)
		:pos(x, y)

		local sGrid = base.Grid.new()
		:addItem(display.newSprite("AwakeStone0.png"):scale(0.7))
		:addItem(display.newSprite("Lock_Another_Small.png"))

		grid:setSelectedImage(sGrid)

		grid:addItemWithKey("countLabel", base.Label.new({
			size=18,
		}):pos(30, -30):align(display.CENTER))

		grid:onClicked(function()
			self:onSelectedStarItem(idx)
		end, cc.size(100, 100))

		return grid
	end

	display.newSprite("Castle_backgroung1.png")
	:addTo(self.layer_)
	:pos(620, 340)

	self.starupListView = {}
	table.insert(self.starupListView, addStarItem(500, 390, 1))
	table.insert(self.starupListView, addStarItem(620, 390, 2))
	table.insert(self.starupListView, addStarItem(740, 390, 3))
	table.insert(self.starupListView, addStarItem(500, 290, 4))
	table.insert(self.starupListView, addStarItem(620, 290, 5))
	table.insert(self.starupListView, addStarItem(740, 290, 6))

---------------------------------------
-- 技能列表
	self.listView_ = base.GridView.new({
		rows = 1,
		viewRect = cc.rect(0, 0, 750, 130),
		direction = "horizontal",
		itemSize = cc.size(150, 130),
	}):addTo(self.layer_)
	:setBounceable(false)
	:pos(80, 40)

-- 技能信息显示框
	self.skillTip = base.Grid.new()
	:setBackgroundImage(display.newSprite("Castle_Skill_Tip.png"))
	:addItemWithKey("skillTitle", base.Label.new({size=20}):pos(-190, 60))
	:addItemWithKey("skillDesc", base.Label.new({
		size=20,
		dimensions = cc.size(380, 400),
		align = cc.TEXT_ALIGNMENT_LEFT,
	}):pos(-0, 30):align(display.CENTER_TOP))
	:addTo(self, 10)
	:center()
	:hide()

end

-- 点击 强化按钮
function CityInfoScene:onButtonStrongUp()
	CommonSound.click() -- 音效
	print("强化按钮")

	if self.data.level < UserData:getUserLevel() then
		local cost = CityData:getStrongCost(self.data.id, self.data.level + 1)
		if cost > UserData.gold then
			showToast({text="金币不足"})
		else
			self:onStrongUp()
		end
	else
		showToast({text="已升到当前最大等级"})
	end
end

-- 强化
function CityInfoScene:onStrongUp()
	local cityTypeId = self.data.id 	-- 建筑id
	local level = self.data.level 		-- 当前等级
	NetHandler.request("CityQiangHua", {
		data = {
			param1 = checknumber(cityTypeId),
		},
		onsuccess = function()
			showToast({text="强化成功"})
			self:onStrongUpOk()
		end,
		onerror = function()

		end
	}, self)
end
-- 强化成功
function CityInfoScene:onStrongUpOk()
	self.towerModel:setLevel(self.data.level)
	CommonView.animation_lvup_light(self.layer_, {
		x = 220,
		y = 380,
	})

	self:updateNameLabel()
	self:updateStarLabel()
	self:updateStrongUp()
end

-- 点击 属性按钮
function CityInfoScene:onButtonInfo()
	CommonSound.click() -- 音效
	print("属性按钮")
	local layer = app:createView("city.CityInfoLayer", {
		name = self.data.name,
		towerModel = self.towerModel,
 	})
	:addTo(self, 10)
	:onEvent(function(event)
		if event.name == "close" then
			event.target:removeSelf()
		end
	end)

	return layer
end

-- 点击 升阶按钮
function CityInfoScene:onButtonStarUp()
	CommonSound.click() -- 音效
	print("升阶按钮")
	if CityData:canStarUp(self.data.id) then
		self:onStarUp()
	end
end

-- 点击 升阶按钮
function CityInfoScene:onStarUp()
	NetHandler.request("CityUpStar", {
		data = {
			param1 = checknumber(self.data.id),
		},
		onsuccess = function()
			showToast({text="升阶成功"})

			self:updateListView()
			self:updateStarListView()
			self:updateStarLabel()
			self:updateStarupButton()
		end,
		onerror = function()

		end
	}, self)
end

-- 显示 技能描述
function CityInfoScene:showSkillTip(skillData)
	local tip = self.skillTip
	tip:show()
	tip:getItem("skillTitle"):setString(skillData.name)
	tip:getItem("skillDesc"):setString(skillData.desc)
end

-- 隐藏 技能描述
function CityInfoScene:hideSkillTip()
	self.skillTip:hide()
end

-- 点击 升星需要的材料
function CityInfoScene:onSelectedStarItem(idx)
	CommonSound.click() -- 音效
	local item = self.data.data.items[idx]
	if item then
		local itemData = ItemData:getItemConfig(item.id)
		UserData:showItemDropLayer(itemData)
	end
end

----------------------------------------

function CityInfoScene:updateData()
	self.towerModel:setLevel(self.data.level)
end

function CityInfoScene:updateView()
	self:updateListView()
	self:updateStarListView()
	self:updateNameLabel()
	self:updateStarLabel()
	self:updateStrongUp()
	self:updateStarupButton()

	self:hideSkillTip()
end
-- 更新技能列表
function CityInfoScene:updateListView()
	local skillList = self.data.skillList

	self.listView_
	:removeAllItems()
	:addItems(#skillList, function(event)
		local index = event.index
		local skillId = skillList[index]
		print("id:", skillId)
		local skillData = CityData:getSkill(skillId)
		local grid = base.Grid.new()

		local icon = display.newSprite(skillData.icon)
		if not self.data.data:isSkillOpen(skillId) then
			icon:setColor(cc.c3b(100,100,100))
		end

		grid:addItem(icon)
		grid:addItem(display.newSprite(string.format("Castle_Skill_Star%d.png", index)):pos(0, -40))

		grid:onTouch(function(event)
			if event.name == "began" then
				self:showSkillTip(skillData)
			elseif event.name == "ended" then
				self:hideSkillTip()
			end
		end)

		return grid
	end)
	:reload()
end

-- 更新 升星消耗材料列表
function CityInfoScene:updateStarListView()
	local idx = 1
	for i,v in ipairs(self.data.data.items) do
		local grid = self.starupListView[i]
		grid:setSelected(false)

		grid:setBackgroundImage(UserData:createItemView(v.id, {tips=false}):scale(0.7))

		local itemCount = self:getItemCount(v.id)
		if self.isGuideStarup then
			itemCount = itemCount + v.num
		end
		local str = string.format("%d/%d", itemCount, v.num)
		grid:getItem("countLabel"):setString(str)

		idx = i + 1
	end

	for i=idx,6 do
		local grid = self.starupListView[i]
		grid:getItem("countLabel"):setString("")
		grid:setBackgroundImage(nil)
		grid:setSelected(true)
	end
end

function CityInfoScene:getItemCount(key)
	local item = ItemData:getItem(key)
	return item and item.count or 0
end

-- 更新 建筑名字等级
function CityInfoScene:updateNameLabel()
	self.nameLabel:setString(string.format("%s lv.%d", self.data.name, self.data.level))
end
-- 更新建筑星级
function CityInfoScene:updateStarLabel()
	self.starLvLabel:setString(tostring(self.data.data.star))
end
-- 更新 升星按钮
function CityInfoScene:updateStarupButton()
	local enable = true
	if not self.isGuideStarup then
		 enable = CityData:canStarUp(self.data.id)
	end

	self.starBtn:setButtonEnabled(enable)
end
-- 更新强化信息
function CityInfoScene:updateStrongUp()
	local cost = CityData:getStrongCost(self.data.id, self.data.level + 1)
	if cost > UserData.gold then
		self.costLabel:setColor(cc.c3b(250,0,0))
	else
		self.costLabel:setColor(cc.c3b(250,250,0))
	end
	self.costLabel:setString(tostring(cost))
end

---------------------------------------------------
-- 新手引导
function CityInfoScene:onGuide()
	if GuideData:isNotCompleted("Castle") then
		self.isGuideStarup = true
		self:updateStarListView()
		self:updateStarupButton()

		self:onGuideStrongUp()
	end

end

function CityInfoScene:onGuideStrongUp()
	local point = convertPosition(self.strongBtn, self)
	local cost = CityData:getStrongCost(self.data.id, self.data.level + 1)
	UserData:showGuideLayer({
		text = GameConfig.tutor_talk["70"].talk,
		x = point.x,
		y = point.y,
		offX = 290,
		offY = 120,
		scale = -1,
		callback = function()
			self.data.level = self.data.level + 1
			self:onStrongUpOk()
			self:onGuideInfo()
		end
	})
end

function CityInfoScene:onGuideInfo()
	local point = convertPosition(self.strongBtn, self)
	UserData:showGuideLayer({
		text = GameConfig.tutor_talk["71"].talk,
		x = display.cx - 180,
		y = display.cy - 125,
		offX = 290,
		offY = 120,
		scale = -1,
		callback = function()
			local layer = self:onButtonInfo()
			UserData:showGuideLayer({
				text = GameConfig.tutor_talk["72"].talk,
				x = display.cx + 250,
				y = display.cy + 170,
				offX = -300,
				offY = 60,
				callback = function()
					layer:removeSelf()
					self:onGuideStarUp()
				end
			})
		end
	})
end

function CityInfoScene:onGuideStarUp()
	local point = convertPosition(self.starBtn, self)
	UserData:showGuideLayer({
		text = GameConfig.tutor_talk["73"].talk,
		x = point.x,
		y = point.y,
		offX = -300,
		offY = 110,
		callback = function()
			self.isGuideStarup = false
			local nextId = self.data.data.nextCityId
			if nextId then
				CityData:setCity(self.data.id, nextId)
			end

			self:updateListView()
			self:updateStarListView()
			self:updateStarLabel()
			self:updateStarupButton()

			self:onGuideSkillInfo()
		end
	})
end

function CityInfoScene:onGuideSkillInfo()

	local gLayer = UserData:showGuideLayer({
		text = GameConfig.tutor_talk["74"].talk,
		autoremove = false,
		x = display.cx - 330,
		y = display.cy - 220,
		offX = 300,
		offY = 110,
		scale = -1,
	})
	local gzorder = gLayer:getLocalZOrder()
	local skillId = self.data.skillList[1]
	local skillData = CityData:getSkill(skillId)

	base.Grid.new({})
	:pos(display.cx - 330, display.cy - 220)
	:addTo(self)
	:zorder(gzorder)
	:onTouch(function(event)
		if event.name == "began" then
			self:showSkillTip(skillData)
		elseif event.name == "ended" then
			self:hideSkillTip()
			event.target:removeSelf()
			gLayer:removeSelf()

			self:onGuideFinish()
		end
	end, cc.size(130, 130))
end

function CityInfoScene:onGuideFinish()
	GuideData:setCompleted("Castle", function()
		TaskData:addTaskParams("city", 1)
	end)
end

return CityInfoScene


