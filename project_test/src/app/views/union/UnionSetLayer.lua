--[[
    公会申请设置
]]
local UnionSetLayer = class("UnionSetLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 200))
end)

local BgImg = "Union_Mail_Bg.png"
local applyTitle = "union_set.png"
local applyStage = {"30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85"}
local image_ = {
	    normal = "union_image.png",
	    pressed = "union_image.png",
	    disabled = "union_image.png",
	}
local img1 = { normal = "union_img1.png"}
local img2 = { normal = "union_img2.png"}
local img1_ = "union_img1.png"
local img2_ = "union_img2.png"

function UnionSetLayer:ctor()
	self:initData()
	self:initView()
end

function UnionSetLayer:initData()
	self.applyNum = tonumber(UnionListData.unionData.applyLv)
	if tonumber(UnionListData.unionData.applyType) == 1 then
		self.isPassApply = false
	elseif tonumber(UnionListData.unionData.applyType) == 2 then
		self.isPassApply = true
	end
    self.addImg = {true , true}
end

function UnionSetLayer:initView()
	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy-20):addTo(self)
	display.newSprite(applyTitle):pos(380, 425):addTo(self.spriteBg)

    local posX = -50
	local label1 = display.newTTFLabel({text = "设置入会申请等级：",color = cc.c3b(254, 231, 93), size = 24})
    label1:pos(posX+label1:getContentSize().width,345):addTo(self.spriteBg)

    -- 入会申请等级
    self.img1 = display.newSprite():pos(347,345):addTo(self.spriteBg, 2)

    CommonButton.yellow3("",{image = image_})
    :onButtonClicked(function ()
    	self.addImg[1] = not self.addImg[1]
    	if self.addImg[1] then
    		self.img1:setTexture("union_2.png")
    		self:removeJoinLevel(1)
    	else
    		self.img1:setTexture("union_1.png")
    		self.listView:show()
    		self.listView:setTouchEnabled(true)
			self.btnApply:setButtonEnabled(false)
    	end
	end)
	:pos(328, 345)
	:addTo(self.spriteBg)

    self.applyStage = display.newTTFLabel({text = "",color = CommonView.color_black(), size = 24})
    self.applyStage:pos(310, 345):addTo(self.spriteBg, 2)

    local label2 = display.newTTFLabel({text = "设置跳过入会申请：",color = cc.c3b(254, 231, 93), size = 24})
    label2:pos(posX+label2:getContentSize().width,250):addTo(self.spriteBg)

    -- 是否跳过入会申请
    self.img2 = display.newSprite():pos(347,250):addTo(self.spriteBg, 5)

    self.btnApply = CommonButton.yellow3("",{image = image_})
    :onButtonClicked(function ()
    	self.addImg[2] = not self.addImg[2]
    	if self.addImg[2] then
    		self.img2:setTexture("union_2.png")
    		self:removeIsPass()
    	else
    		self.img2:setTexture("union_1.png")
    		self:createIsPass()
    		self:updateBtnState()
    	end
	end)
	:pos(328, 250)
	:addTo(self.spriteBg)

    self.isPassLabel= display.newTTFLabel({text = "",color = CommonView.color_black(), size = 24})
    self.isPassLabel:pos(310, 250):addTo(self.spriteBg,2)

    local label3 = display.newTTFLabel({text = "（设置后所有玩家申请入会后自动入会）",color = CommonView.color_red() , size = 20})
    label3:pos(posX+label3:getContentSize().width-85,210):addTo(self.spriteBg)

    CommonButton.yellow("取消", {color = cc.c3b(252, 242, 181)})
    :onButtonClicked(function ()
    	self.delegate:removeUnionSetLayer()
	end)
	:addTo(self.spriteBg)
	:pos(185, 65)

	CommonButton.yellow("确定", {color = cc.c3b(252, 242, 181)})
    :onButtonClicked(function ()
    	local ispass = 0
    	if self.isPassApply then
    		ispass = 2
    	else
    		ispass = 1
    	end
    	if self.applyNum == tonumber(UnionListData.unionData.applyLv) and ispass == tonumber(UnionListData.unionData.applyType) then
    		self.delegate:removeUnionSetLayer()
    	else
    		NetHandler.gameRequest("ModifyUnionSetUp", { param1 = self.applyNum, param2 = ispass })
    	end
	end)
	:pos(585,65)
	:addTo(self.spriteBg)

	self:createJoinLevel()
	self.listView:hide()
end

function UnionSetLayer:createJoinLevel()
    --成员list
    self.listView = cc.TableView:create(cc.size(80,140))
	self.listView:setPosition(295,188)
	self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

    self.listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), 0)
    self.listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
	self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.listView:reloadData()
	self.spriteBg:addChild(self.listView, 5)

end

function UnionSetLayer:scrollViewDidScroll(table)
end

function UnionSetLayer:tableCellTouched(table,cell)
	local idx = cell:getIdx()
	self.applyNum = tonumber(applyStage[idx+1])
	self.applyStage:setString(applyStage[idx+1])
	self:removeJoinLevel(2)
end

function UnionSetLayer:cellSizeForTable(table,idx)
	return 34
end

function UnionSetLayer:tableCellAtIndex(table,idx)
	return self:createCell(idx)
end

function UnionSetLayer:numberOfCellsInTableView(table)
	return #applyStage
end

function UnionSetLayer:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)

    local string_ = self.applyStage:getString()
    if string_ == applyStage[idx+1] then
    	local bgSprite = display.newSprite(img1_)
	    bgSprite:setAnchorPoint(0,0)
	    cell:addChild(bgSprite)
	else
		local bgSprite = display.newSprite(img2_)
	    bgSprite:setAnchorPoint(0,0)
	    cell:addChild(bgSprite)
    end

    display.newTTFLabel({text = tostring(applyStage[idx+1]),color = CommonView.color_black(), size = 24})
    :pos(30,15):addTo(cell)

    return cell
end

function UnionSetLayer:removeJoinLevel(data)
	if data == 2 then
		self.addImg[1] = not self.addImg[1]
		self.img1:setTexture("union_2.png")
	end

    self.btnApply:setButtonEnabled(true)

    if self.listView then
    	self.listView:hide()
    	self.listView:setTouchEnabled(false)
    end
end

function UnionSetLayer:createIsPass()
	self.btn1 = CommonButton.yellow3("否",{image = img1})
    :onButtonClicked(function ()
        self.isPassLabel:setString("否")
        self:removeIsPass(2)
        self.isPassApply = false
	end)
	:pos(328, 215)
	:addTo(self.spriteBg)

	self.btn2 = CommonButton.yellow3("是",{image = img1})
    :onButtonClicked(function ()
    	self.isPassLabel:setString("是")
    	self:removeIsPass(2)
    	self.isPassApply = true
	end)
	:pos(328, 180)
	:addTo(self.spriteBg)
end

function UnionSetLayer:removeIsPass(data)
	if data == 2 then
		self.addImg[2] = not self.addImg[2]
		self.img2:setTexture("union_2.png")
	end

	if self.btn1 then
		self.btn1:removeFromParent()
		self.btn1 = nil
	end
	if self.btn2 then
		self.btn2:removeFromParent()
		self.btn2 = nil
	end
end

function UnionSetLayer:updateBtnState()

    local string_ = self.isPassLabel:getString()
    if string_ == "否" then
    	self.btn1:setButtonImage("normal","union_img1.png")
    	self.btn2:setButtonImage("normal","union_img2.png")
    elseif string_ == "是" then
    	self.btn1:setButtonImage("normal","union_img2.png")
    	self.btn2:setButtonImage("normal","union_img1.png")
    end
end

function UnionSetLayer:updateData()
	self.applyNum = tonumber(UnionListData.unionData.applyLv)
	if tonumber(UnionListData.unionData.applyType) == 1 then
		self.isPassApply = false
	elseif tonumber(UnionListData.unionData.applyType) == 2 then
		self.isPassApply = true
	end
    self.addImg = {true , true}
end

function UnionSetLayer:updateView()
	self.applyStage:setString(tostring(self.applyNum))
	if self.isPassApply then
		self.isPassLabel:setString("是")
	else
		self.isPassLabel:setString("否")
	end

	if self.addImg[1] then
		self.img1:setTexture("union_2.png")
	else
		self.img1:setTexture("union_1.png")
	end

	if self.addImg[2] then
		self.img2:setTexture("union_2.png")
	else
		self.img2:setTexture("union_1.png")
	end

end

return UnionSetLayer
