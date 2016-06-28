
local ChatLeftView = class("ChatLeftView", function()
	return display.newNode()
end)
local RichLabel = import("app.ui.RichLabel")

function ChatLeftView:ctor()
	self:initData()
	self:initView()

	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			local  point = {x = event.x, y =event.y}
			if self:touchInNode(point) then
				self.isPush = true
				self:setTouchSwallowEnabled(true)
			else
				self:setTouchSwallowEnabled(false)
			end
			return self.isPush
		elseif event.name == "moved" then
		elseif event.name == "ended" then
			local  point = {x = event.x, y = event.y}
			if self:touchInNode(point) and self.isPush then
				if not self.delegate.chatView.textfield then
					self.delegate.chatView:createEditBox()
				end
				self.delegate.chatView:show()
				self.delegate.chatView:updateView()
			end
			self.isPush = false
		end
    end)

end

function ChatLeftView:touchInNode(point)
	point = self.back:convertToNodeSpace(point)
	local roleRect = {x = 0, y = 0, width = 360, height = 115}
	return cc.rectContainsPoint(roleRect,point)
end

function ChatLeftView:initData()
	self.showData = {}
	self.chatCounts = 1
	self.isPush = false
end

function ChatLeftView:initView()
	self.back = display.newSprite("left_back.png")
    :pos(display.left+130,display.bottom)
    :addTo(self)

    local params = {
        dimensions = cc.size(340,0),
        text = "暂无聊天消息",
        fontSize = 18,
    }
    self.chatLabel = RichLabel:create(params)
    self.chatLabel:setPosition(20,105)
    self.chatLabel:addTo(self.back)
end

function ChatLeftView:createChatMsg(data)
	local msg = ""
	if data.channelType == "2" then -- 系统消息
		msg = string.format("[image=System_Tip.png scale=0.7][/image][fontColor=FF2C2C fontSize=18][公告][/fontColor]%s",toChatStr(data.msg))
	elseif data.channelType == "3" then -- 世界消息
		msg = string.format("[image=World_Tip.png scale=0.7][/image][fontColor=00F8F8 fontSize=18]%s:[/fontColor]%s",data.name,toChatStr(data.msg))
	elseif data.channelType == "4" then -- 公会消息
		msg = string.format("[image=Union_Tip.png scale=0.7][/image][fontColor=00F8F8 fontSize=18]%s:[/fontColor]%s",data.name,toChatStr(data.msg))
	end
	return msg
end

function ChatLeftView:updateData()
	if #ChatData.allLeftData > 0 then
		self.showData = {}
		table.insert(self.showData,ChatData.allLeftData[1])
	end
end

function ChatLeftView:updateView()
	if #self.showData > 0 then
		local msg = self:createChatMsg(self.showData[1])
		self.chatLabel:setLabelString(msg)
	end
end

return ChatLeftView