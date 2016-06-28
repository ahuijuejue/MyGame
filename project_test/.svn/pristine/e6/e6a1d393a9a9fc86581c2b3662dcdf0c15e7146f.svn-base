--[[
章节选择框
]]
local ChapterGrid = class("ChapterGrid", base.TableNode)

ChapterGrid.chestIconList = {
	"Chapter_Chest1.png",
	"Chapter_Chest2.png",
	"Chapter_Chest3.png",
}

--[[

chaptertype  1 普通章节

]]
function ChapterGrid:ctor(params)
	params = params or {}
	ChapterGrid.super.ctor(self, params)

	self:initView(params)
end

local function showYouYouAni(img)
	local dur = randFloat(3, 6)
	local actions = {
		transition.create(cc.ScaleTo:create(0.1, 1.3, 1.5), {easing="backin"}),
		transition.create(cc.ScaleTo:create(0.3, 1), {easing="backout"}),
		cc.DelayTime:create(dur),
	}
	local action = transition.sequence(actions)
	action = cc.RepeatForever:create(action)
	img:runAction(action)
end

function ChapterGrid:initView(params)

	-- 章节名
	self.chapterName = base.Label.new({
		size = 28,
		color=CommonView.color_white(),
	})
	:pos(0, 35)
	:align(display.CENTER)
	:zorder(5)
	:addTo(self)

	-- 章节名2
	self.preName = base.Label.new({
		size = 22
	})
	:pos(0, 165)
	:align(display.CENTER)
	:zorder(6)
	:addTo(self)

	-- 章节图标
	self.icon = display.newNode()
	:addTo(self)

	self.iconName = ""
	self.iconImg = nil

	-- 章节星星数 图标
	display.newSprite("Chapter_Star.png")
	:pos(-40, -150)
	:zorder(6)
	:addTo(self)

	-- 章节星星数 label
	self.starNum = base.Label.new({
		size=22,
	})
	:pos(-75, -153)
	:zorder(7)
	:addTo(self)

	-- 解锁内容1
	self.openLabel1 = base.Label.new({
		size=20,
		color=cc.c3b(255,255,0)
	})
	:align(display.CENTER)
	:zorder(2)
	:addTo(self)

	-- 解锁内容2
	self.openLabel2 = base.Label.new({
		size=20,
		color=cc.c3b(125,125,125)
	})
	:align(display.CENTER)
	:zorder(2)
	:addTo(self)

	-- 解锁内容3
	self.openLabel3 = base.Label.new({
		size=20,
		color=cc.c3b(255,0,0)
	})
	:align(display.CENTER)
	:zorder(2)
	:addTo(self)

-----------------------------------------------
-- 宝箱
	-- 宝箱背景光
	self.chestBack = display.newSprite("Chapter_Chest_Bg.png")
	:pos(60, -120)
	:addTo(self)
	:zorder(6)

	local action = cc.RepeatForever:create(cc.RotateBy:create(4, 360))
    self.chestBack:runAction(action)

    -- 宝箱领取完
    self.chestOk = display.newSprite("Chapter_over.png")
    :pos(60, -120)
    :addTo(self)
    :zorder(6)

    -- 宝箱icon
    self.chestIcons = display.newNode()
    :pos(60, -120)
    :zorder(7)
    :addTo(self)


    self.isShowChestAni = false

    self.chestIcon = nil
    self.chestIconIndex = 0

    -- 宝箱星星icon
    display.newSprite("Star_Yellow.png")
    :addTo(self.chestIcons, 2)
    :pos(30, -30)
    :scale(1.5)

    -- 宝箱星星 label
    self.chestStarNum = base.Label.new({
		size=22,
	})
	:pos(30, -30)
	:align(display.CENTER)
	:addTo(self.chestIcons, 3)

    -- 点击宝箱
    self.touchNode = base.TouchNode.new()
    :onEvent(function(event)
    	self:onChestEvent_(event)
    end, cc.size(80, 80))
    :pos(60, -120)
    :addTo(self)

end

function ChapterGrid:setChapterName(name)
	self.chapterName:setString(name)
	return self
end

function ChapterGrid:setPreName(name)
	self.preName:setString(name)
	return self
end

function ChapterGrid:setIcon(iconname)
	if self.iconName ~= iconname then
		self.icon:removeAllChildren()
		self.iconImg = display.newSprite(iconname)
		:addTo(self.icon)
	end
	return self
end

function ChapterGrid:grayIcon(b)
	if not self.iconImg then return self end
	local color
	if b then
		color = cc.c3b(100,100,100)
	else
		color = cc.c3b(255,255,255)
	end
	self.iconImg:setColor(color)
	return self
end

function ChapterGrid:setStarNum(num, numMax)
	local str = string.format("%d/%d", num, numMax)
	self.starNum:setString(str)
	return self
end

function ChapterGrid:setOpen1(txt)
	self.openLabel1:setString(txt)
	self:showOpen1(true)
	return self
end

function ChapterGrid:setOpen2(txt)
	self.openLabel2:setString(txt)
	self:showOpen2(true)
	return self
end

function ChapterGrid:setOpen3(txt)
	self.openLabel3:setString(txt)
	self:showOpen3(true)
	return self
end

function ChapterGrid:showOpen1(b)
	self.openLabel1:setVisible(b)
	return self
end

function ChapterGrid:showOpen2(b)
	self.openLabel2:setVisible(b)
	return self
end

function ChapterGrid:showOpen3(b)
	self.openLabel3:setVisible(b)
	return self
end

-----------------------------------------

function ChapterGrid:setChestStarNum(num)
	local str = string.format("%d", num)
	self.chestStarNum:setString(str)
	return self
end

-- 显示背景光
function ChapterGrid:showChestBack(b)
	if b then
		self.chestBack:show()
	else
		self.chestBack:hide()
	end
	return self
end

-- 显示背景光
function ChapterGrid:showChestOk(b)
	if b then
		self.chestOk:show()
	else
		self.chestOk:hide()
	end
	return self
end

function ChapterGrid:showChestIcon(b)
	if b then
		self.chestIcons:show()
	else
		self.chestIcons:hide()
	end
	return self
end

-- 显示宝箱icon
function ChapterGrid:showChestIconIndex(index)
	if index ~= self.chestIconIndex then
		if self.chestIcon then
			self.chestIcon:removeSelf()
			self.chestIcon = nil
		end
		self.chestIconIndex = index
		local iconName = self.chestIconList[index]
		if iconName then
			self.chestIcon = display.newSprite(iconName)
			:addTo(self.chestIcons)
		end
	end

	return self
end

function ChapterGrid:showChestAni(b)
	if b ~= self.isShowChestAni then
		self.isShowChestAni = b
		if b then
			-- transition.resumeTarget(self.chestIcons)
			showYouYouAni(self.chestIcons)
		else
			-- transition.pauseTarget(self.chestIcons)
			self.chestIcons:stopAllActions()
		end
	end
end

function ChapterGrid:setSelected(b)
	self:showNormalImage(not b)
	self:showSelectImage(b)
	self:grayIcon(not b)

	return self
end

function ChapterGrid:onChestTouch(callback)
	self.chestListener = callback
	return self
end

function ChapterGrid:onChestEvent_(event)
	if not self.chestListener then return self end
	event.target = self
	self.chestListener(event)
end

------------------------------------------------
function ChapterGrid:showNormalImage(b)
	if self.normalImg then
		if b then
			self.normalImg:show()
		else
			self.normalImg:hide()
		end
	end
	return self
end

function ChapterGrid:showSelectImage(b)
	if self.selectImg then
		if b then
			self.selectImg:show()
		else
			self.selectImg:hide()
		end
	end
	return self
end

function ChapterGrid:initNormalSelectIf()
	if self.normalImg or self.selectImg then return end
	self.normalImg = display.newSprite("Chapter_Board.png")
	:addTo(self)
	:zorder(5)

	self.selectImg = display.newSprite("Chapter_Board_Select.png")
	:addTo(self)
	:zorder(5)
end

function ChapterGrid:initEliteSelectIf()
	if self.normalImg or self.selectImg then return end
	self.normalImg = display.newSprite("Chapter_Board2.png")
	:addTo(self)
	:zorder(5)

	self.selectImg = display.newSprite("Chapter_Board_Select2.png")
	:addTo(self)
	:zorder(5)
end

------------------------------------------------

return ChapterGrid













