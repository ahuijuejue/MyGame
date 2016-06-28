--[[
    聊天界面
--]]

local ChatLayer = class("ChatLayer", function()
	return display.newLayer()
end)
local RichLabel = require("app.ui.RichLabel")
local scheduler = require("framework.scheduler")

local ChatViewBg = "ChatView_Bg.png"
local ChatLine = "Chat_Line.png"
local ChatClose_1 = "Chat_Close_1.png"
local ChatClose_2 = "Chat_Close_2.png"
local SetBtn_1 = "Set_Btn_1.png"
local SetBtn_2 = "Set_Btn_2.png"
local ChannelBtn_1 = "Channel_Btn_1.png"
local ChannelBtn_2 = "Channel_Btn_2.png"
local ExpressBtn_1 = "Express_Btn_1.png"
local ExpressBtn_2 = "Express_Btn_2.png"
local ExpressBtn_3 = "Express_Btn_3.png"
local Button_Sent_1 = "Button_Enter.png"
local Button_Sent_2 = "Button_Enter_Light.png"
local Button_Sent_3 = "Button_Gray.png"

local BUTTON_ID = {
	BUTTON_SENT = 1,
	BUTTON_EXPRESS = 2,
}

function ChatLayer:ctor()
	self:initData()
	self:initView()
end

function ChatLayer:initData()
	self.sendTimer = nil
	self.sendTime = 0

	self.channels     = {}    -- 频道按钮
	self.chatMsg      = ""    -- 发送内容
	self.sectionIndex = 2     -- 默认显示世界频道
    self.unionId    = UserData.unionId    -- 公会id
end

function ChatLayer:initView()
	CommonView.blackLayer2()
    :addTo(self)

    self.layer_ = display.newNode():size(960, 640):align(display.CENTER)
    :addTo(self)
    :pos(display.left+403,display.cy)
    :zorder(1)

    display.newSprite(ChatViewBg):pos(480,322):addTo(self.layer_)
    display.newSprite(ChatLine):pos(200,287):addTo(self.layer_)

    -- 关闭按钮
    local image_ = {normal = ChatClose_1, pressed = ChatClose_2}
	CommonButton.yellow3("",{image = image_})
	:addTo(self.layer_, 1)
	:pos(904, 320)
	:onButtonClicked(function()
		CommonSound.close()
		self:removeTextfield()
 		self.delegate.chatView:hide()
	end)

    -- 设置按钮
    local image_ = {normal = SetBtn_1, pressed = SetBtn_2}
	CommonButton.yellow3("",{image = image_})
	:addTo(self.layer_,1)
	:pos(133, 58)
	:onButtonClicked(function()
        self.delegate:createChatSetView()
	end)

	-- 表情按钮
	local image_ = {normal = ExpressBtn_1, pressed = ExpressBtn_2, disabled = ExpressBtn_3}
	self.expressBtn = CommonButton.yellow3("",{image = image_})
	self.expressBtn:addTo(self.layer_,1)
	self.expressBtn:pos(686, 600)
	self.expressBtn:onButtonClicked(handler(self,self.buttonEvent))
	self.expressBtn:setTag(BUTTON_ID.BUTTON_EXPRESS)

	-- 发送按钮
	local image_ = {normal = Button_Sent_1, pressed = Button_Sent_2, disabled = Button_Sent_3}
	self.sentBtn = CommonButton.yellow3("发送",{image = image_})
	self.sentBtn:addTo(self.layer_,1)
	self.sentBtn:pos(796, 600)
	self.sentBtn:onButtonClicked(handler(self,self.buttonEvent))
	self.sentBtn:setTag(BUTTON_ID.BUTTON_SENT)

	self.listView = cc.TableView:create(cc.size(665, 520))
	self.listView:setPosition(200, 27)
	self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

    self.listView:setDelegate()
	self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	self.listView:addTo(self.layer_)

    -- 创建频道
	self:createChannels()
	self.btnGroup_:selectedButtonAtIndex_(2)
end

function ChatLayer:cellSizeForTable(table,idx)
	return self:getCurrentSize(idx+1)
end

function ChatLayer:tableCellAtIndex(table,idx)
	return self:createCell(idx)
end

function ChatLayer:numberOfCellsInTableView(table)
	return self:getCurrentCount()
end

function ChatLayer:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)
    self:setGridShow(cell,idx+1)
    return cell
end

function ChatLayer:createChannels()
    local image_ = {normal = ChannelBtn_1, selected = ChannelBtn_2,disabled = ChannelBtn_1}

    local btn = CommonButton.sidebar_("系统",{image = image_})
    :addTo(self.layer_,1)
    table.insert(self.channels, btn)

    local btn = CommonButton.sidebar_("世界",{image = image_})
    :addTo(self.layer_,1)
    table.insert(self.channels, btn)

    local btn = CommonButton.sidebar_("公会",{image = image_})
    :addTo(self.layer_,1)
    table.insert(self.channels, btn)

    self.btnGroup_ = base.ButtonGroup.new({
        zorder1 = 1,
        zorder2 = 5,
    })
    :addButtons(self.channels)
    :walk(function(index, button)
    	button:pos(134, 500 - (index-1) * 75)
    end)
    :onEvent(function(event)
    	AudioManage.playSound("Click.mp3")
    	if event.selected ~= 3 then
    		self:selectedChannel(event.selected)
    	else
    		if self.unionId == "" then
    			showToast({text = "去创建公会吧！"})
	    		event.target:selectedButtonAtIndex_(event.last)
	    	else
	    		self:selectedChannel(event.selected)
    		end
    	end
    end)
end

function ChatLayer:createEditBox()
		-- 输入框
	local function onEdit(event, editbox)
		if event == "began" then
	        -- 开始输入
	    elseif event == "changed" then

	    	if self.sectionIndex == 1 then
	    		editbox:setText("")
	    	elseif self.sectionIndex == 2 or self.sectionIndex == 3 then
	    		if OpenLvData:isOpen("sendMessage") then
	    			-- 输入框内容发生变化
			        local _text = editbox:getText()
		            self.chatMsg = _text

					local _trimed = string.trim(_text)
				    _trimed = parseString(_trimed, 130, 2)

					if _trimed ~= _text then
						editbox:setText(_trimed)
					end
				else
					editbox:setText("")
					showToast({text = string.format("战队%d级开启发送消息！", OpenLvData["sendMessage"].openLv)})
	    		end
	    	end

	    elseif event == "ended" then
	        -- 输入结束
	    elseif event == "return" then
	        -- 从输入框返回
	    end
	end

	local textBack = display.newScale9Sprite()
	textBack:setOpacity(100)

	self.textfield = cc.ui.UIInput.new({
	    UIInputType = 1,
	    image = textBack,
	    size = cc.size(550, 35),
	   	x = 95,
	    y = 600,
	    listener = onEdit,
	}):addTo(self.layer_)
	:align(display.LEFT_CENTER)
	self.textfield:setMaxLength(66)

	if self.sectionIndex == 1 then
		self.textfield:setPlaceHolder("该频道不能发言，请切换至其他频道")
	else
		self.textfield:setPlaceHolder("最多输入65个字")
	end
end

function ChatLayer:buttonEvent(event)
	AudioManage.playSound("Click.mp3")
	if OpenLvData:isOpen("sendMessage") then
		local tag = event.target:getTag()
	    if tag == BUTTON_ID.BUTTON_SENT then
	    	if self.chatMsg == "" then
	    		showToast({text = "发送内容不能为空！"})
	    	else
	    		local channelType = self.sectionIndex + 1   -- 世界聊天
	    		NetHandler.gameRequest("SendChatMsg",{param1 = channelType, param2 = self.chatMsg})
	    		self.chatMsg  = ""
	    		if self.textfield then
	    			self.textfield:setText("")
	    		end
	    		self.sendTime = GlobalData.sentMsgCold
	    		self.sentBtn:setButtonLabel(cc.ui.UILabel.new({text = self.sendTime.."s", size = 26}))
				self.sentBtn:setButtonEnabled(false)
	    		self.sendTimer = scheduler.scheduleGlobal(function ()
	    			self.sendTime = self.sendTime - 1
	    			if self.sendTime == 0 then
	    				scheduler.unscheduleGlobal(self.sendTimer)
	    				if self.sectionIndex ~= 1 then
	    					self.sentBtn:setButtonLabel(cc.ui.UILabel.new({text = "发送", size = 26}))
		    				self.sentBtn:setButtonEnabled(true)
	    				end
	    			else
	    				if self.sectionIndex ~= 1 then
	    					self.sentBtn:setButtonLabel(cc.ui.UILabel.new({text = self.sendTime.."s", size = 26}))
	    				end
		    		end
	    		end,1)
	    	end
	    elseif tag == BUTTON_ID.BUTTON_EXPRESS then
			self.delegate:createExpressView()
		end
	else
		showToast({text = string.format("战队%d级开启发送消息！", OpenLvData["sendMessage"].openLv)})
	end
end

function ChatLayer:selectedChannel(index)
	self.sectionIndex = index
	if self.sectionIndex == 1 then
		if self.textfield then
        	self.textfield:setPlaceHolder("该频道不能发言，请切换至其他频道")
	    	self.textfield:setText("")
        end
    	self.expressBtn:setButtonEnabled(false)
    	self.sentBtn:setButtonEnabled(false)
    	self.sentBtn:setButtonLabel(cc.ui.UILabel.new({text = "发送", size = 26}))
    else
    	if self.textfield then
			self.textfield:setPlaceHolder("最多输入65个字")
		end
    	self.expressBtn:setButtonEnabled(true)
    	if self.sendTime == 0 then
			self.sentBtn:setButtonEnabled(true)
    		self.sentBtn:setButtonLabel(cc.ui.UILabel.new({text = "发送", size = 26}))
    	else
			self.sentBtn:setButtonEnabled(false)
    		self.sentBtn:setButtonLabel(cc.ui.UILabel.new({text = self.sendTime.."s", size = 26}))
    	end
	end
	self.listView:reloadData()
end

function ChatLayer:setGridShow(cell, idx)
	local data = self:getCurrentData(idx)
	local msg = toChatStr(data.msg, 0.45, 22)
	local params = {
        dimensions = cc.size(540,0),
        text = msg,
    }
	local label_ =  RichLabel:create(params)
	local itemHeight = self:getCurrentSize(idx)

	if self.sectionIndex == 1 then       -- 系统
		label_:pos(82, (label_:getLabelSize().height*11)/10+7):addTo(cell)
		display.newSprite("System_Tip.png"):pos(45,itemHeight-30):addTo(cell)
	elseif self.sectionIndex == 2 or self.sectionIndex == 3 then   -- 世界频道
        if data.sender ~= UserData.teamId then  -- 对方消息
		    local boxWidth = label_:getLabelSize().width+10
		    local boxHeight = label_:getLabelSize().height+10
	    	local posX = 107 + boxWidth/2
	    	local chatBox = display.newScale9Sprite("Chat_Bg_Other.png",posX,25,cc.size(boxWidth,boxHeight))
	    	chatBox:setAnchorPoint(0.5,0)
	    	cell:addChild(chatBox)

	    	label_:pos(5,boxHeight-5)
	        label_:addTo(chatBox)

		    local nameLabel = display.newTTFLabel({text = data.name,color = CommonView.color_blue(),size = 22})
			nameLabel:pos(177+nameLabel:getContentSize().width/2, itemHeight - 27)

			local vipLabel = cc.Label:createWithCharMap("word2.png",15,20,48)
			vipLabel:setString(data.vipLevel)
			vipLabel:pos(220+nameLabel:getContentSize().width, itemHeight - 27)

			display.newSprite("Mail_Circle.png"):scale(0.75):pos(50, itemHeight - 57):addTo(cell)
			if self.sectionIndex == 2 then
				display.newSprite("World_Tip.png"):pos(140, itemHeight - 27):addTo(cell)
			elseif self.sectionIndex == 3 then
				display.newSprite("Union_Tip.png"):pos(140, itemHeight - 27):addTo(cell)
			end
	        display.newSprite("Vip_Small.png"):pos(195+nameLabel:getContentSize().width, itemHeight - 27):addTo(cell)
	        nameLabel:addTo(cell)
	        vipLabel:addTo(cell)
	        display.newSprite(data.headIcon):scale(0.75):pos(50, itemHeight - 57):addTo(cell)
	        display.newSprite("Chat_Tip_Other.png"):pos(103, itemHeight - 74):addTo(cell)
        else -- 我方消息
		    local boxWidth = label_:getLabelSize().width+10
		    local boxHeight = label_:getLabelSize().height+10
	    	local posX = 553 - boxWidth/2
	    	local chatBox = display.newScale9Sprite("Chat_Bg_Self.png",posX,25,cc.size(boxWidth,boxHeight))
	    	chatBox:setAnchorPoint(0.5,0)
	    	cell:addChild(chatBox)

	    	label_:pos(5,boxHeight-5)
	        label_:addTo(chatBox)

        	local nameLabel = display.newTTFLabel({text = data.name, color = CommonView.color_blue(), size = 22})
			nameLabel:pos(420-nameLabel:getContentSize().width/2, itemHeight - 27)

			local vipLabel = cc.Label:createWithCharMap("word2.png",15,20,48)
			vipLabel:setString(data.vipLevel)
			vipLabel:pos(468,itemHeight - 27)

			display.newSprite("Mail_Circle.png"):scale(0.75):pos(615, itemHeight - 57):addTo(cell)
			if self.sectionIndex == 2 then
				display.newSprite("World_Tip.png"):pos(520, itemHeight - 27):addTo(cell)
			elseif self.sectionIndex == 3 then
				display.newSprite("Union_Tip.png"):pos(520, itemHeight - 27):addTo(cell)
			end
	        display.newSprite("Vip_Small.png"):pos(440, itemHeight - 27):addTo(cell)
	        nameLabel:addTo(cell)
	        vipLabel:addTo(cell)
	        display.newSprite(data.headIcon):scale(0.75):pos(615,itemHeight - 57):addTo(cell)
	        display.newSprite("Chat_Tip_Self.png"):pos(557, itemHeight - 74):addTo(cell)
        end
	end
end

function ChatLayer:updateView()
	self.listView:reloadData()
end

function ChatLayer:removeTextfield()
	if self.textfield then
		self.textfield:removeFromParent()
		self.textfield = nil
	end
end

function ChatLayer:getCurrentSize(idx)
	if self.sectionIndex == 1 then
		return ChatData.sysSize[idx]
	elseif self.sectionIndex == 2 then
		return ChatData.worldSize[idx]
	elseif self.sectionIndex == 3 then
		return ChatData.unionSize[idx]
	end
end

function ChatLayer:getCurrentData(idx)
	if self.sectionIndex == 1 then
		return ChatData.sysData[idx]
	elseif self.sectionIndex == 2 then
		return ChatData.worldData[idx]
	elseif self.sectionIndex == 3 then
		return ChatData.unionData[idx]
	end
end

function ChatLayer:getCurrentCount()
	if self.sectionIndex == 1 then
		return #ChatData.sysData
	elseif self.sectionIndex == 2 then
		return #ChatData.worldData
	elseif self.sectionIndex == 3 then
		return #ChatData.unionData
	end
end

return ChatLayer
