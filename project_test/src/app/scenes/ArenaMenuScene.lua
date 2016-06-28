--[[
竞技场列表 场景
]]

local ArenaMenuScene = class("ArenaMenuScene", base.Scene)

function ArenaMenuScene:initData()
	self.openArenaLv = OpenLvData.arena.openLv 		-- 开启竞技场等级
	self.openLookingLv = OpenLvData.wanted.openLv 	-- 开启日月追缉等级
	self.openEternalLv = 0 	-- 开启永恒之战等级
end

function ArenaMenuScene:initView()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer(200)
	:addTo(self)

	-- 按钮层
	self.menuLayer = app:createView("widget.MenuLayer", {wealth="arena"}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

	self.limitLayer = base.TouchNode.new()
	:center()
	:addTo(self, 10)
	:onEvent(function()

	end, cc.size(display.width, display.height))
	:hide()

-----------------------------
	local infoData = ArenaData.arenaInfo["1"]
	self.arenaWidget = app:createView("arena.ArenaInfoWidget", {
		nameIcon = "Arena_word_arena.png",
		desc = infoData.desc,
		openLv = string.format("%d级开启", self.openArenaLv),
	})
	:addTo(self.layer_)
	:pos(450, 300)
	:onButtonEnterCallback(function(event)
		if event.name == "enter" then
			self:performWithDelay(function()
				self:stopAllActions()
				event.target.grid:getBase("normalImage_"):playSequence("up", true)

				self:enterArenaScene()
			end, 0.5)
		elseif event.name == "up" then
			self:performWithDelay(function()
				event.target.grid:getBase("normalImage_"):playSequence("up", true)
				self:showLimitLayer(false)
			end, 0.5)
		elseif event.name == "down" then
			event.target.grid:getBase("normalImage_"):playSequence("down", true)
			self:showLimitLayer(true)
		end
	end)

	self.arenaWidget.grid
	:setNormalImage(
		GameGaf.new({
		    name = "arena_arena",
		    -- y = -40,
	    })
	    :start()
		:play("up", true).anim
	)

------------------------
	infoData = ArenaData.arenaInfo["2"]
	self.lookingWidget = app:createView("arena.ArenaInfoWidget", {
		nameIcon = "Arena_word_wanted.png",
		desc = infoData.desc,
		openLv = string.format("%d级开启", self.openLookingLv),
	})
	:addTo(self.layer_)
	:pos(170, 370)
	:onButtonEnterCallback(function(event)
		if event.name == "enter" then
			self:performWithDelay(function()
				event.target.grid:setSelected(false)
				self:stopAllActions()

				self:enterLookingFor()
			end, 0.5)
		elseif event.name == "up" then
			self:performWithDelay(function()
				event.target.grid:setSelected(false)
				self:showLimitLayer(false)
			end, 0.5)
		elseif event.name == "down" then
			event.target.grid:setSelected(true)
			self:showLimitLayer(true)
		end
	end)

	self.lookingWidget.grid
	:setSelectedImage(
		GameGaf.new({
	        name = "arena_wanted_2",
	        -- y = -40,
	    })
	    :start()
	    :play("idle", true).anim
    )
    :addItemWithKey("normalgaf",
    	GameGaf.new({
	        name = "arena_wanted_1",
	        -- y = -40,
	    })
	    :start()
		:play("idle", true).anim
	)
	:setDisabledImage(display.newSprite("Arena_wanted_dis.png"))


--------------------------
	infoData = ArenaData.arenaInfo["3"]
	self.eternalWidget = app:createView("arena.ArenaInfoWidget", {
		desc = infoData.desc,
		openLv = "敬请期待",
	})
	:addTo(self.layer_)
	:pos(730, 370)
	:onButtonEnterCallback(function(event)
		if event.name == "enter" then
			self:enterEternalWar()
		end
	end)
	:showDescLabel(false)

	self.eternalWidget.grid
	:setDisabledImage(display.newSprite("Arena_Eternalwar_dis.png"))

	self.eternalWidget.grid:setEnabled(false)

end

-- 屏蔽场景层
function ArenaMenuScene:showLimitLayer(b)
	self.limitLayer:setVisible(b)
end

function ArenaMenuScene:updateData()

end

function ArenaMenuScene:updateView()
	local lv = UserData:getUserLevel()
	self:operateWidget(lv, self.openArenaLv, self.arenaWidget)
	self:operateWidget(lv, self.openLookingLv, self.lookingWidget)
	self:showLimitLayer(false)
end

-- 进入竞技场
function ArenaMenuScene:enterArenaScene()
	print("enterArenaScene")
	if UserData:getUserLevel() >= self.openArenaLv then
		SceneData:pushScene("Arena", self, nil, function()
			self:showLimitLayer(false)
		end)
	end
end

-- 进入日月追缉
function ArenaMenuScene:enterLookingFor()
	print("enterLookingFor")
	if UserData:getUserLevel() >= self.openLookingLv then
		-- app:pushScene("ArenaLookingForScene")
		SceneData:pushScene("Wanted", self, nil, function()
			self:showLimitLayer(false)
		end)
	end
end

-- 进入永恒之战
function ArenaMenuScene:enterEternalWar()

end

-- 更新单元
function ArenaMenuScene:operateWidget(nowLevel, widgetLevel, widget)
	if nowLevel >= widgetLevel then -- 解锁状态
		widget
		-- :showLock(false)
		:showDescLabel(true)
		:showOpenLvLabel(false)
		:showNameIcon(true)

		widget.grid:setEnabled(true)

		local item = widget.grid:getItem("normalgaf")
		if item then
			item:show()
		end

	else -- 加锁状态
		widget
		-- :showLock(true)
		:showDescLabel(false)
		:showOpenLvLabel(true)
		:showNameIcon(false)

		widget.grid:setEnabled(false)

		local item = widget.grid:getItem("normalgaf")
		if item then
			item:hide()
		end
	end
end

--------------------------------------------------
-- 新手引导
function ArenaMenuScene:onGuide()
	if GuideData:isNotCompleted("Wanted") and UserData:getUserLevel() >= OpenLvData.wanted.openLv then
		local point = convertPosition(self.lookingWidget, self)
		UserData:showGuideLayer({
			text = GameConfig.tutor_talk["84"].talk,
			x = point.x,
			y = point.y,
			offX = 310,
			offY = 110,
			scale = -1,
			autoremove = false,
			callback = function(target)
	            GuideData:setCompleted("Wanted", function()
					self:enterLookingFor()
					target:removeSelf()
				end,
				function()
					target:removeSelf()
				end)
	        end,
		})
	end
end


return ArenaMenuScene
