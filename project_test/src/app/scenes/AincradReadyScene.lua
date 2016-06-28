--[[
艾恩葛朗特 备战界面 
]]

local AincradReadyScene = class("AincradReadyScene", base.Scene)

function AincradReadyScene:initData(options)		

	self.heroList_ = UserData:getAincradBattleList()	
	self.enermyTeam = options.team 
	
end

function AincradReadyScene:initView()
	self:autoCleanImage()
	
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)
	
	-- 选择层
	self.selectLayer_ = app:createView("readyplay.AincradSelectLayer", {limitnum = 7}):addTo(self)
	:setHeroList(self.heroList_)
	:onTouch(function(event)
		local name = event.name 
		if name == "selected" then 
			self.startPlayBtn_:setButtonEnabled(true)
		elseif name == "unselected" then 
			if event.count <= 0 then 
				self.startPlayBtn_:setButtonEnabled(false)
			end 
		end 
		-- body
	end)

	-- 开始按钮
	self.startPlayBtn_ = CommonButton.start()
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		print("kaishi")
		if self.selectLayer_:canSelected() then 			
			local msg = base.Label.new({text="现在未满员出战，是否继续开始战斗？", size=20}):align(display.CENTER)
			
			AlertShow.show2("友情提示", msg, "确定", function()
				self:didStartGame()
			end)
		else
			self:didStartGame()
		end 
	end)
	:addTo(self)
	:pos(display.cx + 400, 220)
	:zorder(10)
	:setButtonEnabled(false)

	-- 返回按钮
	CommonButton.back()
	:onButtonClicked(function(event)
		CommonSound.back() -- 音效
		
		app:popScene()
	end)
	:addTo(self)
	:pos(display.right - 90, display.top - 60)
	:zorder(10)
	
end

function AincradReadyScene:didStartGame() 
	if AincradData.selectedTeam then 
		self:toBattle()
	else 
		NetHandler.request("SelectAincradTeam", {
			data = {param1=self.enermyTeam.teamId}, 
			onsuccess = function()	
				self:netToBattle()		 								
			end
		}, self)
	end 
end

function AincradReadyScene:toBattle() 
	local team = AincradData.selectedTeam 

	local ids, heros = self.selectLayer_:getHeroList()	
	UserData:setAincradBattleList(ids)

	heros = clone(heros)
	for k,w in pairs(heros) do
		for i,v in ipairs(w) do
			local oldHero = AincradData:getOldHero(v.roleId)		
			if oldHero then 
				v.anger = oldHero.anger
				v.hp = oldHero.hp * v.maxHp
			end
		end
	end

	local lvKey = tostring(AincradData.floor)
    local data = GameConfig.aincrad_up[lvKey]
    for i,enemy in ipairs(team:getRoleList()) do
        for k,value in pairs(data) do
            if k == "hp" then
            	enemy.maxHp = enemy.maxHp * value
            else
            	enemy[k] = enemy[k] * value
            end
        end
        enemy.hp = enemy.maxHp * enemy.hp
    end

	local hardIndex = self.enermyTeam.index -- 关卡难度
		
	local param = {
		hardIndex 		= 	hardIndex, -- 关卡难度
		baseScore 		= 	AincradData:getBaseScore(hardIndex, AincradData:getCurrentFloor(), UserData:getUserLevel()), -- 获得基础积分

		building 		= 	CityData:getBuilding(),
		seal_xing 		= 	SealData:getAttributeForBattle(),
		item 			= 	{},
		gold 			= 	0,
		skillValue 		= 	0,
		heroAppendExp 	= 	0,
		teamTotalExp 	= 	UserData.totalExp,
		teamAppendExp 	= 	0,
		buff 			= 	AincradBuffData:getHaveBuff2(), 
		team  			= 	heros, 		-- 己方战队
		tailSkill 		= {					
							level = SealData:getSealLevel(), 			-- 封印等级 
							skill = TailsData:getTailsSkillIdList(),	-- 尾兽技能id列表 
						},
		enemy 			= { -- 对方
		    team = clone(team:getRoleList()), 	-- 对方战队
		    tailSkill 	= {					
							level = team:getSealLevel(), 			-- 封印等级 
							skill = team:getTailsSkillList(),		-- 尾兽技能id列表 
						},
		    userId 		= team.userId, 				-- 对方用户id 
		    teamId 		= team.teamId,				-- 对方战队id 
		},	
		winFunction 	= 	function()			
								AudioManage.playMusic("Main.mp3",true)	
								app:pushScene("AincradScene")							
							end,
		failedFunction 	= 	function()
								AudioManage.playMusic("Main.mp3",true)
								app:pushScene("AincradScene")	
							end,

	}

	app:enterScene("AincradBattleScene", {param})
end

function AincradReadyScene:netToBattle()
	self:toBattle()
end 

function AincradReadyScene:showSelectGuideIndex(index, callback)
	local posX = display.left + 80 + (index-1) * 155 
	local posY = display.cy - 230
    app:createView("widget.GuideLayer"):addTo(self):zorder(10)        
    :showRect(150, 180, posX, posY, function()         	
    	self.selectLayer_:selectedGetListIndex(index)
    	if callback then 
    		callback()
    	end 
    end) 
    :showFinger(posX, posY)
end 

function AincradReadyScene:showExchangeRole(callback)
	local posX = display.cx + 200
	local posY = display.cy + 120 
	local startX = posX + 110 
	local startY = posY - 40 
	local endX = posX - 70 
	local endY = posY + 60 
	local moveAction = cc.RepeatForever:create(cc.Sequence:create(
		cc.MoveTo:create(1, cc.p(endX, endY)),
		cc.DelayTime:create(1),
		cc.MoveTo:create(0, cc.p(startX, startY))
	))
    local guideLayer = app:createView("widget.GuideLayer"):addTo(self):zorder(10)        
    :showRect(440, 320, posX, posY, nil, false) 
    :showFinger(startX, startY, moveAction) 

    local isShow = false 
    local item1 = self.selectLayer_.getViewList_[1]
    local item2 = self.selectLayer_.getViewList_[3] 
    base.Grid.new()
    :addTo(self)
    :zorder(11)
    :pos(posX, posY)
    :onTouch(function(event)    	
    	if event.name == "began" then
    		if item1:hiteTest(event.x, event.y) then 
    			isShow = true 
    		else 
    			isShow = false 
    		end 
		elseif event.name == "moved" then 
			if isShow then 
				self.selectLayer_:movedGetGrid(1, event.x, event.y)
			end 
		elseif event.name == "ended" then 
			if isShow then 
				if item2:hiteTest(event.x, event.y) then 
					self.selectLayer_:endedGetGrid(1, event.x, event.y) 
					guideLayer:removeSelf()
					if callback then 
						callback()
					end 
				else 
					self.selectLayer_:endedGetGrid(1, 0, 0)	
				end 
				isShow = false 
			end 
		end 	
	end, cc.size(440, 320))
	
end 

function AincradReadyScene:showStartGuide()
	local point = self.startPlayBtn_:convertToWorldSpace(cc.p(0, 0))
	point = self:convertToNodeSpace(point)
	local posX = point.x
	local posY = point.y 
    app:createView("widget.GuideLayer"):addTo(self):zorder(10)        
    :showCicle(120, posX, posY, function()         	
    	self:didStartGame()
    end, false) 
    :showFinger(posX, posY)
end 


return AincradReadyScene