--[[
竞技场防御场景
]]
local ArenaDefenseScene = class("ArenaDefenseScene", base.Scene)

function ArenaDefenseScene:initData()
	self.heroList_ = UserData:getArenaDefenseList()
end

function ArenaDefenseScene:initView()
	self:autoCleanImage()

	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 选择层
	self.selectLayer_ = app:createView("readyplay.ArenaSelectHeroLayer"):addTo(self)
	:setHeroList(self.heroList_)
	:onTouch(function(event)
		local name = event.name
		if name == "selected" then
			print("selected")
			self.changed_ = true
		elseif name == "unselected" then
			print("unselected")
			self.changed_ = true
		end
		-- body
	end)

	-- 保存阵容按钮
	self.startPlayBtn_ = cc.ui.UIPushButton.new({normal = "Save_Team.png"})
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效

		local heroList = self.selectLayer_:getHeroList()
		if table.nums(heroList) == 0 then
			showToast({text="不能为空"})
		elseif self:checkHeroList(heroList) then
			showToast({text="阵型未改变"})
		else
			self:saveHeroList(heroList)
		end
	end)
	:addTo(self)
	:pos(860, 230)
	:zorder(10)

	-- label 变身数量
	self.superLabel_ = base.Label.new({
		color=cc.c3b(230,0,0),
		size = 20,
		})
	:addTo(self)
	:align(display.CENTER)
	:pos(display.cx, display.height-30)

	-- 返回按钮
	CommonButton.back()
	:onButtonClicked(function(event)
		CommonSound.back() -- 音效

		self:pop()
	end)
	:addTo(self)
	:pos(display.right - 90, display.top - 60)
	:zorder(10)
end

-- 检测队列与原来队列是否相同
function ArenaDefenseScene:checkHeroList(list)
	local count1 = table.nums(self.heroList_)
	local count2 = table.nums(list)
	if count1 ~= count2 then
		return false
	end
	for i=1,count1 do
		if self.heroList_[i] ~= list[i] then
			return false
		end
	end
	return true
end

function ArenaDefenseScene:saveHeroList(list, callback)

	self.startPlayBtn_:setButtonEnabled(false)
	local idstr = table.concat(list, ",")

	local param = {param1=idstr}
	if GuideData:isNotCompleted("Arena1") then    -- 竞技场防御 引导
		param.param100 = "Arena1"
	end

	showLoading()
	NetHandler.request("SaveJingjiDefense", {
		data = param,
		onsuccess = function()
			hideLoading()
			self.startPlayBtn_:setButtonEnabled(true)
			self:netSaveDefense()
			if callback then
				callback()
			end
		end,
		onerror = function()
			hideLoading()
		end
	}, self)

end

--
function ArenaDefenseScene:netSaveDefense()
	self.heroList_ = UserData:getArenaDefenseList()
	self.selectLayer_:setHeroList(self.heroList_)
	self.selectLayer_:updateData()
	self.selectLayer_:updateView()
	showToast({text="保存成功"})
end

function ArenaDefenseScene:updateView()
	local superCount, nextOpenLv = ArenaData:getSuperOpen(UserData:getUserLevel())
	self.selectLayer_:setSuperCount(superCount)
	if nextOpenLv then
		self.superLabel_:setString(string.format("%d级开放第%d个变身位", nextOpenLv, superCount+1))
	else
		self.superLabel_:setString("")
	end
end
----------------------------------------------------
-- 新手引导

function ArenaDefenseScene:onGuide()
	if UserData:getUserLevel() < OpenLvData.arena.openLv then return end

	if GuideData:isNotCompleted("Arena1") then    -- 竞技场防御
        self.selectLayer_:setHeroList({})
		self.selectLayer_:updateData()
		self.selectLayer_:updateView()
		self:showSelectGuideIndex(1, "46", function()
			self:showSelectGuideIndex(2, "47", function()
				self:showSelectGuideIndex(3, "48", function()
					self:showStartGuide(function()
						self:showBackGuide()
					end)
				end)
			end)
		end)
	end
end

function ArenaDefenseScene:showSelectGuideIndex(index, textFlag, callback)
    local posX = display.cx - 370 + (index-1) * 185
	local posY = 100

	showTutorial2({
	    text = GameConfig.tutor_talk[textFlag].talk,
	    rect = cc.rect(posX, posY, 130, 130),
	    x = posX + 260,
	    y = posY + 120,
	    scale = -1,
	    callback = function(target)
	        self.selectLayer_:selectedGetListIndex(index)
	        target:removeSelf()
	    	if callback then
	    		callback()
	    	end
	    end,
	})
end

function ArenaDefenseScene:showStartGuide(callback)
	local point = convertPosition(self.startPlayBtn_, self)
	local posX = point.x
	local posY = point.y

    showTutorial2({
		text = GameConfig.tutor_talk["49"].talk,
	    rect = cc.rect(posX, posY, 120, 120),
	    x = posX - 300,
	    y = posY + 120,
	    callback = function(target)
	    	local heroList = self.selectLayer_:getHeroList()
			self:saveHeroList(heroList, callback)
	        target:removeSelf()
	    end,
	})
end

function ArenaDefenseScene:showBackGuide()
	local posX = display.right - 90
	local posY = display.top - 60

    showTutorial2({
		text = GameConfig.tutor_talk["50"].talk,
	    rect = cc.rect(posX, posY, 120, 120),
	    x = posX - 250,
	    y = posY - 50,
	    callback = function(target)
	    	app:popScene()
	        target:removeSelf()
	    end,
	})
end


return ArenaDefenseScene
