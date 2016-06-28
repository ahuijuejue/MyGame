
local ChatSetView = class("ChatSetView", function()
	return display.newColorLayer(cc.c4f(0, 0, 0, 150))
end)

local chooseBtn = "Set_Choose.png"

function ChatSetView:ctor()
	self.isChoose = {
		cc.UserDefault:getInstance():getStringForKey(UserData.teamId.."Channel_System"),
		cc.UserDefault:getInstance():getStringForKey(UserData.teamId.."Channel_World"),
		cc.UserDefault:getInstance():getStringForKey(UserData.teamId.."Channel_Union"),
	}

    for i=1,#self.isChoose do
    	if self.isChoose[i] == "" then
    		self.isChoose[i] = "1"
    	end
    end

    self.chooseBtn = {}
    self.choose    = {}

    self:initView()
end

function ChatSetView:initView()
	self.layer_ = display.newNode():size(960, 640):align(display.CENTER)
    :addTo(self)
    :center()
    :zorder(1)

	CommonButton.close()
	:scale(0.8)
	:addTo(self.layer_, 1)
	:pos(715, 430)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeSetView()
	end)

    display.newSprite("Set_Bg.png"):addTo(self.layer_):pos(475,300)
    createOutlineLabel({text = "营地接收频道设置", size = 24, color = cc.c3b(255,255,10)})
    :pos(375,400):addTo(self.layer_)

    -- 系统频道消息是否显示
    local image_ = {normal = chooseBtn, pressed = chooseBtn}
	self.chooseBtn1 = CommonButton.yellow3("",{image = image_})
	:addTo(self.layer_,1)
	:pos(300, 340)
	:setButtonLabel(cc.ui.UILabel.new({text = "系统频道", size = 24, color = cc.c3b(255,255,10)}))
	:setButtonLabelOffset(40, 0)
    :setButtonLabelAlignment(display.LEFT_CENTER)
	:onButtonClicked(function()
        if self.isChoose[1] == "0" then
        	cc.UserDefault:getInstance():setStringForKey(UserData.teamId.."Channel_System","1")
	        cc.UserDefault:getInstance():flush()
        elseif self.isChoose[1] == "1" then
        	cc.UserDefault:getInstance():setStringForKey(UserData.teamId.."Channel_System","0")
	        cc.UserDefault:getInstance():flush()
        end
        self.isChoose[1] = cc.UserDefault:getInstance():getStringForKey(UserData.teamId.."Channel_System")
        self:updateChooseState(1)
        dump(self.isChoose[1])
	end)
	table.insert(self.chooseBtn, self.chooseBtn1)

	-- 世界频道消息是否显示
    local image_ = {normal = chooseBtn, pressed = chooseBtn}
	self.chooseBtn2 = CommonButton.yellow3("",{image = image_})
	:addTo(self.layer_,1)
	:pos(530, 340)
	:setButtonLabel(cc.ui.UILabel.new({text = "世界频道", size = 24,  color = cc.c3b(255,255,10)}))
	:setButtonLabelOffset(40, 0)
    :setButtonLabelAlignment(display.LEFT_CENTER)
	:onButtonClicked(function()
        if self.isChoose[2] == "0" then
        	cc.UserDefault:getInstance():setStringForKey(UserData.teamId.."Channel_World","1")
	        cc.UserDefault:getInstance():flush()
        elseif self.isChoose[2] == "1" then
        	cc.UserDefault:getInstance():setStringForKey(UserData.teamId.."Channel_World","0")
	        cc.UserDefault:getInstance():flush()
        end
        self.isChoose[2] = cc.UserDefault:getInstance():getStringForKey(UserData.teamId.."Channel_World")
        self:updateChooseState(2)
	end)
	table.insert(self.chooseBtn, self.chooseBtn2)

	-- 公会频道消息是否显示
	local image_ = {normal = chooseBtn, pressed = chooseBtn}
	self.chooseBtn3 = CommonButton.yellow3("",{image = image_})
	:addTo(self.layer_,1)
	:pos(300, 270)
	:setButtonLabel(cc.ui.UILabel.new({text = "公会频道", size = 24,  color = cc.c3b(255,255,10)}))
	:setButtonLabelOffset(40, 0)
    :setButtonLabelAlignment(display.LEFT_CENTER)
	:onButtonClicked(function()
        if self.isChoose[3] == "0" then
        	cc.UserDefault:getInstance():setStringForKey(UserData.teamId.."Channel_Union","1")
	        cc.UserDefault:getInstance():flush()
        elseif self.isChoose[3] == "1" then
        	cc.UserDefault:getInstance():setStringForKey(UserData.teamId.."Channel_Union","0")
	        cc.UserDefault:getInstance():flush()
        end
        self.isChoose[3] = cc.UserDefault:getInstance():getStringForKey(UserData.teamId.."Channel_Union")
        self:updateChooseState(3)
	end)
	table.insert(self.chooseBtn, self.chooseBtn3)


end

function ChatSetView:updateChooseState(index)
	ChatData.setState = self.isChoose

	if index then
		if self.isChoose[index] == "1" then
			self.choose[tostring(index)] = display.newSprite("Select_Chart_Green.png")
			:addTo(self.chooseBtn[index]):scale(0.8)
	    else
	    	if self.choose[tostring(index)] then
	    		self.choose[tostring(index)]:removeFromParent()
			    self.choose[tostring(index)] = nil
	    	end
		end
	else
		for i=1,#self.isChoose do
			if self.isChoose[i] == "1" then
				self.choose[tostring(i)] = display.newSprite("Select_Chart_Green.png")
				:addTo(self.chooseBtn[i]):scale(0.8)
		    else
		    	if self.choose[tostring(i)] then
				    self.choose[tostring(i)]:removeFromParent()
				    self.choose[tostring(i)] = nil
				end
			end
		end
	end

end

return ChatSetView
