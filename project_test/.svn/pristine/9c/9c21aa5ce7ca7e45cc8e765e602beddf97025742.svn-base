--
-- Author: zsp
-- Date: 2015-01-01 00:11:49
--
local scheduler  = require(cc.PACKAGE_NAME .. ".scheduler")
local AnimWrapper = import("app.util.AnimWrapper")
--[[
	加载动画资源 并缓存
	todo 改用native代码 多线程 异步加载
--]]
GafAssetCache = {}

GafAssetCache.assetMap = {}
GafAssetCache.assetNameMap = {}

function GafAssetCache.load(assetNames,callback)
	GafAssetCache.assetNames = assetNames
	GafAssetCache.onLoad = callback
	GafAssetCache.loadTotal = table.nums(GafAssetCache.assetNames)
	GafAssetCache.loadNum = 1
	scheduler.performWithDelayGlobal(handler(GafAssetCache,GafAssetCache.__load),0)
end

--[[
	分步加载动画资源
--]]
function GafAssetCache.__load()
	local name = GafAssetCache.assetNames[GafAssetCache.loadNum]
	if GafAssetCache.assetMap[name] then
	else
		local zipPath = name..".zip"
		local gafPath = name.."/"..name..".gaf"
		local asset = gaf.GAFAsset:createWithBundle(zipPath,gafPath)
		if GafAssetCache.loadNum  <= GafAssetCache.loadTotal then
   			scheduler.performWithDelayGlobal(function()
   				GafAssetCache.onLoad(GafAssetCache.loadNum,GafAssetCache.loadTotal)
   				if GafAssetCache.loadNum < GafAssetCache.loadTotal then
   					GafAssetCache.loadNum = GafAssetCache.loadNum + 1
   					GafAssetCache.__load()
   				end
   			end,0)
   		end
		GafAssetCache.addAsset(name,asset)
	end
	return
end

--[[
	在缓存中创建动画
--]]
function GafAssetCache.makeAnimatedObject(name)
	local asset = GafAssetCache.assetMap[name]
	local obj =  AnimWrapper.new(asset)
	obj:setFps(30)
	return obj
end

--[[
	检查缓存动画
--]]
function GafAssetCache.hasCache(name)
	if GafAssetCache.assetMap[name] then
		return true
	end
	return false
end

--[[
	添加动画资源缓存
--]]
function GafAssetCache.addAsset(name, asset)
	 GafAssetCache.assetMap[name] = asset
	 asset:retain()
end

--[[
	添加资源名称 构建参数列表
--]]
function GafAssetCache.addAssetName(name)
	if name ~= "" then
		GafAssetCache.assetNameMap[name] = ""
	end
	
	return GafAssetCache
end

--[[
	加载攻击特效
--]]
function GafAssetCache.addAttackEffect()
	GafAssetCache.addAssetName("atk_effect_1")
	GafAssetCache.addAssetName("atk_effect_2")
	GafAssetCache.addAssetName("atk_effect_3")
	GafAssetCache.addAssetName("atk_effect_4")
	GafAssetCache.addAssetName("atk_effect_5")
	GafAssetCache.addAssetName("buff_blood_effect_1")

	return GafAssetCache
end

--[[
	加载登场特效
--]]
function GafAssetCache.addEnterEffect()
	GafAssetCache.addAssetName("enter_effect_1")
    GafAssetCache.addAssetName("enter_effect_2")
    GafAssetCache.addAssetName("enter_effect_3")
    GafAssetCache.addAssetName("enter_effect_4")
    GafAssetCache.addAssetName("enter_effect_5")
    GafAssetCache.addAssetName("enter_effect_6")

    return GafAssetCache
end

--[[
	加载黄金钟资源
--]]
function GafAssetCache.addClockAsset()
	GafAssetCache.addAssetName("Clock1")
    GafAssetCache.addAssetName("Clock2")
    GafAssetCache.addAssetName("Clock3")
    GafAssetCache.addAssetName("Clock4")
    GafAssetCache.addAssetName("Clock5")
    GafAssetCache.addAssetName("Clock6")

    return GafAssetCache
end

--[[
	添加队伍中的队员动画资源名称
--]]
function GafAssetCache.addTeamAssetName(teamModel)
	for i=1,#teamModel do
      	local roleId = teamModel[i].roleId
      	local image = GameConfig.character[roleId].image
      	local atk_effect = GameConfig.character[roleId].atk_effect
      	GafAssetCache.addAssetName(image)
      	GafAssetCache.addAssetName(atk_effect)

      	if image == "Windranger" then
      		GafAssetCache.addAssetName("Windranger_skill_2")
      	end

	    if image == "Origami" then
	      	GafAssetCache.addAssetName("Origami_skill_1")
	    end

      	if image == "Uryuu" then
      		GafAssetCache.addAssetName("Uryuu_skill_2")
      	end

      	if image == "Shino" then
      		GafAssetCache.addAssetName("Shino_skill_1")
      		GafAssetCache.addAssetName("Shino_skill_2")
      	end

	    if teamModel[i].evolve then
	      	local evolveEffect = GameConfig.character[roleId].evolve_effect
	      	GafAssetCache.addAssetName(evolveEffect)
	        local evolveId = ""..checkint(roleId) + 1
	        local evoImage = GameConfig.character[evolveId].image
	        GafAssetCache.addAssetName(evoImage)

	        if evoImage == "sWindranger" then
	      		GafAssetCache.addAssetName("sWindranger_skill_2")
	      	end

	      	if evoImage == "sOrigami" then
	      		GafAssetCache.addAssetName("sOrigami_skill_2")
	      		GafAssetCache.addAssetName("sOrigami_skill_3")
	      	end

	      	if evoImage == "sShino" then
	      		GafAssetCache.addAssetName("sShino_skill_2")
	      	end
	    end
    end
   
    return GafAssetCache
end

--[[
	加载关卡内伏兵资源
--]]
function GafAssetCache.addCustomAssetName(customId)
	if customId then
		local array = GameConfig.custom[customId].wave_wave or {}

		for i=1, #array do
	      local tb = GameConfig.wave[array[i]]
	      for i=1,5 do
	         local eid = tb["enemy"..i]
	         if eid and eid ~= "" then
				local image = GameConfig.enemy[eid].image
				local effect = GameConfig.enemy[eid].atk_effect
	            GafAssetCache.addAssetName(image)
	            if effect ~= "" then
	            	 GafAssetCache.addAssetName(effect)
	            end
	         end
	      end
	    end
	end

	return GafAssetCache
end

--[[
	添加关卡出兵波的敌人动画资源
--]]
function GafAssetCache.addWaveAssetName(wave)
	if wave  then
		local array  = string.split(wave, ",")
	    for i=1, #array do
	      local tb = GameConfig.wave[array[i]]
	      for i=1,5 do
	         local eid = tb["enemy"..i]
	         if eid and eid ~= "" then
				local image = GameConfig.enemy[eid].image
				local effect = GameConfig.enemy[eid].atk_effect
	            GafAssetCache.addAssetName(image)
	            if effect ~= "" then
	            	GafAssetCache.addAssetName(effect)
	            end
	            if image == "sWindranger" then
		      		GafAssetCache.addAssetName("sWindranger_skill_2")
		      	end
		      	if image == "sOrigami" then
		      		GafAssetCache.addAssetName("sOrigami_skill_2")
		      		GafAssetCache.addAssetName("sOrigami_skill_3")
		      	end
		      	if image == "Windranger" then
			      	GafAssetCache.addAssetName("Windranger_skill_2")
			    end
		      	if image == "Origami" then
		      		GafAssetCache.addAssetName("Origami_skill_1")
		      	end
		      	if image == "Uryuu" then
		      		GafAssetCache.addAssetName("Uryuu_skill_2")
		      	end
		      	if image == "Shino" then
		      		GafAssetCache.addAssetName("Shino_skill_1")
		      		GafAssetCache.addAssetName("Shino_skill_2")
		      	end
		      	if image == "sShino" then
		      		GafAssetCache.addAssetName("sShino_skill_2")
		      	end
	         end
	      end
	    end
	end
    return GafAssetCache
end

--[[
	添加世界树伏兵资源
--]]
function GafAssetCache.addTreeCustomAssetName(customId)
	if customId then
		local array = GameConfig.tree_custom[customId].wave_wave or {}
		for i=1, #array do
	      local tb = GameConfig.tree_wave[array[i]]
	      for i=1,5 do
	         local eid = tb["enemy"..i]
	         if eid and eid ~= "" then
	         	--print(eid)
				local image = GameConfig.enemy[eid].image
				local effect = GameConfig.enemy[eid].atk_effect
	            GafAssetCache.addAssetName(image)
	            if effect ~= "" then
	            	 GafAssetCache.addAssetName(effect)
	            end
	         end
	      end
	    end
	end

	return GafAssetCache
end


function GafAssetCache.addTreeWaveAssetName(wave)
	if wave  then
		local array  = string.split(wave, ",")
    
	    for i=1, #array do
	      local tb = GameConfig.tree_wave[array[i]]
	      for i=1,5 do
	         local eid = tb["enemy"..i]
	         if eid and eid ~= "" then
				local image = GameConfig.enemy[eid].image
				local effect = GameConfig.enemy[eid].atk_effect
	            GafAssetCache.addAssetName(image)
	        	GafAssetCache.addAssetName(effect)
	        	
	            if image == "sWindranger" then
		      		GafAssetCache.addAssetName("sWindranger_skill_2")
		      	end
		      	if image == "sOrigami" then
		      		GafAssetCache.addAssetName("sOrigami_skill_2")
		      		GafAssetCache.addAssetName("sOrigami_skill_3")
		      	end
		      	if image == "Windranger" then
			      	GafAssetCache.addAssetName("Windranger_skill_2")
			    end
		      	if image == "Origami" then
		      		GafAssetCache.addAssetName("Origami_skill_1")
		      	end
		      	if image == "Uryuu" then
		      		GafAssetCache.addAssetName("Uryuu_skill_2")
		      	end
		      	if image == "Shino" then
		      		GafAssetCache.addAssetName("Shino_skill_2")
		      	end
		      	if image == "sShino" then
		      		GafAssetCache.addAssetName("sShino_skill_2")
		      	end
	         end
	      end
	    end
	end

    return GafAssetCache
end

--[[
	添加关卡中 护送人的动画资源
--]]
function GafAssetCache.addEscortAssetName(escortId)
	if escortId then
		 GafAssetCache.addAssetName(GameConfig.enemy[escortId].image)
       	 GafAssetCache.addAssetName(GameConfig.enemy[escortId].atk_effect)
       	 GafAssetCache.addAssetName("door")
	end

	return GafAssetCache
end

--[[
	添加队员角色登场特效动画资源
--]]
function GafAssetCache.addEnterSkillAssetName(teamModel)
	if #teamModel > 1 then
		for i=2,#teamModel do
			if teamModel[i]:checkEvolve() then
				local roleId = teamModel[i].roleId
	      		GafAssetCache.addAssetName(GameConfig.character[roleId].enter_effect)
			else
				--觉醒前用通用特效
				GafAssetCache.addAssetName("enter_effect_6")
			end		
		end
	end
	
	return GafAssetCache
end

--[[
	添加尾兽技能资源
--]]
function GafAssetCache.addTailSkillAssetName(tailSkill)
	if tailSkill then
		 for k,v in pairs(tailSkill.skill) do
		 	local image = GameConfig.skill_tails[v].image
            GafAssetCache.addAssetName(image)
            GafAssetCache.addAssetName("pet_"..image)
        end

        --todo 动态添加
        GafAssetCache.addAssetName("Tower1")
	end
	
	return GafAssetCache
end 

--[[
	添加关卡城建
--]]
function GafAssetCache.addBuildingAssetName(data)
	if data then
		for k,v in pairs(data) do
			 local image = GameConfig.tower[v.id].image
			  GafAssetCache.addAssetName(image)
		end
	end

	return GafAssetCache
end

--[[
	添加关卡中敌人的塔
--]]
function GafAssetCache.addTowerAssetName(customId)
	if not  GameConfig.custom[customId] then
	 	return GafAssetCache
	end
	local cfg = GameConfig.custom[customId].tower
	if cfg then
		local table = string.split(cfg, ":")
      	for k,v in pairs(table) do
          local data = string.split(v, ",")
          local towerId = data[1]
          local image = GameConfig.tower[towerId].image
          --print(image)
          GafAssetCache.addAssetName(image)
    	end
	end

	return GafAssetCache
end


--[[
	获取参数列表
--]]
function GafAssetCache.getAssetNames()
	local assetTable = {} --table.keys(assetMap) 
    for k,v in pairs(GafAssetCache.assetNameMap) do
       if k ~= "" then
          table.insert(assetTable,k)
       end
    end

    return assetTable
end


--[[
	重置参数
--]]
function GafAssetCache.reset()
	for k,v in pairs(GafAssetCache.assetMap) do
		v:release()
	end

	GafAssetCache.assetMap = nil
	GafAssetCache.assetMap = {}

	GafAssetCache.assetNameMap = nil 
	GafAssetCache.assetNameMap = {}

	return GafAssetCache
end


