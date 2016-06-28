--[[
城建主界面
]]

local CityScene = class("CityScene", base.Scene)

function CityScene:initData()
	self.cityData = {
		CityData:getCity("2"),
		CityData:getCity("1"),
		CityData:getCity("3"),
	}

end

function CityScene:initView()

	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer"):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

--------------------------------------------------------
-- 背景框
	display.newSprite("Castle_Title.png")
	:addTo(self)
	:pos(display.cx, display.top - 100)

	base.Label.new({text="战斗建筑", size=26})
	:align(display.CENTER)
	:addTo(self)
	:pos(display.cx, display.top - 100)
--------------------------------------------------------

--------------------------------
-- 城堡
	self.cityView = {}
	for i,v in ipairs(self.cityData) do
		local view = self:createCityGrid(v.icon, function(grid)
			self:onButtonSelected(v, grid)
		end)
		:addTo(self.layer_)
		:pos(200 + (i-1)*280, 320)

		table.insert(self.cityView, view)
	end

--------------------------------

end

function CityScene:createCityGrid(imgName, callback)
	local ani = GameGaf.new({
        name = imgName,
        y = -150,
    })
    :start()
    :play("idle", true)

    local icon = ani.anim

	local grid = base.Grid.new()
	:addItem(icon)
	:addItem(display.newSprite("Castle_Name.png"):pos(0, -200))
	:addItem(display.newSprite("Castle_Star.png"):pos(70, -100))
	:addItem(display.newSprite("Castle_Level.png"):pos(-100, 80))

	grid:addItemWithKey("tips", display.newSprite("Castle_RedPoint.png"):pos(80, 110))
	:addItemWithKey("name", base.Label.new({size=20}):align(display.CENTER):pos(0, -200))
	:addItemWithKey("star", base.Label.new({size=20, color=cc.c3b(0,0,0), border=false}):align(display.CENTER):pos(70, -103))
	:addItemWithKey("level", base.Label.new({size=20}):align(display.CENTER):pos(-100, 80))
	:onClicked(function()
		callback(grid)
	end, cc.size(250,250))

	return grid
end

function CityScene:onButtonSelected(data, grid)
	CommonSound.click() -- 音效
	print("进入：", data.name)
	app:pushScene("CityInfoScene", {{data=data, towerModel=CityData:getTowerModel(data.data.id, data.level)}})
end

function CityScene:updateOthers()
	self:updateTips()
end

function CityScene:updateView()
	for i,v in ipairs(self.cityData) do
		self:updateCityGrid(self.cityView[i], v)
	end
end

function CityScene:updateCityGrid(grid, data)
	grid:getItem("name"):setString(data.name)
	grid:getItem("star"):setString(data.data.star)
	grid:getItem("level"):setString(string.format("lv.%d", data.level))
end

-- 更新显示 建筑是否可以提升
function CityScene:updateTips()
	for i,v in ipairs(self.cityData) do
		local tip = self.cityView[i]:getItem("tips")
		print("can strong up:",  CityData:canStrongUp(v.id))
		print("can star up:",  CityData:canStarUp(v.id))
		if CityData:canStrongUp(v.id) or CityData:canStarUp(v.id) then
			tip:show()
		else
			tip:hide()
		end
	end
end

---------------------------------------------------
-- 新手引导
function CityScene:onGuide()
	if UserData:getUserLevel() < OpenLvData.city.openLv then return end

	if GuideData:isNotCompleted("Castle") then
		local view = self.cityView[2]
		local data = self.cityData[2]
		local point = convertPosition(view, self)
		UserData:showGuideLayer({
			text = GameConfig.tutor_talk["69"].talk,
			x = point.x,
			y = point.y,
			offX = -270,
			offY = 110,
			callback = function(event)
				self:onButtonSelected(data, view)
			end
		})
	end

end



return CityScene


