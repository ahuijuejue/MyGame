--[[
战力活动层
]]
--[[
战队信息展示
]]

local TeamInfoLayer = class("TeamInfoLayer", function()
	return display.newNode()
end)

function TeamInfoLayer:ctor(params)
	self:initData(params)
	self:initView()
end

function TeamInfoLayer:initData(params)
	self.teamData = params.data
	self.type_    = params.orderType
end

function TeamInfoLayer:initView()
	-- 灰层背景
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    self.layer_ = display.newNode():size(960, 640):align(display.CENTER)
    :addTo(self)
    :center()

    CommonView.mFrame4()
    :addTo(self.layer_)
    :pos(480, 300)

    CommonView.sFrame1()
    :addTo(self.layer_)
    :pos(480, 200)

    CommonView.barFrame3()
    :addTo(self.layer_)
    :pos(430, 360)


    -- 关闭按钮
	CommonButton.close():addTo(self.layer_, 2):pos(800, 505)
	:onButtonClicked(function()
		CommonSound.close() -- 音效

		self:onEvent_{name="close"}
	end)

	local data = self.teamData

	-- icon back
	display.newSprite(ArenaData:getDefaultBorder())
	:addTo(self.layer_)
    :pos(270, 400)
    :scale(1.35)

	-- icon
	if data.icon then
		display.newSprite(data.icon)
		:addTo(self.layer_)
		:pos(270, 400)
		:scale(1.3)
    else
    	display.newSprite("head_10001.png")
		:addTo(self.layer_)
		:pos(270, 400)
		:scale(1.3)
	end

	-- name
	base.Label.new({text=data.name, size=26})
	:addTo(self.layer_)
	:pos(350, 360)

	-- level
	base.Label.new({
		text="等级：",
		size=20,
		color=CommonView.color_orange(),
	})
	:addTo(self.layer_)
	:pos(350, 450)

	base.Label.new({
		text=tostring(data.level),
		size=22,
		color=CommonView.color_orange(),
	})
	:addTo(self.layer_)
	:pos(440, 450)

	if self.type_ == 3 then
		base.Label.new({
			text="总战斗力：",
			size=20,
			color=CommonView.color_orange(),
		})
		:addTo(self.layer_)
		:pos(350, 410)
	elseif self.type_ == 4 then
		base.Label.new({
			text="战队经验：",
			size=20,
			color=CommonView.color_orange(),
		})
		:addTo(self.layer_)
		:pos(350, 410)
	elseif self.type_ == 5 then
		base.Label.new({
			text="总星星数：",
			size=20,
			color=CommonView.color_orange(),
		})
		:addTo(self.layer_)
		:pos(350, 410)
	elseif self.type_ == 7 then
		base.Label.new({
			text="公会经验：",
			size=20,
			color=CommonView.color_orange(),
		})
		:addTo(self.layer_)
		:pos(350, 410)
	end

	base.Label.new({
		text=tostring(data.score_),
		size=22,
		color=CommonView.color_orange(),
	})
	:addTo(self.layer_)
	:pos(500, 410)

	-- vip
	base.Label.new({
		text=string.format("V%d", data.vip),
		size=32,
		color=CommonView.color_orange(),
	})
	:addTo(self.layer_)
	:pos(600, 360)

	-- 战队成员
	local mList = data:getRoleList()
	local startX = 240
	for i,v in ipairs(mList) do
		print("add:", i)
		local grid = base.Grid.new()
		:addTo(self.layer_)
		:pos(startX, 200)

		if i == 1 then
			startX = startX + 130
		else
			startX = startX + 122
			grid:scale(0.8)
		end
		grid:addItem(display.newSprite(v:getBorder())) -- 头像边框
		grid:addItem(display.newSprite(v:getIcon())) -- 队员头像
		grid:addItem(display.newSprite("Banner_Level.png"):pos(-40, 40))
		grid:addItem(base.Label.new({text=tostring(v.level), size=24, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(-40, 40))
		grid:addItem(createStarIcon(v.starLv):pos(-50, -30))

	end

end

function TeamInfoLayer:onEvent(listener)
	self.eventListener = listener

	return self
end

function TeamInfoLayer:onEvent_(event)
	if not self.eventListener then return end

	event.target = self
	self.eventListener(event)
end

return TeamInfoLayer
