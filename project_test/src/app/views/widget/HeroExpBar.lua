--
-- Author: zsp
-- Date: 2015-04-03 16:17:05
--
local HeroExpBar = class("HeroExpBar", function()
	return display.newNode()
end)

--[[
	英雄经验条 跨等级升级时 会又动画效果 战斗结算用到了 
	todo 跨级动画显示进度的通用组件
--]]
function HeroExpBar:ctor(totalExp)

	self.totalExp = totalExp
	self.exp = 0

	local bgSprite = display.newSprite("Accout_Exp_Slip_Short.png")
	bgSprite:addTo(self)

	self.bar = cc.ProgressTimer:create(display.newSprite("Account_Exp_Short.png"))
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar:setMidpoint(cc.p(0, 0))
    self.bar:setBarChangeRate(cc.p(1, 0))
    
    local heroExp = GameExp.getCurrentExp(self.totalExp) / GameExp.getUpgradeExp(self.totalExp)
    self.bar:setPercentage(heroExp * 100)
    --bar:setPosition(heroExpBarBg:getContentSize().width * 0.5, heroExpBarBg:getContentSize().height *  0.5)
    self.bar:addTo(self)


end

function HeroExpBar:onUpdate(dt)
	-- body
	
	--每帧调用增加总进度的百分之5
	local r = GameExp.getUpgradeExp(self.totalExp) * 0.05
	self.totalExp = math.min( GameExp.getFinalExp(self.totalExp, r) , self.totalExp + r)
	self.exp = math.max(self.exp - r,0)

	--print(self.totalExp)
	if self.exp > 0 then
		local heroExp = GameExp.getCurrentExp(self.totalExp) / GameExp.getUpgradeExp(self.totalExp)
		--printInfo("%d===%d===%d",GameExp.getCurrentExp(self.totalExp),GameExp.getUpgradeExp(self.totalExp),GameExp.getLevel(self.totalExp))
		self.bar:setPercentage(heroExp * 100)
		if  self.bar:getPercentage() == 100 then
			--print("升级了")
		end
	else
		print("动画完成")
		self:unscheduleUpdate()
	end

end

--[[
	增加经验
--]]
function HeroExpBar:addExp(exp,delay)
  
  -- todo 升满级的时候处理
  --print("%d=======================%d",GameExp.getFinalExp(self.totalExp, exp),self.totalExp)

  if GameExp.getFinalExp(self.totalExp, exp) == self.totalExp then
  	--todo
  		print("已经升级到头了~~~")
  		return
  end

  self.exp = exp

  self:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function()
  	   
  	  self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
  	  self:scheduleUpdate()

  end)))
end

return HeroExpBar