--[[
竞技场主场景
]]
local ArenaScene = class("ArenaScene", base.Scene)

function ArenaScene:initData()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.updateCoolTime))
    self:scheduleUpdate()
end

function ArenaScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer", {wealth="arena"}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

	local layer_ = self.layer_

--------------------------------------------------------
-- 背景框
	CommonView.backgroundFrame1()
	:addTo(self.layer_)
	:pos(435, 280)
	:zorder(2)

	display.newSprite("Player_Arena_Banner.png")
	:addTo(self.layer_, 2)
	:pos(200, 460)

------------------------------------------------------------

	-- user info
	display.newSprite(ArenaData:getDefaultBorder()):addTo(self.layer_, 2):pos(100, 495)
	self.icon_ = base.Grid.new():addTo(self.layer_, 2):pos(100, 495)--:hide()

	-- 排名
	base.Label.new({text="我的排名", size=20, color=cc.c3b(255,243,140)})
	:align(display.CENTER)
	:addTo(self.layer_, 2):pos(245, 510)
	-- 战斗力
	display.newSprite("word_battle_def.png")
	:addTo(self.layer_, 2):pos(130, 422)

	self.battleLabel_ = base.Grid.new():addTo(self.layer_, 2):setNormalImage(NumberData:font2(0)):pos(200, 422) 	-- 战斗力
	self.rankLabel_ = base.Grid.new():addTo(self.layer_, 2):setNormalImage(NumberData:font6(0)):pos(245, 470) 	-- 排名
	-- 战斗剩余次数
	base.Label.new({text="剩余次数：", size=20, color=cc.c3b(255,243,140)}):addTo(self.layer_, 2):pos(640, 360) -- 650
	self.battleNumLabel_ = base.Label.new({size=20, color=cc.c3b(255,243,140)}):addTo(self.layer_, 2)
	:pos(755, 360):align(display.CENTER)

	-- 增加剩余次数按钮
	self.plusBtn_ = cc.ui.UIPushButton.new({normal="Plus1.png"}):addTo(layer_, 2):pos(800, 360)
	:onButtonClicked(function(event)
		self:alertBuyTimes()
	end)

	-- 冷却时间
	base.Label.new({text="冷却时间：", size=20, color=cc.c3b(50,250,0)}):addTo(self.layer_, 2):pos(360, 360) -- 360
	self.coolTimeLabel_ = base.Label.new({size=20, color=cc.c3b(0,250,0)}):addTo(self.layer_, 2):pos(470, 360)

	self.challengeView_ = {}
	for i=1,4 do
		local grid = base.Grid.new():addTo(layer_, 2):pos((i - 1) * 198 + 140, 190)
		:addItems({
			display.newSprite("Arena_Enermy_Banner.png"),
			display.newSprite("Banner_Level.png"):zorder(5):pos(-45, 60),
			CommonButton.red("挑战", {size=30}):pos(0, -112)
				:onButtonClicked(function(event)
					CommonSound.click() -- 音效

					self:_challengeIndex(i)
				end),
			base.Grid.new():pos(0, 28)
			:addItem(display.newSprite(ArenaData:getDefaultBorder()))
				:onTouch(function(event)
	       			if event.name == "began" then
	       				self:showTeam(i)

	       			elseif event.name == "ended" then
	       				self:hideTeam()
	       			end

	    		end, cc.size(130, 130)),
		})
		:addItemsWithKey({
			rankLabel_ = base.Label.new({size=24, color=cc.c3b(250, 250, 250)}):pos(-5, 118):zorder(5), 		-- 排名
			battleLabel_ = base.Label.new({size=22, color=cc.c3b(250, 250, 0)}):pos(-10, -67):zorder(5), 	-- 战斗力
			nameLabel_ = base.Label.new({size=20}):pos(0, -40):align(display.CENTER):zorder(5), 	-- 名字
			lvLabel_ = base.Label.new({size=24, color=cc.c3b(250, 250,0)}):zorder(5):pos(-45, 60):align(display.CENTER):zorder(5), -- 等级
			})

		table.insert(self.challengeView_, grid)
	end

	-- 上按钮集合
	-- 刷新对手按钮
	self.refreshBtn_ = cc.ui.UIPushButton.new({normal="Arena_Button_1.png"})
	:addTo(layer_, 2)
	:pos(430, 460)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		print("刷新")
		self.refreshBtn_:setButtonEnabled(false)
		NetHandler.request("RefreshOppnentList", {onsuccess = handler(self, self.netRefreshTeam)}, self)
	end)

	-- 刷新冷却时间按钮 (重置时间)
	self.refreshTimeBtn_ = cc.ui.UIPushButton.new({normal="Arena_Button_5.png"})
	:addTo(layer_, 2)
	:pos(430, 460)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		-- body
		self:alertRefreshTime()
	end)

	-- 防守按钮
	cc.ui.UIPushButton.new({normal="Arena_Button_2.png"})
	:addTo(layer_, 2)
	:pos(545, 460)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		print("防守")
		app:pushScene("ArenaDefenseScene")
	end)

	-- 竞技排行
	cc.ui.UIPushButton.new({normal="Arena_Button_3.png"})
	:addTo(layer_, 2)
	:pos(660, 460)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		print("竞技排行")
		NetHandler.request("CommonRankingShow", {
			data = {param1 = 1},
			onsuccess = handler(self, self.netRank)
		}, self)
	end)


	-- 战报
	cc.ui.UIPushButton.new({normal="Arena_Button_4.png"})
	:addTo(layer_, 2)
	:pos(775, 460)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		print("战报")
		NetHandler.request("ShowBattleReport", {onsuccess = handler(self, self.netReport)}, self)
	end)

---------------------------------------------------------
-- 侧边按钮
	-- 竞技
	base.Grid.new()
	:setBackgroundImage("Label_Normal.png")
	:setSelectedImage("Label_Select.png", 2)
	:addItems({
		base.Label.new({text="竞技", size=22}):align(display.CENTER):pos(5, 0)
	})
	:addTo(self.layer_)
	:pos(885, 450)
	:zorder(5)
	:setSelected(true)

	-- 商店
	base.Grid.new()
	:setBackgroundImage("Label_Normal.png")
	:setSelectedImage("Label_Select.png", 2)
	:addItems({
		base.Label.new({text="商店", size=22}):align(display.CENTER):pos(5, 0)
	})
	:addTo(self.layer_)
	:pos(885, 375)
	:zorder(1)
	:onClicked(function(event)
		CommonSound.click() -- 音效

		SceneData:enterScene("ShopArena", self)
	end)

	-- 积分
	base.Grid.new()
	:setBackgroundImage("Label_Normal.png")
	:setSelectedImage("Label_Select.png", 2)
	:addItems({
		base.Label.new({text="积分", size=22}):align(display.CENTER):pos(5, 0)
	})
	:addTo(self.layer_)
	:pos(885, 300)
	:zorder(1)
	:onClicked(function(event)
		CommonSound.click() -- 音效

		app:enterScene("ArenaIntegralScene")
	end)

------------------------------------------------------------
-- 提示红点
	self.redPoint = display.newSprite("Point_Red.png"):addTo(self.layer_)
	:zorder(5)
	:pos(940, 330)
	:hide()

end

function ArenaScene:showTeam(index)
	if not self.teamLayer_ then
		self.teamView_ = {}
		local node = display.newNode():addTo(self, 10):zorder(11)
		display.newSprite("Defence_Show.png"):addTo(node)
		for i=1,5 do
			local grid = base.Grid.new():addTo(node):pos(i * 95 - 285, 0):scale(0.6)
			if i == 1 then grid:scale(0.8) end

			table.insert(self.teamView_, grid)
		end
		self.teamLayer_ = node
	end
	local posX = display.cx + (index - 2.5) * 100 - 45
	self.teamLayer_:show():pos(posX, display.cy+80)

	local data = self.teamList_[index]:getRoleList()
	for i,v in ipairs(data) do
		local grid = self.teamView_[i]
		grid:addItems({
			display.newSprite(v:getIcon()):zorder(2), 	-- 队员头像
			display.newSprite(v:getBorder()), 			-- 头像边框
			display.newSprite("Banner_Level.png"):pos(-40, 40):zorder(3),
			base.Label.new({text=tostring(v.level), size=24, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(-40, 40):zorder(4),
			createStarIcon(v.starLv):pos(-50, -30):zorder(5),
		})
	end
end

function ArenaScene:hideTeam()
	if self.teamLayer_ then
		for i,v in ipairs(self.teamView_) do
			v:removeItems()
		end
		self.teamLayer_:hide()
	end
end

function ArenaScene:updateData()

	-- 挑战战队
	self.teamList_ = ArenaData:getTeamList()

	-- 玩家自己战队
	self.team = ArenaTeam.new({
		rank 	= ArenaData.rank, 		-- 竞技场排名
		name 	= UserData.name, 		-- 战队名
		level 	= UserData:getUserLevel(), 	-- 战队总经验
		icon 	= UserData.headIcon, 	-- 战队头像
		battle 	= ArenaData:getBattle(), -- 战斗力
	})

end

function ArenaScene:updateView()
	self:updatePlayerIcon() -- 头像
	self:updatePlayerBattle() -- 战斗力
	self:updatePlayerRank() -- 排名
	self:updateBattleNum() -- 挑战剩余次数
	self:updateCoolTime() -- 冷却时间
	self:updateChallengeList() -- 更新挑战队列
	self:updateRedPoint()

end

function ArenaScene:updatePlayerIcon() -- 头像
	self.icon_:setNormalImage(self.team.icon)

	return self
end

function ArenaScene:updatePlayerBattle() -- 战斗力
	self.battleLabel_:setNormalImage(NumberData:font2(self.team:getBattle()))
	return self
end

function ArenaScene:updatePlayerRank() -- 排名
	self.rankLabel_:setNormalImage(NumberData:font6(self.team.rank, -2):align(display.CENTER):scale(0.9))
	return self
end

function ArenaScene:updateBattleNum() -- 挑战剩余次数
	self.battleNumLabel_:setString(string.format("%d/%d", ArenaData:haveBattleNum(), ArenaData.battleNumMax))

	self.plusBtn_:setVisible(ArenaData:haveBattleNum() < ArenaData.battleNumMax)

	return self
end

function ArenaScene:updateCoolTime(dt) -- 冷却时间
	if ArenaData:getCoolTime() <= 0 then
		self.coolTimeLabel_:setString("无冷却")
		self.refreshTimeBtn_:hide()
		self.refreshBtn_:show()
	else
		self.coolTimeLabel_:setString(formatTime1(ArenaData:getCoolTime()))
		self.refreshTimeBtn_:show()
		self.refreshBtn_:hide()
	end
end

function ArenaScene:updateChallengeList() -- 更新挑战队列
	for i,v in ipairs(self.challengeView_) do
		v:getItem("rankLabel_"):setString(tostring(self.teamList_[i].rank)) 	-- 战队排名
		v:getItem("nameLabel_"):setString(tostring(self.teamList_[i].name)) 	-- 战队名称
		v:getItem("lvLabel_"):setString(tostring(self.teamList_[i].level)) 		-- 战队等级
		v:getItem("battleLabel_"):setString(tostring(self.teamList_[i]:getBattle())) -- 战队战斗力
		v:addItemsWithKey({
			icon_ = display.newSprite(self.teamList_[i].icon):pos(0, 28):zorder(2), 	-- 战队头像
			})
	end
end

function ArenaScene:_challengeIndex(index)
	if ArenaData:getCoolTime() > 0 then
		self:alertRefreshTime()
	else
		if ArenaData:haveBattleNum() > 0 then -- 挑战剩余次数
			app:pushScene("ArenaReadyScene", {{
				otherTeam 	= ArenaData:getTeamList()[index],
				myTeam 		= self.team,
			}})
		else
			self:alertBuyTimes()
		end
	end
end

function ArenaScene:updateRedPoint()
	if ArenaData:haveAward() then
		self.redPoint:show()
	else
		self.redPoint:hide()
	end
end

function ArenaScene:alertBuyTimes()
	if UserData.diamond < ArenaData.timesCost then
		GemsAlert:show()
	else
		local msg = {
			base.Label.new({text="是否花费", size=22}):pos(30, 150),
			base.Label.new({text=string.format("x%d来购买%d次", ArenaData.timesCost, 1), size=22}):pos(200, 150),
			base.Label.new({text="挑战次数", size=22}):pos(200, 110):align(display.CENTER),
			display.newSprite("Diamond.png"):pos(150, 150),
		}

		AlertShow.show2("友情提示", msg, "确定", function( ... )
			NetHandler.request("BuyJingjiTimes", {onsuccess=handler(self, self.netBuyTimes)}, self)
		end)
	end
end

function ArenaScene:alertRefreshTime()
	print("重置时间")
	if UserData.diamond < ArenaData.refreshCost then
		GemsAlert:show()
	else
		local msg = {
			base.Label.new({text="是否花费", size=22}):pos(30, 130),
			base.Label.new({text=string.format("x%d来清除冷却时间", ArenaData.refreshCost), size=22}):pos(200, 130),
			display.newSprite("Diamond.png"):pos(150, 130),
		}

		AlertShow.show2("友情提示", msg, "确定", function()
			NetHandler.request("ClearArenaCool", {onsuccess=handler(self, self.netRefreshTime)}, self)
		end)
	end
end

-- 购买剩余挑战次数回调
function ArenaScene:netBuyTimes()
	showToast({text="成功购买挑战次数"})
	self:updateBattleNum()
end

-- 刷新冷却时间回调
function ArenaScene:netRefreshTime()
	showToast({text="成功清除冷却时间"})
end

-- 刷新挑战队列
function ArenaScene:netRefreshTeam()
	showToast({text="刷新挑战队列成功"})
	self.refreshBtn_:setButtonEnabled(true)
	self:updateData()
	self:updateChallengeList() -- 更新挑战队列
end

-- 竞技场战报
function ArenaScene:netReport()
	if self.reportLayer then
		self.reportLayer:removeSelf()
	end

	self.reportLayer = app:createView("arena.ArenaReportLayer")
	:addTo(self)
	:zorder(10)
	:onEvent(function(event)
		if event.name == "close" then
			event.target:removeSelf()
			self.reportLayer = nil
		end
	end)
end

-- 获取竞技场排行
function ArenaScene:netRank()
	if not self.rankLayer then
		self.rankLayer = app:createView("arena.ArenaRankLayer")
		:addTo(self)
		:zorder(10)

		self.rankLayer:onEvent(function(event)
			if event.name == "close" then
				event.target:hide()
			end
		end)
	end

	self.rankLayer
	:show()
	:updateShow()
end

--------------------------------------------------------------------
---- guide

function ArenaScene:onGuide()
	if UserData:getUserLevel() < OpenLvData.arena.openLv then return end

	if GuideData:isNotCompleted("Arena1") then    -- 竞技场 防御
        local posX = display.cx + 70
        local posY = display.cy + 150

        showTutorial2({
            text = GameConfig.tutor_talk["45"].talk,
            rect = cc.rect(posX, posY, 120, 120),
            x = posX - 290,
            y = posY+100,
            callback = function(target)
                app:pushScene("ArenaDefenseScene")
                target:removeSelf()
            end,
        })

    elseif GuideData:isNotCompleted("Arena2") then    -- 竞技场 后续
        self:showGuideTeam(function()
        	self:showStartGuide()
        end)
	end
end

function ArenaScene:showGuideTeam(callback)
	local grid = self.challengeView_[4]
	local point = convertPosition(grid, self)
	local posX = point.x
	local posY = point.y + 25
	local r = 120

	local guideLayer = showTutorial2({
        text = GameConfig.tutor_talk["51"].talk,
        rect = cc.rect(posX, posY, r, r),
        x = posX - 300,
        y = posY+100,
    })

    base.Grid.new()
    :addTo(guideLayer)
    :zorder(10)
    :pos(posX, posY)
    :onTouch(function (event)
    	if event.name == "began" then
			self:showTeam(2)
		elseif event.name == "ended" then
			self:hideTeam()
			guideLayer:removeSelf()
			if callback then
				callback()
			end
		end
    end, cc.size(r, r))


end

function ArenaScene:showStartGuide()
	local grid = self.challengeView_[4]
	local point = convertPosition(grid, self)

	UserData:showGuideLayer({
		text = GameConfig.tutor_talk["52"].talk,
		x = point.x,
		y = point.y - 100,
		offX = -300,
		offY = 100,
		autoremove = false,
		callback = function(target)
            GuideData:setCompleted("Arena2", function()
				self:_challengeIndex(4)
				target:removeSelf()
			end,
			function()
				target:removeSelf()
				self:showStartGuide()
			end)
        end,
	})


end


return ArenaScene