--[[
    公会日志
]]
local UnionLogLayer = class("UnionLogLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 200))
end)

local BgImg = "union_member_bg.png"
local listImage = "union_list_bg.png"

function UnionLogLayer:ctor()
	self:initData()
	self:initView()
end

function UnionLogLayer:initData()
	self.msg = UnionListData.logMsg
end

function UnionLogLayer:initView()

	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy-20):addTo(self)

	-- 关闭按钮
	CommonButton.close()
	:addTo(self.spriteBg,3)
	:pos(640, 405)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeUnionLogLayer()
	end)

	--成员list
    self.listView = cc.TableView:create(cc.size(610,375))
	self.listView:setPosition(17,18)
	self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

	self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.listView:reloadData()
	self.spriteBg:addChild(self.listView)

end

function UnionLogLayer:cellSizeForTable(table,idx)
	return 25
end

function UnionLogLayer:tableCellAtIndex(table,idx)
	return self:createCell(idx)
end

function UnionLogLayer:numberOfCellsInTableView(table)
	return #self.msg
end

function UnionLogLayer:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)

    local logLabel = createOutlineLabel({
    		text  = self.msg[idx+1],
			size  = 20,
			dimensions = cc.size(570,0),
			color = cc.c3b(252, 242, 181),
    	})
    logLabel:setPosition(20,0)
    logLabel:setAnchorPoint(0,0)
    cell:addChild(logLabel)

    return cell
end

return UnionLogLayer
