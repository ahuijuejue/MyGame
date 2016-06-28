--[[
世界树备战界面
]]
local TreeReadyScene = class("TreeReadyScene", base.Scene)


function TreeReadyScene:initData()
	self.heroList_ = TreeData:getBattleList()
end

function TreeReadyScene:initView()
	-- self:autoCleanImage()

	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer", {wealth="tree", menu=false}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)


	-- 选择层
	self.selectLayer_ = app:createView("readyplay.TreeSelectLayer", {limitnum = 7}):addTo(self)
	:setHeroList(self.heroList_)
	:onTouch(function(event)
		local name = event.name
		if name == "selected_pre" then
			if event.target:canSelected() then
				self.startPlayBtn_:hide()
			else
				self.startPlayBtn_:show()
			end
		elseif name == "selected" then
			if event.target:canSelected() then
				self.startPlayBtn_:hide()
			else
				self.startPlayBtn_:show()
			end
		end
		-- body
	end)
	:zorder(11)

	-- 开始按钮
	self.startPlayBtn_ = CommonButton.start()
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		self:didStartGame()

	end)
	:addTo(self)
	:pos(display.cx + 400, 220)
	:zorder(10)
	:hide()

end

function TreeReadyScene:didStartGame()
	local heroData = self.selectLayer_:getHeroList()
	self:didBattle()
end

function TreeReadyScene:updateView()
	self:updateStartButtonStatus()
end

function TreeReadyScene:updateStartButtonStatus()
	if TreeData.winTimes < TreeData:getWinMax() then
		self.startPlayBtn_:setButtonEnabled(true)
	else
		self.startPlayBtn_:setButtonEnabled(false)
	end
end

-- 进入战斗场景
function TreeReadyScene:didBattle()
	local heroData = self.selectLayer_:getHeroList()

	local function parseHero(data)
		local oldHero = TreeData:getBattleHero(data.roleId)
		if oldHero then
			data.anger = oldHero.anger
			data.hp = oldHero.hp * data.maxHp
		end
	end

	heroData = clone(heroData)
	for k,v in pairs(heroData) do
		for k2,v2 in pairs(v) do
			parseHero(v2)
		end
	end

	local toData = {
		building 		= 	CityData:getBuilding(),
		seal_xing 		= 	SealData:getAttributeForBattle(),
		team 			= 	heroData,
		item 			= 	{},
		gold 			= 	0,
		skillValue 		= 	0,
		heroAppendExp 	= 	0,
		teamTotalExp 	= 	UserData.totalExp,
		teamAppendExp 	= 	0,
		treeweId = TreeData.tree_we, -- todo tihuan
		chapter = tostring(TreeData.winTimes+1),
		battleInfo 		= 	TreeData.battleData,
		tailSkill 		= 	{
			level = SealData:getSealLevel(), 	-- 封印等级
			skill = TailsData:getTailsSkillIdList(),	-- 尾兽技能id列表
		},

		winFunction 	= 	function()
			AudioManage.playMusic("Main.mp3",true)
			app:popScene()

		end,
		failedFunction 	= 	function()
			AudioManage.playMusic("Main.mp3",true)
			app:popScene()
		end,
	}

	-------------------------
	print("进入战斗场景")
    app:pushScene("TreeBattleScene", {toData})

end

------------------------------------------------
-- 新手引导
function TreeReadyScene:onGuide()
	local level = UserData:getUserLevel()
	if level < OpenLvData.tree.openLv then return end

	if GuideData:isNotCompleted("WorldTree") then
		self:showSelectGuide(function()
			self:showRefreshGuide(function()
				self:onGuideEnd()
			end)
		end)
	end
end

function TreeReadyScene:showSelectGuide(callback)
	local view = self.selectLayer_.cacheViewList_[2]
	local point = convertPosition(view, self)
	UserData:showGuideLayer({
		text = GameConfig.tutor_talk["78"].talk,
		x = point.x,
		y = point.y,
		offX = -240,
		offY = 130,
		callback = callback,
	})
end

function TreeReadyScene:showRefreshGuide(callback)
	local point = convertPosition(self.selectLayer_.refreshBtn, self)

	UserData:showGuideLayer({
		text = GameConfig.tutor_talk["79"].talk,
	    x = point.x,
	    y = point.y,
	    offX = -300,
	    offY = 130,
	    callback = callback,
	})

end

function TreeReadyScene:onGuideEnd()
	GuideData:setCompleted("WorldTree")
end

function TreeReadyScene:netCallback(event)
    local data = event.data
    local order = data.order
    if  order == OperationCode.OpenShopProcess then
        app:pushScene("ShopScene")
    end
end

function TreeReadyScene:onEnter()
	self:updateView()
	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
	self:onGuide()
end

function TreeReadyScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return TreeReadyScene
