--
-- Author: zsp
-- Date: 2015-06-06 12:05:30
--

--[[
	塔状态
--]]
local TowerState       = {}

TowerState.idle        = import(".TowerIdleState").new()
TowerState.attack      = import(".TowerAttackState").new()
TowerState.delayAttack = import(".TowerAttackDelayState").new()
TowerState.farAttack   = import(".TowerFarAttackState").new()
TowerState.nearAttack  = import(".TowerNearAttackState").new()
TowerState.demage      = import(".TowerDamageState").new()
TowerState.dead        = import(".TowerDeadState").new()

return TowerState