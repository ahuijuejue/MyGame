--[[
日月追缉 场景
]]


local ArenaLookingForScene = class("ArenaLookingForScene", base.Scene)

function ArenaLookingForScene:initData()
	
end

function ArenaLookingForScene:initView()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer(200)
	:addTo(self)

	-- 按钮层
	self.menuLayer = app:createView("widget.MenuLayer", {wealth="skill"}):addTo(self)	
	:onBack(function(layer)
		app:popScene()
	end)


	-- 追缉成功总数：
	base.Label.new({text="追缉成功总数：", size=22, color = CommonView.color_orange()})
	:addTo(self.layer_)
	:pos(50, 550)

	self.okTimesLabel = base.Label.new({size=22})
	:addTo(self.layer_)
	:pos(230, 550)

	-- 标题
	-- base.Label.new({text="烈阳追缉", size=22})
	-- :align(display.CENTER)
	base.Grid.new()
	:setBackgroundImage("Wanted_Sun_Icon.png")
	:addTo(self.layer_)
	:pos(180, 350)
	:onClicked(function()
		self:enterSun()
	end)

	-- base.Label.new({text="皎月追缉", size=22})
	-- :align(display.CENTER)
	base.Grid.new()
	:setBackgroundImage("Wanted_Moon_Icon.png")
	:addTo(self.layer_)
	:pos(780, 350)
	:onClicked(function()
		self:enterMoon()
	end)

	-- 挑战按钮
	CommonButton.button({
		normal="Wanted_BtnB_Normal.png",
		pressed="Wanted_BtnB_Selected.png",		
	})
	:addTo(self.layer_)
	:pos(180, 160)
	:onButtonClicked(function()
		self:enterSun()
	end)

	CommonButton.button({
		normal="Wanted_BtnG_Normal.png",
		pressed="Wanted_BtnG_Selected.png",		
	})
	:addTo(self.layer_)
	:pos(780, 160)
	:onButtonClicked(function()
		self:enterMoon()
	end)


	-- 说明
	display.newSprite("Wanted_Desc.png")
	:addTo(self.layer_)
	:pos(480, 60)

	base.Label.new({
		text="说明：", 
		size=22
	})
	:addTo(self.layer_)
	:pos(140, 70)

	local label1 = base.Label.new({
		text="烈阳追缉", 
		size=22,
		color = CommonView.color_orange(),
	})
	:addTo(self.layer_)
	:pos(220, 70)

	label1 = base.Label.new({
		text="可以获得", 
		size=22,
		color=CommonView.color_white(),
	})
	:addTo(self.layer_)
	:pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY())

	base.Label.new({
		text="技能点、专属装备碎片及其它", 
		size=22,
		color=CommonView.color_blue(),
	})
	:addTo(self.layer_)
	:pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY())

	label1 = base.Label.new({
		text="皎月追缉", 
		size=22,
		color=CommonView.color_purple(),
	})
	:addTo(self.layer_)
	:pos(220, 40)

	label1 = base.Label.new({
		text="可以获得", 
		size=22,
		color=CommonView.color_white(),
	})
	:addTo(self.layer_)
	:pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY())

	base.Label.new({
		text="灵能值、专属装备碎片及其它", 
		size=22,
		color=CommonView.color_blue(),
	})
	:addTo(self.layer_)
	:pos(label1:getPositionX() + label1:getContentSize().width, label1:getPositionY())

	-- 剩余次数
	local arrowIcon = display.newSprite("Wanted_Arrow.png")
	:addTo(self.layer_)
	:pos(480, 162)

	arrowIcon:runAction(cc.RepeatForever:create(transition.sequence({
        cc.ScaleTo:create(1, 0.9, 1),
        cc.ScaleTo:create(1, 1.1, 1)    
    })))

	base.Label.new({
		text="剩余次数：", 
		size=20,
		color=CommonView.color_white(),
	})
	:addTo(self.layer_)
	:pos(370, 160)

	self.haveTimesLabel = base.Label.new({
		size=20,
		color=CommonView.color_yellow(),
	})
	:addTo(self.layer_)
	:pos(490, 160)

	-- 增加次数按钮
	self.addBtn = base.Grid.new()
	:setBackgroundImage("Plus2.png")
	:addTo(self.layer_)
	:pos(620, 160)
	:onClicked(function(event)
		self:onEventAddTimes()
	end)

	-- 被挑战者
	self.heroWidget = app:createView("arena.HeroInfoWidget")
	:addTo(self.layer_)
	:pos(480, 380)
	:zorder(5)


	-- 换一个
	CommonButton.button({
		normal = "Wanted_Btn_Change.png",
	})
	:addTo(self.layer_, 5)
	:pos(480, 210)
	:onButtonClicked(function()
		self:onEventChangeEnermy()
	end)


	-- 计时更新显示 剩余次数
	self:schedule(function()
		self:updateHaveTimes()
	end, 0.2)

end 

-- 进入烈阳追缉
function ArenaLookingForScene:enterSun()
	if self:checkHaveTimes() then 
		self:enterWar(1, "ArenaBattleScene")
	end 
end

-- 进入皎月追缉
function ArenaLookingForScene:enterMoon()
	if self:checkHaveTimes() then 
		self:enterWar(2, "ArenaBattleScene")
	end 
end

-- 进入
function ArenaLookingForScene:enterWar(type, toScene)
	if self:checkHaveTimes() then 
		app:pushScene("ArenaLookingReadyScene", {{
			type = type,
			myTeam = self.team,
			otherTeam = ArenaLookingForData:getEnermyTeam(),
			toScene = toScene,
		}})
	end 
end

function ArenaLookingForScene:updateData()
	-- ArenaLookingForData.haveTimes = 9
	-- ArenaLookingForData.recoverTime = UserData:getServerSecond() - 30

	-- 玩家自己战队
	self.team = ArenaTeam.new({ 
		name 	= UserData.name, 		-- 战队名 
		level 	= UserData:getUserLevel(), 	-- 战队总经验
		icon 	= UserData.headIcon, 	-- 战队头像 		
	})
end

function ArenaLookingForScene:updateView()
	self:updateOkTimes()
	self:updateHaveTimes()
	self:updateHeroWidget()
end

-- 更新成功次数显示
function ArenaLookingForScene:updateOkTimes()
	local str = string.format("%d", ArenaLookingForData.okTimes)
	self.okTimesLabel:setString(str)
end

-- 更新剩余次数显示
function ArenaLookingForScene:updateHaveTimes()
	ArenaLookingForData:updateTimesData()

	local haveTimes = ArenaLookingForData:getHaveTimes()
	local str 
	if haveTimes < ArenaLookingForData:timesMax() then
		local min = math.floor(ArenaLookingForData.countdown / 60)
		local sec = math.mod(ArenaLookingForData.countdown, 60)
		str = string.format("%d(%02d:%02d)", haveTimes, min, sec)
	else 
		str = string.format("%d(max)", haveTimes)
	end 

	self.haveTimesLabel:setString(str)

	
	self:showAddButton(haveTimes == 0)
	
end

-- 更新被挑战者
function ArenaLookingForScene:updateHeroWidget()
	local data = ArenaLookingForData:getEnermyTeam()
	self.heroWidget:setName(data.name)
	:setLevel(data:getLevel())
	:setBattle(data:getBattle())
	:setList(data:getRoleList())
	:setIcon(data.icon)
	:setBorder(data:getBorder())
end

-- 显示 购买次数按钮
function ArenaLookingForScene:showAddButton(b)
	self.addBtn:setVisible(b)
end

-- 增加次数 事件
function ArenaLookingForScene:onEventAddTimes()
	print("增加次数")
	self:showBuyTimesAlert()
end

-- 换一个敌人 事件
function ArenaLookingForScene:onEventChangeEnermy()
	print("换一个")
	NetHandler.request("UpdateZhuijiEnemy", {
		onsuccess = function(items)
			self:onNetChangeEnermy()
		end,
	}, self)

end

-- 换一个敌人 成功
function ArenaLookingForScene:onNetChangeEnermy(event)
	print("换一个成功")
	self:updateHeroWidget()
end

-- 检查次数是否足够
function ArenaLookingForScene:checkHaveTimes()
	if ArenaLookingForData:getHaveTimes() > 0 then
		return true 
	else 
		self:showBuyTimesAlert()
		return false 
	end 
end

-- 显示购买次数层
function ArenaLookingForScene:showBuyTimesAlert()
	local costDiamond = ArenaLookingForData:getCostForBuyTimes()
	if UserData.diamond < costDiamond then 
		GemsAlert:show()
	else
		local msg = {
			base.Label.new({text="是否花费", size=22}):pos(30, 150),
			base.Label.new({text=string.format("x%d来购买%d次", costDiamond, 1), size=22}):pos(200, 150),
			base.Label.new({text="挑战次数", size=22}):pos(200, 110):align(display.CENTER),		
			display.newSprite("Diamond.png"):pos(160, 150),
		}

		AlertShow.show2("友情提示", msg, "确定", function( ... )
			self:netBuyTimes()
			NetHandler.request("BuyZhuijiPower", {onsuccess=handler(self, self.netBuyTimes)}, self)
		end)
	end 
end

-- 购买次数 成功
function ArenaLookingForScene:netBuyTimes(evnet)
	print("购买次数成功")
	self:updateData()
	self:updateView()
end 


return ArenaLookingForScene
