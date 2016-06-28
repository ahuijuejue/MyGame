--
-- Author: zsp
-- Date: 2015-06-06 10:48:07
--

--[[
	战斗的角色的声效播放工具
--]]

module("BattleSound", package.seeall)

--[[
	脚步声
--]]
function playFoot(roleId,frameNum)
	playSound(roleId,frameNum,"foot_frame","foot_sound")
end

--[[
	攻击喊声 todo 先不用了
--]]
function playAttack(roleId,frameNum)
	playSound(roleId,frameNum,"attck_frame","attck_sound")
end

--[[
	攻击声效
	attackNum 攻击段数
--]]
function playHit(roleId,attackNum,frameNum)
	playSound(roleId,frameNum,string.format("hit%d_frame", attackNum),string.format("hit%d_sound", attackNum))
end

--[[
	技能声效
	skillNum 技能编号
--]]
function playSkill(roleId,skillNum,frameNum)
	playSound(roleId,frameNum,string.format("skill%d_frame", skillNum),string.format("skill%d_sound", skillNum))
	if skillNum == 2 then
		playSound(roleId,frameNum,string.format("skill%d_2_frame", skillNum),string.format("skill%d_2_sound", skillNum))
	end
end

--[[
	伤害声效
--]]
function playDamage(roleId,num,frameNum)
	playSound(roleId,frameNum,string.format("behit%d_frame", num),string.format("behit%d_sound", num))
end

--[[
	死亡声效
--]]
function playDead(roleId,frameNum)
	playSound(roleId,frameNum,"dead1_frame","dead1_sound")
	playSound(roleId,frameNum,"dead2_frame","dead2_sound")
end

--[[
	胜利声效
--]]
function playWin(roleId,frameNum)
	playSound(roleId,frameNum,"win_frame","win_sound")
end

--[[
	变身声效
--]]
function playEvolve(roleId)
	playSound(roleId, 0, nil, "morph_sound")
end

--[[
	替补登场声效
--]]
function playEnter(roleId)
	playSound(roleId, 0, nil, "enter_sound")
end

--[[
	播放声效
--]]
function playSound(roleId,frameNum,frameName,soundName)
	
	local cfg =  GameConfig.HeroSound[roleId]
	if not cfg then
		return
	end

	if frameName then
		local frame = cfg[frameName] or {}
		if table.keyof(frame,tostring(frameNum)) == nil then
			return
		end
	end
	
	
	local name = cfg[soundName]
	AudioManage.playSound(name,false)
end