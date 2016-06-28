--[[
艾恩葛朗特场景
]]
local AincradScene = class("AincradScene", base.Scene)

function AincradScene:initData()
	self.canStart = false
end

function AincradScene:initView()
	self:autoCleanImage()
	-- 背景
	-- CommonView.background_aincrad()
	-- :addTo(self)
	-- :center()
	app:createView("aincrad.AincradBackground")
	:addTo(self)

	display.newSprite("main_bottom_bg.png")
	:addTo(self)
	:pos(display.cx, display.top - 30)

	display.newSprite("main_bottom_bg.png")
	:flipY(true)
	:addTo(self)
	:pos(display.cx, display.bottom + 30)

	-- 按钮层
	app:createView("widget.MenuLayer", {wealth="castle"}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)


---------------------------------------------------------------------
-- 全部通过
	self.okLayer = display.newSprite("Anicrad_Win.jpg"):addTo(self):center():hide()
	local size = self.okLayer:getContentSize()
	display.newSprite("Word_Anicrad_Win.png"):addTo(self.okLayer)
	:pos(size.width*0.5, size.height*0.5)

---------------------------------------------------------------------

	-- 重新开始 按钮
	app:createView("aincrad.AincradButton"):addTo(self)
	:pos(display.left + 80, display.bottom + 28)
	:zorder(1)
	:onEvent(function()
		self:onButtonRestart()
	end)

	-- 商店按钮
	CommonButton.button({
		normal = "Aincrad_Shop.png",
	})
	:addTo(self, 5)
	:pos(display.left + 110, display.top - 160)
	:onButtonClicked(function()
		NetHandler.gameRequest("OpenShop",{param1 = 6})
	end)

	-- 排行按钮
	CommonButton.button({
		normal = "aincrad_btn_ranking.png",
	})
	:addTo(self, 5)
	:pos(display.left + 110, display.top - 310)
	:onButtonClicked(function()
		CommonSound.click() -- 音效
		NetHandler.request("CommonRankingShow", {
			data = {param1 = 2},
			onsuccess = handler(self, self.netRank)
		}, self)
	end)

	-- 规则按钮
	CommonButton.button({
		normal = "aincrad_btn_rule.png",
	})
	:addTo(self, 5)
	:pos(display.left + 110, display.top - 460)
	:onButtonClicked(function()
		CommonSound.click() -- 音效
		self:showRuleLayer()
	end)

	-- buff层
	self.barLayer = app:createView("aincrad.AincradBar"):addTo(self)
	:pos(display.cx + 170, display.bottom + 30)
	:zorder(1)

	-- 积分层
	self.scoreLayer = app:createView("aincrad.AincradScoreWidgetLayer")
	:addTo(self)
	:pos(display.left + 150, display.bottom + 30)
	:zorder(1)

-- 显示选择第几层按钮
	self.floorButton = app:createView("aincrad.FloorButtonLayer"):addTo(self.layer_):pos(480, 250)
	:onEvent(function(event)
		CommonSound.click() -- 音效

		self:onSelectedFloor(AincradData.floor)
	end)

	-- 屏蔽层
	self.limitLayer = display.newNode():addTo(self)
	:zorder(100)
	:size(display.width, display.height)
	:onTouch(function()

	end)

	-- 最高积分
	display.newSprite("aincrad_frame_maxscore.png")
	:addTo(self, 2)
	:pos(display.cx, display.top - 80)

	self.maxScoreLabel = base.Label.new({
		size = 22,
	})
	:align(display.CENTER)
	:addTo(self, 2)
	:pos(display.cx, display.top - 80)


end

-- 刷新按钮
function AincradScene:onButtonRestart()
	self.scoreLayer:updateData()
	self.scoreLayer:updateView()

	self:updateData()
	self:updateView()
	self:checkProcess()
	self.barLayer:showChange(false)
	self:showOkLayer(false)
end
local ceng = {
	"一", "二", "三", "四", "五",
	"六", "七", "八", "九", "十",
	"十一", "十二", "十三", "十四", "十五",
	"十六", "十七", "十八", "十九", "二十",
	-- "二十一", "二十二", "二十三", "二十四", "二十五",
	-- "二十六", "二十七", "二十八", "二十九", "三十",
}

-- 点击第index层
function AincradScene:onSelectedFloor(index)
	if self.canStart then
		NetHandler.request("SelectAincradOppnentList", {
			onsuccess = function()
				app:pushScene("AincradSelectEnemyScene")
			end
		}, self)
	else
		if AincradData.isBattleOk and not AincradData.isGetReward then
			print("先去领取奖励")
			return
		end
	end
end

-- 显示第index按钮
function AincradScene:showFloor(index, animated)
	local idx = math.mod(index, 2)
	if idx == 0 then idx = 2 end
	local posY = 250 + index * 10
	self.floorButton:showIndex(idx, string.format("第%s层", ceng[index]))
	:pos(480, posY)
end

function AincradScene:hideFloor(animated)
	self.floorButton:hideLayer(animated)
end

function AincradScene:showLimit(b)
	if b then
		self.limitLayer:show()
	else
		self.limitLayer:hide()
	end
end

function AincradScene:setCanStart(b)
	self.canStart = b
	if b then
		self:showLimit(false)
	else
		self:showLimit(true)
	end
end

--------------------------------------

function AincradScene:updateView()
	self:checkProcess()
	self:updateMaxScoreView()
end

function AincradScene:checkProcess()
	self:hideFloor()
	self:setCanStart(false)
	if AincradData.isBattleOk then 	-- 已经挑战成功
		if AincradData.isGetReward then 	-- 已经领取奖励
			if AincradData.floor < AincradData:getFloorMax() then
				self:showFloor(AincradData.floor+1, true)
				self:setCanStart(true)
			else -- 全通
				self:showOkLayer(true)
				self:setCanStart(true)
			end
		else 								-- 没有领取奖励
			if math.mod(AincradData.floor, 2) == 1 then 	-- 奇数关卡
				-- 选buff界面
				NetHandler.request("GetAincradReward", {
					onsuccess = function()
						app:pushScene("AincradSelectBuffScene")
					end
				}, self)
			else 	-- 偶数关卡
				-- 领奖界面
				-- 然后进入晶库
				NetHandler.request("GetAincradReward", {
					onsuccess = function()
						app:pushScene("AincradGetRewardScene")
					end
				}, self)
			end
		end
	else
		self:showFloor(AincradData.floor, false)
		self:setCanStart(true)
	end
end

function AincradScene:updateMaxScoreView()
	self.maxScoreLabel:setString(string.format("今日最高：%d", AincradData.maxScore))
end

function AincradScene:showOkLayer(show)
	if show then
		self.okLayer:show()
	else
		self.okLayer:hide()
	end
end

-----------------------------------------------
--======*******************************=======---
-- 获取排行
function AincradScene:netRank()
	if not self.rankLayer then
		self.rankLayer = app:createView("rank.AincradRankLayer")
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

-- 规则
function AincradScene:showRuleLayer()
	if not self.ruleLayer then
		self.ruleLayer = app:createView("aincrad.AincradRuleLayer")
		:addTo(self)
		:zorder(10)
		:updateListView()

		self.ruleLayer:onEvent(function(event)
			if event.name == "close" then
				event.target:hide()
			end
		end)
	end

	self.ruleLayer
	:show()
	:setRank(RankData:getRank("aincrad").rank)
	:updateShow()

end

----------------------------------------------
-- 新手引导
function AincradScene:onGuide()
	local level = UserData:getUserLevel()
	if level < OpenLvData.aincrad.openLv then return end

	if GuideData:isNotCompleted("Aincrad") then -- 艾恩葛朗特
		self:showStartGuide(function()
			self:onSelectedFloor(1)
		end)
    end
end

function AincradScene:showStartGuide(callback)
	local point = convertPosition(self.floorButton.layers[1].layer, self, cc.p(-250, -97))
	local posX = point.x
	local posY = point.y
	showTutorial2({
        text = GameConfig.tutor_talk["60"].talk,
        rect = cc.rect(posX, posY, 130, 130),
        x = posX+300,
        y = posY + 110,
        scale = -1,
        callback = function(target)
        	GuideData:setCompleted("Aincrad", function()
        		if callback then
	        		callback()
	        	end
	        	target:removeSelf()
        	end,
        	function()
        		target:removeSelf()
        		self:onGuide()
        	end)
        end,
    })
end

----------------------------------------------
function AincradScene:netCallback(event)
    local data = event.data
    local order = data.order
    if  order == OperationCode.OpenShopProcess then
        app:pushScene("ShopScene")
    end
end

function AincradScene:onEnter()
	AincradScene.super.onEnter(self)

	ResetTimeData:addObserver("aincrad", function()
		self:updateData()
		self:updateView()
	end)
	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function AincradScene:onExit()
	ResetTimeData:removeObserver("aincrad")

	AincradScene.super.onExit(self)
	GameDispatcher:removeEventListener(self.netEvent)
end


return AincradScene
