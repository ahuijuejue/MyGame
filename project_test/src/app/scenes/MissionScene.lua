--[[
关卡场景
]]
local MissionScene = class("MissionScene", base.Scene)

--[[
@param options table 参数表
chapterId 章节id
stageId 关卡id
latestType 自动跳转到最新关卡. 1.普通关卡，2.精英章节
]]

function MissionScene:initData(options)
	self.items_ = {}
	self.openData_ = {}

	local toType = options.latestType
	local chapterId = options.chapterId
	local stageId = options.stageId
	if toType then
		local chapterData = ChapterData:getLatestChapter(options.latestType == 2)
		chapterId = chapterData.id
		stageId = nil
	elseif stageId then
		-- print("stage id:", stageId)
		local stageData = ChapterData:getStage(stageId)
		chapterId = stageData.chapterId
	end

	self.chapterData_ = ChapterData:getChapter(chapterId)
	self.chapterId = chapterId

	self.selectedIndex_ = 0

	if stageId then
		local idx = ChapterData:getIndexOfStage(chapterId, stageId)
		if idx > 0 and ChapterData:isStageOpen(stageId) then
			self.selectedIndex_ = idx
		end
	elseif ChapterData:isChapterOver(chapterId) then
		self.selectedIndex_ = 1
	end
end

function MissionScene:initView(options)
	-- self:loadImage("texture_account.plist", "texture_account.pvr.ccz")
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	self.menuLayer = app:createView("widget.MenuLayer", {autoOpen=true}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

-------------------------------------------------
-- 背景框
	CommonView.boardFrame1()
	:addTo(self.layer_)
	:pos(435, 280)

	display.newSprite("Stage_Left.png"):addTo(self.layer_):pos(575, 295)
	display.newSprite("Stage_Right.png"):addTo(self.layer_):pos(173, 280)
	display.newSprite("Stage_SubBack1.png"):addTo(self.layer_):pos(575, 195)
	display.newSprite("Stage_Line.png"):addTo(self.layer_):pos(575, 465)

	-- 三星条件
	base.Label.new({text="三星条件：", color=cc.c3b(255,255,0), size=20})
	:addTo(self.layer_):pos(370, 380)

	-- 可能掉落
	display.newSprite("Word_Fall.png"):addTo(self.layer_):pos(420, 240)--:scale(0.9)

	-- 体力
	base.Label.new({text=string.format("体力消耗：%d", self.chapterData_.power), color=cc.c3b(255,255,250), size=20})
	:addTo(self.layer_):pos(370, 415)

	display.newSprite("Energy.png"):addTo(self.layer_):pos(525, 415):scale(0.5)

	-- 星星
	for i=1,3 do
		display.newSprite("Star_Gray.png"):addTo(self.layer_):pos(675 + 35 * i, 470)
	end

	display.newSprite("Star_Yellow.png"):addTo(self.layer_):pos(665, 526)
	for i=1,3 do
		display.newSprite("Star_Yellow.png"):addTo(self.layer_):pos(410, 250 + i * 35):scale(0.7)
	end

-------------------------------------------------
-------------------------------------------------
-- 关卡列表
	-- 箭头
	local arrowUp = display.newSprite("UpAndDown.png"):pos(170, 515):addTo(self.layer_):rotation(0):hide()
	local arrowDown = display.newSprite("UpAndDown.png"):pos(170, 40):addTo(self.layer_):rotation(180):hide()
	self.arrow_ = {arrowUp, arrowDown}

	-- 列表
	self.listView_ = base.GridViewOne.new({
		viewRect = cc.rect(0, 0, 256, 410),
		itemSize = cc.size(256, 113),
		page = true,
	})
	:addTo(self.layer_)
	:zorder(5)
	:pos(40, 78)
	:setBounceable(false)
	:onTouch(function(event)
		if event.name == "selected" then
			local index = event.index
			if index then
				self:selectedIndex(index)

				CommonSound.click() -- 音效
			end

		elseif event.name == "moved" or event.name == "page_ended" then
			self:updateArrow()
		end

	end)

-------------------------------------------------
-- 按钮
	-- 出征 按钮
	self.startBtn = CommonButton.button({
		normal="Button_Ready.png",
		pressed="Button_Ready_Light.png"
	})
	:addTo(self.layer_)
	:pos(720, 85)
	:onButtonClicked(function()
		CommonSound.click() -- 音效

		self:startGame()
	end)

	createAniArrow():addTo(self.layer_, 10)
	:pos(720, 160)

---------------------
	-- 扫荡
	local btnSweep = display.newNode():hide():pos(310, 85)

	-- 扫荡
	CommonButton.yellow("扫荡", {borderColor=cc.c4b(69,31,4,255)})
	:addTo(btnSweep)
	:pos(90, 0)
	:onButtonClicked(function()
		CommonSound.click() -- 音效

		self:didSweep()
	end)

	-- 扫荡n次
	self.btnSweepN_ = CommonButton.yellow(string.format("扫荡%d次", self.chapterData_.sweep), {borderColor=cc.c4b(69,31,4,255)})
	:addTo(btnSweep)
	:pos(230, 0)
	:onButtonClicked(function()
		CommonSound.click() -- 音效

		self:didSweepN()
	end)

--------------------------------------------------
-- 活动元件
	self.grid_ = base.Grid.new():addTo(self.layer_):zorder(2)


	self.grid_:addItemsWithKey({
		btnSweep = btnSweep,
		labelSweep = base.Label.new({text="关卡达到三星可以\n开启扫荡功能", size=20, color=cc.c3b(0,250,10)}):pos(390, 85):hide(),
		dropItems = display.newNode():pos(430, 175),
		--
		chapter = base.Label.new({size=22, color=cc.c3b(250,250, 0)}):pos(530, 525):align(display.CENTER), -- 章节名
		mission = base.Label.new({size=20, color=cc.c3b(0,250, 250)}):pos(400, 470), -- 关卡名
		chapterStar = base.Label.new({size=20}):pos(690, 525), -- 章节获得星星
		labelStar1 = base.Label.new({size=20}):pos(430, 355),
		labelStar2 = base.Label.new({size=20}):pos(430, 320),
		labelStar3 = base.Label.new({size=20}):pos(430, 285),
		star1 = display.newSprite("Star_Yellow.png"):pos(710, 470),
		star2 = display.newSprite("Star_Yellow.png"):pos(745, 470),
		star3 = display.newSprite("Star_Yellow.png"):pos(780, 470),

	})

----------------------------------------------------
-- 精英关卡
	if self:isElite() then
		self.grid_:addItem(base.Label.new({text="剩余次数：", color=cc.c3b(255,255,250), size=20}):pos(630, 385))

		-- 增加 剩余次数
		self.remainingPlus_ = cc.ui.UIPushButton.new({
			normal = "Plus2.png",
		})
		:pos(800, 385)
		-- :hide()
		:onButtonClicked(function(event)
			CommonSound.click() -- 音效

			self:toAddEliteTimes()
		end)

		self.grid_:addItem(self.remainingPlus_)

		-- 剩余次数 显示
		self.grid_:addItemWithKey("remaining", base.Label.new({color=cc.c3b(255,255,250), size=20}):pos(740, 385))
	end
------------------------------------------------------

end

-- 是否是精英关卡
function MissionScene:toAddEliteTimes()
	print("增加精英关卡次数")
	local data = self:getSelectedData()
	ElitAlert:show(data.id, function()
		self:showInfoView(self.selectedIndex_)
		self:updateSweepButton()
	end)
end

-- 是否是精英关卡
function MissionScene:isElite()
	return self.chapterData_:isElite()
end

function MissionScene:selectedIndex(index)
	print("index:", index)
	if self.selectedIndex_ ~= index and #self.items_ > 0 then
		self:__selectedIndex(index)
	end
end

function MissionScene:__selectedIndex(index)
	if index < 1 then
		local nCount = #self.items_
		for i=1,nCount do
			local stage = self.items_[nCount - i + 1]
			if ChapterData:isStageOpen(stage.id) then
				index = nCount - i + 1
				break
			end
		end
	end

	local data = self.items_[index]
	if data and ChapterData:isStageOpen(data.id) then
		self.listView_:walkItems(function(event)
			event.item:setSelected(index == event.index)
		end)

		self.selectedIndex_ = index
		self:showInfoView(index)

		self.listView_:showRow(index)
	end

	self:updateSweepButton()
end

function MissionScene:getSelectedData()
	local index = self.selectedIndex_
	return self.items_[index]
end

function MissionScene:showInfoView(index) -- 显示关卡信息
	local data = self.items_[index]
	local grid = self.grid_
	grid:getItem("mission"):setString(string.format("%s  %s", data.preName, data.name))
	grid:getItem("labelStar1"):setString(data.star1)
	grid:getItem("labelStar2"):setString(string.format("%d秒内通关", data.star2))
	grid:getItem("labelStar3"):setString(data.star3Str)

	-- 关卡种类
	if data.type > 1 then
		grid:addItemsWithKey({
			typeMark = self:createMark(data):pos(660, 470)
		})
	else
		grid:addItemWithKey("typeMark", nil)
	end
	-- 3星通关
	if data.passLevel >= 3 then
		grid:getItem("btnSweep"):show()
		grid:getItem("labelSweep"):hide()
	else
		grid:getItem("labelSweep"):show()
		grid:getItem("btnSweep"):hide()
	end
	-- 关卡星级显示
	for i=1,3 do
		if data.passLevel >= i then
			grid:getItem(string.format("star%d", i)):show()
		else
			grid:getItem(string.format("star%d", i)):hide()
		end
	end

	if self:isElite() then -- 精英关卡
		-- dump(data)
		grid:getItem("remaining"):setString(string.format("%d/%d", data:getEliteTimes(), data.passLimit))
		-- 剩余次数
		if data:getEliteTimes() > 0 then
			self.remainingPlus_:hide()
		else
			self.remainingPlus_:show()
		end
	end
	-- 可能掉落
	local dropLayer = grid:getItem("dropItems")
	dropLayer:removeAllChildren()
	for i,v in ipairs(data.dropItems) do
		UserData:createItemView(v):addTo(dropLayer):pos((i - 1) * 105, 0):scale(0.7)
	end

end

function MissionScene:createMark(data)
	local spr = display.newSprite("Stage_Mark.png")
	base.Label.new({text=data:getMarkName(), size=20}):align(display.CENTER)
	:addTo(spr)
	:pos(32.5, 20)

	return spr
end

function MissionScene:didSweep()
	print("扫荡")
	local stage = self:getSelectedData()
	if self:isElite() and stage:getEliteTimes() < 1 then
		self:alertNotEnough()
		return
	end
	self:didSweep_(1)

end

function MissionScene:didSweepN()
	local stage = self:getSelectedData()
	if self:isElite() and stage:getEliteTimes() < 1 then
		self:alertNotEnough()
		return
	end

	if VipData:canSweep() then
		self:didSweep_(self:getSweepNum())
	else
		showToast({text="需要VIP达到4级", time=1})
	end

end

function MissionScene:getSweepNum()
	local count = math.floor(UserData.power/self.chapterData_.power)
	count = math.min(count, self.chapterData_.sweep)
	if self:isElite() then
		local stage = self:getSelectedData()
		count = math.min(count, stage:getEliteTimes())
	end
	return count
end

function MissionScene:didSweep_(num)
	if num == 0 or UserData.power < self.chapterData_.power * num then
		self:alertPowerNotEnough()
	else
		showLoading()
		local data = self:getSelectedData()
		NetHandler.request("SaoDang", {
			data = {
				param1 = data.id,
				param2 = num,
				param3 = data.stageType,
			},
			onsuccess= function(params)
				hideLoading()
				self:netSweepOk(params.items, function()
					if params.levelUp then
						UserData:showTeamLevelUp(params.levelUp, function()
							if params.isSecret then
								UserData:showSecretTalk(params.isSecret, function()
									self:onGuide()
								end)
							else
								self:onGuide()
							end
						end)
					else
						if params.isSecret then
							UserData:showSecretTalk(params.isSecret, function()
								self:onGuide()
							end)
						else
							self:onGuide()
						end
					end

				end)
			end,
			onerror=function()
				hideLoading()
			end
		}, self)
	end
end

-- 点击开始游戏
function MissionScene:startGame()
	print("出征")
	local data = self:getSelectedData()
	if self:isElite() and data:getEliteTimes() < 1 then
		self:alertNotEnough()
		return
	end

	if UserData.power < self.chapterData_.power then
		self:alertPowerNotEnough()
		return
	end

	local chapterId = data.chapterId
	local stageId = data.id

	app:pushScene("ReadyPlayScene", {{chapterId=chapterId, stageId=stageId, stageType=self.chapterData_.type}})

end
-- 挑战次数已达上限
function MissionScene:alertNotEnough()
	-- base.AlertBar.simpleShow({
	-- 	text = "挑战次数已达上限",
	-- 	-- time = 3,
	-- })
	self:toAddEliteTimes()
end

-- 挑战次数已达上限
function MissionScene:alertPowerNotEnough()
	-- base.AlertBar.simpleShow({
	-- 	text = "体力不足",
	-- 	-- time = 3,
	-- })

	PowerAlert:show()
end

function MissionScene:onEnter()
	MissionScene.super.onEnter(self)

	self.updateEp = GameDispatcher:addEventListener(EVENT_CONSTANT.UPDATE_USER_EP, function()
		self:updateSweepButton()
	end)

	self:updateSecretShopTip()

end

function MissionScene:updateSecretShopTip()

	if UserData:getSecretShopTip() then
		local cScene = display.getRunningScene()
		app:createView("shop.SecretShopTip"):addTo(cScene)
		:zorder(100)
		UserData:setSecretShopTip(false)
	end
end

function MissionScene:netSweepOk(params, callback)
	local items = params.items
	local items2 = params.items2
	local stageId = params.stageId
	local data = ChapterData:getStage(stageId)
	if data then
		self.sweepLayer = app:createView("sweep.SweepDisplayLayer", {
			name =	data.name,
			drops = items,
			drugs = items2,
			gold = params.gold,
			soul = params.soul,
			exp = data:getTeamExp(),
		}):addTo(self)
		:zorder(10)
		:onEvent(function(event)
			if event.name == "close" then
				event.target:removeSelf()
				if callback then callback() end
			elseif event.name == "completed" then
				if self:isElite() then
					self:updateElite()
				end
			end
		end)
		:start()

	end
	self:updateSweepButton()

end

function MissionScene:updateData()
	self.items_ = ChapterData:getShowStages(self.chapterId)

end


function MissionScene:updateView()
	self:updateListView()
	self:updateArrow()
	self:updateChapterInfo()
	self:__selectedIndex(self.selectedIndex_)
	-- self:updateSweepButton()
end

function MissionScene:updateListView()
	self.listView_
	:resetData()
	:addSection({
		count=#self.items_,
		getItem = handler(self, self.createItem)
	})
	:reload()
end

function MissionScene:createItem(event)
	local index = event.index
	local data = self.items_[index]
	-- dump(data)
	local grid = base.Grid.new()

	local preName = base.Label.new({text = data.preName, color=cc.c3b(0,250, 250), size=20})
	local stageName = base.Label.new({text = data.name, size=20}):align(display.CENTER)

	if data:isMainStage() then
		grid:setNormalImage(display.newSprite("Button.png"))
		grid:setSelectedImage(display.newSprite("Button_Select.png"), 2)
		preName:pos(-105, 27)
		stageName:pos(0, 0)
	else
		grid:setNormalImage(display.newSprite("SubStage_Button.png"):pos(20, 0))
		grid:setSelectedImage(display.newSprite("SubStage_Select.png"):pos(20, 0), 2)
		preName:pos(-65, 27)
		stageName:pos(20, 0)
		grid:addItem(display.newSprite("SubStage_Line.png"):pos(-115, 0))
	end
	grid:addItem(preName)
	grid:addItem(stageName)

	if data.type > 1 then
		grid:addItem(self:createMark(data):pos(90, 27))
	end

	if ChapterData:isStageOpen(data.id) then -- 关卡解锁
		local stars = {}
		for i=1,3 do
			local star = display.newSprite("Star_Gray.png"):pos(30 + 20 * i, -30):scale(0.6)
			table.insert(stars, star)
			if data.passLevel >= i then
				star = display.newSprite("Star_Yellow.png"):pos(30 + 20 * i, -30):scale(0.6)
				table.insert(stars, star)
			end
		end
		grid:addItems(stars)
	else
		grid:addItem(base.Label.new({text="未开放", size=20}):align(display.CENTER):pos(70, -30))
	end

	return grid
end

function MissionScene:updateArrow()
	local rect = self.listView_:getScrollNodeRect()
	local viewRect = self.listView_:getViewRect()

	local scrollY = self.listView_:getScrollNode():getPositionY()
	if scrollY < viewRect.y then
		self.arrow_[2]:show()
	else
		self.arrow_[2]:hide()
	end

	if scrollY + rect.height > viewRect.y + viewRect.height then
		self.arrow_[1]:show()
	else
		self.arrow_[1]:hide()
	end

end

function MissionScene:updateChapterInfo() -- 显示章节信息
	local data = self.chapterData_
	local star, starMax = ChapterData:getChapterStar(self.chapterId)
	-- dump(data, "chapter")
	self.grid_:getItem("chapter"):setString(string.format("%s %s", data.preName, data.name))
	self.grid_:getItem("chapterStar"):setString(string.format("%d/%d", star, starMax))
	-- self.grid_:getItem("sweep"):setString(string.format("%s/10", ChapterData.sweepTimes))

end
-- 更新多次扫荡按钮次数显示
function MissionScene:updateSweepButton()
	local count = self:getSweepNum()
	self.btnSweepN_:setButtonLabelString(string.format("扫荡%d次", count))
end

-- 更新精英次数 ui
function MissionScene:updateElite()
	if not self:isElite() then return end
	-- 精英关卡
	local data = self:getSelectedData()
	if data then
		local grid = self.grid_
		-- 剩余次数
		grid:getItem("remaining"):setString(string.format("%d/%d", data:getEliteTimes(), data.passLimit))
		if data:getEliteTimes() > 0 then
			self.remainingPlus_:hide()
		else
			self.remainingPlus_:show()
		end
	end
end

--------------------------------------------------
-- 新手引导
function MissionScene:onGuide()
	GuideManager:makeGuide(self)
	-- local keys = GuideData.key

	-- if self:showStartGuide({name=keys.superHero}) then
	-- 	self:selectedIndex(self:getSortIndex(1, 0))
	-- elseif self:showStartGuide({name=keys.sortTeam}) then
	-- 	self:selectedIndex(self:getSortIndex(2, 0))
	-- elseif GuideManager:makeGuide() then
	-- 	self.menuLayer:openMenuNode()
 --    end
end

function MissionScene:getSortIndex(sort1, sort2)
	for i,v in ipairs(self.items_) do
		if v.sort == sort1 and v.sort2 == sort2 then
			return i
		end
	end
	return 1
end

function MissionScene:showStartGuide(params)
	if GuideData:isNotCompleted(params.name) then
		local posX = display.cx + 285
    	local posY = display.cy - 240

        showTutorial2({
            text = GameConfig.tutor_talk["12"].talk,
            rect = cc.rect(posX, posY, 200, 85),
            x = posX - 250,
            y = posY + 120,
            callback = function(target)
                self:startGame()
                target:removeSelf()
            end,
        })

        return true
	end
	return false
end

function MissionScene:onExit()
	GameDispatcher:removeEventListener(self.updateEp)

	MissionScene.super.onExit(self)
end

return MissionScene