local ZoneListLayer = class("ZoneListLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 125))
end)

local UIListView = import("framework.cc.ui.UIListView")

local recentImage = "server_recent.png"
local supImage = "server_support.png"
local bgImage = "ServerList.png"
local closeImage = "Close.png"
local nodeImage = "Server_Bg.png"
local TAG = {
        [-1] = "tag_4.png",
        [1] = "tag_1.png",
        [2] = "tag_2.png",
        [3] = "tag_3.png"
    }
local unit = 3

function ZoneListLayer:ctor()

    local recentBg = display.newSprite(recentImage)
    recentBg:pos(display.cx - 182,display.cy + 202)
    recentBg:addTo(self)
    self.recentBtn = createButtonWithLabel({normal = "Server_Bg.png"},{text = "",size = 20})
    self.recentBtn:pos(154,50)
    self.recentBtn:addTo(recentBg)

    local supBg = display.newSprite(supImage)
    supBg:pos(display.cx + 182,display.cy + 202)
    supBg:addTo(self)
    self.supBtn = createButtonWithLabel({normal = "Server_Bg.png"},{text = "",size = 20})
    self.supBtn:pos(154,51)
    self.supBtn:addTo(supBg)

	local bgSprite = display.newSprite(bgImage)
    bgSprite:setPosition(display.cx,display.cy - 90)
    self:addChild(bgSprite)

    self.listView = self:createListView()
    self.listView:pos(20,17)
    bgSprite:addChild(self.listView,2)

end

function ZoneListLayer:createListView()
	local params = {viewRect = cc.rect(0,0,735,330),direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
	listView = UIListView.new(params)
    return listView
end

function ZoneListLayer:updateList(data,param1,param2)
    for i=1,#data do
        if data[i].id == UserData.zoneId then
            self.recentBtn:setButtonLabelString(data[i].name)  -- 最近服务器
            :onButtonClicked(function()
                AudioManage.playSound("Click.mp3")
                UserData.zoneName = data[i].name
                UserData.zoneId = data[i].id
                if self.delegate then
                    self.delegate:updateZoneName()
                end
                self:setVisible(false)
            end)
            if self.hotMark1 then
                self.hotMark1:setTexture(TAG[data[i].status])
            else
                self.hotMark1 = display.newSprite(TAG[data[i].status])
                self.recentBtn:addChild(self.hotMark1:pos(-85,0), 2)
            end
            self.recentBtn:setTouchSwallowEnabled(false)
        end
        if data[i].id == param1 then
            self.supBtn:setButtonLabelString(param2)  -- 推荐服务器
            :onButtonClicked(function()
                AudioManage.playSound("Click.mp3")
                UserData.zoneName = data[i].name
                UserData.zoneId = data[i].id
                if self.delegate then
                    self.delegate:updateZoneName()
                end
                self:setVisible(false)
            end)
            if self.hotMark2 then
                self.hotMark2:setTexture(TAG[data[i].status])
            else
                self.hotMark2 = display.newSprite(TAG[data[i].status])
                self.supBtn:addChild(self.hotMark2:pos(-85,0), 2)
            end
            self.supBtn:setTouchSwallowEnabled(false)
        end
    end

    self.listView:removeAllItems()
	local itemLine = math.ceil(#data/unit)
	self:createItems(itemLine,data)
    self.listView:reload()
end

function ZoneListLayer:createItems(itemLine,data)
    for i=1,itemLine do
        local item = self.listView:newItem()
        local content = display.newNode()
        for count = 1,unit do
            local index = (i-1)*unit + count
            if index <= #data then
                local posX = (count-1)*246 + 117
                local posY = 40
                local node = self:createZoneNode(data[index])
                node:setPosition(posX,posY)
                content:addChild(node)
            end
        end
        content:setContentSize(735,65)
        item:addContent(content)
        item:setItemSize(735,65)
        self.listView:addItem(item)
    end
end

function ZoneListLayer:createZoneNode(data)
    local zoneName = data.name
    local param1 = {normal = nodeImage, pressed = nodeImage}
    local param2 = {text = zoneName,size = 20}
    local zoneBtn = createButtonWithLabel(param1,param2)
    :onButtonClicked(function()
        AudioManage.playSound("Click.mp3")
        UserData.zoneName = data.name
        UserData.zoneId = data.id
        if self.delegate then
            self.delegate:updateZoneName()
        end
        self:setVisible(false)
        NetHandler.tokenHandler()
    end)
    zoneBtn:addChild(display.newSprite(TAG[data.status]):pos(-85,0), 2)
    zoneBtn:setTouchSwallowEnabled(false)
    return zoneBtn
end

return ZoneListLayer