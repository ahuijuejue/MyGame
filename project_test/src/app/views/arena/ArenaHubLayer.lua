--
-- Author: zsp
-- Date: 2015-03-20 18:31:09
--
local scheduler         = require(cc.PACKAGE_NAME .. ".scheduler")
local BattleEvent       = require("app.battle.BattleEvent")
local AngerButton      = require("app.views.battle.AngerButton")
--local BattlePauseDialog = require("app.views.battle.BattlePauseDialog")

--[[
	战斗界面上的ui控件层
--]]
local ArenaHubLayer = class("ArenaHubLayer",function()
    return display.newNode()
end)

function ArenaHubLayer:ctor(leftTeam,rightTeam)
    
	self.currTime             = 0  --记录当前时间，用于战斗倒计时
	self.timeOut              = 120 --90秒一波战斗超时
	self.dtTimeOut            = 0  --倒计时计数
	self.__timeScheduleHandle = nil 
	
	-- self.leader.onUpdateHp    = handler(self, self.onLeaderUpdateHp)
	-- self.leader.onUpdateAnger = handler(self, self.onLeaderUpdateAnger)
	-- self.leader.onUpdateHit   = handler(self, self.onUpdateHit)

	-- self.superLeader.onUpdateHp    = handler(self, self.onSuperLeaderUpdateHp)
	-- self.superLeader.onUpdateAnger = handler(self, self.onSuperLeaderUpdateAnger)

	local goldBanner = display.newSprite("FGold_Banner.png")
	goldBanner:setAnchorPoint(0,0.5)
	goldBanner:setPosition(20,display.top-40)
	goldBanner:addTo(self)

	self.goldLabel =  display.newTTFLabel({
		text  = "0",
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.goldLabel:setAnchorPoint(0,0.5)
	self.goldLabel:setPosition(50,20)
	self.goldLabel:setColor(cc.c3b(255,255,0))
	self.goldLabel:addTo(goldBanner)

	local itemBanner = display.newSprite("FItem_Banner.png")
	itemBanner:setAnchorPoint(0,0.5)
	itemBanner:setPosition(220,display.top-40)
	itemBanner:addTo(self)

	self.itemLabel =  display.newTTFLabel({
		text  = "0",
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.itemLabel:setAnchorPoint(0,0.5)
	self.itemLabel:setPosition(60,20)
	self.itemLabel:setColor(cc.c3b(255,255,0))
	self.itemLabel:addTo(itemBanner)

	local timeBanner = display.newSprite("FTime_Banner.png")
	timeBanner:setAnchorPoint(1,0.5)
	timeBanner:setPosition(display.right-20,display.top-40)
	timeBanner:addTo(self)

	self.timeLabel =  display.newTTFLabel({
		text  = "1:30",
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.timeLabel:setAnchorPoint(0,0.5)
	self.timeLabel:setPosition(40,20)
	self.timeLabel:setColor(cc.c3b(255,255,0))
	self.timeLabel:addTo(timeBanner)

	self.leftMenu = self:createTeamMenuPanel(leftTeam)
	self.rightMenu = self:createTeamMenuPanel(rightTeam)
	self.rightMenu:setPosition(self.rightMenu:getPositionX(),self.rightMenu:getPositionY() + 80)
	self.rightMenu:setVisible(false)
	
	self:startCountdown()
end

function ArenaHubLayer:createTeamMenuPanel(team)
	local panel = display.newNode()
	panel:addTo(self)

	local i = 0
	for k,v in pairs(team) do
		if v.evolveNode then
			local btn  = AngerButton.new(v)
			btn:setScale(0.8)
			btn:setPosition(100 * i + 50 ,0)
			btn:addTo(panel)

			v.onUpdateAnger            = handler(btn, btn.onUpdateAnger1)
			v.evolveNode.onUpdateAnger = handler(btn, btn.onUpdateAnger2)
			
			btn:onButtonClicked(function(event)
				if v == nil or not v:isActive() or v.evolveNode:isActive() then
					return
				end

				btn:setEvolveMode(true)
				btn:setButtonEnabled(false)
				btn.progress1:setPercentage(0)

				BattleEvent:dispatchEvent({
				    name  = BattleEvent.HERO_FALSH,
				    role  = v
				})
			end)

			i = i + 1
		end
	end
	panel:setPosition(display.cx - i * 100 * 0.5,70)

	return panel
end



--[[
	更新战斗倒计时
--]]
function ArenaHubLayer:updateCountdown(dt)
	-- body
	self.dtTimeOut = self.dtTimeOut + 1
	local time = self.timeOut - self.dtTimeOut --(os.time() - self.currTime)
	--print(time)
	self.timeLabel:setString(string.format("%d:%02d",math.floor(time / 60) , time % 60))

	if time == 0 then
		 self:stopCountdown()
		 
		 BattleEvent:dispatchEvent({
			name    = BattleEvent.GAME_TIMEOUT
 		 })
	end
end

--[[
	启动战斗时间计时器
--]]
function ArenaHubLayer:startCountdown()
	
	self:stopCountdown()

	self.currTime = os.time()
	if not self.__timeScheduleHandle then
		self.__timeScheduleHandle = scheduler.scheduleGlobal(handler(self,self.updateCountdown),1)
	end
end

--[[
	停止战斗时间计时器
--]]
function ArenaHubLayer:stopCountdown()
	if self.__timeScheduleHandle then
		scheduler.unscheduleGlobal(self.__timeScheduleHandle)
		self.__timeScheduleHandle = nil
	end
end

function ArenaHubLayer:onExit()
	self:stopCountdown()
end


return ArenaHubLayer