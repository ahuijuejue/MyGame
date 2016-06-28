local UnionApplyLayer = class("UnionApplyLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 200))
end)

local listImage = "union_list_bg.png"
local BgImg = "Union_Mail_Bg.png"
local applyTitle = "union_apply_title.png"

function UnionApplyLayer:ctor()
	self:initData()
	self:initView()
end

function UnionApplyLayer:initData()
	self.listIndex = nil
    self.applyCounts = 1
	self.applyData = UnionListData.applyData
    if #self.applyData > 0 then
        self.applyCounts = #self.applyData
    end
end

function UnionApplyLayer:initView()
	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy-20):addTo(self)
	display.newSprite(applyTitle):pos(380, 425):addTo(self.spriteBg)

	-- 关闭按钮
	CommonButton.close()
	:addTo(self.spriteBg,3)
	:pos(750, 445)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeUnionApplyLayer()
	end)

    --申请人list
    self.listView = cc.TableView:create(cc.size(772,377))
	self.listView:setPosition(18,19)
	self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

    self.listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), 0)
    self.listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
	self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.listView:reloadData()
	self.spriteBg:addChild(self.listView)
end

function UnionApplyLayer:scrollViewDidScroll(table)

end

function UnionApplyLayer:tableCellTouched(table,cell)
	-- print("cellIdx:"..cell:getIdx())
end

function UnionApplyLayer:cellSizeForTable(table,idx)
	return 105
end

function UnionApplyLayer:tableCellAtIndex(table,idx)
	return self:createCell(idx)
end

function UnionApplyLayer:numberOfCellsInTableView(table)
	return self.applyCounts
end

function UnionApplyLayer:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)

	local bgSprite = display.newSprite(listImage):scale(0.95)
    bgSprite:setAnchorPoint(0,0)
    cell:addChild(bgSprite)

    if self.applyCounts == 1 and #self.applyData == 0 then
        createOutlineLabel({text = "暂时没有新的人员申请",color = cc.c3b(254, 231, 93), size = 20}):pos(127,50):addTo(cell)
    else
        local data = self.applyData[idx+1]

        display.newSprite("Mail_Circle.png"):pos(60,50):scale(0.75):addTo(cell)
        display.newSprite(data.icon):pos(60, 50):scale(0.75):addTo(cell)  -- data.icon

        local pos = 112
        local name = display.newTTFLabel({text = data.name,color = cc.c3b(254, 231, 93), size = 20}) -- data.name
        name:pos(pos+name:getContentSize().width/2,65)
        name:addTo(cell)

        local memLv = display.newTTFLabel({text = "lv."..tostring(GameExp.getUserLevel(data.exp)), color = cc.c3b(254, 231, 93), size = 20}) -- data.lv
        memLv:pos(pos+memLv:getContentSize().width/2,30)
        memLv:addTo(cell)

        local totalP = display.newTTFLabel({text = "战力："..data.power,color = cc.c3b(252, 242, 181), size = 20})  -- data.power
        totalP:pos(pos+165+totalP:getContentSize().width/2,45)
        totalP:addTo(cell)

        local pos = 652
        CommonButton.yellow("拒绝", {color = cc.c3b(252, 242, 181)})
        :onButtonClicked(function ()
            self.listIndex = idx + 1
            NetHandler.gameRequest("ApproveJoin", {param1 = 0, param2 = data.userId})
        end)
        :pos(pos - 120, 45)
        :scale(0.7)
        :addTo(cell)

        CommonButton.yellow("同意", {color = cc.c3b(252, 242, 181)})
        :onButtonClicked(function ()
            self.listIndex = idx + 1
            if tonumber(UnionListData.unionData.memberNums) == tonumber(UnionListData.unionData.memberMaxNums) then
                showToast({text = "公会人员已满！"})
            else
                NetHandler.gameRequest("ApproveJoin", {param1 = 1, param2 = data.userId})
            end
        end)
        :pos(pos,45)
        :scale(0.7)
        :addTo(cell)
    end

    return cell
end

function UnionApplyLayer:updateData()
    self.applyCounts = 1
    self.applyData = UnionListData.applyData
    if #self.applyData > 0 then
        self.applyCounts = #self.applyData
    end
end

function UnionApplyLayer:updateView()
    self.listView:reloadData()
end

return UnionApplyLayer