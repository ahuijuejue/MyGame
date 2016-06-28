--
-- Author: zsp
-- Date: 2014-11-21 18:32:37
--

--[[
	队长状态
--]]
local LeaderState = {}

LeaderState.idle        = import(".LeaderIdleState").new()
LeaderState.walk        = import(".LeaderWalkState").new()
LeaderState.skill       = import(".LeaderSkillState").new()
LeaderState.attack      = import(".LeaderAttackState").new()
LeaderState.delayAttack = import(".LeaderAttackDelayState").new()
LeaderState.farAttack   = import(".LeaderFarAttackState").new()
LeaderState.nearAttack  = import(".LeaderNearAttackState").new()
LeaderState.demage1     = import(".LeaderDamage1State").new()
LeaderState.demage2     = import(".LeaderDamage2State").new()
LeaderState.evolve      = import(".LeaderEvolveState").new()
LeaderState.dead        = import(".LeaderDeadState").new()
LeaderState.win         = import(".LeaderWinState").new()

return LeaderState