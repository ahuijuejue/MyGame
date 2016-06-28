--[[
山多拉的灯阵型界面
]]
local HolyLandInfoSubScene = import(".HolyLandInfoSubScene")
local TrialLightInfoScene = class("TrialLightInfoScene", HolyLandInfoSubScene)

function TrialLightInfoScene:initDescriptionShow()
	-- 列表
	local items = {
		"血量很少，体积也\n小，抵抗物理伤害",
		"血量中等，体积也\n小，抵抗物理伤害",
		"血量很多，体积也\n小，抵抗物理伤害",
		"血量中等，体积也\n小，抵抗能量伤害",
		"血量很少，体积也\n小，抵抗能量伤害",
		"血量很多，体积也\n小，抵抗能量伤害",
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

	self.posLabel1:setString("前排")
	self.posLabel2:setString("中排")
	self.posLabel3:setString("后排")

end 

-- 场景标题
function TrialLightInfoScene:createTitle()
	return display.newSprite("word_light.png")
end 

-- 副标题1 阵型字
function TrialLightInfoScene:createSubTitle1()
	return display.newSprite("word_format_desc.png")
end 

-- 副标题2
function TrialLightInfoScene:createSubTitle2()
	return display.newSprite("word_clock.png")
end 

function TrialLightInfoScene:toBattleScene()
	app:pushScene("TrialLightReadyScene", {{grade=self.grade}})
end 

--[[
----@param data {
	id = "10001",	-- id
	type = 1, 		-- 类型 1.物 2.魔 
	size = 1, 		-- 钟的占格 1，2，4
}
or 第几个配置灯
]]

function TrialLightInfoScene:createItem(data)	
	local iconData 
	if type(data) == "number" then 
		iconData = TrialIcon:getLight(data)
	else 
		iconData = TrialIcon:getIconData(data.id)
	end 
	
	local border = iconData.border 
	local imgStr = iconData.icon 
	local typeStr = iconData.name 
	return base.Grid.new()
	:addItems({
		display.newSprite(border),
		display.newSprite(imgStr),
		display.newSprite("Name_Banner.png"):pos(-40, 40),
		base.Label.new({text=typeStr, size=14}):pos(-40, 40):align(display.CENTER),
	})

end 

---------------------------------------------

function TrialLightInfoScene:updateData()
	local light = TrialData:getLight(self.grade) 
	self.items_ = light:getDataList()

end

-- 阵型
function TrialLightInfoScene:updateFormation()
	self.itemsLayer_:removeAllChildren()
	local addX = 77.5
	local x = 115 - addX
	local addY = 67
	local baseY = 270 

	local moveX = function(data)
		if data.size == 4 then 
			return addX * 2
		else 
			return addX 
		end
	end

	function moveSingle(data) 
		print("single move")
		x = x + moveX(data)
		self:createItem(data)
		:addTo(self.itemsLayer_)
		:pos(x, baseY - addY * 2)
		x = x + moveX(data)
	end

	function moveTable(arr)
		print("table move")
		x = x + moveX(arr[1])
		local y = baseY
		for i,v in ipairs(arr) do
			y = y - addY 
			self:createItem(v)
			:addTo(self.itemsLayer_)
			:pos(x, y)
			y = y - addY
		end
		x = x + moveX(arr[1])
	end
	
	for i,v in ipairs(self.items_) do		
		if v.id then 	
			moveSingle(v)			
		else 
			moveTable(v)
		end 
		
	end

end 


return TrialLightInfoScene




