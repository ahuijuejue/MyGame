--[[
    公会战争之地
]]

local BasicScene = import("..ui.BasicScene")
local UnionArenaScene = class("UnionArenaScene", BasicScene)

local MenuNode = import("..views.main.MenuNode")

local TAG = "UnionArenaScene"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"
local unionArenaBg = "unionArenaBg_2.png"
local unionArena_title = "unionArena_title.png"
local listImage  = "unionData_list.png"

function UnionArenaScene:ctor()
	UnionArenaScene.super.ctor(self,TAG)

    self:initData()
    self:initView()
end

function UnionArenaScene:initData()
	self.unionDataList = UnionListData.unionArenaList
	self.unionCounts =  #self.unionDataList
end

function UnionArenaScene:initView()
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
    app:createView("widget.MenuLayer", {wealth="instancePower"}):addTo(self):zorder(10)
    :onBack(function(layer)
        self:pop()
    end)

	self:createMenuNode()

	self.layer_ = display.newLayer():size(960, 640):pos(display.cx,display.cy):align(display.CENTER):addTo(self)
	display.newSprite(unionArenaBg):pos(450, 300):addTo(self.layer_)
	display.newSprite(unionArena_title):pos(445, 500):addTo(self.layer_)

	--公会list
    self.listView = cc.TableView:create(cc.size(766,398))
    self.listView:setPosition(63,67)
    self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

    self.listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), 0)
    self.listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.listView:reloadData()
    self.layer_:addChild(self.listView)

end

function UnionArenaScene:scrollViewDidScroll(table)

end

function UnionArenaScene:tableCellTouched(table,cell)
	-- print("cellIdx:"..cell:getIdx())
end

function UnionArenaScene:cellSizeForTable(table,idx)
	  return 80
end

function UnionArenaScene:tableCellAtIndex(table,idx)
	  return self:createCell(idx)
end

function UnionArenaScene:numberOfCellsInTableView(table)
	  return self.unionCounts
end

function UnionArenaScene:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)

    local bgSprite = display.newSprite(listImage)
    bgSprite:setAnchorPoint(0,0)
    cell:addChild(bgSprite)

    local data = self.unionDataList[idx + 1]
    -- 公会等级
    display.newTTFLabel({text = UnionListData:getLevel(data.exp), color = cc.c3b(255, 231, 96), size = 18}):pos(75,35):addTo(cell)
    -- 公会名称
    display.newTTFLabel({text = data.name, color = cc.c3b(255, 231, 96), size = 18}):pos(170,35):addTo(cell)
    :enableOutline(cc.c4b(41,12,0,255), 2)
    -- 会长名称
    display.newTTFLabel({text = data.president, color = cc.c3b(255,  242, 184), size = 18}):pos(310,35):addTo(cell)
    -- 人数
    display.newTTFLabel({text = data.number.."/"..data.limitUp, color = cc.c3b(255,  242, 184), size = 18}):pos(475,35):addTo(cell)
    -- 战力
    display.newTTFLabel({text = tostring(tonumber(data.combat)), color = cc.c3b(255, 0, 0), size = 18}):pos(600,35):addTo(cell)
    -- 操作按钮
    CommonButton.yellow("选择公会", {color = cc.c3b(252, 242, 181)})
    :onButtonClicked(function ()
        print("选择公会 .. "..data.id)
        NetHandler.gameRequest("ShowUnionMembers", { param1 = data.id})
    end)
    :pos(710,35)
    :addTo(cell)
    :scale(0.75)

    return cell
end


function UnionArenaScene:createMenuNode()
	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)
end

function UnionArenaScene:updateData()
end

function UnionArenaScene:updateView()
end

function UnionArenaScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.ShowUnionMembersProcess then
        app:pushToScene("UnionArenaMemberScene")
    end
end

function UnionArenaScene:onEnter()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function UnionArenaScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return UnionArenaScene
