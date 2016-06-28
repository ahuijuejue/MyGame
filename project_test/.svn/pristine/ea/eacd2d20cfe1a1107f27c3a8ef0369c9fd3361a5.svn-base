--
-- Author: zsp
-- Date: 2015-02-03 15:46:34
--
local GameNode     = import(".GameNode")
local StateManager = import("..state.StateManager")
local TrapState    = import("..state.TrapState")
local TrapNode     = class("TrapNode", GameNode)

--[[
	战斗场景中的陷阱 陷阱
--]]

function TrapNode:ctor(params)
	self.level      = params.level or 1
	self.trapId     = params.trapId
	self.parentNode = params.parentNode
	self.num        = 4
	self.camp       = GameCampType.right
	self.enemyCamp  = GameCampType.left
	self.viewRect   = cc.rect(0,0,0,0)
	
	local cfg       = GameConfig.trap[self.trapId]
	self.pic        = "trap_1" --cfg["pic"]
	self.hitFrame   = string.split(cfg["hit_frame"], ",")
	self.buffId     = cfg["buff_id"] or ""
	
	self.viewOffset = cc.p(checkint(cfg["view_box"][1]), checkint(cfg["view_box"][2]))
	self.viewSize   = cc.size(checkint(cfg["view_box"][3]), checkint(cfg["view_box"][4]))
	
	--升级会影响的属性
	self.damage     = checkint(cfg["damage"])
	self.damageType = checkint(cfg["damage_type"])
	self.interview  = checknumber(cfg["interview"])

	--属性升级
	local levelData = cfg["level_data"]
	if levelData then
		for i=1,#levelData do
			local data = levelData[i]
			local tb   = string.split(data,":")
			local k    = tb[1]
			local v    = checknumber(tb[2])
			self[k]    = Formula[7](self[k], self.level,checknumber(v))
		end
	end

	self.animGroup = {}
	self:createBoundingBox()

	self.state    = TrapState
	self.stateMgr = StateManager.new(self,self.state.normal)
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    	self:update(dt)
	end)

	self:scheduleUpdate()

end

function TrapNode:update( dt )
	
	-- if self.isPaused then
	-- 	return
	-- end
	self.stateMgr:update(dt)
end

--[[
	调用此方法前必须添加到节点总并设置好位置
--]]
function TrapNode:createAnimNode()
	
	local z = {850,800,790,780,770}
	local function onFrame(frame,finish)
        self.stateMgr.currentState:executeAnim(self,frame,finish)
    end

	local pNode = self:getParent()
	local x,y = self:getPosition()
	for i=1,self.num do
		local anim =  GafAssetCache.makeAnimatedObject(self.pic)
		if i == 1 then
			anim:setDelegate()
			--todo unregisterScriptHandler
			anim:registerScriptHandler(onFrame)
		end
		local frameSize = anim:getFrameSize()
		anim:addTo(pNode)
		anim:setLocalZOrder(z[i])
		anim:setPosition((frameSize.width * - 0.5) + (x - (i-1) * 15), (frameSize.height - 440 )  + ( y + (i-1) * 30))
		--anim:setPosition(frameSize.width * - 0.5 + (400),frameSize.height * 0.5 + 500)
		anim:start()
		table.insert(self.animGroup,anim)
	end
end

function TrapNode:createBoundingBox()
	self.viewBox = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	self.viewBox:setContentSize(self.viewSize.width,self.viewSize.height)
	self.viewBox:setPosition(self.viewSize.width * -0.5 + self.viewOffset.x, self.viewOffset.y)
	self.viewBox:setVisible(false)
	self.viewBox:addTo(self)
end

--[[
	获取角色的视野范围信息
--]]
function TrapNode:getViewRect()

	local pt = self.viewBox:convertToWorldSpace(cc.p(0,0))
	self.viewRect.width  = self.viewBox:getContentSize().width
	self.viewRect.height = self.viewBox:getContentSize().height
	self.viewRect.x = pt.x
	self.viewRect.y = pt.y

	return self.viewRect
end

--[[
	播放动画
--]]
function TrapNode:playAnim(name,loop)
	for k,v in pairs(self.animGroup) do
		v:playSequence(name,loop)
	end
end

function TrapNode:playNormal()
	self:playAnim("normal",false)
end

function TrapNode:playReady()
	self:playAnim("ready",false)
end

function TrapNode:playFire()
	self:playAnim("fire",false)
end

function TrapNode:doNormal()
	self.stateMgr:changeState(self.state.normal)
end

function TrapNode:doReady()
	self.stateMgr:changeState(self.state.ready)
end

function TrapNode:doFire()
	self.stateMgr:changeState(self.state.fire)
end

return TrapNode
