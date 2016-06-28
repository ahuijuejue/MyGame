--[[
进入竞技场商店
]]

local ShopBaseVisitor = import(".ShopBaseVisitor")
local ShopArenaVisitor = class("ShopArenaVisitor", ShopBaseVisitor)


function ShopArenaVisitor:getNetOrder()
	return "OpenShopArena"
end 

function ShopArenaVisitor:getShopSceneName()
	return "ArenaShopScene"
end 

function ShopArenaVisitor:getShopType()
	return 4
end 

function ShopArenaVisitor:isShopOpen()
	return UserData:getUserLevel() >= OpenLvData.arena.openLv
end 

return ShopArenaVisitor