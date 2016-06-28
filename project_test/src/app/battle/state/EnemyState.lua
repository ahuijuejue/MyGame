--
-- Author: zsp
-- Date: 2014-11-25 18:29:38
--

--npc敌人的状态类
local EnemyState = {}

EnemyState.idle        = import(".EnemyIdleState").new()
EnemyState.walk        = import(".EnemyWalkState").new()
EnemyState.skill       = import(".EnemySkillState").new()
EnemyState.attack      = import(".EnemyAttackState").new()
EnemyState.delayAttack = import(".EnemyAttackDelayState").new()
EnemyState.farAttack   = import(".EnemyFarAttackState").new()
EnemyState.nearAttack  = import(".EnemyNearAttackState").new()
EnemyState.demage1     = import(".EnemyDamage1State").new()
EnemyState.demage2     = import(".EnemyDamage2State").new()
EnemyState.dead        = import(".EnemyDeadState").new()
EnemyState.win         = import(".EnemyWinState").new()

return EnemyState