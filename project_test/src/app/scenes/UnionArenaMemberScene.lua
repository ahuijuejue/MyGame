--[[
    公会战争之地
]]

local BasicScene = import("..ui.BasicScene")
local UnionArenaMemberScene = class("UnionArenaMemberScene", BasicScene)

local MenuNode = import("..views.main.MenuNode")
local UnionMemberNode = import("..views.union.UnionMemberNode")

local TAG = "UnionArenaMemberScene"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"
local unionArenaBg = "unionArenaBg_2.png"
local boardImage = "Hero_Banner.png"
local lineImage = "Line.png"
local itemImage = "HeroList.png"
local boardImage = "bg_001.png"

local unit = 4

function UnionArenaMemberScene:ctor()
	UnionArenaMemberScene.super.ctor(self,TAG)

    self:initData()
    self:initView()
end

function UnionArenaMemberScene:initData()
	self.unionArenaMemberData = UnionListData.unionArenaMembers   -- 挑战公会成员列表
	self.unionArenaMemberCounts = #self.unionArenaMemberData
	self.ownLine = math.ceil(self.unionArenaMemberCounts/unit)
	self.times = UnionListData.times
end

function UnionArenaMemberScene:initView()
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
    display.newTTFLabel({text = "挑战的战力值越高，获胜后的奖励越丰富", color = cc.c3b(255, 231, 96), size = 20}):pos(245, 500):addTo(self.layer_)

    -- 挑战剩余次数显示
    self.battleTimes = display.newTTFLabel({text = "剩余次数："..self.times.."/5", color = cc.c3b(255, 231, 96), size = 20})
    self.battleTimes:pos(745, 500):addTo(self.layer_)

    -- 增加剩余次数按钮
    self.plusBtn_ = cc.ui.UIPushButton.new({normal="Plus1.png"}):addTo(self.layer_, 2):pos(835, 500)
    :onButtonClicked(function(event)
        self:alertBuyTimes()
    end)

	-- 公会list
    self.listView = cc.TableView:create(cc.size(790,400))
    self.listView:setPosition(45,67)
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

function UnionArenaMemberScene:scrollViewDidScroll(table)

end

function UnionArenaMemberScene:tableCellTouched(table,cell)
	-- print("cellIdx:"..cell:getIdx())
end

function UnionArenaMemberScene:cellSizeForTable(table,idx)
    return 295
end

function UnionArenaMemberScene:tableCellAtIndex(table,idx)
	local cell
    cell = self:createItem(idx, self.unionArenaMemberData, idx)
    return cell
end

function UnionArenaMemberScene:numberOfCellsInTableView(table)
	local count = self.ownLine
    return count
end

function UnionArenaMemberScene:createItem(idx,heroList,cellIdx)
    local item = cc.TableViewCell:new()
    item:setIdx(cellIdx)

    for count = 1,unit do
        local index = idx*unit + count
        if index <= #heroList then
            local posX = 195*(count - 1) + 12
            local unionMemberNode = UnionMemberNode.new(heroList[index], index)
            unionMemberNode.delegate = self
            unionMemberNode:setPosition(posX,0)
            item:addChild(unionMemberNode)
        end
    end
    return item
end

function UnionArenaMemberScene:createMenuNode()
	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)
end

function UnionArenaMemberScene:alertBuyTimes()
    if UserData.diamond < UnionListData:getCostForBuyTimes() then  -- 购买次数需要的钻石数 是否读表
        GemsAlert:show()
    else
        if UnionListData.buyTimes <= VipData:getUnionArenaTimeMax() then
            local msg = {
                base.Label.new({text="是否花费", size=22}):pos(30, 150),
                -- UnionListData.timesCost     UnionListData:getCostForBuyTimes()
                base.Label.new({text=string.format("x%d来购买%d次", UnionListData.timesCost, 1), size=22}):pos(200, 150),
                base.Label.new({text="挑战次数", size=22}):pos(200, 110):align(display.CENTER),
                display.newSprite("Diamond.png"):pos(150, 150),
            }

            AlertShow.show2("友情提示", msg, "确定", function( ... )
                NetHandler.gameRequest("UnionCombatTime")
            end)
        else
            showToast({text = "购买次数已达上限！"})
            app:pushScene("RechargeScene")
        end
    end
end

function UnionArenaMemberScene:updateData()
    self.unionArenaMemberData = UnionListData.unionArenaMembers   -- 挑战公会成员列表
    self.unionArenaMemberCounts = #self.unionArenaMemberData
    self.ownLine = math.ceil(self.unionArenaMemberCounts/unit)
    self.times = UnionListData.times
end

function UnionArenaMemberScene:updateView()
    self:updateBattleNum()
	self.listView:reloadData()
end

function UnionArenaMemberScene:updateBattleNum()
    self.battleTimes:setString("剩余次数："..self.times.."/5")

    self.plusBtn_:setVisible(self.times < 5)
    print("购买次数成功")
end

function UnionArenaMemberScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.UnionCombatTimeProcess then
        self:updateData()
        self:updateView()
    end
end

function UnionArenaMemberScene:onEnter()
    self:updateData()
    self:updateView()

    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function UnionArenaMemberScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return UnionArenaMemberScene
