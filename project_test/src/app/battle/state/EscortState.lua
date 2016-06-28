--
-- Author: zsp
-- Date: 2015-04-08 10:53:10
--

--护送角色状态类
local EscortState = {}

EscortState.idle    = import(".EscortIdleState").new()
EscortState.walk    = import(".EscortWalkState").new()
EscortState.demage1 = import(".EscortDamage1State").new()
EscortState.demage2 = import(".EscortDamage2State").new()
EscortState.dead    = import(".EscortDeadState").new()
EscortState.win     = import(".EscortWinState").new()

return EscortState