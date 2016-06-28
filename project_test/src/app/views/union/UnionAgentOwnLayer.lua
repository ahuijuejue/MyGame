--[[
    我的雇佣兵
]]

local UnionAgentOwnLayer = class("UnionAgentOwnLayer", function()
	return display.newNode()
end)
local BgImg = "Union_Mail_Bg.png"
local title = "union_agent_title.png"
local word = "union_agent_word.png"
local list = "union_agent_list.png"
local pointImage = "Point_Red.png"

function UnionAgentOwnLayer:ctor()
	self:initData()
	self:initView()
end

function UnionAgentOwnLayer:initData()
    self.ownAgentData = UnionListData:showOwnAgent()
end

function UnionAgentOwnLayer:initView()

    -- 说明按钮
	CommonButton.yellow("说明", {color = cc.c3b(252, 242, 181), size = 24})
    :onButtonClicked(function ()
    	self.delegate.delegate:createAgentDesLayer()
        print("说明")
    end)
    :pos(145, 52)
    :addTo(self)

    -- 派出佣兵按钮
    CommonButton.yellow("派出佣兵", {color = cc.c3b(252, 242, 181), size = 24})
    :onButtonClicked(function ()
        print("派出佣兵")
        self.delegate.delegate:createAgentSendLayer()
    end)
    :pos(565, 52)
    :addTo(self)
    -- 雇佣兵红点
    self.agentRedPoint = display.newSprite(pointImage):pos(625, 72):zorder(11)
    self.agentRedPoint:setVisible(UnionListData:isShowSendRedPoint())
    self:addChild(self.agentRedPoint)

	-- 雇佣兵list
    self.listView = cc.TableView:create(cc.size(766,306))
    self.listView:setPosition(40,87)
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

end

function UnionAgentOwnLayer:scrollViewDidScroll(table)

end

function UnionAgentOwnLayer:tableCellTouched(table,cell)
	print("cellIdx:"..cell:getIdx())
end

function UnionAgentOwnLayer:cellSizeForTable(table,idx)
	  return 110
end

function UnionAgentOwnLayer:tableCellAtIndex(table,idx)
	  return self:createCell(idx)
end

function UnionAgentOwnLayer:numberOfCellsInTableView(table)
	  return #self.ownAgentData
end

function UnionAgentOwnLayer:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)

    local bgSprite = display.newSprite(list)
    bgSprite:setAnchorPoint(0,0)
    cell:addChild(bgSprite)

    -- 佣兵信息
    local data = self.ownAgentData[idx+1]

    -- 佣兵头像
    display.newSprite("Mail_Circle.png"):scale(0.75):pos(80, 50):addTo(cell)
    display.newSprite(data.avatarImage):pos(80, 47):addTo(cell):scale(0.7)

    -- 佣兵收入
    local posX = 240
    local gainTotal = display.newTTFLabel({text = UnionListData:getTotalGain(data.level, data.sendTime, data.useTimes ),
                                           color = cc.c3b(252, 242, 181), size = 18})
    gainTotal:pos(posX+gainTotal:getContentSize().width/2, 60):addTo(cell)

    -- 佣兵派出时间
    local time_ = display.newTTFLabel({text = UnionListData:getAgentTimeByHeroId_(data.sendTime), color = cc.c3b(252, 242, 181), size = 18})
    time_:pos(posX+time_:getContentSize().width/2, 30):addTo(cell)

    local agentTime = UnionListData:getAgentTimeByHeroId(data.sendTime)  -- 已被派出的时间 小时
    CommonButton.yellow("立即归队", {color = cc.c3b(252, 242, 181), size = 24})
    :onButtonClicked(function ()
        if agentTime < 8 then  -- 派出时间不足8小时 则提醒
            showToast({text = string.format("该英雄还有%d小时后才能归队", 8 - agentTime)})
        else
            self.delegate.delegate:createAgentGainLayer({
                heroLevel = tonumber(data.level),
                time = data.sendTime,
                agentTimes = data.useTimes,
                heroId = data.roleId})
        end
    end)
    :pos(590, 55)
    :addTo(cell)
    :scale(0.9)

    local redPoint = display.newSprite(pointImage):pos(650, 75):zorder(11)
    redPoint:setVisible(UnionListData:getAgentGain_(data.level, data.useTimes) or UnionListData:getProTectGain_(data.level, data.sendTime))
    cell:addChild(redPoint)

    return cell
end

function UnionAgentOwnLayer:updateData()
    self.ownAgentData = UnionListData.ownAgentData
end

function UnionAgentOwnLayer:updateView()
    -- 雇佣兵红点
    self.agentRedPoint:setVisible(UnionListData:isShowSendRedPoint())
    self.listView:reloadData()
end

return UnionAgentOwnLayer
