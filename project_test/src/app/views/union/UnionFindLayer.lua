local UnionFindLayer = class("UnionFindLayer",function ()
	return display.newNode()
end)

local nameInput = "Union_Find_Bg.png"
local iconInput = "Union_Icon.png"
local listImage = "union_list_bg.png"
local barImage = "union_bar.png"

function UnionFindLayer:ctor()
	self:initData()
    self:initView()
end

function UnionFindLayer:initData()
	self.unionName = ""
	self.findCount = 0
	self.findResult = {}
end

function UnionFindLayer:initView()
    display.newTTFLabel({text = "公会ID：", color = cc.c3b(252, 242, 181),size=22}):pos(190, 320):addTo(self)

    self:createEditBox()

    CommonButton.yellow("搜索", {size = 24,color = cc.c3b(252, 242, 181)})
	:onButtonClicked(function ()
		self:showFindResult()
	end)
	:pos(590, 320)
	:addTo(self)
	:scale(0.8)

    self.listView = cc.TableView:create(cc.size(772,120))
	self.listView:setPosition(22,170)
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

function UnionFindLayer:scrollViewDidScroll(table)

end

function UnionFindLayer:tableCellTouched(table,cell)
	print("cellIdx:"..cell:getIdx())
end

function UnionFindLayer:cellSizeForTable(table,idx)
	return 105
end

function UnionFindLayer:tableCellAtIndex(table,idx)
	return self:createCell(idx)
end

function UnionFindLayer:numberOfCellsInTableView(table)
	return self.findCount
end

function UnionFindLayer:createCell(idx)
	local cell = cc.TableViewCell:new()
	cell:setIdx(idx)

	local bgSprite = display.newSprite(listImage)
    bgSprite:setAnchorPoint(0,0)
    cell:addChild(bgSprite)

	local data  = self.findResult[idx+1]
	local grid = base.Grid.new()
	self:setGridShow(grid, data)
	cell:addChild(grid)

    return cell
end

function UnionFindLayer:setGridShow(grid, data)
	grid:removeItems()
	:addItems({
		display.newSprite(data.icon):pos(75,52):scale(0.8), -- 公会头像
        display.newSprite("union_lv.png"):pos(63,15), -- 公会等级
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
    local name = display.newTTFLabel({text = data.name..member_,color = cc.c3b(254, 231, 93),size = 22})  -- 公会名称
    name:pos(pos+name:getContentSize().width/2,70)
    local des = display.newTTFLabel({text = data.info, color = cc.c3b(252, 242, 181),size = 18})  -- 公会简介
    des:pos(pos+des:getContentSize().width/2,30)

    grid:addItems({centetUnionBtn, name, des ,expLabel
    	})-- display.newSprite("Vip_Small.png"):pos(60, 15)
end

function UnionFindLayer:createEditBox()

	local function onEdit(event, editbox)
	    if event == "began" then
	    elseif event == "changed" then
	        local _text = editbox:getText()
	        self.unionName = _text

			local _trimed = string.trim(_text)
			_trimed = parseString(_trimed, 12, 2)
			if _trimed ~= _text then
			    editbox:setText(_trimed)
			end
	    elseif event == "ended" then
	    elseif event == "return" then
	    end
	end

	local textBack = display.newScale9Sprite(nameInput)
	-- textBack:setOpacity(100)
	self.textName = cc.ui.UIInput.new({
	    UIInputType = 1,
	    image = textBack,
	    size = cc.size(250, 35),
	   	x = 80,
	    y = 80,
	    listener = onEdit,
	}):addTo(self)
	:pos(360,320)
	:align(display.CENTER)
	self.textName:setPlaceHolder("在此输入查找的公会ID")
	self.textName:setMaxLength(10)

end

function UnionFindLayer:updateData()
	for i,v in ipairs(UnionListData.unionFindList) do
		self.findCount = i
		table.insert(self.findResult, v)
	end
end

function UnionFindLayer:updateView()
	self.listView:reloadData()
end

function UnionFindLayer:showFindResult()
    if self.unionName == "" then
    	showToast({text = "请输入公会ID！"})
    else
    	NetHandler.gameRequest("SearchUnion",{param1 = self.unionName})
    end

end

return UnionFindLayer
