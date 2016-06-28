local UnionJoinLayer = class("UnionJoinLayer",function ()
	return display.newNode()
end)

local listImage = "union_list_bg.png"
local barImage = "union_bar.png"

function UnionJoinLayer:ctor()
	self:initData()
	self:initView()
end

function UnionJoinLayer:initData()
	self.requestCounts = 0
	self.unionCounts  = 0
	self.unionCounts_ = 0
	self.unionData    = {}
	for i,v in ipairs(UnionListData.unionShowList) do
		self.unionCounts = i
		table.insert(self.unionData, v)
	end
end

function UnionJoinLayer:initView()
	self.listView = cc.TableView:create(cc.size(772,355))
	self.listView:setPosition(25,20)
	self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

    self.listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), 0)
    self.listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
	self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.listView:reloadData()
	self:addChild(self.listView)

    -- local viewSize = self.listView:getViewSize().height
    -- local contenSize = self.listView:getContentSize().height
    -- local percent = viewSize / contenSize
    -- self.sliderBar = display.newSprite("bar.png")
    -- self.sliderBar:setPosition(800, 345)
    -- self:addChild(self.sliderBar)

    -- if self.unionCounts == 0 then
    -- 	self.sliderBar:hide()
    -- else
    -- 	self.sliderBar:show()
    -- end

end

function UnionJoinLayer:scrollViewDidScroll(table)
    -- local sliderPos = self.listView:getContentOffset().y
    -- local sliderPos_ = self.listView:getContentSize().height- self.listView:getViewSize().height
    -- local percent = -(sliderPos/sliderPos_)
    -- if self.sliderBar then
    -- 	if 355*percent+40 > 344 then
    -- 		self.sliderBar:setPosition(800, 344)
    -- 	elseif 355*percent+40 < 39 then
    -- 		self.sliderBar:setPosition(800, 39)
    -- 	else
    -- 		self.sliderBar:setPosition(800, 355*percent+40)
    -- 	end
    -- end
end

function UnionJoinLayer:tableCellTouched(table,cell)
	print("cellIdx:"..cell:getIdx())
end

function UnionJoinLayer:cellSizeForTable(table,idx)
	return 105
end

function UnionJoinLayer:tableCellAtIndex(table,idx)
	if idx+1 == self.unionCounts then
		local pageNum = math.ceil((idx+1)/10) + 1
		if pageNum ~= 1 then
			if self.requestCounts ~= pageNum then
				self.requestCounts = pageNum
				NetHandler.gameRequest("SHowUnionByPage", {param1 = self.requestCounts})
			else
				self.requestCounts = self.requestCounts + 1
				NetHandler.gameRequest("SHowUnionByPage", {param1 = self.requestCounts})
			end
		end
	end
	return self:createCell(idx)
end

function UnionJoinLayer:numberOfCellsInTableView(table)
	return self.unionCounts
end

function UnionJoinLayer:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)

    local bgSprite = display.newSprite(listImage)
    bgSprite:setAnchorPoint(0,0)
    cell:addChild(bgSprite)

	local data  = self.unionData[idx+1]
	local grid = base.Grid.new()
	self:setGridShow(grid, data, idx+1)
	cell:addChild(grid)

    return cell
end

function UnionJoinLayer:setGridShow(grid, data, index)
	grid:removeItems()
	:addItems({
		display.newSprite(data.icon):pos(75,52):scale(0.8), -- 公会头像
		display.newSprite("union_lv.png"):pos(63,15), -- 公会等级
        -- display.newTTFLabel({text = "lv."}):pos(60,15),  -- 公会等级
        display.newTTFLabel({text = "申请等级"..data.applyLv,color = cc.c3b(252, 242, 181),size = 18}):pos(670,85),   -- 申请等级
		})
	local centetUnionBtn = CommonButton.yellow("立即加入", {size = 22,color = cc.c3b(252, 242, 181)})   -- 申请加入按钮
					        :onButtonClicked(function ()
					        	if UnionListData.isCanApply == 1 then
					        		NetHandler.gameRequest("ApplyUnion", {param1 = data.id})
					        	elseif UnionListData.isCanApply == 0 then
					        		showToast({text = "退出公会后1个小时内不能申请"})
					        	end
							end)
							:pos(675,40)
	if tonumber(data.applyLv) <= tonumber(UserData:getUserLevel()) then
		centetUnionBtn:setButtonEnabled(true)
	else
		centetUnionBtn:setButtonEnabled(false)
	end

	if data.isApply == 0 then
		centetUnionBtn:setButtonEnabled(true)
	elseif data.isApply == 1 then
		centetUnionBtn:setButtonEnabled(false)
		centetUnionBtn:setButtonLabel(base.Label.new({text="已申请", size=22}):align(display.CENTER))
	end

	local expLabel = cc.Label:createWithCharMap("word2.png",15,20,48)
	expLabel:setString(UnionListData:getLevel(tonumber(data.exp)))    -- 公会等级
	expLabel:pos(78+expLabel:getContentSize().width/2,14)

	local pos = 150
	local member_ = "（"..data.memberNums.."/"..data.memberMaxNums.."）"
    local name = display.newTTFLabel({text = data.name..member_,color = cc.c3b(254, 231, 93), size = 22})  -- 公会名称
    name:pos(pos+name:getContentSize().width/2,70)
    local des = display.newTTFLabel({text = data.info,color = cc.c3b(252, 242, 181), size = 18})  -- 公会简介
    des:pos(pos+des:getContentSize().width/2,30)

    grid:addItems({centetUnionBtn, name, des, expLabel,
    	})-- display.newSprite("Vip_Small.png"):pos(60, 15)
end

function UnionJoinLayer:updateData()
	self.unionCounts_ = self.unionCounts
	for i,v in ipairs(UnionListData.unionShowList) do
		self.unionCounts = i
		table.insert(self.unionData, v)
	end
end

function UnionJoinLayer:insertListCell()
	self.listView:reloadData()
	self.listView:setContentOffset(cc.p(0, -1050), false)
end

function UnionJoinLayer:updateView()
	-- if self.unionCounts == 0 then
 --    	self.sliderBar:hide()
 --    else
 --    	self.sliderBar:show()
 --    end
	self.listView:reloadData()
end

return UnionJoinLayer
