local NoticeLayer = class("NoticeLayer",function ()
	return display.newLayer()
end)

local UIScrollView = import("framework.cc.ui.UIScrollView")
local noticeImage = "Notice_Board.png"

function NoticeLayer:ctor(notice)
	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

	local noticeSprite = display.newSprite(noticeImage)
	noticeSprite:setPosition(display.cx,display.cy)
	self:addChild(noticeSprite)

	local node = display.newNode()

	local noticeTab = json.decode(notice)

	local param = {text = noticeTab.title,size = 24}
	local title = createOutlineLabel(param)
	title:setPosition(332,400-24)
	title:setColor(display.COLOR_GREEN)
	node:addChild(title)

	local param = {text = noticeTab.content, 
		size = 20, 
		align = cc.ui.TEXT_ALIGN_LEFT, 
		dimensions = cc.size(550, 0)}
	local content = createOutlineLabel(param)
	content:setAnchorPoint(0,1)
	content:setPosition(65,400-44)
	node:addChild(content)

	local offsetY = title:getContentSize().height + content:getContentSize().height
	local param = {text = "From: "..noticeTab.sender, size = 20}
	local sender = createOutlineLabel(param)
	sender:setAnchorPoint(1,1)
	sender:setColor(cc.c3b(255,97,0))
	sender:setPosition(600,400-offsetY-20)
	node:addChild(sender)

	local rect = {x = 65,y = 91,width = 580, height = 300}
	cc.ui.UIScrollView.new({viewRect = rect})
    :addScrollNode(node)
    :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
    :addTo(noticeSprite)

    local param1 = {normal = "Button_Enter.png", pressed = "Button_Enter_Light.png"}
    local param2 = {text = GET_TEXT_DATA("TEXT_SURE")}
    local closeBtn = createButtonWithLabel(param1,param2)
    :onButtonClicked(function ()
    	AudioManage.playSound("Click.mp3")
    	self:removeFromParent(true)
    end)
    closeBtn:setPosition(332,50)
    noticeSprite:addChild(closeBtn)
end

return NoticeLayer