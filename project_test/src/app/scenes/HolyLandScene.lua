--[[
修炼圣地场景
]]
local HolyLandScene = class("HolyLandScene", base.Scene)


function HolyLandScene:initData()
	-- body
	self.items_ = {} 
	self.trialList = {
		TrialData:getTrial("light"),
		TrialData:getTrial("time"),
		TrialData:getTrial("mount"),
	}

	self.openLv = {
		OpenLvData.holyLight.openLv,
		OpenLvData.holyHouse.openLv,
		OpenLvData.holyMount.openLv,
	}
end

function HolyLandScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background1()
	:addTo(self)
	:center()
	
	CommonView.blackLayer2()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer"):addTo(self)	
	:onBack(function(layer)
		self:pop()
	end)

-- 主层
------------------------------------------------------------------
-- 背景框
	local posX = 430

	-- CommonView.backgroundFrame1()
	-- :addTo(self.layer_)
	-- :pos(posX, 280)
	-- :zorder(2)


	-- 标题	
	-- CommonView.titleLinesFrame2()
	-- :addTo(self.layer_)
	-- :pos(posX, 540)
	-- :zorder(2)

	-- display.newSprite("word_holyland.png")	
	-- :addTo(self.layer_)
	-- :pos(posX, 540)
	-- :zorder(2)
------------------------------------------------------------------

	-- 列表
	local scenes = {"TrialLightScene", "TrialHouseScene", "TrialMountScene"}
	local titles = {"Word_TheLight2.png", "Word_TimeHouse2.png", "Word_Mountain2.png"}
	local backgrounds = {"Trainning_Banner1.png", "Trainning_Banner2.png", "Trainning_Banner3.png"}
	for i,v in ipairs(self.trialList) do
		local sceneName = scenes[i] 
		local title = titles[i]
		local background = backgrounds[i]
		local openStr = string.format("%d级开启", self.openLv[i])
		self:addGridItem(title, openStr, "Training_Lock.png", 265 * i - 90, 280, sceneName, background)
	end 

end 

function HolyLandScene:addGridItem(title, openTxt, opennImg, x, y, scenename, background)
	local index = #self.items_ + 1
	local item = self:createGridItem(title, openTxt, opennImg, background)
	:addTo(self.layer_, 2)
	:pos(x, y)		
	:onTouch(function(event)
		if event.name == "clicked" then 
			CommonSound.click() -- 音效
			-- print(title)
			if self:isOpen(index) then 
				print("进入")
				if scenename then 
					app:pushScene(scenename)
				end 
			else 
				print("未开启")
			end 
		end 
	end)

	table.insert(self.items_, item)

	return item
end

function HolyLandScene:createGridItem(title, openTxt, opennImg, background)
	local item = base.Grid.new()	
	:addItemWithKey("background", display.newSprite(background))
	-- :addItem("Trainning_Banner.png")
	-- :addItem(display.newSprite(title):pos(0, 186))
	:addItemsWithKey({
		enterLabel = base.Label.new({text="点击进入", color=cc.c3b(0,255,0), size=22}):align(display.CENTER):pos(0, -150):hide(),
		openLabel = base.Label.new({text=openTxt, size=22, color=cc.c3b(255,0,0)}):align(display.CENTER):pos(0, -150),
	})
	:addItemWithKey("lockimg", display.newSprite(opennImg))

	return item
end 

------------------------------------

function HolyLandScene:updateData()
	self.level = UserData:getUserLevel()
end

function HolyLandScene:updateView() 	
	for i,v in ipairs(self.items_) do
		if self:isOpen(i) then 
			v:getItem("enterLabel"):show()
			v:getItem("openLabel"):hide()
			v:getItem("lockimg"):hide()
			v:getItem("background"):setColor(cc.c3b(255,255,255))
		else 
			v:getItem("enterLabel"):hide()
			v:getItem("openLabel"):show()
			v:getItem("lockimg"):show()
			v:getItem("background"):setColor(cc.c3b(100,100,100))
		end 
	end
end

function HolyLandScene:isOpen(index) 
	local level = self.openLv[index]
	if self.level >= level then 
		return true 
	end 
	return false 
end

function HolyLandScene:getTrialData(index) 
	return self.trialList[index]
end 



return HolyLandScene


