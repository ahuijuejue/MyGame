--
-- Author: zsp
-- Date: 2014-12-08 18:20:43
--

--[[
	负责战斗模块中的事件代理对象，提供一个统一的注册和派发事件的入口 
--]]

-- todo 改名 BattleDispatcher
local BattleEvent = {}

---英雄变身插画
BattleEvent.HERO_FALSH 				 = "BATTLE_HERO_FALSH"
---玩家队长变身开启
BattleEvent.EVOLVE_BEGIN             = "BATTLE_EVOLVE_BEGIN"
---玩家队长变身开启
BattleEvent.EVOLVE_END               = "BATTLE_EVOLVE_END"
---玩家队长变身开启
BattleEvent.EVOLVE_EFFECT_END        = "BATTLE_EVOLVE_EFFECT_END"
--玩家队长技能特效开启
BattleEvent.SKILL_EFFECT_BEGIN       = "BATTLE_SKILL_BEGIN"
--玩家队长技能特效关闭
BattleEvent.SKILL_EFFECT_END         = "BATTLE_SKILL_END"
--关卡出兵逻辑创建一波敌人
BattleEvent.LOGIC_CREATE_WAVE        = "BATTLE_LOGIC_CREATE_WAVE"
--关卡出兵逻辑创建敌人
BattleEvent.LOGIC_CREATE_ENEMY       = "BATTLE_LOGIC_CREATE_ENEMY"
--关卡出兵逻辑创建敌人全部完成
BattleEvent.LOGIC_CREATE_END         = "BATTLE_LOGIC_CREATE_END"
--关卡挑战超时
BattleEvent.GAME_TIMEOUT             = "BATTLE_GAME_TIMEOUT"
--杀死了一个敌人
BattleEvent.KILL_ENEMY               = "BATTLE_KILL_ENEMY"
--杀死了一个角色
BattleEvent.KILL_CHARACTER           = "BATTLE_KILL_CHARACTER"
--杀死了一个塔
BattleEvent.KILL_TOWER               = "BATTLE_KILL_TOWER"
--打碎了一个钟
BattleEvent.KILL_CLOCK               = "BATTLE_KILL_CLOCK"
--召唤了一个队员
BattleEvent.CALL_MEMBER              = "BATTLE_CALL_MEMBER"
--显示队员登场技能特效开始
BattleEvent.ENTER_SKILL_EFFECT_BEGIN = "BATTLE_ENTER_SKILL_BEGIN"
--显示队员登场技能特效结束
BattleEvent.ENTER_SKILL_EFFECT_END   = "BATTLE_ENTER_SKILL_END"
--尾兽技能特效开启
BattleEvent.TAIL_SKILL_EFFECT_BEGIN  = "BATTLE_TAIL_SKILL_BEGIN"
--尾兽技能特效关闭
BattleEvent.TAIL_SKILL_EFFECT_END    = "BATTLE_TAIL_SKILL_END"
--左右晃动相机
BattleEvent.CAMERA_SWAY              = "BATTLE_CAMERA_SWAY"
--动作慢放开始
BattleEvent.SLOW_BEGIN               = "BATTLE_SLOW_BEGIN"
--动作慢放结束 暂时没用到
BattleEvent.SLOW_END                 = "BATTLE_SLOW_END"
--护送队员到成功走到护送终点
BattleEvent.ESCORT_END               = "BATTLE_ESCORT_END"
--护送队员死亡
BattleEvent.KILL_ESCORT              = "BATTLE_KILL_ESCORT"

--引导技能事件
BattleEvent.GUIDE_BUTTON = "BATTLE_GUIDE_BUTTON"

cc.GameObject.extend(BattleEvent)
:addComponent("components.behavior.EventProtocol")
:exportMethods()


return BattleEvent