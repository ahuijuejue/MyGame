--[[
    公会全员邮件
]]
local UnionMailLayer = class("UnionMailLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 200))
end)

local BgImg         = "Union_Mail_Bg.png"
local applyTitle    = "Mail_Name.png"
local MailSenderImg = "Mail_Sender.png"
local MailDesImg    = "Mail_Des.png"

function UnionMailLayer:ctor()
	self:initData()
	self:initView()
end

function UnionMailLayer:initData()
	self.senderName = UserData.name
	self.sendMSg    = ""
    self.mailCount = UnionListData.mailCounts
end

function UnionMailLayer:initView()
	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy-20):addTo(self)
	display.newSprite(applyTitle):pos(380, 425):addTo(self.spriteBg)

    local posX = 180
	local label1 = display.newTTFLabel({text = "发送人：",color = cc.c3b(254, 231, 93), size = 24})
    label1:pos(posX-label1:getContentSize().width/2,350):addTo(self.spriteBg)

    display.newSprite(MailSenderImg):pos(posX+210, 350):addTo(self.spriteBg)
    local senderName = display.newTTFLabel({text = self.senderName,color = cc.c3b(254, 231, 93), size = 24})
    senderName:pos(posX+10+senderName:getContentSize().width/2,350):addTo(self.spriteBg)

    local label2 = display.newTTFLabel({text = "邮件内容：",color = cc.c3b(254, 231, 93), size = 24})
    label2:pos(posX-label2:getContentSize().width/2,280):addTo(self.spriteBg)

    local image_ = {normal = MailDesImg}
    CommonButton.yellow3("", {image = image_})
    :onButtonClicked(function ()
    	self.delegate:createUnionEditBox({
                msg        = self.sendMSg,
                fontNum    = 1000,
                width      = 529,
                height     = 35,
                posX       = display.cx + 60,
                posY       = display.cy + 25,
                des        = "输入邮件内容",
                maxLength  = 66,
                })
    end)
    :pos(posX+265, 200):addTo(self.spriteBg)

    CommonButton.yellow("取消", {color = cc.c3b(252, 242, 181)})
    :onButtonClicked(function ()
    	self.delegate:removeUnionMailLayer()
	end)
	:addTo(self.spriteBg)
	:pos(185, 65)

	CommonButton.yellow("发送", {color = cc.c3b(252, 242, 181)})
    :onButtonClicked(function ()
        if self.mailCount < 2 then
            if self.sendMSg == "" then
                showToast({text = "写邮件了吗？"})
            else
                NetHandler.gameRequest("SendUnionMail", {param1 = self.sendMSg})
            end
        else
            showToast({text = "一天只能发送两封邮件哦！"})
        end
	end)
	:pos(585,65)
	:addTo(self.spriteBg)

end

function UnionMailLayer:updateData()
    self.mailCount = UnionListData.mailCounts
end

function UnionMailLayer:updateView()
	if self.des then
        self.des:removeFromParent()
        self.des = nil
    end
	self.des = base.TalkLabel.new({
                text  = self.sendMSg,
                size  = 23,
                dimensions = cc.size(523, 0),
                color = cc.c3b(254, 231, 93)
            })
    self.des:pos(192, 285 - 25*self.des:getLines())
    self.des:addTo(self.spriteBg,2)
end

return UnionMailLayer

