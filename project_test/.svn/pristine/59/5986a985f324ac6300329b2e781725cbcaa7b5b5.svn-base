--[[
进入商店 基础类
]]
local ShopBaseVisitor = class("ShopBaseVisitor", base.SceneVisitor)

function ShopBaseVisitor:toScene(totype)
	self:toScene_(self:getShopSceneName(), {sceneOrder=self:getNetOrder(), shopType=self:getShopType()}, totype)
end

function ShopBaseVisitor:netToScene(totype)
	if self:isShopOpen() then 
		self:sendData("OpenShop", {param1=self:getShopType()}, function()
			self:toScene(totype)
		end)
	else 
		showToast({text="等级不足", time=1})
	end 
end

function ShopBaseVisitor:getShopSceneName()
	return ""
end 

function ShopBaseVisitor:getShopType()
	return 0
end 

function ShopBaseVisitor:isShopOpen()
	return true
end 

return ShopBaseVisitor