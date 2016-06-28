local UnionAgentSendLayer = class("UnionAgentSendLayer",function ()
	return display.newNode()
end)

local backBoard = "agent_send.png"
local agentNodeImg = "agent_seng_node.png"

local unit = 4

function UnionAgentSendLayer:ctor()
    self:initData()
	self:initView()
end

function UnionAgentSendLayer:initData()
	self.data = UnionListData:getHeroList_()
	self.ownLine = math.ceil(#self.data/unit)
end

function UnionAgentSendLayer:initView()
	CommonView.blackLayer2()
	:addTo(self)

	local listBoard = display.newSprite(backBoard):pos(display.cx,display.cy-30):addTo(self)

	-- 关闭按钮
	CommonButton.close()
	:addTo(listBoard,3)
	:pos(548, 505)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeAgentSendLayer()
	end)

    self.listView = cc.TableView:create(cc.size(560,470))
    self.listView:setPosition(13,20)
    self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

    self.listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), 0)
    self.listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.listView:reloadData()
    listBoard:addChild(self.listView)

end

function UnionAgentSendLayer:scrollViewDidScroll(table)

end

function UnionAgentSendLayer:tableCellTouched(table,cell)
	-- print("cellIdx:"..cell:getIdx())
end

function UnionAgentSendLayer:cellSizeForTable(table,idx)
    return 105
end

function UnionAgentSendLayer:tableCellAtIndex(table,idx)
	local cell
    cell = self:createItem(idx, self.data, idx)
    return cell
end

function UnionAgentSendLayer:numberOfCellsInTableView(table)
	local count = self.ownLine
    return count
end

function UnionAgentSendLayer:createItem(idx,heroList,cellIdx)
    local item = cc.TableViewCell:new()
    item:setIdx(cellIdx)

    for count = 1,unit do
        local index = idx*unit + count
        if index <= #heroList then
            local posX = 128*(count - 1) + 77
            local data = heroList[index]
            local image_ = {normal = agentNodeImg}
            local agentNode = CommonButton.yellow3("",{image = image_})-- display.newSprite(agentNodeImg)
            agentNode:onButtonClicked(function()
                -- 判断派出英雄是否已达上限
                if #UnionListData.ownAgentData >= 2 then
                    showToast({text = "派出英雄已达上限"})
                    self.delegate:removeAgentSendLayer()
                else
                    NetHandler.gameRequest("SendMercenary", {param1 = data.roleId})
                end
            end)
            agentNode:setPosition(posX,47)

            display.newSprite("Mail_Circle.png"):pos(8,2):scale(0.55):addTo(agentNode)
	        display.newSprite(data.avatarImage):pos(8, 2):scale(0.55):addTo(agentNode)
            display.newSprite("Banner_Level.png"):pos(-28, 25):zorder(3):scale(0.6):addTo(agentNode)
            display.newSprite(data.jobImage):pos(-28, 25):zorder(3):scale(0.6):addTo(agentNode)
	        display.newTTFLabel({text="lV"..tostring(data.level), size=15, color=cc.c3b(252, 242, 181)}):align(display.CENTER):pos(32, -39):addTo(agentNode)
			createStarIcon(data.starLv):pos(-25, -23):zorder(5):scale(0.6):addTo(agentNode)

            item:addChild(agentNode)
        end
    end
    return item
end

return UnionAgentSendLayer