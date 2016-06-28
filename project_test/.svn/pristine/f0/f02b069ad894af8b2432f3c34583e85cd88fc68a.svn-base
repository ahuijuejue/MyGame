--[[
庐山五老峰阵型界面
]]
local HolyLandInfoSubScene = import(".HolyLandInfoSubScene")
local TrialMountInfoScene = class("TrialMountInfoScene", HolyLandInfoSubScene)

function TrialMountInfoScene:initDescriptionShow()
	-- 列表
	base.ListView.new({
		viewRect = cc.rect(0, 0, 300, 320),
		itemSize = cc.size(300, 300),
	})
	:addTo(self.layer_)
	:pos(530, 130)
	:zorder(5)
	:setBounceable(false)	
	-- :addItems(#items, function(event)
	-- 	local index = event.index		
	-- 	local item = self:createItem(index)			
	-- 	local grid = base.Grid.new()
	-- 	grid:addItem(display.newSprite("Lamp_huawen1.png"):pos(43, -15))
	-- 	:addItem(base.Label.new({text=items[index], align = cc.TEXT_ALIGNMENT_LEFT, size=16}):pos(-45, -35):align(display.BOTTOM_LEFT))
	-- 	:addItem(item:pos(-95, 0):scale(0.8))
				
	-- 	return grid 
	-- end)
	-- :reload()
	:addItems(1, function(event)		
		local str = [[
嗔念、贪念、妄念、执念、怨念
等都属于心魔。

心魔可以常在、可以突现、可以
隐匿、可以成长、可以吞噬人心、
也可以历练人心。

一重心魔：比较容易克服
二重心魔：一个不小的挑战
三种心魔：最难战胜的自我
		]]
		local grid = base.Grid.new()
		:addItems({				
			base.Label.new({text=str, align = cc.TEXT_ALIGNMENT_LEFT, size=16}):pos(0, 0):align(display.CENTER),			
		})
		
		return grid 
	end)
	:reload()

	-- 阵型
	self.itemsLayer_ = display.newNode():addTo(self.layer_)
	:pos(0, 135)
	:zorder(3)

	self.posLabel1:setString("一重")
	self.posLabel2:setString("二重")
	self.posLabel3:setString("三重")

end 

-- 场景标题
function TrialMountInfoScene:createTitle()
	return display.newSprite("word_mountain.png")
end 

-- 副标题1 阵型字
function TrialMountInfoScene:createSubTitle1()
	return display.newSprite("word_format_desc.png")
end 

-- 副标题2
function TrialMountInfoScene:createSubTitle2()
	return display.newSprite("word_demons.png")
end 

function TrialMountInfoScene:toBattleScene()
	app:pushScene("TrialMountReadyScene", {{grade=self.grade}})
end 

--@param type 类型 1,2,3
function TrialMountInfoScene:createItem(heroId, index) 	
	local border = ({"HeroCircle2.png", "HeroCircle3.png", "HeroCircle4.png"})[index]
	local level = self.levelList[index]

	local heroIcon = display.newSprite(UserData:getHeroIcon(heroId))

	local grid = base.Grid.new()
	:addItems({
		display.newSprite(border),
		heroIcon, 
		display.newSprite("Name_Banner.png"):pos(40, -35):zorder(4),
		base.Label.new({text=tostring(level), color=cc.c3b(250,250,250), size=18}):align(display.CENTER):pos(40, -35):zorder(5),
	})

	return grid 

end 

---------------------------------------------

function TrialMountInfoScene:updateData()
	local mountData = TrialData:getMount(self.grade)
	self.items_ = mountData:getDataList() 
	self.levelList = mountData:getLevelList()
end

-- 阵型
function TrialMountInfoScene:updateFormation()
	self.itemsLayer_:removeAllChildren()
	local x = 115
	local addX = 155
	local y = 135 

	for i,v in ipairs(self.items_) do
		self:createItem(v, i)
		:addTo(self.itemsLayer_)
		:pos(x, y)			
		x = x + addX
	end
end 

return TrialMountInfoScene



