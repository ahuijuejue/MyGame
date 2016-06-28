--[[
    公会管理
]]
local UnionMemberLayer = class("UnionMemberLayer",function ()
	return display.newColorLayer(cc.c4b(0, 0, 0, 200))
end)

local BgImg = "union_member_bg.png"
local applyTitle = "union_member_list.png"

function UnionMemberLayer:ctor(memberData)
	-- self.memberData = memberData

	self.spriteBg = display.newSprite(BgImg):pos(display.cx-5,display.cy):addTo(self)
	display.newSprite(applyTitle):pos(320, 180):addTo(self.spriteBg)

	-- 关闭按钮
	CommonButton.close()
	:addTo(self.spriteBg,3)
	:pos(640, 405)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close() -- 音效
		self.delegate:removeUnionMemberLayer()
	end)

    display.newSprite("Mail_Circle.png"):pos(105, 318):addTo(self.spriteBg)
	display.newSprite(UserData.headIcon):pos(105, 318):addTo(self.spriteBg)

    local pos = 200
    local name = display.newTTFLabel({text = "吼吼吼吼吼吼",color = cc.c3b(254, 231, 93), size = 24})
    name:pos(pos+name:getContentSize().width/2,335)
    name:addTo(self.spriteBg)

    local vipLv = display.newTTFLabel({text = "V".."15",color = cc.c3b(254, 231, 93), size = 24})
    vipLv:pos(pos+170+vipLv:getContentSize().width/2,335)
    vipLv:addTo(self.spriteBg)

    local memLv = display.newTTFLabel({text = "lv.".."20", color = cc.c3b(254, 231, 93), size = 24})
    memLv:pos(pos+230+memLv:getContentSize().width/2,335)
    memLv:addTo(self.spriteBg)

    local totalP = display.newTTFLabel({text = "战力：".."99999999",color = cc.c3b(252, 242, 181), size = 20})
    totalP:pos(pos+totalP:getContentSize().width/2,295)
    totalP:addTo(self.spriteBg)

    local recentL = display.newTTFLabel({text = "登录：一小时前",color = cc.c3b(252, 242, 181), size = 20})
    recentL:pos(pos+200+recentL:getContentSize().width/2,295)
    recentL:addTo(self.spriteBg)

    -- 英雄列表
	self.listView_ = base.ListView.new({
		viewRect = cc.rect(0, 0, 555, 135),
		direction = "horizontal",
		itemSize = cc.size(135, 135),
		page = true,
	})
	:addTo(self.spriteBg)
	:pos(43, 109)


    if "是否是好友" then
    	CommonButton.yellow("删除好友", {color = cc.c3b(252, 242, 181)})
	    :onButtonClicked(function ()
			print("删除好友")
		end)
		:addTo(self.spriteBg)
		:pos(125, 65)
	else
		CommonButton.yellow("加为好友", {color = cc.c3b(252, 242, 181)})
	    :onButtonClicked(function ()
			print("加为好友")
		end)
		:addTo(self.spriteBg)
		:pos(125, 65)
    end

	CommonButton.yellow("发起会话", {color = cc.c3b(252, 242, 181)})
    :onButtonClicked(function ()
		print("发起会话")
	end)
	:pos(525,65)
	:addTo(self.spriteBg)

end

function UnionMemberLayer:updateListView()
	self.listView_
	:removeAllItems()
	:addItems(6, function(event)
		local index = event.index
		local grid = base.Grid.new({type=1})
		self:showGrid(grid, data)
		return grid
	end)
	:reload()

end

function UnionMemberLayer:showGrid(grid, data)
	-- local typeImg = self:getHeroTypeImage(data.roleId)
	grid:removeItems()
	:addItems({
		display.newSprite(UserData.headIcon):pos(0, 0):zorder(2):scale(0.8),
		display.newSprite("Job_Circle.png"):pos(-45, 45):zorder(5):scale(0.8),
		-- createStarIcon("12"):pos(-50, -30):zorder(5):scale(0.8),
	})

	return self
end

return UnionMemberLayer

