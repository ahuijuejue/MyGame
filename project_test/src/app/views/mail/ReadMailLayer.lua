
local ReadMailLayer = class("ReadMailLayer", function( ... )
	return display.newNode()
end)

function ReadMailLayer:ctor(data)
	self:initData(data)
	self:initView(data)
	CommonView.animation_show_out(self.layer_)
end

function ReadMailLayer:initData(data)
	self.items = {}
	self.mailId = data.id

	if data:haveAnnex() then
		for k,v in pairs(data.items) do
			table.insert(self.items, {
				count 	= v,
				icon 	= UserData:createItemView(k),
			})
		end

		for k,v in pairs(data.heros) do
			print("k:", k)
			table.insert(self.items, {
				count 	= v,
				icon 	= UserData:createHeroView(k),
			})
		end
	end
	-- dump(self.items)
end

function ReadMailLayer:initView(data)

	-- 灰层背景
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	self:onButtonClose(data)
    end)

    local layer_ = display.newNode():size(960, 640):align(display.CENTER)
    layer_:addTo(self):center()
	self.layer_ = layer_

-- 主层
	local posY = 175
    --------背景框
    CommonView.mFrame2()
    :addTo(self.layer_)
	:pos(480, 320)
	:onTouch(function(event)
		if event.name == "began" then
			return true
		end
	end)

	CommonView.titleLinesFrame2()
	:addTo(self.layer_)
	:pos(480, 550)

	-- display.newSprite("Mail_ItemBar.png"):addTo(self.layer_)
	-- :pos(480, posY)

    ------------------------------------

    -- 标题
    base.Label.new({text=data.title, size=26, color=cc.c3b(255,255,255)}):addTo(self.layer_)
    :align(display.CENTER)
    :pos(480, 550)

    -----------------------------------------------------------------------
    -- 描述
    local descLabel = base.Label.new({
		text 	= 	data.desc,
		dimensions = cc.size(520, 0),
		align 	= 	cc.TEXT_ALIGNMENT_LEFT,
		size 	= 	20,
		color 	= 	cc.c3b(255,255,4),
		})
	:align(display.CENTER)

    local height = descLabel:getCascadeBoundingBox().height

    base.ListView.new({
    	viewRect=cc.rect(0, 0, 530, 260),
    }):addTo(self.layer_)
    :setBounceable(false)
    :pos(215, 235)
    :addSizeItem(cc.size(530, height), function()
    	return descLabel
    end)
    :addSizeItem(cc.size(570, 100), function()
    	local label = base.Label.new({text=data.from, size=20, color=cc.c3b(10,239,4)})
    	:align(display.RIGHT_CENTER):pos(250, 0)

    	return base.Grid.new():addItem(label)
    end)
    :reload()

	-----------------------------------------------------------------------

	-- 附件
	if self:haveAnnex() then
		display.newSprite("Mail_ItemBar.png"):addTo(self.layer_)
		:pos(480, posY)

		for i,v in ipairs(self.items) do
			local posX = i * 100 + 160
			v.icon:addTo(self.layer_):pos(posX, posY):scale(0.7)
			if v.count > 1 then
				base.Label.new({text=tostring(v.count)}):align(display.CENTER):addTo(self.layer_):pos(posX + 35, posY-30)
			end
		end

		self.btnReceived_ = base.Grid.new():addTo(self.layer_):pos(700, posY)
		:setNormalImage(
			CommonButton.yellow("领取")
			:onButtonClicked(function()
				self:onEvent_{name="received"}

				CommonSound.click() -- 音效
			end)
		)
		:setSelectedImage(display.newSprite("Got_Mark.png"))
		:setSelected(data.received)
	end

	-- 关闭按钮
	CommonButton.close():addTo(self.layer_):pos(800, 550)
	:onButtonClicked(function( ... )
		self:onButtonClose(data)

		CommonSound.close() -- 音效
	end)
end

function ReadMailLayer:onButtonClose(data)
	if data.received then
		self:onEvent_{name="close"}
	else
		if self:haveAnnex() then
			self:onEvent_{name="close"}
		else
			self:onEvent_{name="read"}
		end
	end
end

function ReadMailLayer:haveAnnex()
	return #self.items > 0
end

function ReadMailLayer:onEvent(listener)
	self.eventListener = listener

	return self
end

function ReadMailLayer:onEvent_(event)
	if not self.eventListener then return end

	event.target = self
	self.eventListener(event)
end

function ReadMailLayer:setReceived()
	if self.btnReceived_ then
		self.btnReceived_:setSelected(true)
	end
end

return ReadMailLayer

