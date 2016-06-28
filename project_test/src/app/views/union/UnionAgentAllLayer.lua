--[[
    所有雇佣兵
]]

local UnionAgentAllLayer = class("UnionAgentAllLayer", function()
	return display.newNode()
end)
local BgImg = "Union_Mail_Bg.png"
local title = "union_agent_title.png"
local word = "union_agent_word.png"
local list = "union_agent_list.png"
local agentNodeImg = "agent_node.png"

local unit = 4

function UnionAgentAllLayer:ctor()
	self:initData()
	self:initView()
end

function UnionAgentAllLayer:initData()
    self.unionAgentData = UnionListData.allAgentData
    self.ownLine = math.ceil(#self.unionAgentData/unit)
end

function UnionAgentAllLayer:initView()
    createOutlineLabel({text = "本公会所有佣兵", size = 24}):pos(400, 370):addTo(self)

	-- 公会list
    self.listView = cc.TableView:create(cc.size(766,330))
    self.listView:setPosition(13,23)
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

function UnionAgentAllLayer:scrollViewDidScroll(table)

end

function UnionAgentAllLayer:tableCellTouched(table,cell)
	-- print("cellIdx:"..cell:getIdx())
end

function UnionAgentAllLayer:cellSizeForTable(table,idx)
    return 175
end

function UnionAgentAllLayer:tableCellAtIndex(table,idx)
	local cell
    cell = self:createItem(idx, self.unionAgentData, idx)
    return cell
end

function UnionAgentAllLayer:numberOfCellsInTableView(table)
	local count = self.ownLine
    return count
end

function UnionAgentAllLayer:createItem(idx,heroList,cellIdx)
    local item = cc.TableViewCell:new()
    item:setIdx(cellIdx)

    for count = 1,unit do
        local index = idx*unit + count
        if index <= #heroList then
            local posX = 175*(count - 1) + 112
            local data = heroList[index]
            local agentNode = display.newSprite(agentNodeImg)
            agentNode:setPosition(posX,90)

            createOutlineLabel({text = data.teamName, color = cc.c3b(252, 242, 181), size = 18}):scale(0.8):pos(75,144):addTo(agentNode)
            display.newSprite("Mail_Circle.png"):pos(80,83):scale(0.75):addTo(agentNode)
	        display.newSprite(data.avatarImage):pos(80, 83):scale(0.75):addTo(agentNode)
            display.newSprite("Banner_Level.png"):pos(40, 110):zorder(3):scale(0.8):addTo(agentNode)
            display.newSprite(data.jobImage):pos(40, 110):zorder(3):scale(0.8):addTo(agentNode)
	        base.Label.new({text="lV"..tostring(data.level), size=24, color=cc.c3b(252, 242, 181)}):align(display.CENTER):pos(105, 22):scale(0.8):addTo(agentNode)
			createStarIcon(data.starLv):pos(40, 52):zorder(5):scale(0.75):addTo(agentNode)

            item:addChild(agentNode)
        end
    end
    return item
end

function UnionAgentAllLayer:updateData()
    self.unionAgentData = UnionListData.allAgentData
    self.ownLine = math.ceil(#self.unionAgentData/unit)
end

function UnionAgentAllLayer:updateView()
    self.listView:reloadData()
end

return UnionAgentAllLayer
