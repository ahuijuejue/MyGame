--
-- Author: zsp
-- Date: 2014-11-21 18:03:02
--

--
-- Author: zsp
-- Date: 2014-11-21 17:53:33
--

local StateManager = class("StateManager")

function StateManager:ctor(owner,state)
	
	self.owner         = owner
	self.currentState  = state
	self.previousState = state
	self.globalState   = nil
	self.lockState     = false -- 锁定状态

	self.currentState:enter(self.owner)

	--减少帧内计算量
	self.globalFrame = 1

end

function StateManager:update(dt)
	-- body
	self.globalFrame = self.globalFrame + 1


	if self.globalState ~= nil then
		self.globalState:execute(self.owner,dt,self.globalFrame)
	end

	if self.currentState ~= nil then
		self.currentState:execute(self.owner,dt,self.globalFrame)
	end
end

function StateManager:changeState(newState)
	if self.lockState then
		return
	end
	self.currentState:exit(self.owner)
	self.previousState = self.currentState
	self.currentState = newState
	self.currentState:enter(self.owner)
end

function StateManager:revertToPreviousState()
	-- body
	self:changeState(self.previousState)
end

return StateManager