
local c = cc
local Node = c.Node

function Node:onTouch(listener)   
	-- print("short onTouch") 
    self:setTouchEnabled(true)
    self:addNodeEventListener(c.NODE_TOUCH_EVENT, listener)
    
    return self
end

function Node:addPos(posX, posY)
	local x, y = self:getPosition()
	if type(posX) == "table" then 
		self:pos(x + posX.x, y + posX.y)
	else 
		self:pos(x + posX, y + posY)
	end 
	
	return self
end

function Node:itemPos(anchorX, anchorY, item)
	local size
	if item then 
		size = item:getContentSize()
	elseif self:getParent() then 
		size = self:getParent():getContentSize()
	else 
		size = self:getContentSize()
	end 

	local x = size.width * anchorX 
	local y = size.height * anchorY 
	self:pos(x, y)
	
	return self
end


function Node:autoCleanImage()	
    self:addNodeEventListener(cc.NODE_EVENT, function(event)    	
    	if event.name == "enter" then
            if self.autoCleanupImages_ then 
                if not self.loadCount_ then 
                    self.loadCount_ = 1 
                else 
                    if self.loadCount_ < 1 then 
                        for plist, image in pairs(self.autoCleanupImages_) do   
                            print("auto load:", image)                 
                            ResManage.load(plist, image)
                        end
                    end
                    self.loadCount_ = self.loadCount_ + 1
                end             	               
            end        
        elseif event.name == "exit" then
            if self.autoCleanupImages_ then 
            	self.loadCount_ = self.loadCount_ - 1
                if self.loadCount_ < 1 then 
                    for plist, image in pairs(self.autoCleanupImages_) do
                        print("auto remove:", image)
                        ResManage.remove(plist, image)
                    end
                end 
            end
        end
    end)

    return self
end

function Node:loadImage(plist, image)
    if not self.autoCleanupImages_ then self.autoCleanupImages_ = {} end
    self.autoCleanupImages_[plist] = image
    ResManage.load(plist, image)
    
    return self
end


function Node:worldPos()
    return self:convertToWorldSpace(cc.p(0,0))
end

--[[
@param tabel point cc.p的点位置,世界坐标
]]
function Node:nodePos(point)
    return self:convertToNodeSpace(point)
end

function Node:scheduleTimes(callback, interval, times, completed)
    local seq = {}
    items = times + 1
    if times < 1 then times = 1 end 
    for i=1,times do
        table.insert(seq, cc.DelayTime:create(interval))
        table.insert(seq, cc.CallFunc:create(callback))
    end
    if completed then 
        table.insert(seq, cc.CallFunc:create(completed))           
    end 

    local action = transition.sequence(seq)
    
    self:runAction(action)
    return action
end




