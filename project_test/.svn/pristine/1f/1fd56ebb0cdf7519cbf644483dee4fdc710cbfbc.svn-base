--[[
精神时间屋阵型界面
]]
local HolyLandInfoSubScene = import(".HolyLandInfoSubScene")
local TrialHouseInfoScene = class("TrialHouseInfoScene", HolyLandInfoSubScene)

function TrialHouseInfoScene:initDescriptionShow()
	-- 列表
	local items = {
		"血量很少，一次\n出现8只，造成\n物理伤害。",
		"血量一般，一次\n出现3只，造成\n物理伤害。",
		"血量很多，一次\n出现1只，造成\n物理伤害。",
		"血量很少，一次\n出现8只，造成\n能量伤害。",
		"血量一般，一次\n出现3只，造成\n能量伤害。",
		"血量很多，一次\n出现1只，造成\n能量伤害。",
	}
	
	base.ListView.new({
		viewRect = cc.rect(0, 0, 300, 320),
		itemSize = cc.size(300, 130),
	})
	:addTo(self.layer_)
	:pos(530, 130)
	:zorder(5)
	:setBounceable(false)	
	:addItems(#items, function(event)
		local index = event.index		
		local item = self:createItem(index)			
		local grid = base.Grid.new()
		grid:addItem(display.newSprite("Lamp_huawen1.png"):pos(43, -15))
		:addItem(base.Label.new({text=items[index], align = cc.TEXT_ALIGNMENT_LEFT, size=16}):pos(-45, -35):align(display.BOTTOM_LEFT))
		:addItem(item:pos(-95, 0):scale(0.8))
				
		return grid 
	end)
	:reload()

	-- 阵型
	self.itemsLayer_ = display.newNode():addTo(self.layer_)
	:pos(0, 135)
	:zorder(3)

	self.posLabel1:setString("第一波")
	self.posLabel2:setString("第二波")
	self.posLabel3:setString("第三波")

end 

-- 场景标题
function TrialHouseInfoScene:createTitle()
	return display.newSprite("word_time_room.png")
end 

-- 副标题1 阵型字
function TrialHouseInfoScene:createSubTitle1()
	return display.newSprite("word_format_desc.png")
end 

-- 副标题2
function TrialHouseInfoScene:createSubTitle2()
	return display.newSprite("word_ghost.png")
end 

function TrialHouseInfoScene:toBattleScene()
	app:pushScene("TrialHouseReadyScene", {{grade=self.grade}})
end 

--@param type 类型 1,2,3物免 4,5,6.魔免
function TrialHouseInfoScene:createItem(index, showCount) 	
	local iconData
	if type(index) == "string" then 
		iconData = TrialIcon:getIconData(index) 
	else
		iconData = TrialIcon:getHouse(index) 
	end 
	
	local border = iconData.border 
	local imgStr = iconData.icon 
	local typeStr = iconData.name 
	local grid = base.Grid.new()
	:addItems({
		display.newSprite(border),
		display.newSprite(imgStr),
		display.newSprite("Name_Banner.png"):pos(-40, 40),
		base.Label.new({text=typeStr, size=14}):pos(-40, 40):align(display.CENTER),
	})

	if showCount then 
		local count = iconData.num 
		grid:addItem(display.newSprite("Name_Banner.png"):pos(40, -40))
		grid:addItem(base.Label.new({text=tostring(count), size=18}):pos(40, -40):align(display.CENTER))
	end 

	return grid 

end 

---------------------------------------------

function TrialHouseInfoScene:updateData()
	local house = TrialData:getHouse(self.grade) 
	self.items_ = house:getDataList()

end

-- 阵型
function TrialHouseInfoScene:updateFormation()
	self.itemsLayer_:removeAllChildren()
	local x = 115
	local addX = 155	
	local y = 135

	for i,v in ipairs(self.items_) do 	
		self:createItem(v, true)
		:addTo(self.itemsLayer_)
		:pos(x, y)			
		x = x + addX
	end

end 

return TrialHouseInfoScene



