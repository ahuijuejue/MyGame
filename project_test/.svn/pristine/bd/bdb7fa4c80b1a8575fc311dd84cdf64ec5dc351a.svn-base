
local ChatExpressView = class("ChatExpressView", function()
	return display.newNode()
end)

function ChatExpressView:ctor()
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			return true
		elseif event.name == "ended" then
			if event.x < 695 and event.y < 283 then
			else
				self.delegate:removeExpressView()
			end
		end
    end)

    self:initData()
    self:initView()

end

function ChatExpressView:initData()
	self.expressData = {}
	self.expressNum  = 0
	self.rowItem     = 0
end

function ChatExpressView:initView()
	self.layer_ = display.newNode():size(display.width, display.height):align(display.BOTTOM_LEFT)
    :addTo(self)
    :zorder(1)

    self.back = display.newSprite("Express_Bg.png"):addTo(self.layer_):pos(347,135)

	self.listView1 = base.ListView.new({
		viewRect = cc.rect(0, 0, 685, 250),
		itemSize = cc.size(675, 80),
	}):addTo(self.back,3)
	:pos(0, 10)
	:onTouch(handler(self, self.touchListener))

end

function ChatExpressView:touchListener(event)
    if "clicked" == event.name then
        local column = math.ceil(event.point.x/85)
        local idx = (event.itemPos - 1)*8 + column
        local chooseExpress = self.expressData[idx].name
        self.delegate.chatView.chatMsg = string.format(self.delegate.chatView.chatMsg.."%s", chooseExpress)
        self.delegate.chatView.textfield:setText(self.delegate.chatView.chatMsg)

        self.delegate:removeExpressView()
    end
end

function ChatExpressView:setGridShow(grid, data)
	local spriteTable = {}
	local posX = -287
	local addX = 84
	for i=1,#data do
		local sprite = display.newSprite(data[i].img):pos(posX+(i-1)*addX, 0)
		table.insert(spriteTable, sprite)
	end
    grid:removeItems()
	:addItems(spriteTable)
end

function ChatExpressView:updateData()
	for k,v in pairs(GameConfig["ChatExpression"]) do
	    table.insert(self.expressData,{
	    	id = tonumber(k),
	    	name = v.Name,
	    	img = v.Img})
	end
	table.sort(self.expressData, function(a, b)
		return a.id < b.id
	end)
    self.expressNum = #self.expressData
end

function ChatExpressView:updateView()
	self.listView1
	:removeAllItems()
	:addItems(self.expressNum/8+1, function(event)
		local data = {}
		for i=1,8 do
			self.rowItem = self.rowItem + 1
			table.insert(data,self.expressData[self.rowItem])
		end
		local grid = base.Grid.new()
		self:setGridShow(grid, data)
		return grid
	end)
	:reload()
end

return ChatExpressView