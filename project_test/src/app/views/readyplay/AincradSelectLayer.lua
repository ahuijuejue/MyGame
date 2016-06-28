--[[
艾恩葛朗特选择英雄界面
]]
local SelectLayer = import(".SelectLayer")
local AincradSelectLayer = class("AincradSelectLayer", SelectLayer)

function AincradSelectLayer:initData(options)	
	self.maxGet_ = 7
	AincradSelectLayer.super.initData(self)
end 

function AincradSelectLayer:initView()	
	AincradSelectLayer.super.initView(self)

	-- 已选取区域		
	self:addHeroPos(self.heroIndexes.leader, 800, 385, 2)
	self:addHeroPos(self.heroIndexes.member1, 520, 360, 2)	
	self:addHeroPos(self.heroIndexes.member2, 320, 360, 2)	
	self:addHeroPos(self.heroIndexes.member3, 120, 360, 2)

	self:addHeroPos(self.heroIndexes.bench1, 610, 490, 1)
	self:addHeroPos(self.heroIndexes.bench2, 410, 490, 1)
	self:addHeroPos(self.heroIndexes.bench3, 210, 490, 1)

	self:setSuperCount(1)
	
end 

function AincradSelectLayer:isHeroDead(data)
	local oldData = AincradData:getOldHero(data.roleId)
	if oldData and oldData.hp == 0 then 
		return true 
	end 
	return false
end 

function AincradSelectLayer:selectedList(event)
	local item = event.item:getContent()
	local index = event.itemPos

	local data = self:getCurrentList()[index]
	if item:isSelected() then					
		self:unselectedGetList(data)
		item:setSelected(false)									
	else 
		if self:canSelected() and (not self:isHeroDead(data)) then 
		 	self:selectedGetList(data, item)
			item:setSelected(true)
		end 
	end 
end 


function AincradSelectLayer:showGrid(grid, data)

	local oldData = AincradData:getOldHero(data.roleId)
	local hpProcess = 1 
	local angerProcess = 0 
	if oldData then 
		hpProcess = oldData.hp
		angerProcess = oldData.anger / data.maxAnger 
	end 
	local typeImg = self:getHeroTypeImage(data.roleId)
	local cls = display.newSprite
	local offY = 0
	if hpProcess <= 0 then 	
		cls = CommonView.filter_gray
		offY = -20
	else		
		grid:addItemsWithKey({
			hpBack = display.newSprite("P_Slip.png"):pos(-55, -50):zorder(10):align(display.CENTER_LEFT), 
			angerBack = display.newSprite("P_Slip.png"):pos(-55, -70):zorder(10):align(display.CENTER_LEFT), 
			hpBar = UserData:slider("HP_Slip.png", hpProcess):zorder(11):align(display.CENTER_LEFT):pos(-52, -50),
			angerBar = UserData:slider("RP_Slip.png", angerProcess):zorder(11):align(display.CENTER_LEFT):pos(-52, -70),		
		})
	end 

	grid:addItemsWithKey({
		icon_ = cls(UserData:getHeroIcon(data.roleId)):pos(0, 20+offY):zorder(2),
		border_ = cls(UserData:getHeroBorder(data)):pos(0, 20+offY),
		lvbk_ = cls("Name_Banner.png"):pos(40, -25+offY):zorder(4),
		lvLabel_ = base.Label.new({text=tostring(data.level), color=cc.c3b(250,250,250), size=18}):align(display.CENTER):pos(40, -25+offY):zorder(5),
		typeIcon_ = cls(typeImg):pos(-45, 55+offY):zorder(6),
		typeIconBoarder_ = cls("Job_Circle.png"):pos(-45, 55+offY):zorder(5),
		starLv_ = createStarIcon(data.starLv):pos(-50, -20+offY):zorder(5),
	})

	
	return self
end	

function AincradSelectLayer:showGridGet(grid, data)
	AincradSelectLayer.super.showGridGet(self, grid, data)

	local oldData = AincradData:getOldHero(data.roleId)
	local hpProcess = 1 
	local angerProcess = 0 
	if oldData then 
		hpProcess = oldData.hp 
		angerProcess = oldData.anger / data.maxAnger 
	end 

	grid:addItemsWithKey({		
		hpBack = display.newSprite("P_Slip.png"):pos(-55, -50):zorder(10):align(display.CENTER_LEFT), 
		angerBack = display.newSprite("P_Slip.png"):pos(-55, -70):zorder(10):align(display.CENTER_LEFT), 
		hpBar = UserData:slider("HP_Slip.png", hpProcess):zorder(11):align(display.CENTER_LEFT):pos(-52, -50),
		angerBar = UserData:slider("RP_Slip.png", angerProcess):zorder(11):align(display.CENTER_LEFT):pos(-52, -70),		
	})
	:setSelected(true)
	
	return self
end	

function AincradSelectLayer:updateHeroData()
	self.data_ = {}	
	local list = {LIST_TYPE.HERO_ALL, LIST_TYPE.HERO_TANK, LIST_TYPE.HERO_DPS, LIST_TYPE.HERO_AID}
	for i,v in ipairs(list) do
		local heros = HeroListData:getListWithType(v)
		table.insert(self.data_, heros)
	end
	
	for i,v in ipairs(self.data_) do
		table.sort(v, function(x, y)			
			local dead1 = self:isHeroDead(x)
			local dead2 = self:isHeroDead(y)
			
			if dead1 or dead2 then 
				return (not dead1) and dead2 
			end 

			if x.level > y.level then 
				return true
			elseif x.level == y.level then 
				if x.starLv > y.starLv then 
					return true
				elseif x.starLv == y.starLv then 
					if x.strongLv > y.strongLv then 
						return true
					elseif x.strongLv == y.strongLv then 
						return checknumber(x.roleId) < checknumber(y.roleId)
					end 
				end 
			end
			return false
		end)
	end
end 

function AincradSelectLayer:updateHeroGetData()
	local heroList_ = self.heroList_ or {}
	self.getDataList_ = {}
	for i,v in ipairs(heroList_) do
		local data = table.item(self.data_[1], function(a)
			return a.roleId == v
		end)
		if data then 
			local oldData = AincradData:getOldHero(data.roleId)
			if oldData and oldData.hp > 0 then 
				table.insert(self.getDataList_, data)
			end 
		end 
	end
end 


return AincradSelectLayer